local table_insert = table.insert
local table_concat = table.concat

local segment_class = require("src.segment.init")

---@class lua-term.components.text
local _text = {}

---@param id string
---@param parent lua-term.segment_parent
---@param text string
function _text.new(id, parent, text)
    return segment_class.new(id, function()
        return text
    end, parent)
end

---@param parent lua-term.segment_parent
---@param ... any
function _text.print(parent, ...)
    local items = {}
    for _, value in ipairs({ ... }) do
        table_insert(items, tostring(value))
    end
    local text = table_concat(items, "\t")
    local segment = _text.new("<print>", parent, text)
    parent:update()
    return segment
end

return _text
