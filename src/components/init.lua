---@class lua-term.components
---@field group lua-term.components.group
---
---@field text lua-term.components.text
---@field loading lua-term.components.loading
---@field throbber lua-term.components.throbber
local components = {
    group = require("src.components.group"),

    text = require("src.components.text"),
    loading = require("src.components.loading"),
    throbber = require("src.components.throbber"),
}

return components
