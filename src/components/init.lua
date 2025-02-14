---@class lua-term.components
---@field segment lua-term.segment | lua-term.segment.__con
---
---@field text lua-term.components.text | lua-term.components.text.__con
---@field loading lua-term.components.loading | lua-term.components.loading.__con
---@field throbber lua-term.components.throbber | lua-term.components.throbber.__con
---
---@field line lua-term.components.line | lua-term.components.line.__con
---@field group lua-term.components.group | lua-term.components.group.__con
---
---@field stream lua-term.components.stream | lua-term.components.stream.__con
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
