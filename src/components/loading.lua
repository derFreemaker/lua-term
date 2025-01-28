local utils = require("misc.utils")
local string_rep = string.rep

local colors = require("third-party.ansicolors")
local segment_class = require("src.segment.init")

---@class lua-term.components.loading.config.create
---@field length integer | nil (default: 40)
---
---@field color_bg ansicolors.color | nil (default: black)
---@field color_fg ansicolors.color | nil (default: magenta)
---
---@field count integer

---@class lua-term.components.loading.config
---@field length integer
---
---@field color_bg ansicolors.color
---@field color_fg ansicolors.color
---
---@field count integer

---@class lua-term.components.loading : lua-term.segment_interface
---@field id string
---
---@field state integer
---
---@field config lua-term.components.loading.config
---
---@field private m_segment lua-term.segment
local loading = {}

---@param id string
---@param parent lua-term.segment_parent
---@param config lua-term.components.loading.config.create
---@return lua-term.components.loading
function loading.new(id, parent, config)
    config = config or {}

    config.length = utils.value.default(config.length, 40)

    config.color_bg = utils.value.default(config.color_bg, colors.onblack)
    config.color_fg = utils.value.default(config.color_fg, colors.onmagenta)

    ---@type lua-term.components.loading
    local instance = setmetatable({
        id = id,
        state = 0,

        config = config,
    }, { __index = loading })
    instance.m_segment = segment_class.new(id, parent, function()
        return instance:render()
    end)

    return instance
end

---@return string
function loading:render()
    local mark_tiles = math.floor(self.config.length * self.state / self.config.count)
    if mark_tiles == 0 then
        return self.config.color_bg(string_rep(" ", self.config.length))
    end

    return self.config.color_fg(string_rep(" ", mark_tiles))
        .. self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
end

function loading:requested_update()
    self.m_segment:requested_update()
end

---@param state integer
---@param update boolean | nil
function loading:changed(state, update)
    self.state = state
    self.m_segment:changed(utils.value.default(update, true))
end

---@param state integer
---@param update boolean | nil
function loading:changed_relativ(state, update)
    self.state = self.state + state
    self.m_segment:changed(utils.value.default(update, true))
end

---@param update boolean | nil
function loading:remove(update)
    self.m_segment:remove(update)
end

return loading
