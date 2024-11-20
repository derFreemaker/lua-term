---@class lua-term
---@field colors ansicolors
---
---@field terminal lua-term.terminal
---@field components lua-term.components
local term = {
    colors = require("third-party.ansicolors"),

    terminal = require("src.terminal"),
    components = require("src.components")
}

return term
