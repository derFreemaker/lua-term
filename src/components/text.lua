local table_insert = table.insert
local table_concat = table.concat

local segment_class = require("src.segment.init")

---@class lua-term.components.text : lua-term.segment_interface
---@field private m_text string
---@field private m_segment lua-term.segment
local _text = {}

---@param id string
---@param parent lua-term.segment_parent
---@param text string
---@return lua-term.components.text
function _text.new(id, parent, text)
    local instance = setmetatable({
        m_text = text
    }, { __index = _text })
    instance.m_segment = segment_class.new(id, function()
        ---@diagnostic disable-next-line: invisible
        return instance.m_text
    end, parent)

    return instance
end

---@param parent lua-term.segment_parent
---@param ... any
---@return lua-term.segment
function _text.print(parent, ...)
    local items = {}
    for _, value in ipairs({ ... }) do
        table_insert(items, tostring(value))
    end
    local text = table_concat(items, "\t")

    local segment = segment_class.new("<print>", function()
        return text
    end, parent)
    parent:update()
    return segment
end

---@return boolean update_requested
function _text:requested_update()
    return segment_class:requested_update()
end

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function _text:render(context)
    return self.m_segment:render(context)
end

---@param update boolean | nil
function _text:remove(update)
    return self.m_segment:remove(update)
end

---@param text string
---@param update boolean | nil
function _text:change(text, update)
    self.m_text = text
    return self.m_segment:changed(update)
end

return _text
