---@class lua-term.components
---@field segment lua-term.segment
---
---@field text lua-term.components.text
---@field loading lua-term.components.loading
---@field throbber lua-term.components.throbber
---
---@field line lua-term.components.line
---@field group lua-term.components.group
---
---@field stream lua-term.components.stream
---
---@field loop_with_end lua-term.components.loop_with_end
local components = {
    segment = require("src.segment.init"),

    text = require("src.components.text"),
    loading = require("src.components.loading"),
    throbber = require("src.components.throbber"),

    line = require("src.components.line"),
    group = require("src.components.group"),

    stream = require("src.components.stream"),

    loop_with_end = require("src.components.loop_with_end")
}

return components
