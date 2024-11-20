local make_term_func = require("src.maketermfunc")

---@class lua-term.erase
local erase = {}

erase.till_end = make_term_func("0J")
erase.till_begin = make_term_func("1J")
erase.screen = make_term_func("2J")
erase.saved_lines = make_term_func("3J")

erase.till_eol = make_term_func("0K")
erase.till_bol = make_term_func("1K")
erase.line = make_term_func("2K")

return erase
