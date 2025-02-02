local cursor = require("src.misc.cursor")
local erase = require("src.misc.erase")

local pairs = pairs
local math_abs = math.abs
local string_rep = string.rep
local io_type = io.type
local table_insert = table.insert
local table_remove = table.remove

local _segment_parent = require("src.segment.parent")
local _text = require("src.components.text")

--//TODO: rewrite entire entity and cache system
--//TODO: currently 2+ caching of same line

---@class lua-term.render_context
---@field show_id boolean
---
---@field height integer
---@field width integer
---
---@field position_changed boolean

---@class lua-term.terminal : object, lua-term.segment_parent
---@field show_ids boolean
---@field show_lines boolean
---
---@field private m_stream file*
---
---@field private m_segments lua-term.segment_interface[]
---
---@field private m_org_print function
---@field private m_cursor_pos integer
---@overload fun(stream: file*) : lua-term.terminal
local _terminal = {}

---@alias lua-term.terminal.__con fun(stream: file*) : lua-term.terminal

---@deprecated
---@private
---@param super lua-term.segment_parent.__init
---@param stream file*
function _terminal:__init(super, stream)
    super()

    if io_type(stream) ~= "file" then
        error("stream is not valid")
    end
    stream:write("\27[?7l")

    self.show_ids = false
    self.show_lines = false

    self.m_stream = stream
    self.m_segments = {}
    self.m_cursor_pos = 1
end

function _terminal:close()
    self.m_stream:write("\27[?7h")
end

---@param ... any
---@return lua-term.components.text
function _terminal:print(...)
    return _text.static__print(self, ...)
end

function _terminal:add_child(segment)
    table_insert(self.m_segments, segment)
end

function _terminal:remove_child(child)
    for index, segment in ipairs(self.m_segments) do
        if segment == child then
            table_remove(self.m_segments, index)
            break
        end
    end
end

function _terminal:clear()
    self.m_segments = {}
    self:update()
end

---@private
---@param line integer
function _terminal:jump_to_line(line)
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

function _terminal:update()
    local buffer = {}
    local buffer_pos = 0

    for _, segment in ipairs(self.m_segments) do
        ---@type lua-term.render_context
        local context = {
            show_id = self.show_ids,
            height = 30,
            width = 80,
            position_changed = segment:get_info().line ~= buffer_pos
        }

        local update_buffer, length = segment:render(context)

        for index, line in pairs(update_buffer) do
            buffer[buffer_pos + index] = line
        end
        buffer_pos = buffer_pos + length
    end

    for line, content in pairs(buffer) do
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
        local last_segment = self.m_segments[#self.m_segments]:get_info()
        self:jump_to_line(last_segment.line + last_segment.length)
    else
        self:jump_to_line(1)
    end

    self.m_stream:write(erase.till_end())
    self.m_stream:flush()
end

return class("lua-term.terminal", _terminal, {
    inherit = {
        _segment_parent
    }
})
