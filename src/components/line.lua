local utils = require("misc.utils")
local table_insert = table.insert
local table_remove = table.remove
local table_concat = table.concat

local _segment_interface = require("src.segment.interface")
local _segment_parent = require("src.segment.parent")

---@class lua-term.components.line : lua-term.segment.interface, lua-term.segment.single_line_parent, object
---@field private m_id string
---
---@field private m_requested_update boolean
---
---@field private m_parent lua-term.segment.parent
local _line = {}

---@deprecated
---@private
---@param id string
---@param parent lua-term.segment.parent
function _line:__init(id, parent)
    self.m_id = id
    self.m_requested_update = true
end

-- lua-term.segment.interface

---@return string
function _line:get_id()
    return self.m_id
end

---@param update boolean | nil
function _line:remove(update)
    self.m_parent:remove_child(self)

    if update then
        self.m_parent:update(false)
    end
end

function _line:requested_update()
    if self.m_requested_update then
        return true
    end

    for _, child in ipairs(self.m_childs) do
        if child:requested_update() then
            return true
        end
    end
end

---@return lua-term.render_buffer update_buffer
---@return integer length
function _line:render_impl(context)
    self.m_requested_update = false

    if context.show_id then
        local line_buffer = {}
        local line_buffer_pos = 1

        for _, entry in ipairs(self.m_childs) do
            local buffer, length = entry:render(context)
            line_buffer_pos[line_buffer_pos] = buffer
            line_buffer_pos = line_buffer_pos + length
        end

        return line_buffer, line_buffer_pos - 1
    end

    local line_buffer = {}
    for _, entry in ipairs(self.m_childs) do
        local buffer = entry:render(context)
        table_insert(line_buffer, buffer[1])
    end

    return { table_concat(line_buffer) }, 1
end

-- lua-term.segment.parent

function _line:update(only_schedule)
    if only_schedule then
        self.m_requested_update = true
    end

    self.m_parent:update()
end

return class("lua-term.components.line", _line, {
    inherit = {
        _segment_interface,
        _segment_parent,
    }
})
