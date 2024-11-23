local utils = require("misc.utils")
local table_insert = table.insert
local table_remove = table.remove

local text_component = require("src.components.text")
local entry_class = require("src.segment.entry")

---@class lua-term.components.group : lua-term.segment_interface, lua-term.segment_parent
---@field private m_requested_update boolean
---@field private m_childs lua-term.segment_entry[]
---@field private m_parent lua-term.segment_parent
local group_class = {}

---@param id string
---@param parent lua-term.segment_parent
---@return lua-term.components.group
function group_class.new(id, parent)
    local instance = setmetatable({
        m_childs = {},
        m_requested_update = false,

        m_parent = parent,
    }, { __index = group_class })
    parent:add_segment(id, instance)

    return instance
end

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function group_class:render(context)
    self.m_requested_update = false

    if #self.m_childs == 0 then
        return {}, 0
    end

    local line_buffer_pos = 0
    local line_buffer = {}
    for _, child in pairs(self.m_childs) do
        if not context.show_ids and not child:requested_update() then
            if child.line ~= line_buffer_pos then
                for index, line in ipairs(child.lines) do
                    line_buffer[line_buffer_pos + index] = line
                end
            end

            line_buffer_pos = line_buffer_pos + child.lines_count
            goto continue
        end

        local update_lines = child:pre_render(context)
        child.line = line_buffer_pos
        for index, line in pairs(update_lines) do
            line_buffer[line_buffer_pos + index] = line
        end
        line_buffer_pos = line_buffer_pos + #update_lines

        ::continue::
    end

    local last_child = self.m_childs[#self.m_childs]
    local last_line = last_child.line + last_child.lines_count
    return line_buffer, last_line
end

---@param update boolean | nil
function group_class:remove(update)
    update = utils.value.default(update, true)

    self.m_parent:remove_child(self)

    if update then
        self.m_parent:update()
    end
end

function group_class:requested_update()
    if self.m_requested_update then
        return true
    end

    for _, child in ipairs(self.m_childs) do
        if child:requested_update() then
            return true
        end
    end
end

-- lua-term.parent

function group_class:update()
    self.m_parent:update()
end

function group_class:print(...)
    return text_component.print(self, ...)
end

function group_class:add_segment(id, segment)
    local entry = entry_class.new(id, segment)
    table_insert(self.m_childs, entry)
end

function group_class:remove_child(child)
    for index, entry in pairs(self.m_childs) do
        if entry:has_segment(child) then
            table_remove(self.m_childs, index)
        end
    end

    self.m_requested_update = true
end

return group_class
