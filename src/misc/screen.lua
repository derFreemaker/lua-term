local table_concat = table.concat

---@enum lua-term.screen.state
local state = {
    Normal = 0,
    AnsiEscapeCode = 1
}

---@class lua-term.screen.line
---@field [integer] string
---@field length integer

---@class lua-term.screen
---@field private m_read_char_func fun() : string | nil
---
---@field private m_cursor_x integer
---@field private m_cursor_y integer
---@field private m_screen (lua-term.screen.line|nil)[]
---@field private m_changed table<integer, true>
---
---@field private m_state lua-term.screen.state
---@field private m_buffer string | nil
local screen_class = {}

---@param read_char_func fun() : string | nil
function screen_class.new(read_char_func)
    return setmetatable({
        m_read_char_func = read_char_func,

        m_cursor_x = 1,
        m_cursor_y = 1,
        m_screen = {},
        m_changed = {},

        m_state = state.Normal
    }, { __index = screen_class })
end

---@private
---@param line integer
---@return lua-term.screen.line
function screen_class:get_line(line)
    local _line = self.m_screen[line]
    if not _line then
        _line = { length = 0 }
        self.m_screen[line] = _line
    end
    return _line
end

function screen_class:get_height()
    return #self.m_screen
end

---@return (string[]|nil)[]
function screen_class:get_screen()
    return self.m_screen
end

---@return table<integer, string>
function screen_class:get_changed()
    ---@type table<integer, string>
    local buffer = {}
    for line in pairs(self.m_changed) do
        buffer[line] = table_concat(self:get_line(line))
    end
    return buffer
end

function screen_class:clear_changed()
    self.m_changed = {}
end

---@private
---@param dx integer
---@param dy integer
function screen_class:move_cursor(dx, dy)
    self.m_cursor_x = math.max(1, self.m_cursor_x + dx)
    self.m_cursor_y = math.max(1, self.m_cursor_y + dy)
end

---@private
---@param seq string
---@return integer[]
local function parse_ansi_escape_code_params(seq)
    local params = {}
    for param in seq:gmatch("%d+") do
        table.insert(params, tonumber(param))
    end
    return params
end

---@private
---@param command string
function screen_class:execute_ansi_escape_code(command)
    local params = parse_ansi_escape_code_params(self.m_buffer:sub(3, -1)) -- Extract parameters

    -- Process the command
    if command == "A" then
        -- Cursor Up (CSI n A)
        self:move_cursor(0, -(params[1] or 1))
    elseif command == "B" then
        -- Cursor Down (CSI n B)
        self:move_cursor(0, params[1] or 1)
    elseif command == "C" then
        -- Cursor Forward (CSI n C)
        self:move_cursor(params[1] or 1, 0)
    elseif command == "D" then
        -- Cursor Back (CSI n D)
        self:move_cursor(-(params[1] or 1), 0)
    elseif command == "H" or command == "f" then
        -- Cursor Position (CSI n;m H or CSI n;m f)
        self.m_cursor_y = params[1] or 1
        self.m_cursor_x = params[2] or 1
    elseif command == "J" then
        -- Erase in Display (CSI n J)
        if params[1] == 2 or not params[1] then
            self.m_screen = {}
        end
    elseif command == "K" then
        -- Erase in Line (CSI n K)
        local line = self:get_line(self.m_cursor_y)
        for x = self.m_cursor_x, line.length do
            line[x] = nil
        end
        line.length = self.m_cursor_x
    else
        self:write(self.m_buffer)
    end

    self.m_state = state.Normal
    self.m_buffer = nil
end

---@private
---@param buffer string
function screen_class:write(buffer)
    for i = 1, #buffer do
        local char = buffer:sub(i, i)

        local line = self:get_line(self.m_cursor_y)
        for x = line.length + 1, self.m_cursor_x - 1 do
            if not line[x] then
                line[x] = " "
            end
        end

        line[self.m_cursor_x] = char
        if line.length < self.m_cursor_x then
            line.length = self.m_cursor_x
        end
        self.m_cursor_x = self.m_cursor_x + 1

        self.m_changed[self.m_cursor_y] = true
    end
end

---@return string | nil char
function screen_class:process_char()
    local char = self.m_read_char_func()
    if not char then
        return nil
    end

    if char == "\r" then
        self.m_cursor_x = 1
        return char
    elseif char == "\n" then
        self.m_cursor_x = 1
        self.m_cursor_y = self.m_cursor_y + 1
        return char
    elseif char == "\27" then
        self.m_buffer = char
        self.m_state = state.AnsiEscapeCode
        return char
    elseif self.m_state == state.Normal then
        self:write(char)
        return char
    end

    if self.m_state == state.AnsiEscapeCode and #self.m_buffer == 1 and char ~= "[" then
        self.m_buffer = self.m_buffer .. char
        self.m_state = state.Normal
    end

    if self.m_state == state.Normal and self.m_buffer then
        self:write(self.m_buffer)
        self.m_buffer = nil
    elseif char:find("[A-Za-z]") then
        self:execute_ansi_escape_code(char)
    elseif self.m_state == state.AnsiEscapeCode then
        self.m_buffer = self.m_buffer .. char
    end

    return char
end

---@return string
function screen_class:to_string()
    local pos_y = 0
    local result = {}
    for y, row in pairs(self.m_screen) do
        while pos_y < y do
            pos_y = pos_y + 1
            if not result[pos_y] then
                result[pos_y] = ""
            end
        end

        local pos_x = 0
        local line = {}
        for x, char in pairs(row) do
            while pos_x < x do
                pos_x = pos_x + 1
                if not line[pos_x] then
                    line[pos_x] = " "
                end
            end

            line[x] = char
        end
        result[y] = table.concat(line)
    end
    return table.concat(result, "\n")
end

return screen_class
