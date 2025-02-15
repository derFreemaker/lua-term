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
-- terminal:show_line_numbers()

local handle, err_msg = io.popen("ping 1.1.1.1", "r")
if not handle then
    error(err_msg)
end

local stream = term.components.stream("<stream>", terminal, handle, {
    before_each_line = term.colors.foreground_24bit(100, 100, 100) .. ">  ",
    after_each_line = term.colors.reset
})
stream:read_all(true)

sleep(1)
stream:remove(true)
handle:close()

-- local test_tbl = {
--     1, 1, 1, 1, 1,
--     test = 1, test2 = 1, test3 = 1, test4 = 1, test5 = 1,
-- }
-- for _ in term.components.loop_with_end.pairs("test", terminal, test_tbl, {
--     show_iterations_per_second = true,
-- }) do
--     sleep(0.2)
-- end
-- for _ in term.components.loop_with_end.ipairs("test", terminal, test_tbl) do
--     sleep(0.1)
-- end
-- for _ in term.components.loop_with_end._for("test", terminal, 1, 1500, 1, {
--     show_iterations_per_second = true,
--     update_on_every_iterations = 50,
-- }) do
--     sleep(0.005)
-- end

-- terminal:clear()

print("## END ##")
