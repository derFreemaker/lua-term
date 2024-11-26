local utils = require("misc.utils")
local table_insert = table.insert
local table_concat = table.concat

---@class lua-term.components.stream.config
---@field before string | nil
---@field after string | nil

---@class lua-term.components.stream : lua-term.segment_interface
---@field config lua-term.components.stream.config
---
---@field private m_stream file*
---@field private m_closed boolean
---
---@field private m_buffer string[][]
---@field private m_line_count integer
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

        m_buffer = {
            {}
        },
        m_line_count = 1,

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
    ---@type string[]
    local buffer = {
        [self.m_line_count] = ("%s%s%s"):format(
            self.config.before or "",
            table_concat(self.m_buffer[self.m_line_count]),
            self.config.after or ""
        )
    }
    return buffer, self.m_line_count
end

function stream_class:requested_update()
    return self.m_requested_update
end

---@private
---@param update boolean | nil
function stream_class:read(update)
    local char = self.m_stream:read(1)
    if not char then
        self.m_closed = true
        return nil
    end

    if char ~= "\n" then
        table_insert(self.m_buffer[self.m_line_count], char)
    end

    if utils.value.default(update, true) then
        self:update()
    end

    return char
end

---@param update boolean | nil
function stream_class:read_line(update)
    while true do
        local char = self:read(update)
        if not char then
            break
        end

        if char == "\n" then
            self.m_line_count = self.m_line_count + 1
            self.m_buffer[self.m_line_count] = {}
            break
        end
    end
end

---@param update boolean | nil
function stream_class:read_all(update)
    while not self.m_closed do
        self:read_line(update)
    end
end

function stream_class:update()
    self.m_requested_update = true
    self.m_parent:update()
end

return stream_class
