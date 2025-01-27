---@param seconds number
local function sleep(seconds)
    local end_time = seconds + os.clock()
    while end_time > os.clock() do
    end
end

package.path = "./?.lua;" .. package.path
---@type lua-term
local term = require("src.init")

local terminal = term.terminal.stdout()
-- terminal.show_ids = true
-- terminal.show_lines = true

-- local body = term.components.group.new("body", terminal)
-- local satusbar = term.components.line.new("statusbar", terminal)

-- local test = term.components.loading.new("test loading", satusbar)
-- local throb = term.components.throbber.new("test throbber", satusbar)
-- throb:rotate_on_every_update()

-- terminal:update()

-- for i = 1, 6 do
--     local test2 = term.components.loading.new("test loading 2", body, {
--         length = 30
--     })
--     for j = 1, 6 do
--         sleep(0.1)
--         test2:changed(100 / 6 * j)
--     end
--     test2:remove()

--     sleep(0.2)
--     test:changed(100 / 6 * i)
-- end

-- terminal:clear()

-- local handle, err_msg = io.popen("ping 1.1.1.1", "r")
-- if not handle then
--     error(err_msg)
-- end

-- local stream = term.components.stream.new("<stream>", terminal, handle, {
--     before = term.colors.foreground_24bit(100, 100, 100) .. ">  ",
--     after = term.colors.reset
-- })
-- stream:read_all()

-- sleep(2)
-- stream:remove()
-- handle:close()


local test_tbl = {
    1, 1, 1, 1, 1,
    test = 1, test2 = 1, test3 = 1, test4 = 1, test5 = 1,
}
for _ in term.components.loading.loop("test", terminal, test_tbl) do
    sleep(0.05)
end
for _ in term.components.loading.loop("test", terminal, test_tbl, ipairs) do
    sleep(0.05)
end

terminal:close()

print("## END ##")
