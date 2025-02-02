local utils = require("misc.utils")

local string_rep = string.rep
local table_insert = table.insert
local table_remove = table.remove
local debug_traceback = debug.traceback

local _segment_interface = require("src.segment.interface")

---@class lua-term.segment.info
---@field showing_id boolean
---@field requested_update boolean
---
---@field line integer
---@field length integer

---@alias lua-term.segment.func (fun() : table<integer, string>, integer)

---@class lua-term.segment : object, lua-term.segment_interface
---@field id string
---
---@field m_showing_id boolean
---@field m_requested_update boolean
---
---@field private m_content string[]
---@field private m_content_length integer
---@field private m_func lua-term.segment.func
---
---@field private m_parent lua-term.segment_parent
---@overload fun(id: string, parent: lua-term.segment_parent, func: lua-term.segment.func) : lua-term.segment
local _segment = {}

---@alias lua-term.segment.__init fun(id: string, parent: lua-term.segment_parent, func: lua-term.segment.func)
---@alias lua-term.segment.__con fun(id: string, parent: lua-term.segment_parent, func: lua-term.segment.func) : lua-term.segment

---@deprecated
---@private
---@param id string
---@param parent lua-term.segment_parent
---@param func lua-term.segment.func
function _segment:__init(id, parent, func)
    self.id = id

    self.m_requested_update = true
    self.m_showing_id = false

    self.m_content = {}
    self.m_content_length = 0
    self.m_func = func

    self.m_parent = parent

    parent:add_child(self)
end

---@deprecated
---@private
function _segment:__gc()
    self:remove(true)
end

---@param update boolean | nil
function _segment:remove(update)
    self.m_parent:remove_child(self)

    if update then
        self.m_parent:update()
    end
end

---@param update boolean | nil
function _segment:changed(update)
    self.m_requested_update = true

    if update then
        self.m_parent:update()
    end
end

-- lua-term.segment_interface

---@return boolean
function _segment:requested_update()
    return self.m_requested_update
end

---@param render_func lua-term.segment.func
---@return lua-term.segment.func
local function create_render_function(render_func)
    return function()
        local buffer, lines = render_func()

        assert(type(buffer) == "table",
            "no buffer return from render function (#1 return value)")
        assert(math.type(lines) == "integer",
            "no lines count return from render function (#2 return value)")

        return buffer, lines
    end
end

---@return table<integer, string> update_buffer
---@return integer lines
function _segment:render(context)
    local buffer, length
    if self.m_requested_update then
        self.m_requested_update = false

        local pre_render_thread = coroutine.create(create_render_function(self.m_func))
        ---@type boolean, table<integer, string> | string, integer
        local success, buffer_or_msg, buffer_length = coroutine.resume(pre_render_thread)

        if not success then
            buffer_or_msg = utils.string.split(
                ("%s\nerror rendering segment:\n%s\n%s")
                :format(
                    string_rep("-", 80),
                    debug_traceback(pre_render_thread, buffer_or_msg),
                    string_rep("-", 80)
                ),
                "\n", true)
            buffer_length = #buffer_or_msg
        end
        ---@cast buffer_or_msg -string

        buffer = buffer_or_msg
        length = buffer_length
    end

    if self.m_showing_id then
        for i = 1, length, 1 do
            self.m_content[i + 1] = buffer[i]
        end
        self.m_content_length = length + 2
    else
        for i = 1, length, 1 do
            self.m_content[i] = buffer[i]
        end
        self.m_content_length = length
    end

    if context.show_id ~= self.m_showing_id then
        if context.show_id then
            self.m_content_length = self.m_content_length + 2

            local id_str = "---- '" .. self.id .. "' "
            id_str = id_str .. string_rep("-", 80 - id_str:len())
            table_insert(self.m_content, 1, string_rep("-", 80 - id_str))
            table_insert(self.m_content, string_rep("-", 80))
        else
            self.m_content_length = self.m_content_length - 2

            table_remove(self.m_content, 1)
            table_remove(self.m_content, self.m_content_length + 1)
        end

        self.m_showing_id = context.show_id
    end

    if context.position_changed then
        return self.m_content, self.m_content_length
    end

    return buffer, length
end

return class("lua-term.segment", _segment, {
    inherit = {
        _segment_interface
    }
})
