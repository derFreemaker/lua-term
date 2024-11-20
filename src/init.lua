---@class lua-term
---@field colors ansicolors
local term = {
    colors = require("third-party.ansicolors"),

    terminal = require("src.terminal"),
    components = require("src.components")
}

return term
