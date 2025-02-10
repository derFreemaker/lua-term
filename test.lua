---@param seconds number
local function sleep(seconds)
    local end_time = seconds + os.clock()
    while end_time > os.clock() do
    end
end

package.path = "./?.lua;" .. package.path
---@type lua-term
local term = require("src.init")

local terminal = term.asci_terminal(io.stdout)
terminal:show_ids()
terminal:show_line_numbers()

-- local handle, err_msg = io.popen("ping 1.1.1.1", "r")
-- if not handle then
--     error(err_msg)
-- end

-- local stream = term.components.stream.new("<stream>", terminal, handle, {
--     before = term.colors.foreground_24bit(100, 100, 100) .. ">  ",
--     after = term.colors.reset
-- })
-- stream:read_all()

-- sleep(5)
-- stream:remove()
-- handle:close()

-- local test_tbl = {
--     1, 1, 1, 1, 1,
--     test = 1, test2 = 1, test3 = 1, test4 = 1, test5 = 1,
-- }
-- for _ in term.components.loop_with_end.pairs("test", terminal, test_tbl, {
--     show_iterations_per_second = true,
--     count = 10,
-- }) do
--     sleep(0.2)
-- end
-- for _ in term.components.loop_with_end.ipairs("test", terminal, test_tbl, {
--     count = 5,
-- }) do
--     sleep(0.15)
-- end
-- for _ in term.components.loop_with_end._for("test", terminal, 1, 1500, 1, {
--     show_iterations_per_second = true,
--     update_on_every_iterations = 10,
-- }) do
--     sleep(0.005)
-- end

local throbber = term.components.throbber("test", terminal, {
    rotate_on_every_update = true
})
terminal:update()

throbber:rotate()

sleep(3)

terminal:clear()

print("## END ##")
