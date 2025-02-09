local make_term_func = require("src.misc.maketermfunc")

---@class lua-term.erase
local erase = {
    ---@type fun() : string
    till_end = make_term_func("0J"),
    ---@type fun() : string
    till_begin = make_term_func("1J"),
    ---@type fun() : string
    screen = make_term_func("2J"),
    ---@type fun() : string
    saved_lines = make_term_func("3J"),

    ---@type fun() : string
    till_eol = make_term_func("0K"),
    ---@type fun() : string
    till_bol = make_term_func("1K"),
    ---@type fun() : string
    line = make_term_func("2K"),
}

return erase
