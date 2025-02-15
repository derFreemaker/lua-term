local string_rep = string.rep

local colors = require("third-party.ansicolors")
local _segment = require("src.segment.init")
local _segment_interface = require("src.segment.interface")

---@class lua-term.components.throbber.config.create
---@field space integer | nil (default: 2)
---
---@field color_bg ansicolors.color | nil (default: transparent)
---@field color_fg ansicolors.color | nil (default: magenta)
---
---@field rotate_on_every_update boolean | nil

---@class lua-term.components.throbber.config
---@field space integer
---
---@field color_bg ansicolors.color
---@field color_fg ansicolors.color
---
---@field rotate_on_every_update boolean

---@class lua-term.components.throbber : lua-term.segment.single_line_interface, object
---@field config lua-term.components.throbber.config
---
---@field private m_state integer
---@field private m_segment lua-term.segment
---@overload fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.throbber.config.create | nil) : lua-term.components.throbber
local _throbber = {}

---@alias lua-term.components.throbber.__init fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.throbber.config.create | nil)
---@alias lua-term.components.throbber.__con fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.throbber.config.create | nil) : lua-term.components.throbber

---@deprecated
---@private
---@param id string
---@param parent lua-term.segment.single_line_parent
---@param config lua-term.components.throbber.config.create | nil
function _throbber:__init(id, parent, config)
    config = config or {}
    config.space = config.space or 2
    config.color_bg = config.color_bg or colors.transparent
    config.color_fg = config.color_fg or colors.magenta
    config.rotate_on_every_update = config.rotate_on_every_update or true
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.config = config

    self.m_state = 0
    self.m_segment = _segment(id, parent, function(_)
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

        if self.config.rotate_on_every_update then
            self.m_segment:changed()
        end

        local str = ""
        if self.config.space > 0 then
            str = string_rep(" ", self.config.space)
        end

        str = str .. self.config.color_bg(self.config.color_fg(state_str))
        return { str }, 1
    end)
end

function _throbber:rotate()
    self.m_segment:changed(true)
end

-- lua-term.segment.single_line_interface

function _throbber:get_id()
    return self.m_segment:get_id()
end

function _throbber:requested_update()
    return self.m_segment:requested_update()
end

function _throbber:remove(update)
    return self.m_segment:remove(update)
end

function _throbber:render_impl(context)
    return self.m_segment:render_impl(context)
end

return class("lua-term.components.throbber", _throbber, {
    inherit = {
        _segment_interface
    }
})
