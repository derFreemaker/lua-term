local utils = require("misc.utils")

local _line = require("src.components.line")
local _segment = require("src.segment.init")
local _loading = require("src.components.loading")

---@class lua-term.components.loop_with_end.config.create : lua-term.components.loading.config.create
---@field update_on_remove boolean | nil default is `true`
---@field update_on_every_iterations integer | nil default is `true`
---@field show_progress_number boolean | nil default is `true`
---@field show_iterations_per_second boolean | nil default is `false`
---
---@field count integer | nil when nil table will be counted with the iterator first

---@class lua-term.components.loop.config : lua-term.components.loading.config
---@field update_on_remove boolean
---@field update_on_every_iterations boolean
---@field show_progress_number boolean
---@field show_iterations_per_second boolean

---@class lua-term.components.loop_with_end : lua-term.segment.single_line_interface, object
---@field stopwatch Freemaker.utils.stopwatch
---
---@field loading_line lua-term.components.line
---@field loading_bar lua-term.components.loading
---@field info_text lua-term.segment
---
---@field config lua-term.components.loop.config
local _loop_with_end = {}

---@param id string
---@param parent lua-term.segment.single_line_parent
---@param config lua-term.components.loop_with_end.config.create
---@return lua-term.components.loop_with_end
function _loop_with_end.new(id, parent, config)
    config.update_on_remove = utils.value.default(config.update_on_remove, true)
    config.update_on_every_iterations = utils.value.default(config.update_on_every_iterations, 1)
    config.show_progress_number = utils.value.default(config.show_progress_number, true)
    config.show_iterations_per_second = utils.value.default(config.show_iterations_per_second, false)

    local stopwatch = utils.stopwatch.start_new()
    local loading_line = _line(id, parent)
    local loading_bar = _loading(id .. "-loading_bar", loading_line, config)
    local info_text = _segment(id .. "-info", loading_line, function()
        local builder = utils.string.builder.new()

        if config.show_progress_number then
            local count_str = tostring(config.count)
            local state_str = utils.string.left_pad(tostring(loading_bar.state), count_str:len())
            builder:append(" <", count_str, "/", state_str, ">")
        end

        if config.show_iterations_per_second and loading_bar.state ~= 0 then
            local time = stopwatch:reset()
            local avg_update_time_seconds = time / 1000
            local avg_updates_per_second = 1 / avg_update_time_seconds
            local avg_iterations_per_second = avg_updates_per_second * config.update_on_every_iterations
            builder:append(" |")

            if avg_iterations_per_second < 1 then
                builder:append(string.format("%.2f", avg_iterations_per_second))
            elseif avg_iterations_per_second < 10 then
                builder:append(string.format("%.1f", avg_iterations_per_second))
            else
                builder:append(string.format("%.0f", avg_iterations_per_second))
            end

            builder:append("itr/s|")
        end

        return { builder:build() }, 1
    end)

    local instance = setmetatable({
        stopwatch = stopwatch,

        loading_line = loading_line,
        loading_bar = loading_bar,
        info_text = info_text,

        config = config
    }, { __index = _loop_with_end })

    return instance
end

function _loop_with_end:increment()
    self.loading_bar:changed_relativ(1, false)

    if self.loading_bar.state % self.config.update_on_every_iterations == 0 then
        self.info_text:changed()
        self.loading_line:update()
    end
end

function _loop_with_end:show()
    self.loading_bar:changed(nil, false)
    self.info_text:changed(false)
    self.loading_line:update()
end

function _loop_with_end:remove()
    self.stopwatch:stop()
    self.loading_line:remove(self.config.update_on_remove)
end

--- Will iterate over whole table if config.count not set
---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment.single_line_parent
---@param tbl table<K, V>
---@param iterator_func (fun(tbl: table<K, V>) : (fun(tbl: table<K, V>, index: K | nil) : K, V))
---@param config lua-term.components.loop_with_end.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V iterator
---@return T tbl
---@return any | nil first_index
function _loop_with_end.iterator(id, parent, tbl, iterator_func, config)
    config = config or {}

    ---@type table, any
    local value_pairs, first_index
    if config.count then
        -- create the iterator
        iterator_func, value_pairs, first_index = iterator_func(tbl)
    else
        value_pairs = {}
        for index, value in iterator_func(tbl) do
            value_pairs[index] = value
        end
        iterator_func = next
        config.count = #value_pairs
    end

    local loop = _loop_with_end.new(id, parent, config)
    loop:show()

    local first_iter = true

    ---@generic K, V
    ---@param index K | nil
    ---@return K, V
    local function iterator(_, index)
        local key, value = iterator_func(tbl, index)

        if not first_iter then
            loop:increment()
        else
            first_iter = false
        end

        if key == nil then
            loop:remove()
        end

        return key, value
    end

    return iterator, tbl, first_index
end

---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment.single_line_parent
---@param tbl table<K, V>
---@param config lua-term.components.loop_with_end.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function _loop_with_end.pairs(id, parent, tbl, config)
    return _loop_with_end.iterator(id, parent, tbl, pairs, config)
end

---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment.single_line_parent
---@param tbl table<K, V>
---@param config lua-term.components.loop_with_end.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function _loop_with_end.ipairs(id, parent, tbl, config)
    return _loop_with_end.iterator(id, parent, tbl, ipairs, config)
end

---@class lua-term.components.for_loop.config.create : lua-term.components.loop_with_end.config.create
---@field count nil

---@param id string
---@param parent lua-term.segment.single_line_parent
---@param start number
---@param _end number
---@param increment number | nil
---@param config lua-term.components.for_loop.config.create | nil
---@return fun(_, index: integer) : integer, true
function _loop_with_end._for(id, parent, start, _end, increment, config)
    increment = increment or 1
    config = config or {}
    config.count = _end

    local loop = _loop_with_end.new(id, parent, config)
    loop:show()

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

        loop:increment()

        if index == _end then
            loop:remove()
            return nil, nil
        end

        return index + 1, true
    end
end

return _loop_with_end
