local table_insert = table.insert
local table_concat = table.concat

local make_term_func = require("src.misc.maketermfunc")

---@class lua-term.cursor
local cursor = {
    ---@type fun() : string
    home = make_term_func("H"),
    ---@type fun(line: integer, column: integer)  : string
    jump = make_term_func("%d;%dH"),
    ---@type fun(value: integer) : string
    go_up = make_term_func("%dA"),
    ---@type fun(value: integer) : string
    go_down = make_term_func("%dB"),
    ---@type fun(value: integer) : string
    go_right = make_term_func("%dC"),
    ---@type fun(value: integer) : string
    go_left = make_term_func("%dD"),
    ---@type fun() : string
    save = make_term_func("s"),
    ---@type fun() : string
    restore = make_term_func("u"),
}

return cursor
