local make_term_func = require("src.maketermfunc")

---@class lua-term.cursor
local cursor = {
    ---@type fun(w: integer, h: integer)
    jump = make_term_func("%d;%dH"),
    ---@type fun(value: integer)
    go_up = make_term_func("%dA"),
    ---@type fun(value: integer)
    go_down = make_term_func("%dB"),
    ---@type fun(value: integer)
    go_right = make_term_func("%dC"),
    ---@type fun(value: integer)
    go_left = make_term_func("%dD"),
    ---@type fun()
    save = make_term_func("s"),
    ---@type fun()
    restore = make_term_func("u"),
}

return cursor
