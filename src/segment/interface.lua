local class_system = require("misc.class_system")

---@class lua-term.segment.interface
local _segment_interface = {}

---@return string
function _segment_interface:get_id()
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.get_id = class_system.is_interface

---@return integer
function _segment_interface:get_length()
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.get_length = class_system.is_interface

---@return boolean
function _segment_interface:requested_update()
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.requested_update = class_system.is_interface

---@param context lua-term.render_context
---@return lua-term.render_buffer update_buffer
---@return integer length
function _segment_interface:render(context)
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.render = class_system.is_interface

return interface("lua-term.segment.interface", _segment_interface)
