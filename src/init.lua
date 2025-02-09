-- load class system
require("misc.class_system")

local utils = require("misc.utils")

local erase = require("src.misc.erase")
local cursor = require("src.misc.cursor")

local io_type = io.type
local math_abs = math.abs

local ansicolors = require("third-party.ansicolors")
local components = require("src.components.init")
local _terminal = require("src.terminal")

---@class lua-term
---@field colors ansicolors
---
---@field terminal lua-term.terminal.__con
---
---@field components lua-term.components
local term = {
    colors = ansicolors,
    components = components,

    terminal = _terminal,

    ---@param stream file*
    ---@return lua-term.terminal
    asci_terminal = function(stream)
        local cursor_pos = 1

        if io_type(stream) ~= "file" then
            error("stream not valid")
        end

        local builder = utils.string.builder.new()
        return _terminal({
            write = function(...)
                builder:append(...)
            end,
            write_line = function(...)
                builder:append_line(...)
                cursor_pos = cursor_pos + 1
            end,
            flush = function()
                stream:write(builder:build())
                stream:flush()

                builder:clear()
            end,

            erase_line = function()
                builder:append(erase.line())
            end,
            erase_till_end = function()
                builder:append(erase.till_end())
            end,

            go_to_line = function(line)
                local jump_lines = line - cursor_pos
                if jump_lines == 0 then
                    return
                end

                cursor_pos = line
                if jump_lines > 0 then
                    builder:append(cursor.go_down(jump_lines))
                else
                    builder:append(cursor.go_up(math_abs(jump_lines)))
                end
            end,
        })
    end,
}

return term
