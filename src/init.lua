-- load class system
require("misc.class_system")

---@class lua-term
---@field colors ansicolors
---
---@field terminal lua-term.terminal.__con
---@field components lua-term.components
local term = {
    colors = require("third-party.ansicolors"),

    terminal = require("src.terminal"),
    components = require("src.components.init")
}

return term
