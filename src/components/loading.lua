local utils = require("misc.utils")
local string_rep = string.rep

local colors = require("third-party.ansicolors")
local segment_class = require("src.segment.init")

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

---@param id string
---@param parent lua-term.segment_parent
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
        state_percent = utils.value.clamp(config.state_percent or 0, 0, 100),

        config = config,
    }, { __index = loading })
    instance.m_segment = segment_class.new(id, function()
        return instance:render()
    end, parent)

    config.state_percent = nil

    return instance
end

---@return string
function loading:render()
    local mark_tiles = math.floor(self.config.length * self.state_percent / 100)
    if mark_tiles == 0 then
        return self.config.color_bg(string_rep(" ", self.config.length))
    end

    return self.config.color_fg(string_rep(" ", mark_tiles)) ..
    self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
end

---@param state_percent integer | nil
---@param update boolean | nil
function loading:changed(state_percent, update)
    if state_percent then
        self.state_percent = utils.value.clamp(state_percent, 0, 100)
    end

    self.m_segment:changed(utils.value.default(update, true))
end

---@param state_percent integer
---@param update boolean | nil
function loading:changed_relativ(state_percent, update)
    self.state_percent = utils.value.clamp(self.state_percent + state_percent, 0, 100)

    self.m_segment:changed(utils.value.default(update, true))
end

---@param update boolean | nil
function loading:remove(update)
    self.m_segment:remove(update)
end

return loading
