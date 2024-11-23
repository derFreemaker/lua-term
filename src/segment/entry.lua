local string_rep = string.rep
local table_insert = table.insert
local table_remove = table.remove

---@class lua-term.segment_entry
---@field id string
---@field line integer
---@field lines string[]
---@field lines_count integer
---
---@field private m_showing_id boolean
---@field private m_segment lua-term.segment_interface
local segment_entry_class = {}

---@param id string
---@param segment lua-term.segment_interface
---@return lua-term.segment_entry
function segment_entry_class.new(id, segment)
    return setmetatable({
        id = id,
        line = 0,
        lines = {},
        lines_count = 0,

        m_showing_id = false,
        m_segment = segment,
    }, { __index = segment_entry_class })
end

---@return boolean
function segment_entry_class:requested_update()
    return self.m_segment:requested_update()
end

---@param segment lua-term.segment_interface
---@return boolean
function segment_entry_class:has_segment(segment)
    return self.m_segment == segment
end

---@param context lua-term.render_context
---@return table<integer, string>
function segment_entry_class:pre_render(context)
    local buffer, lines = self.m_segment:render(context)

    if context.show_ids ~= self.m_showing_id then
        if context.show_ids then
            local id_str = "---- '" .. self.id .. "' "
            id_str = id_str .. string_rep("-", 80 - id_str:len())
            table_insert(buffer, 1, id_str)
            table_insert(buffer, string_rep("-", 80))
        else
            table_remove(self.lines, #self.lines)
            table_remove(self.lines, 1)
        end

        self.m_showing_id = context.show_ids
    elseif self.m_showing_id then
        for i = #buffer, 0, -1 do
            buffer[i + 1] = buffer[i]
        end
    end

    for index, content in pairs(buffer) do
        self.lines[index] = content
    end
    for i = lines + 1, self.lines_count do
        self.lines[i] = nil
    end
    self.lines_count = #self.lines

    return buffer
end

return segment_entry_class
