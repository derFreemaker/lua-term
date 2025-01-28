local utils = require("misc.utils")

---@class lua-term.components.loop.config.create : lua-term.components.loading.config.create
---@field tbl_count integer | nil if not given will count tbl first
---@field update_on_every_iteration boolean | nil default is `true`
---@field remove_on_end boolean | nil default is `true`

---@class lua-term.components.loop
local _loop = {}

---@generic T : table, K, V
---@param id string
---@param parent lua-term.segment_parent
---@param tbl table<K, V>
---@param iterator_func (fun(tbl: table<K, V>) : (fun(tbl: table<K, V>, index: K | nil) : K, V)) | nil default is pairs
---@param config lua-term.components.loop.config.create | nil
---@return fun(table: table<K, V>, index: K | nil) : K, V
---@return T
function loading.loop(id, parent, tbl, iterator_func, config)
    --//TODO: we only want to iterate want we need idealy
    local value_pairs = {}
    for index, value in (iterator_func or pairs)(tbl) do
        value_pairs[index] = value
    end

    config = config or {}
    config.count = utils.table.count(value_pairs)
    config.remove_on_end = utils.value.default(config.remove_on_end, true)
    config.update_on_every_iteration = utils.value.default(config.update_on_every_iteration, true)

    local loading_bar = loading.new(id, parent, config)

    if self.config.show_porgress_number then
        local count_str = tostring(self.config.count)
        local state_str = utils.string.left_pad(tostring(self.state), count_str:len())
        builder:append(" <", count_str, "/", state_str, ">")
    end

    if self.config.show_iterations_per_second then
        --//TODO: keep delta
    end

    ---@generic K, V
    ---@param index K | nil
    ---@return K, V
    local function iterator(_, index)
        local key, value = next(value_pairs, index)

        if config.update_on_every_iteration then
            loading_bar:changed_relativ(1, true)
        end

        if (key == nil and value == nil) and config.remove_on_end then
            loading_bar:remove(true)
        end

        return key, value
    end
    return iterator, tbl
end
