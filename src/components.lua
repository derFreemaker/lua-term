local utils = require("utils.utils")

local colors = require("third-party.ansicolors")

local string_rep = string.rep

---@class lua-term.components
local components = {}

---------------
--- loading ---
---------------

---@class lua-term.components.loading.config.create
---@field length integer | nil (default: 40)
---@field state_percent integer | nil in percent (default: 0)
---
---@field color_bg ansicolors.color | nil (default: black)
---@field color_fg ansicolors.color | nil (default: magenta)

---@class lua-term.components.loading.config
---@field length integer
---
---@field color_bg ansicolors.color
---@field color_fg ansicolors.color

---@class lua-term.components.loading
---@field id string
---@field state_percent integer
---
---@field config lua-term.components.loading.config
---
---@field private m_segment lua-term.segment
local loading = {}
components.loading = loading

---@param id string
---@param parent lua-term.parent
---@param config lua-term.components.loading.config.create | nil
---@return lua-term.components.loading
function loading.new(id, parent, config)
    config = config or {}
    config.color_bg = config.color_bg or colors.onblack
    config.color_fg = config.color_fg or colors.onmagenta
    config.length = config.length or 40

    ---@type lua-term.components.loading
    local instance = setmetatable({
        id = id,
        state_percent = config.state_percent or 0,

        config = config,
    }, { __index = loading })
    instance.m_segment = parent:create_segment(id, function()
        return instance:render()
    end)

    config.state_percent = nil

    return instance
end

---@return string
function loading:render()
    local mark_tiles = math.floor(self.config.length * self.state_percent / 100)
    return self.config.color_fg(string_rep(" ", mark_tiles)) .. self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
end

---@param state_percent integer | nil
---@param update boolean | nil
function loading:changed(state_percent, update)
    if state_percent then
        self.state_percent = state_percent
    end

    self.m_segment:changed(update or true)
end

---@param state_percent integer
---@param update boolean | nil
function loading:changed_relativ(state_percent, update)
    self.state_percent = self.state_percent + state_percent
    self.m_segment:changed(update or true)
end

---@param update boolean | nil
function loading:remove(update)
    self.m_segment:remove(update)
end

----------------
--- throbber ---
----------------

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
components.throbber = throbber

---@param id string
---@param parent lua-term.parent
---@param config lua-term.components.throbber.config.create | nil
---@return lua-term.components.throbber
function throbber.new(id, parent, config)
    config = config or {}
    config.space = config.space or 2
    config.color_bg = config.color_bg or colors.reset
    config.color_fg = config.color_fg or colors.magenta

    ---@type lua-term.components.throbber
    local instance = setmetatable({
        id = id,
        m_state = 0,

        m_rotate_on_every_update = false,

        config = config
    }, { __index = throbber })
    instance.m_segment = parent:create_segment(id, function()
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

return components
