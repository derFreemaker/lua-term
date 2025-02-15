local class_system = require("misc.class_system")

---@class lua-term.segment.single_line_interface : lua-term.segment.interface

---@class lua-term.segment.interface
---@field protected m_content_length integer
local _segment_interface = {}

---@return string
function _segment_interface:get_id()
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.get_id = class_system.is_interface

---@return integer
function _segment_interface:get_length()
    return self.m_content_length or 0
end

---@param update boolean | nil
function _segment_interface:remove(update)
end

_segment_interface.remove = class_system.is_interface

---@return boolean
function _segment_interface:requested_update()
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.requested_update = class_system.is_interface

---@protected
---@param context lua-term.render_context
---@return lua-term.render_buffer update_buffer
---@return integer length
function _segment_interface:render_impl(context)
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.render_impl = class_system.is_interface

---@param context lua-term.render_context
---@return lua-term.render_buffer update_buffer
---@return integer length
function _segment_interface:render(context)
    local buffer, length = self:render_impl(context)
    self.m_content_length = length
    return buffer, length
end

return interface("lua-term.segment.interface", _segment_interface)
