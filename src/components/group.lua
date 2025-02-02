local utils = require("misc.utils")

---@class lua-term.components.group : lua-term.segment_parent, lua-term.segment_interface
---@field private m_requested_update boolean
---@field private m_parent lua-term.segment_parent
---@overload fun(id: string, parent: lua-term.segment_parent) : lua-term.components.group
local _group = {}

---@alias lua-term.components.group.__init fun(id: string, parent: lua-term.segment_parent)

---@deprecated
---@private
---@param super lua-term.segment_parent.__init
---@param id string
---@param parent lua-term.segment_parent
function _group:__init(super, id, parent)
    super()

    self.m_requested_update = false
    self.m_parent = parent

    parent:add_child(self)
end

---@param update boolean | nil
function _group:remove(update)
    update = utils.value.default(update, true)

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

function _group:requested_update()
    if self.m_requested_update then
        return true
    end

    for _, child in ipairs(self.m_childs) do
        if child:get_info().requested_update then
            return true
        end
    end
end

---@return table<integer, string> update_buffer
---@return integer lines
function _group:render(context)
    self.m_requested_update = false
    if #self.m_childs == 0 then
        return {}, 0
    end

    for _, segment in ipairs(self.m_childs) do

    end
end

return class("lua-term.components.group", _group, {
    inherit = {
        require("src.segment.parent"),
        require("src.segment.interface")
    },
})
