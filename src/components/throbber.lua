local utils = require("misc.utils")
local string_rep = string.rep

local colors = require("third-party.ansicolors")
local segment_class = require("src.segment.init")

---@class lua-term.components.throbber.config.create
---@field space integer | nil (default: 2)
---
---@field color_bg ansicolors.color | nil (default: transparent)
---@field color_fg ansicolors.color | nil (default: magenta)

---@class lua-term.components.throbber.config
---@field space integer
---
---@field color_bg ansicolors.color
---@field color_fg ansicolors.color

---@class lua-term.components.throbber
---@field id string
---
---@field config lua-term.components.throbber.config
---
---@field private m_rotate_on_every_update boolean
---
---@field private m_state integer
---
---@field private m_segment lua-term.segment
local throbber = {}

---@param id string
---@param parent lua-term.segment_parent
---@param config lua-term.components.throbber.config.create | nil
---@return lua-term.components.throbber
function throbber.new(id, parent, config)
    config = config or {}
    config.space = config.space or 2
    config.color_bg = config.color_bg or colors.transparent
    config.color_fg = config.color_fg or colors.magenta

    ---@type lua-term.components.throbber
    local instance = setmetatable({
        id = id,
        m_state = 0,

        m_rotate_on_every_update = false,

        config = config
    }, { __index = throbber })
    instance.m_segment = segment_class.new(id, parent, function()
        return instance:render()
    end)

    return instance
end

function throbber:render()
    self.m_state = self.m_state + 1
    if self.m_state > 3 then
        self.m_state = 0
    end

    local state_str
    if self.m_state == 0 then
        state_str = "\\"
    elseif self.m_state == 1 then
        state_str = "|"
    elseif self.m_state == 2 then
        state_str = "/"
    elseif self.m_state == 3 then
        state_str = "-"
    end

    if self.m_rotate_on_every_update then
        self.m_segment:changed()
    end

    return string_rep(" ", self.config.space) .. self.config.color_bg(self.config.color_fg(state_str))
end

function throbber:rotate()
    self.m_segment:changed(true)
end

---@param value boolean | nil
function throbber:rotate_on_every_update(value)
    self.m_rotate_on_every_update = utils.value.default(value, true)
end

---@param update boolean | nil
function throbber:remove(update)
    self.m_segment:remove(update)
end

return throbber
