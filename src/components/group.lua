local utils = require("misc.utils")

---@class lua-term.components.group : lua-term.segment.parent, lua-term.segment.interface
---@field id string
---
---@field private m_requested_update boolean
---
---@field private m_parent lua-term.segment.parent
---@overload fun(id: string, parent: lua-term.segment.parent) : lua-term.components.group
local _group = {}

---@alias lua-term.components.group.__init fun(id: string, parent: lua-term.segment.parent)
---@alias lua-term.components.group.__con fun(id: string, parent: lua-term.segment.parent) : lua-term.components.group

---@deprecated
---@private
---@param super lua-term.segment.parent.__init
---@param id string
---@param parent lua-term.segment.parent
function _group:__init(super, id, parent)
    super()

    self.id = id

    self.m_requested_update = false

    self.m_parent = parent

    -- lua-term.segment.interface
    self.m_content_length = 0

    parent:add_child(self)
end

---@param update boolean | nil
function _group:remove(update)
    self.m_parent:remove_child(self)

    if update then
        self.m_parent:update()
    end
end

-- lua-term.segment_parent

function _group:update(only_schedule)
    if only_schedule then
        self.m_requested_update = true
        return
    end

    self.m_parent:update()
end

-- lua-term.segment_interface

---@return string
function _group:get_id()
    return self.id
end

---@return boolean
function _group:requested_update()
    if self.m_requested_update then
        return true
    end

    for _, child in ipairs(self.m_childs) do
        if child:requested_update() then
            return true
        end
    end

    return false
end

---@return table<integer, string> update_buffer
---@return integer length
function _group:render_impl(context)
    self.m_requested_update = false
    if #self.m_childs == 0 then
        return {}, 0
    end

    local group_buffer, group_buffer_pos = {}, 1
    for _, entry in ipairs(self.m_childs) do
        ---@type lua-term.render_context
        local child_context = {
            show_id = context.show_id,
            width = context.width,
            position_changed = entry:get_line() ~= group_buffer_pos or context.position_changed
        }
        local buffer, length = entry:render(child_context)
        entry:set_line(group_buffer_pos)

        group_buffer[group_buffer_pos] = buffer
        group_buffer_pos = group_buffer_pos + length
    end

    self.m_content_length = group_buffer_pos - 1
    return group_buffer, self.m_content_length
end

return class("lua-term.components.group", _group, {
    inherit = {
        require("src.segment.parent"),
        require("src.segment.interface")
    },
})
