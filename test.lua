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

local body = term.components.group.new("body", terminal)
local footer = term.components.group.new("footer", terminal)
local satusbar = term.components.line.new("statusbar", terminal)

local test = term.components.loading.new("test loading", satusbar)
local throb = term.components.throbber.new("test throbber", satusbar)
throb:rotate_on_every_update()

terminal:update()

for i = 1, 6 do
    local test2 = term.components.loading.new("test loading 2", body, {
        length = 30
    })
    for j = 1, 6 do
        sleep(0.1)
        test2:changed(100 / 6 * j, true)
    end
    test2:remove()

    sleep(0.2)
    test:changed(100 / 6 * i, true)
end
footer:remove(false)
satusbar:remove(false)
terminal:update()

print("## END ##")
