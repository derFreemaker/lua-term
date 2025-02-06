local table_insert = table.insert
local table_remove = table.remove

local class_system = require("misc.class_system")
local _entry = require("src.segment.entry")
local _text = require("src.components.text")

---@class lua-term.segment.parent : object
---@field protected m_childs lua-term.segment.entry[]
local _segment_parent = {}

---@alias lua-term.segment.parent.__init fun()

---@deprecated
---@private
function _segment_parent:__init()
    self.m_childs = {}
end

---@param only_schedule boolean | nil
function _segment_parent:update(only_schedule)
end

_segment_parent.update = class_system.is_abstract

---@param ... any
---@return lua-term.components.text
function _segment_parent:print(...)
    return _text.static__print(self, ...)
end

---@param segment lua-term.segment.interface
function _segment_parent:add_child(segment)
    table_insert(self.m_childs, _entry(segment))
end

---@param child lua-term.segment.interface
function _segment_parent:remove_child(child)
    for index, entry in pairs(self.m_childs) do
        if entry:wraps_segment(child) then
            table_remove(self.m_childs, index)
            break
        end
    end

    self:update(true)
end

return class("lua-term.segment_parent", _segment_parent, { is_abstract = true })
