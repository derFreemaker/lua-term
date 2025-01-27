local utils = require("misc.utils")
local string_rep = string.rep

local _string_builder = require("src.common.string_builder")

local colors = require("third-party.ansicolors")
local segment_class = require("src.segment.init")

--//TODO: add some metrics

---@class lua-term.components.loading.config.create
---@field length integer | nil (default: 40)
---
---@field color_bg ansicolors.color | nil (default: black)
---@field color_fg ansicolors.color | nil (default: magenta)
---
---@field count integer | nil
---@field show_iterations_per_second boolean | nil
---@field show_porgress_number boolean | nil

---@class lua-term.components.loading.config
---@field length integer
---
---@field color_bg ansicolors.color
---@field color_fg ansicolors.color
---
---@field count integer
---@field show_iterations_per_second boolean
---@field show_porgress_number boolean


---@class lua-term.components.loading
---@field id string
---
---@field state integer
---
---@field config lua-term.components.loading.config
---
---@field private m_segment lua-term.segment
local loading = {}

---@param id string
---@param parent lua-term.segment_parent
---@param config lua-term.components.loading.config.create | nil
---@return lua-term.components.loading
function loading.new(id, parent, config)
    config = config or {}

    config.length = utils.value.default(config.length, 40)

    config.color_bg = utils.value.default(config.color_bg, colors.onblack)
    config.color_fg = utils.value.default(config.color_fg, colors.onmagenta)

    config.count = utils.value.default(config.count, -1)
    config.show_iterations_per_second = utils.value.default(config.show_iterations_per_second, false)
    config.show_iterations_per_second = utils.value.default(config.show_porgress_number, false)

    ---@type lua-term.components.loading
    local instance = setmetatable({
        id = id,
        state = 0,

        config = config,
    }, { __index = loading })
    instance.m_segment = segment_class.new(id, function()
        return instance:render()
    end, parent)

    return instance
end

---@class lua-term.components.loading.loop.config : lua-term.components.loading.config.create
---@field tbl_count integer | nil if not given will count tbl first
---@field update_on_every_iteration boolean | nil default is `true`
---@field remove_on_end boolean | nil default is `true`

---@return string
function loading:render()
    local mark_tiles = math.floor(self.config.length * self.state_percent / 100)
    if mark_tiles == 0 then
        return self.config.color_bg(string_rep(" ", self.config.length))
    end

    local builder = _string_builder.new()
    builder:append(
        self.config.color_fg(string_rep(" ", mark_tiles)),
        self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
    )

    if self.config.show_porgress_number then
        builder:append(" <", self.state)

        if self.config.count ~= -1 then
            builder:append("/", self.config.count)
        end

        builder:append(">")
    end

    if self.config.show_iterations_per_second then
        --//TODO: keep delta
    end

    return builder:build()
end

---@param state_percent integer
---@param update boolean | nil
function loading:changed(state_percent, update)
    self.state_percent = utils.value.clamp(state_percent, 0, 100)

    self.m_segment:changed(utils.value.default(update, true))
end

---@param state_percent integer
---@param update boolean | nil
function loading:changed_relativ(state_percent, update)
    self.state_percent = utils.value.clamp(self.state_percent + state_percent, 0, 100)

    self.m_segment:changed(utils.value.default(update, true))
end

---@param update boolean | nil
function loading:remove(update)
    self.m_segment:remove(update)
end

---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment_parent
---@param tbl table<K, V>
---@param iterator_func (fun(tbl: table<K, V>) : (fun(tbl: table<K, V>, index: K | nil) : K, V)) | nil default is pairs
---@param config lua-term.components.loading.loop.config | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function loading.loop(id, parent, tbl, iterator_func, config)
    --//TODO: we only want to iterate want we need idealy
    local value_pairs = {}
    for index, value in (iterator_func or pairs)(tbl) do
        value_pairs[index] = value
    end

    config = config or {}
    config.tbl_count = utils.value.default(config.tbl_count, utils.table.count(value_pairs))
    config.remove_on_end = utils.value.default(config.remove_on_end, true)
    config.update_on_every_iteration = utils.value.default(config.update_on_every_iteration, true)

    local loading_bar = loading.new(id, parent, config)
    local percent_per_item = 100 / config.tbl_count

    ---@generic K, V
    ---@param index K | nil
    ---@return K, V
    local function iterator(_, index)
        local key, value = next(value_pairs, index)

        if config.update_on_every_iteration then
            loading_bar:changed_relativ(percent_per_item, true)
        end

        if (key == nil and value == nil) and config.remove_on_end then
            loading_bar:remove(true)
        end

        return key, value
    end
    return iterator, tbl
end

return loading
