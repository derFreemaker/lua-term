---@meta _

---@class lua-term.segment_interface
local segment_interface = {}

---@return boolean update_requested
function segment_interface:requested_update()
end

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function segment_interface:render(context)
end
