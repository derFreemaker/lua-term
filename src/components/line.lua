local utils = require("misc.utils")
local table_insert = table.insert
local table_remove = table.remove
local table_concat = table.concat

local _segment_interface = require("src.segment.interface")
local _segment_parent = require("src.segment.parent")

local _text_segment = require("src.components.text")

---@class lua-term.components.line : lua-term.segment.interface, lua-term.segment.parent
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

---@return string
function _line:get_id()
    return self.m_id
end

-- ---@param context lua-term.render_context
-- ---@return table<integer, string> update_buffer
-- ---@return integer lines
-- function line_class:render(context)
--     local line_buffer = {}
--     for _, child_entry in ipairs(self.m_childs) do
--         if not context.show_id and not child_entry:requested_update() then
--             goto continue
--         end

--         child_entry:pre_render(context)

--         ::continue::

--         for _, line in ipairs(child_entry.lines) do
--             table_insert(line_buffer, line)
--         end
--     end

--     if context.show_id then
--         return line_buffer, #line_buffer
--     end

--     local line = 0
--     if #line_buffer > 0 then
--         line = 1
--     end
--     return { table_concat(line_buffer) }, line
-- end

-- ---@param update boolean | nil
-- function line_class:remove(update)
--     update = utils.value.default(update, true)

--     self.m_parent:remove_child(self)

--     if update then
--         self.m_parent:update()
--     end
-- end

-- function line_class:requested_update()
--     if self.m_requested_update then
--         return true
--     end

--     for _, child in ipairs(self.m_childs) do
--         if child:requested_update() then
--             return true
--         end
--     end
-- end

-- ----------------------
-- --- segment_parent ---
-- ----------------------

-- function line_class:update()
--     self.m_parent:update()
-- end

-- ---@return lua-term.segment
-- function line_class:print(...)
--     return _text_segment.print(self, ...)
-- end

-- function line_class:add_segment(id, segment)
--     table_insert(self.m_childs, segment_entry.new(id, segment))
-- end

-- function line_class:remove_child(child)
--     for index, child_entry in ipairs(self.m_childs) do
--         if child_entry:has_segment(child) then
--             table_remove(self.m_childs, index)
--             break
--         end
--     end

--     self.m_requested_update = true
-- end

return class("lua-term.components.line", _line, {
    inherit = {
        _segment_interface,
        _segment_parent,
    }
})
