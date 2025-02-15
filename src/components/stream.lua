local utils = require("misc.utils")

local io_type = io.type

local _segment = require("src.segment.init")
local _screen = require("src.misc.screen")

---@class lua-term.components.stream.config
---@field before_each_line string | ansicolors.color | nil
---@field after_each_line string | ansicolors.color | nil

---@class lua-term.components.stream : lua-term.segment.interface, object
---@field config lua-term.components.stream.config
---
---@field private m_stream file*
---@field private m_closed boolean
---
---@field private m_screen lua-term.screen
---
---@field private m_segment lua-term.segment
---@overload fun(id: string, parent: lua-term.segment.parent, stream: file*, config: lua-term.components.stream.config | nil) : lua-term.components.stream
local _stream = {}

---@alias lua-term.components.stream.__init fun(id: string, parent: lua-term.segment.parent, stream: file*, config: lua-term.components.stream.config | nil)
---@alias lua-term.components.stream.__con fun(id: string, parent: lua-term.segment.parent, stream: file*, config: lua-term.components.stream.config | nil) : lua-term.components.stream

---@deprecated
---@private
---@param id string
---@param parent lua-term.segment.parent
---@param stream file*
---@param config lua-term.components.stream.config | nil
function _stream:__init(id, parent, stream, config)
    self.config = config or {}

    if io_type(stream) ~= "file" then
        error("stream not valid")
    end

    self.m_stream = stream
    self.m_closed = false

    self.m_screen = _screen.new(function()
        return stream:read(1)
    end)

    self.m_segment = _segment(id, parent, function(_)
        local buffer = self.m_screen:get_changed()
        local length = #buffer

        for line, content in pairs(buffer) do
            buffer[line] = ("%s%s%s"):format(tostring(self.config.before_each_line or ""), content,
                tostring(self.config.after_each_line or ""))
        end

        return buffer, length
    end)
end

function _stream:remove(update)
    self.m_segment:remove(update)
end

function _stream:requested_update()
    return self.m_segment:requested_update()
end

---@private
---@param update boolean | nil
function _stream:read(update)
    local char = self.m_screen:process_char()
    if not char then
        self.m_closed = true
        return
    end

    if update then
        self.m_segment:changed(true)
    end

    return char
end

---@param update boolean | nil
function _stream:read_line(update)
    while true do
        local char = self:read(false)
        if not char then
            break
        end

        if char == "\n" then
            break
        end
    end

    if update then
        self.m_segment:changed(true)
    end
end

---@param update boolean | nil
function _stream:read_all(update)
    while not self.m_closed do
        self:read(update)
    end
end

return class("lua-term.components.screen", _stream)
