---@enum screen.state
local state = {
    Normal = 0,
    AnsiEscapeCode = 1
}

---@class screen
---@field private m_cursor_x integer
---@field private m_cursor_y integer
---@field private m_screen (string[]|nil)[]
---@field private m_state screen.state
---@field private m_read_char fun() : string | nil
---@field private m_buffer string | nil
local _screen = {}

---@param read_func fun() : string | nil
function _screen.new(read_func)
    return setmetatable({
        m_cursor_x = 1,
        m_cursor_y = 1,
        m_screen = {},

        m_read_func = read_func,
        m_state = state.Normal
    }, { __index = _screen })
end

---@private
---@param dx integer
---@param dy integer
function _screen:move_cursor(dx, dy)
    self.m_cursor_x = math.max(1, self.m_cursor_x + dx)
    self.m_cursor_y = math.max(1, self.m_cursor_y + dy)
end

---@private
---@param char string
function _screen:write_char(char)
    if not self.m_screen[self.m_cursor_y] then
        self.m_screen[self.m_cursor_y] = {}
    end
    self.m_screen[self.m_cursor_y][self.m_cursor_x] = char
    self.m_cursor_x = self.m_cursor_x + 1
end

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
---@param buffer string
---@return boolean
function _screen:execute_ansi_escape_code(buffer)
    -- Found an ANSI escape sequence
    local end_pos = buffer:find("[A-Za-z]", 2)
    if not end_pos then
        return false
    end

    local esc_seq = buffer:sub(2, end_pos)
    local command = esc_seq:sub(-1)                                  -- Get the command character
    local params = parse_ansi_escape_code_params(esc_seq:sub(1, -2)) -- Extract parameters

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
        if not self.m_screen[self.m_cursor_y] then
            self.m_screen[self.m_cursor_y] = {}
        end
        for x = self.m_cursor_x, #self.m_screen[self.m_cursor_y] do
            self.m_screen[self.m_cursor_y][x] = nil
        end
    else
        return false
    end
end

---@param buffer string
function _screen:write(buffer)
    
end

---@return boolean
function _screen:process_char()
    local char = self.m_read_char()
    if not char then
        return false
    end

    if char == "\27" then
        self.m_state = state.AnsiEscapeCode
    elseif self.m_state == state.AnsiEscapeCode and char ~= "[" then
        self.m_state = state.Normal
    end

    if self.m_state == state.Normal and self.m_buffer then
        self:write(self.m_buffer)
        self.m_buffer = nil
    elseif self.m_state == state.AnsiEscapeCode then
        self.m_buffer = self.m_buffer .. char
    end

    return true
end

---@param buffer string
---@param x integer | nil
---@param y integer | nil
---@param screen string[][] | nil
local function execute_ansi_escape(buffer, x, y, screen)
    local cursor_x, cursor_y = x or 1, y or 1 -- Initialize cursor position (1-based indexing)
    screen = screen or {}                     -- Terminal buffer (2D array for content)

    local i = 1
    while i <= #buffer do
        local char = buffer:sub(i, i)

        if char == "\27" and buffer:sub(i + 1, i + 1) == "[" then

        elseif char == "\r" then
            -- Handle carriage return
            cursor_x = 1
        elseif char == "\n" then
            -- Handle newline (move to the next line, cursor at beginning)
            cursor_x = 1
            cursor_y = cursor_y + 1
        else
            -- Regular character, write to the screen
            write_char(char)
        end

        i = i + 1
    end

    -- Convert screen to string format for easier debugging (optional)
    local function screen_to_string()
        local result = {}
        for y, row in pairs(screen) do
            local line = {}
            for x = 1, #row do
                line[x] = row[x] or " "
            end
            result[y] = table.concat(line)
        end
        return table.concat(result, "\n")
    end

    return cursor_x, cursor_y, screen, screen_to_string()
end

return execute_ansi_escape
