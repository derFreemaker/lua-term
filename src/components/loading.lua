local utils = require("misc.utils")
local string_rep = string.rep

local colors = require("third-party.ansicolors")
local _segment = require("src.segment.init")
local _segment_interface = require("src.segment.interface")

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

---@class lua-term.components.loading : lua-term.segment.single_line_interface, object
---@field id string
---
---@field state integer
---
---@field config lua-term.components.loading.config
---
---@field private m_segment lua-term.segment
---@overload fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.loading.config.create) : lua-term.components.loading
local _loading = {}

---@alias lua-term.components.loading.__con fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.loading.config.create) : lua-term.components.loading

---@deprecated
---@private
---@param id string
---@param parent lua-term.segment.single_line_parent
---@param config lua-term.components.loading.config.create
function _loading:__init(id, parent, config)
    config = config or {}
    config.length = utils.value.default(config.length, 40)
    config.color_bg = utils.value.default(config.color_bg, colors.onblack)
    config.color_fg = utils.value.default(config.color_fg, colors.onmagenta)

    self.state = 0
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.config = config

    self.m_segment = _segment(id, parent, function(_)
        local mark_tiles = math.floor(self.config.length * self.state / self.config.count)
        if mark_tiles == 0 then
            return { self.config.color_bg(string_rep(" ", self.config.length)) }, 1
        end

        return {
            self.config.color_fg(string_rep(" ", mark_tiles))
            .. self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
        }, 1
    end)
end

function _loading:changed(state, update)
    if state then
        self.state = utils.number.clamp(state, 0, self.config.count)
    end

    self.m_segment:changed(utils.value.default(update, true))
end

---@param state integer
---@param update boolean | nil
function _loading:changed_relativ(state, update)
    self:changed(self.state + state, update)
end

-- lua-term.segment.single_line_interface

function _loading:get_id()
    return self.m_segment:get_id()
end

---@param update boolean | nil
function _loading:remove(update)
    self.m_segment:remove(update)
end

function _loading:requested_update()
    self.m_segment:requested_update()
end

function _loading:render_impl(context)
    return self.m_segment:render_impl(context)
end

return class("lua-term.components.loading", _loading, {
    inherit = {
        _segment_interface
    }
})
