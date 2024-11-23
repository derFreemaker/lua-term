local utils = require("utils.utils")

local string_rep = string.rep
local debug_traceback = debug.traceback

---@alias lua-term.segment.func (fun() : string | nil)

---@class lua-term.segment : lua-term.segment_interface
---@field private m_func lua-term.segment.func
---@field private m_requested_update boolean
---
---@field private m_parent lua-term.segment_parent
local segment_class = {}

---@param id string
---@param func lua-term.segment.func
---@param parent lua-term.segment_parent
---@return lua-term.segment
function segment_class.new(id, func, parent)
    local instance = setmetatable({
        m_func = func,
        m_requested_update = true,

        m_parent = parent,
    }, {
        __index = segment_class
    })
    parent:add_segment(id, instance)

    return instance
end

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function segment_class:render(context)
    self.m_requested_update = false

    local pre_render_thread = coroutine.create(self.m_func)
    local success, str_or_err_msg = coroutine.resume(pre_render_thread)
    if not success then
        str_or_err_msg = ("%s\nerror rendering segment:\n%s\n%s"):format(
            string_rep("-", 80),
            debug_traceback(pre_render_thread, str_or_err_msg),
            string_rep("-", 80))
    end
    coroutine.close(pre_render_thread)

    if not str_or_err_msg then
        return {}, 0
    end

    local buffer = utils.string.split(str_or_err_msg, "\n")
    return buffer, #buffer
end

---@param update boolean | nil
function segment_class:remove(update)
    update = utils.value.default(update, true)

    self.m_parent:remove_child(self)

    if update then
        self.m_parent:update()
    end
end

---@param update boolean | nil
function segment_class:changed(update)
    self.m_requested_update = true

    if update then
        self.m_parent:update()
    end
end

function segment_class:requested_update()
    return self.m_requested_update
end

return segment_class
