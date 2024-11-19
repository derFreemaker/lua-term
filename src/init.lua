local make_term_func = require("src.maketermfunc")

---@class lua-term
---@field colors ansicolors
local term = {
    colors = require("third-party.ansicolors")
}

term.clear = make_term_func("2J")
term.clear_eol = make_term_func("K")
term.clear_end = make_term_func("J")

return term
