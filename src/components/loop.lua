local utils = require("misc.utils")

local _line = require("src.components.line")
local _segment = require("src.segment.init")
local _loading = require("src.components.loading")

---@class lua-term.components.loop.config.create : lua-term.components.loading.config.create
---@field update_on_remove boolean | nil default is `true`
---@field update_on_every_iteration boolean | nil default is `true`
---@field show_progress_number boolean | nil default is `true`
---@field show_iterations_per_second boolean | nil default is `false`
---
---
---@field count integer | nil

---@class lua-term.components.loop.config : lua-term.components.loading.config
---@field update_on_remove boolean
---@field update_on_every_iteration boolean
---@field show_progress_number boolean
---@field show_iterations_per_second boolean

---@class lua-term.components.loop
---@field stopwatch Freemaker.utils.stopwatch
---
---@field loading_line lua-term.components.line
---@field loading_bar lua-term.components.loading
---@field info_text lua-term.segment
---
---@field config lua-term.components.loop.config
local _loop = {}

---@param id string
---@param parent lua-term.segment_parent
---@param config lua-term.components.loop.config.create
---@return lua-term.components.loop
function _loop.new(id, parent, config)
    config.update_on_remove = utils.value.default(config.update_on_remove, true)
    config.update_on_every_iteration = utils.value.default(config.update_on_every_iteration, true)
    config.show_progress_number = utils.value.default(config.show_progress_number, true)
    config.show_iterations_per_second = utils.value.default(config.show_iterations_per_second, false)

    local stopwatch = utils.stopwatch.start_new()
    local loading_line = _line.new(id, parent)
    local loading_bar = _loading.new(id, loading_line, config)
    local info_text = _segment.new(id .. "-info", loading_line, function()
        local builder = utils.string.builder.new()

        if config.show_progress_number then
            local count_str = tostring(config.count)
            local state_str = utils.string.left_pad(tostring(loading_bar.state), count_str:len())
            builder:append(" <", count_str, "/", state_str, ">")
        end

        if config.show_iterations_per_second then
            local iterations_per_second = 1 / (stopwatch:lap() / 1000)
            builder:append(" |", string.format("%.0f", iterations_per_second), "itr/s|")
        end

        return builder:build()
    end)

    local instance = setmetatable({
        stopwatch = stopwatch,

        loading_line = loading_line,
        loading_bar = loading_bar,
        info_text = info_text,

        config = config
    }, { __index = _loop })


    return instance
end

--- Will iterate over whole table if config.count not set
---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment_parent
---@param tbl table<K, V>
---@param iterator_func (fun(tbl: table<K, V>) : (fun(tbl: table<K, V>, index: K | nil) : K, V))
---@param config lua-term.components.loop.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function _loop.iterator(id, parent, tbl, iterator_func, config)
    config = config or {}

    if not config.count then
        local value_pairs = {}
        for index, value in iterator_func(tbl) do
            value_pairs[index] = value
        end

        iterator_func = next
        tbl = value_pairs

        config.count = utils.table.count(value_pairs)
    end

    local loop = _loop.new(id, parent, config)

    ---@generic K, V
    ---@param index K | nil
    ---@return K, V
    local function iterator(_, index)
        local key, value = iterator_func(tbl, index)

        loop:iterate()
        if key == nil then
            loop:remove()
        end

        return key, value
    end
    return iterator, tbl
end

---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment_parent
---@param tbl table<K, V>
---@param config lua-term.components.loop.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function _loop.pairs(id, parent, tbl, config)
    return _loop.iterator(id, parent, tbl, pairs, config)
end

---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment_parent
---@param tbl table<K, V>
---@param config lua-term.components.loop.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function _loop.ipairs(id, parent, tbl, config)
    return _loop.iterator(id, parent, tbl, ipairs, config)
end

---@param id string
---@param parent lua-term.segment_parent
---@param start number
---@param _end number
---@param increment number | nil
---@param config lua-term.components.loop.config.create | nil
---@return fun(_, index: integer) : integer, true
---@return table _ can be ignored
function _loop._for(id, parent, start, _end, increment, config)
    increment = increment or 1
    config = config or {}
    config.count = _end

    local loop = _loop.new(id, parent, config)

    ---@param index integer | nil
    ---@return integer | nil
    ---@return true | nil
    return function(_, index)
        if not index then
            if start == _end then
                return nil, nil
            end

            return start, true
        end

        loop:iterate()

        if index == _end then
            loop:remove()
            return nil, nil
        end

        return index + 1, true
    end, {}
end

function _loop:iterate()
    self.loading_bar:changed_relativ(1)
    self.info_text:changed()

    if self.config.update_on_every_iteration then
        self.loading_line:update()
    end
end

function _loop:remove()
    self.stopwatch:stop()
    self.loading_line:remove(self.config.update_on_remove)
end

return _loop
