---@class lua-term.components
---@field text lua-term.components.text
---@field loading lua-term.components.loading
---@field throbber lua-term.components.throbber
---
---@field line lua-term.components.line
---@field group lua-term.components.group
---
---@field stream lua-term.components.stream
local components = {
    text = require("src.components.text"),
    loading = require("src.components.loading"),
    throbber = require("src.components.throbber"),

    line = require("src.components.line"),
    group = require("src.components.group"),

    stream = require("src.components.stream"),
}

return components
