local utils = require("misc.utils")
local table_insert = table.insert
local table_concat = table.concat

local screen_class = require("src.misc.screen")

---@class lua-term.components.stream.config
---@field before string | ansicolors.color | nil
---@field after string | ansicolors.color | nil

---@class lua-term.components.stream : lua-term.segment_interface
---@field config lua-term.components.stream.config
---
---@field private m_stream file*
---@field private m_closed boolean
---
---@field private m_screen lua-term.screen
---
---@field private m_parent lua-term.segment_parent
---@field private m_requested_update boolean
local stream_class = {}

---@param id string
---@param parent lua-term.segment_parent
---@param stream file*
---@param config lua-term.components.stream.config | nil
---@return lua-term.components.stream
function stream_class.new(id, parent, stream, config)
    local instance = setmetatable({
        config = config or {},

        m_stream = stream,
        m_closed = false,

        m_screen = screen_class.new(function()
            return stream:read(1)
        end),

        m_parent = parent,
        m_requested_update = true,
    }, { __index = stream_class })
    parent:add_segment(id, instance)

    return instance
end

function stream_class:remove(update)
    self.m_parent:remove_child(self)

    if utils.value.default(update, true) then
        self.m_parent:update()
    end
end

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function stream_class:render(context)
    local buffer = self.m_screen:get_changed()
    local height = self.m_screen:get_height()
    self.m_screen:clear_changed()

    for line, content in pairs(buffer) do
        buffer[line] = ("%s%s%s"):format(tostring(self.config.before or ""), content, tostring(self.config.after or ""))
    end

    return buffer, height
end

function stream_class:requested_update()
    return self.m_requested_update
end

---@private
function stream_class:read(update)
    local char = self.m_screen:process_char()
    if not char then
        self.m_closed = true
        return
    end

    if utils.value.default(update, true) then
        self:update()
    end

    return char
end

---@param update boolean | nil
function stream_class:read_line(update)
    while true do
        local char = self:read(false)
        if not char then
            break
        end

        if char == "\n" then
            break
        end
    end

    if utils.value.default(update, true) then
        self:update()
    end
end

---@param update boolean | nil
function stream_class:read_all(update)
    while not self.m_closed do
        self:read(update)
    end
end

function stream_class:update()
    self.m_requested_update = true
    self.m_parent:update()
end

return stream_class
