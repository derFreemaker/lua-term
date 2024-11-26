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

local screen_func = require("screen")

local install = "winget install --disable-interactivity --accept-source-agreements --accept-package-agreements --id \"9P8LTPGCBZXD\" -e"
local uninstall = "winget uninstall --disable-interactivity --id \"9P8LTPGCBZXD\" -e"

local handle, err_msg = io.popen(install, "rb")
if not handle then
    error(err_msg)
end

local text_seg = term.components.segment.new("text", function ()
    return screen_str()
end, terminal)

while true do
    local char = handle:read(1)

end

handle:close()

print("## END ##")
