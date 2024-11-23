---@meta _

---@class lua-term.segment_parent
local parent_class = {}

function parent_class:update()
end

---@param ... any
---@return lua-term.segment
function parent_class:print(...)
end

---@param id string
---@param segment lua-term.segment_interface
function parent_class:add_segment(id, segment)
end

---@param child lua-term.segment_interface
function parent_class:remove_child(child)
end
