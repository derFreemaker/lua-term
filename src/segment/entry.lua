local string_rep = string.rep
local table_insert = table.insert

---@class lua-term.segment.entry : object
---@field id string
---
---@field private m_line integer
---
---@field private m_showing_id boolean
---
---@field private m_segment lua-term.segment.interface
---@overload fun(segment: lua-term.segment.interface) : lua-term.segment.entry
local _entry = {}

---@deprecated
---@private
---@param segment lua-term.segment.interface
function _entry:__init(segment)
    self.id = segment:get_id()

    self.m_line = 0

    self.m_showing_id = false

    self.m_segment = segment
end

function _entry:get_length()
    local segment_length = self.m_segment:get_length()

    if self.m_showing_id then
        return segment_length + 2
    end

    return segment_length
end

function _entry:get_line()
    return self.m_line
end

---@param line integer
function _entry:set_line(line)
    self.m_line = line
end

---@return boolean
function _entry:requested_update()
    return self.m_segment:requested_update()
end

---@param segment lua-term.segment.interface
function _entry:wraps_segment(segment)
    return self.m_segment == segment
end

---@private
---@param buffer table<integer, string>
---@param width integer
function _entry:add_id_to_buffer(buffer, length, width)
    for i = length, 1, -1 do
        buffer[i + 1] = buffer[i]
        buffer[i] = nil
    end

    local id_str = "---- '" .. self.id .. "' "
    buffer[1] = id_str .. string_rep("-", width - id_str:len())
    buffer[length] = "<" .. string_rep("-", width - 2) .. ">"
end

---@param context lua-term.render_context
function _entry:render(context)
    local buffer, length = self.m_segment:render_impl(context)

    if self.m_showing_id then
        for i = length, 1, -1 do
            buffer[i + 1] = buffer[i]
            buffer[i] = nil
        end
        length = length + 2

        if context.position_changed then
            self:add_id_to_buffer(buffer, length, context.width)
        end
    end

    if context.show_id ~= self.m_showing_id then
        if context.show_id then
            length = length + 2

            self:add_id_to_buffer(buffer, length, context.width)
        else
            buffer[1] = nil
            buffer[length] = nil

            for index, content in pairs(buffer) do
                buffer[index - 1] = content
            end
            length = length - 2
        end

        self.m_showing_id = context.show_id
    end

    return buffer, length
end

return class("lua-term.segment.entry", _entry)
