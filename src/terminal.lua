local utils = require("misc.utils")

local pairs = pairs
local string_rep = string.rep
local table_insert = table.insert
local table_remove = table.remove

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

---@class lua-term.terminal.callbacks.create
---@field write fun(...: string)
---@field write_line fun(...: string) | nil
---@field flush fun() | nil
---
---@field erase_line fun()
---@field erase_till_end fun()
---
---@field go_to_line fun(line: integer)

---@class lua-term.terminal.callbacks
---@field write fun(...: string)
---@field write_line fun(...: string)
---@field flush fun()
---
---@field erase_line fun()
---@field erase_till_end fun()
---
---@field go_to_line fun(line: integer)

---@class lua-term.terminal : object, lua-term.segment.parent
---
---@field package m_show_ids boolean
---@field package m_show_line_numbers boolean
---@field package m_callbacks lua-term.terminal.callbacks
---@overload fun(callbacks: lua-term.terminal.callbacks.create) : lua-term.terminal
local _terminal = {}

---@alias lua-term.terminal.__init fun(callbacks: lua-term.terminal.callbacks.create)
---@alias lua-term.terminal.__con fun(callbacks: lua-term.terminal.callbacks.create) : lua-term.terminal

---@deprecated
---@private
---@param super lua-term.segment.parent.__init
---@param callbacks lua-term.terminal.callbacks.create
function _terminal:__init(super, callbacks)
    super()

    self.show_ids = false
    self.show_lines = false

    self.m_callbacks = {
        write = callbacks.write,
        write_line = callbacks.write_line or function(...)
            self.m_callbacks.write(..., "\n")
        end,
        flush = callbacks.flush or function() end,

        erase_line = callbacks.erase_line,
        erase_till_end = callbacks.erase_till_end,

        go_to_line = callbacks.go_to_line
    }
end

---@param value boolean | nil
function _terminal:show_ids(value)
    self.m_show_ids = value or true
end

---@param value boolean | nil
function _terminal:show_line_numbers(value)
    self.m_show_line_numbers = value or true
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
    self.m_callbacks.go_to_line(1)
    self.m_callbacks.erase_till_end()
    self.m_callbacks.flush()
end

---@param self lua-term.terminal
---@param buffer table<integer, string | string[]>
---@param line_start integer
local function write_buffer(self, buffer, line_start)
    for line, content in pairs(buffer) do
        line = line_start + line

        if type(content) == "table" then
            write_buffer(self, content, line - 1)
            goto continue
        end

        self.m_callbacks.go_to_line(line)
        self.m_callbacks.erase_line()

        if self.m_show_line_numbers then
            local line_str = tostring(line)
            local space = 3 - line_str:len()
            self.m_callbacks.write(line_str, string_rep(" ", space), "|")
        end

        self.m_callbacks.write_line(content)

        ::continue::
    end
end

function _terminal:update()
    local buffer = {}
    local buffer_pos = 1

    for _, segment in ipairs(self.m_childs) do
        ---@type lua-term.render_context
        local context = {
            show_id = self.m_show_ids,
            width = 80,
            position_changed = segment:get_line() ~= buffer_pos
        }

        local seg_buffer, seg_length = segment:render(context)
        buffer[buffer_pos] = seg_buffer

        segment:set_line(buffer_pos)
        buffer_pos = buffer_pos + seg_length
    end

    write_buffer(self, buffer, 0)

    if #self.m_childs > 0 then
        local last_segment = self.m_childs[#self.m_childs]
        local line = last_segment:get_line()
        local length = last_segment:get_length()
        self.m_callbacks.go_to_line(line + length)
    else
        self.m_callbacks.go_to_line(1)
    end

    self.m_callbacks.erase_till_end()
    self.m_callbacks.flush()
end

return class("lua-term.terminal", _terminal, {
    inherit = {
        _segment_parent
    }
})
