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

terminal:overrite_print()

local throb = term.components.throbber.new("test throbber", terminal, {
    space = 2
})
local test = term.components.loading.new("test loading", terminal)

local test_print = print("test print")
---@cast test_print -nil

terminal:update()

for i = 1, 10 do
    local test2 = term.components.loading.new("test loading 2", terminal, {
        pos = 3,
        length = 30
    })
    for j = 1, 101, 5 do
        sleep(0.05)
        test2:changed(j)
        terminal:update()
    end
    test2:remove()
    sleep(0.1)

    test:changed(i * 10)
end
test:remove()
throb:remove()
test_print:remove()

terminal:restore_print()
terminal:update()

print("## END ##")
