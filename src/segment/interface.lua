local class_system = require("misc.class_system")

---@class lua-term.segment_interface
local _segment_interface = {}

---@return boolean
function _segment_interface:requested_update()
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.requested_update = class_system.is_interface

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function _segment_interface:render(context)
    ---@diagnostic disable-next-line: missing-return
end

_segment_interface.render = class_system.is_interface

return interface("lua-term.segment_interface", _segment_interface)
