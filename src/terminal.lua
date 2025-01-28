local cursor = require("src.cursor")
local erase = require("src.erase")

local pairs = pairs
local math_abs = math.abs
local string_rep = string.rep
local io_type = io.type
local table_insert = table.insert
local table_remove = table.remove

local entry_class = require("src.segment.entry")
local _text = require("src.components.text")

--//TODO: rewrite entire entity and cache system
--//TODO: currently 2+ caching of same line

---@class lua-term.render_context
---@field show_ids boolean

---@class lua-term.terminal : lua-term.segment_parent
---@field show_ids boolean | nil
---@field show_lines boolean | nil
---
---@field private m_stream file*
---
---@field private m_segments lua-term.segment_entry[]
---
---@field private m_org_print function
---@field private m_cursor_pos integer
local terminal = {}

---@param stream file*
---@return lua-term.terminal
function terminal.new(stream)
    if io_type(stream) ~= "file" then
        error("stream is not valid")
    end

    stream:write("\27[?7l")
    return setmetatable({
        m_stream = stream,
        m_segments = {},
        m_cursor_pos = 1,
    }, { __index = terminal })
end

local stdout_terminal
---@return lua-term.terminal
function terminal.stdout()
    if stdout_terminal then
        return stdout_terminal
    end

    stdout_terminal = terminal.new(io.stdout)
    return stdout_terminal
end

function terminal:close()
    self.m_stream:write("\27[?7h")
end

---@param ... any
---@return lua-term.segment
function terminal:print(...)
    return _text.print(self, ...)
end

function terminal:add_segment(id, segment)
    local entry = entry_class.new(id, segment)
    table_insert(self.m_segments, entry)
end

function terminal:remove_child(child)
    for index, entry in ipairs(self.m_segments) do
        if entry:has_segment(child) then
            table_remove(self.m_segments, index)
        end
    end
end

function terminal:clear()
    self.m_segments = {}
    self:update()
end

---@private
---@param line integer
function terminal:jump_to_line(line)
    local jump_lines = line - self.m_cursor_pos
    if jump_lines == 0 then
        return
    end

    if jump_lines > 0 then
        self.m_stream:write(cursor.go_down(jump_lines))
    else
        self.m_stream:write(cursor.go_up(math_abs(jump_lines)))
    end
    self.m_cursor_pos = line
end

function terminal:update()
    local line_buffer_pos = 1
    ---@type table<integer, string>
    local line_buffer = {}

    for _, segment in ipairs(self.m_segments) do
        if not self.show_ids and not segment:requested_update() then
            if segment.line ~= line_buffer_pos then
                for index, line in ipairs(segment.lines) do
                    line_buffer[line_buffer_pos + index - 1] = line
                end

                segment.line = line_buffer_pos
            end
        else
            local context = {
                show_ids = self.show_ids
            }
            local update_lines = segment:pre_render(context)

            if segment.line ~= line_buffer_pos then
                for index, line in ipairs(segment.lines) do
                    line_buffer[line_buffer_pos + index - 1] = line
                end
            else
                for index, line in pairs(update_lines) do
                    line_buffer[line_buffer_pos + index - 1] = line
                end
            end

            segment.line = line_buffer_pos
        end

        line_buffer_pos = line_buffer_pos + segment.lines_count
    end

    for line, content in pairs(line_buffer) do
        self:jump_to_line(line)

        self.m_stream:write(erase.line())
        if self.show_lines then
            local line_str = tostring(line)
            local space = 3 - line_str:len()
            self.m_stream:write(line_str, string_rep(" ", space), "|")
        end
        self.m_stream:write(content, "\n")
        self.m_cursor_pos = self.m_cursor_pos + 1
    end

    if #self.m_segments > 0 then
        local last_segment = self.m_segments[#self.m_segments]
        self:jump_to_line(last_segment.line + last_segment.lines_count)
    else
        self:jump_to_line(1)
    end

    self.m_stream:write(erase.till_end())
    self.m_stream:flush()
end

return terminal
