local utils = require("misc.utils")

local pairs = pairs
local math_abs = math.abs
local string_rep = string.rep
local io_type = io.type
local table_insert = table.insert
local table_remove = table.remove

local cursor = require("src.misc.cursor")
local erase = require("src.misc.erase")
local _segment_parent = require("src.segment.parent")
local _entry = require("src.segment.entry")
local _text = require("src.components.text")

---@class lua-term.render_context
---@field show_id boolean
---
---@field width integer
---
---@field position_changed boolean

---@alias lua-term.render_buffer table<integer, string | lua-term.render_buffer>

---@class lua-term.terminal : object, lua-term.segment.parent
---@field show_ids boolean
---@field show_lines boolean
---
---@field private m_stream file*
---
---@field private m_cursor_pos integer
---@overload fun(stream: file*) : lua-term.terminal
local _terminal = {}

---@alias lua-term.terminal.__con fun(stream: file*) : lua-term.terminal

---@deprecated
---@private
---@param super lua-term.segment.parent.__init
---@param stream file*
function _terminal:__init(super, stream)
    super()

    if io_type(stream) ~= "file" then
        error("stream is not valid")
    end
    stream:write("\27[?7l") -- disable line wrap

    self.show_ids = false
    self.show_lines = false

    self.m_stream = stream
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
    local entry = _entry(segment)
    table_insert(self.m_childs, entry)
end

function _terminal:remove_child(child)
    for index, segment in ipairs(self.m_childs) do
        if segment:wraps_segment(child) then
            table_remove(self.m_childs, index)
            break
        end
    end
end

function _terminal:clear()
    self.m_childs = {}
    self:update()
end

---@private
---@param line integer
---@return string
function _terminal:jump_to_line(line)
    local jump_lines = line - self.m_cursor_pos
    if jump_lines == 0 then
        return ""
    end

    self.m_cursor_pos = line
    if jump_lines > 0 then
        return cursor.go_down(jump_lines)
    else
        return cursor.go_up(math_abs(jump_lines))
    end
end

---@param buffer table<integer, string | string[]>
---@param line_start integer
---@param builder Freemaker.utils.string.builder
function _terminal:write_buffer(buffer, line_start, builder)
    builder = builder

    for line, content in pairs(buffer) do
        line = line_start + line

        if type(content) == "table" then
            self:write_buffer(content, line - 1, builder)
            goto continue
        end

        builder:append(
            self:jump_to_line(line),
            erase.line()
        )

        if self.show_lines then
            local line_str = tostring(self.m_cursor_pos)
            local space = 3 - line_str:len()
            builder:append(line_str, string_rep(" ", space), "|")
        end

        builder:append_line(content)
        self.m_cursor_pos = self.m_cursor_pos + 1

        ::continue::
    end
end

function _terminal:update()
    local terminal_buffer = {}
    local terminal_buffer_pos = 1

    for _, segment in ipairs(self.m_childs) do
        ---@type lua-term.render_context
        local context = {
            show_id = self.show_ids,
            width = 80,
            position_changed = segment:get_line() ~= terminal_buffer_pos
        }

        local buffer, length = segment:render(context)
        terminal_buffer[terminal_buffer_pos] = buffer

        segment:set_line(terminal_buffer_pos)
        terminal_buffer_pos = terminal_buffer_pos + length
    end

    -- local builder = utils.string.builder.new()
    local builder = {
        append = function(_, ...)
            self.m_stream:write(...)
        end,
        append_line = function(_, ...)
            self.m_stream:write(..., "\n")
        end,
        build = function(_)
            return ""
        end
    }

    self:write_buffer(terminal_buffer, 0, builder)

    if #self.m_childs > 0 then
        local last_segment = self.m_childs[#self.m_childs]
        local line = last_segment:get_line()
        local length = last_segment:get_length()
        builder:append(self:jump_to_line(line + length))
    else
        builder:append(self:jump_to_line(1))
    end

    builder:append(erase.till_end())
    self.m_stream:write(builder:build())
    self.m_stream:flush()
end

return class("lua-term.terminal", _terminal, {
    inherit = {
        _segment_parent
    }
})
