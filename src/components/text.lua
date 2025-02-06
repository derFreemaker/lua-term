local utils = require("misc.utils")

local table_insert = table.insert
local table_concat = table.concat

local _segment = require("src.segment.init")

---@class lua-term.components.text : object, lua-term.segment.interface
---@field private m_text string[]
---@field private m_text_length integer
---@field private m_segment lua-term.segment
---@overload fun(id: string, parent: lua-term.segment.parent, text: string) : lua-term.components.text
local _text = {}

---@alias lua-term.components.text.__init fun(id: string, parent: lua-term.segment.parent, text: string)
---@alias lua-term.components.text.__con fun(id: string, parent: lua-term.segment.parent, text: string) : lua-term.components.text

---@deprecated
---@private
---@param id string
---@param parent lua-term.segment.parent
---@param text string
function _text:__init(id, parent, text)
    self.m_text = utils.string.split(text, "\n", true)
    self.m_text_length = #self.m_text

    self.m_segment = _segment(id, parent, function()
        return self.m_text, self.m_text_length
    end)
end

---@param parent lua-term.segment.parent
---@param ... any
---@return lua-term.components.text
function _text.static__print(parent, ...)
    local items = {}
    for _, value in ipairs({ ... }) do
        table_insert(items, tostring(value))
    end
    local text = table_concat(items, "\t")

    return _text("<print>", parent, text)
end

---@param update boolean | nil
function _text:remove(update)
    return self.m_segment:remove(update)
end

---@param text string
---@param update boolean | nil
function _text:change(text, update)
    self.m_text = utils.string.split(text, "\n", true)
    self.m_text_length = #self.m_text

    return self.m_segment:changed(update)
end

-- lua-term.segment_interface

---@return string
function _text:get_id()
    return self.m_segment:get_id()
end

function _text:get_length()
    return self.m_segment:get_length()
end

---@return boolean update_requested
function _text:requested_update()
    return _segment:requested_update()
end

---@param context lua-term.render_context
---@return table<integer, string> update_buffer
---@return integer lines
function _text:render(context)
    return self.m_segment:render(context)
end

return class("lua-term.components.text", _text)
