---@diagnostic disable

	local __bundler__ = {
	    __files__ = {},
	    __binary_files__ = {},
	    __cache__ = {},
	    __temp_files__ = {},
	    __org_exit__ = os.exit
	}
	function __bundler__.__get_os__()
	    if package.config:sub(1, 1) == '\\' then
	        return "windows"
	    else
	        return "linux"
	    end
	end
	function __bundler__.__loadFile__(module)
	    if not __bundler__.__cache__[module] then
	        if __bundler__.__binary_files__[module] then
	        local tempDir = os.getenv("TEMP") or os.getenv("TMP")
	            if not tempDir then
	                tempDir = "/tmp"
	            end
	            local os_type = __bundler__.__get_os__()
	            local file_path = tempDir .. os.tmpname()
	            local file = io.open(file_path, "wb")
	            if not file then
	                error("unable to open file: " .. file_path)
	            end
	            local content
	            if os_type == "windows" then
	                content = __bundler__.__files__[module .. ".dll"]
	            else
	                content = __bundler__.__files__[module .. ".so"]
	            end
	            local content_len = content:len()
	            for i = 2, content_len, 2 do
	                local byte = tonumber(content:sub(i - 1, i), 16)
	                file:write(string.char(byte))
	            end
	            file:close()
	            __bundler__.__cache__[module] = { package.loadlib(file_path, "luaopen_" .. module)() }
	            table.insert(__bundler__.__temp_files__, file_path)
	        else
	            __bundler__.__cache__[module] = { __bundler__.__files__[module]() }
	        end
	    end
	    return table.unpack(__bundler__.__cache__[module])
	end
	function __bundler__.__cleanup__()
	    for _, file_path in ipairs(__bundler__.__temp_files__) do
	        os.remove(file_path)
	    end
	end
	---@diagnostic disable-next-line: duplicate-set-field
	function os.exit(...)
	    __bundler__.__cleanup__()
	    __bundler__.__org_exit__(...)
	end
	function __bundler__.__main__()
	    local loading_thread = coroutine.create(__bundler__.__loadFile__)
	    local success, items = (function(success, ...) return success, {...} end)
	        (coroutine.resume(loading_thread, "__main__"))
	    if not success then
	        print("error in bundle loading thread:\n"
	            .. debug.traceback(loading_thread, items[1]))
	    end
	    __bundler__.__cleanup__()
	    return table.unpack(items)
	end
	__bundler__.__files__["src.segment.interface"] = function()
	---@meta _

	---@class lua-term.segment_interface
	local segment_interface = {}

	---@return boolean update_requested
	function segment_interface:requested_update()
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function segment_interface:render(context)
	end

end

__bundler__.__files__["src.segment.parent"] = function()
	---@meta _

	---@class lua-term.segment_parent
	local parent_class = {}

	function parent_class:update()
	end

	---@param ... any
	---@return lua-term.segment
	function parent_class:print(...)
	end

	---@param id string
	---@param segment lua-term.segment_interface
	function parent_class:add_segment(id, segment)
	end

	---@param child lua-term.segment_interface
	function parent_class:remove_child(child)
	end

end

__bundler__.__files__["misc.utils"] = function()
	---@diagnostic disable

	local __bundler__ = {
	    __files__ = {},
	    __binary_files__ = {},
	    __cache__ = {},
	    __temp_files__ = {},
	    __org_exit__ = os.exit
	}
	function __bundler__.__get_os__()
	    if package.config:sub(1, 1) == '\\' then
	        return "windows"
	    else
	        return "linux"
	    end
	end
	function __bundler__.__loadFile__(module)
	    if not __bundler__.__cache__[module] then
	        if __bundler__.__binary_files__[module] then
	        local tempDir = os.getenv("TEMP") or os.getenv("TMP")
	            if not tempDir then
	                tempDir = "/tmp"
	            end
	            local os_type = __bundler__.__get_os__()
	            local file_path = tempDir .. os.tmpname()
	            local file = io.open(file_path, "wb")
	            if not file then
	                error("unable to open file: " .. file_path)
	            end
	            local content
	            if os_type == "windows" then
	                content = __bundler__.__files__[module .. ".dll"]
	            else
	                content = __bundler__.__files__[module .. ".so"]
	            end
	            local content_len = content:len()
	            for i = 2, content_len, 2 do
	                local byte = tonumber(content:sub(i - 1, i), 16)
	                file:write(string.char(byte))
	            end
	            file:close()
	            __bundler__.__cache__[module] = { package.loadlib(file_path, "luaopen_" .. module)() }
	            table.insert(__bundler__.__temp_files__, file_path)
	        else
	            __bundler__.__cache__[module] = { __bundler__.__files__[module]() }
	        end
	    end
	    return table.unpack(__bundler__.__cache__[module])
	end
	function __bundler__.__cleanup__()
	    for _, file_path in ipairs(__bundler__.__temp_files__) do
	        os.remove(file_path)
	    end
	end
	---@diagnostic disable-next-line: duplicate-set-field
	function os.exit(...)
	    __bundler__.__cleanup__()
	    __bundler__.__org_exit__(...)
	end
	function __bundler__.__main__()
	    local loading_thread = coroutine.create(__bundler__.__loadFile__)
	    local success, items = (function(success, ...) return success, {...} end)
	        (coroutine.resume(loading_thread, "__main__"))
	    if not success then
	        print("error in bundle loading thread:\n"
	            .. debug.traceback(loading_thread, items[1]))
	    end
	    __bundler__.__cleanup__()
	    return table.unpack(items)
	end
	__bundler__.__files__["src.utils.number"] = function()
		---@class Freemaker.utils.number
		local _number = {}

		---@type table<integer, integer>
		local round_cache = {}

		---@param value number
		---@param decimal integer | nil
		---@return integer
		function _number.round(value, decimal)
		    decimal = decimal or 0
		    if decimal > 308 then
		        error("cannot round more decimals than 308")
		    end

		    local mult = round_cache[decimal]
		    if not mult then
		        mult = 10 ^ decimal
		        round_cache[decimal] = mult
		    end

		    return ((value * mult + 0.5) // 1) / mult
		end

		---@param value number
		---@param min number
		---@param max number
		---@return number
		function _number.clamp(value, min, max)
		    if value < min then
		        return min
		    end

		    if value > max then
		        return max
		    end

		    return value
		end

		return _number

	end

	__bundler__.__files__["src.utils.string.builder"] = function()
		local table_insert = table.insert
		local table_concat = table.concat

		---@class Freemaker.utils.string.builder
		---@field private m_cache string[]
		local _string_builder = {}

		function _string_builder.new()
		    local instance = setmetatable({
		        m_cache = {}
		    }, { __index = _string_builder })
		    return instance
		end

		function _string_builder:append(...)
		    for _, value in ipairs({...}) do
		        table_insert(self.m_cache, tostring(value))
		    end
		end

		function _string_builder:append_line(...)
		    self:append(...)
		    self:append("\n")
		end

		function _string_builder:build()
		    return table_concat(self.m_cache)
		end

		return _string_builder

	end

	__bundler__.__files__["src.utils.string.init"] = function()
		---@class Freemaker.utils.string
		---@field builder Freemaker.utils.string.builder
		local _string = {
		    builder = __bundler__.__loadFile__("src.utils.string.builder")
		}

		---@param str string
		---@param pattern string
		---@param plain boolean | nil
		---@return string | nil, integer
		local function find_next(str, pattern, plain)
		    local found = str:find(pattern, 0, plain or true)

		    if found == nil then
		        return nil, 0
		    end

		    return str:sub(0, found - 1), found - 1
		end

		---@param str string | nil
		---@param sep string | nil
		---@param plain boolean | nil
		---@return string[]
		function _string.split(str, sep, plain)
		    if str == nil then
		        return {}
		    end

		    local strLen = str:len()
		    local sepLen

		    if sep == nil then
		        sep = "%s"
		        sepLen = 2
		    else
		        sepLen = sep:len()
		    end

		    local tbl = {}
		    local i = 0
		    while true do
		        i = i + 1
		        local foundStr, foundPos = find_next(str, sep, plain)

		        if foundStr == nil then
		            tbl[i] = str
		            return tbl
		        end

		        tbl[i] = foundStr
		        str = str:sub(foundPos + sepLen + 1, strLen)
		    end
		end

		---@param str string | nil
		---@return boolean
		function _string.is_nil_or_empty(str)
		    if str == nil then
		        return true
		    end

		    if str == "" then
		        return true
		    end

		    return false
		end

		---@param str string
		---@param length integer
		---@param char string | nil
		function _string.left_pad(str, length, char)
		    local str_length = str:len()
		    return string.rep(char or " ", length - str_length) .. str
		end

		---@param str string
		---@param length integer
		---@param char string | nil
		function _string.right_pad(str, length, char)
		    local str_length = str:len()
		    return str .. string.rep(char or " ", length - str_length)
		end

		return _string

	end

	__bundler__.__files__["src.utils.table"] = function()
		---@class Freemaker.utils.table
		local _table = {}

		---@param t table
		---@param copy table
		---@param seen table<table, table>
		---@return table
		local function copy_table_to(t, copy, seen)
		    if seen[t] then
		        return seen[t]
		    end

		    seen[t] = copy

		    for key, value in next, t do
		        if type(value) == "table" then
		            copy[key] = copy_table_to(value, copy[key] or {}, seen)
		        else
		            copy[key] = value
		        end
		    end

		    local t_meta = getmetatable(t)
		    if t_meta then
		        local copy_meta = getmetatable(copy) or {}
		        copy_table_to(t_meta, copy_meta, seen)
		        setmetatable(copy, copy_meta)
		    end

		    return copy
		end

		---@generic T
		---@param t T
		---@return T table
		function _table.copy(t)
		    return copy_table_to(t, {}, {})
		end

		---@generic T
		---@param from T
		---@param to T
		function _table.copy_to(from, to)
		    copy_table_to(from, to, {})
		end

		---@param t table
		---@param ignoreProperties string[] | nil
		function _table.clear(t, ignoreProperties)
		    if not ignoreProperties then
		        for key, _ in next, t, nil do
		            t[key] = nil
		        end
		    else
		        for key, _ in next, t, nil do
		            if not _table.contains(ignoreProperties, key) then
		                t[key] = nil
		            end
		        end
		    end

		    setmetatable(t, nil)
		end

		---@param t table
		---@param value any
		---@return boolean
		function _table.contains(t, value)
		    for _, tValue in pairs(t) do
		        if value == tValue then
		            return true
		        end
		    end

		    return false
		end

		---@param t table
		---@param key any
		---@return boolean
		function _table.contains_key(t, key)
		    if t[key] ~= nil then
		        return true
		    end

		    return false
		end

		---@param t table
		---@return integer count
		function _table.count(t)
		    local count = 0

		    for _, _ in next, t, nil do
		        count = count + 1
		    end

		    return count
		end

		---@param t table
		---@return table
		function _table.invert(t)
		    local inverted = {}

		    for key, value in pairs(t) do
		        inverted[value] = key
		    end

		    return inverted
		end

		---@generic T
		---@generic R
		---@param t T[]
		---@param func fun(value: T) : R
		---@return R[]
		function _table.map(t, func)
		    ---@type any[]
		    local result = {}

		    for index, value in ipairs(t) do
		        result[index] = func(value)
		    end

		    return result
		end

		-- Only makes this table readonly
		-- **NOT** the child tables
		---@generic T
		---@param t T
		---@return T
		function _table.readonly(t)
		    return setmetatable({}, {
		        __newindex = function()
		            error("this table is readonly")
		        end,
		        __index = t
		    })
		end

		---@generic T
		---@generic R
		---@param t T
		---@param func fun(key: any, value: any) : R
		---@return R[]
		function _table.select(t, func)
		    local copy = _table.copy(t)

		    for key, value in pairs(copy) do
		        if not func(key, value) then
		            copy[key] = nil
		        end
		    end

		    return copy
		end

		---@generic T
		---@generic R
		---@param t T
		---@param func fun(key: any, value: any) : R
		---@return R[]
		function _table.select_implace(t, func)
		    for key, value in pairs(t) do
		        if not func(key, value) then
		            t[key] = nil
		        end
		    end

		    return t
		end

		return _table

	end

	__bundler__.__files__["src.utils.array"] = function()
		local table_insert = table.insert

		---@generic T
		---@param t T[]
		---@param value T
		local function insert_first_nil(t, value)
		    local i = 0
		    while true do
		        i = i + 1
		        if t[i] == nil then
		            t[i] = value
		            return
		        end
		    end
		end

		---@class Freemaker.utils.array
		local _array = {}

		---@generic T
		---@param t T[]
		---@param amount integer
		---@return T[]
		function _array.take_front(t, amount)
		    local length = #t
		    if amount > length then
		        amount = length
		    end

		    local copy = {}
		    for i = 1, amount, 1 do
		        table_insert(copy, t[i])
		    end
		    return copy
		end

		---@generic T
		---@param t T[]
		---@param amount integer
		---@return T[]
		function _array.take_back(t, amount)
		    local length = #t
		    local start = #t - amount + 1
		    if start < 1 then
		        start = 1
		    end

		    local copy = {}
		    for i = start, length, 1 do
		        table_insert(copy, t[i])
		    end
		    return copy
		end

		---@generic T
		---@param t T[]
		---@param amount integer
		---@return T[]
		function _array.drop_front_implace(t, amount)
		    for i, value in ipairs(t) do
		        if i <= amount then
		            t[i] = nil
		        else
		            insert_first_nil(t, value)
		            t[i] = nil
		        end
		    end
		    return t
		end

		---@generic T
		---@param t T[]
		---@param amount integer
		---@return T[]
		function _array.drop_back_implace(t, amount)
		    local length = #t
		    local start = length - amount + 1

		    for i = start, length, 1 do
		        t[i] = nil
		    end
		    return t
		end

		---@generic T
		---@generic R
		---@param t T[]
		---@param func fun(index: integer, value: T) : R
		---@return R[]
		function _array.select(t, func)
		    local copy = {}
		    for index, value in pairs(t) do
		        table_insert(copy, func(index, value))
		    end
		    return copy
		end

		---@generic T
		---@generic R
		---@param t T[]
		---@param func fun(index: integer, value: T) : R
		---@return R[]
		function _array.select_implace(t, func)
		    for index, value in pairs(t) do
		        local new_value = func(index, value)
		        t[index] = nil
		        if new_value then
		            insert_first_nil(t, new_value)
		        end
		    end
		    return t
		end

		--- removes all spaces between
		---@param t any[]
		function _array.clean(t)
		    for key, value in pairs(t) do
		        for i = key - 1, 1, -1 do
		            if key == 1 then
		                goto continue
		            end

		            if t[i] == nil and (t[i - 1] ~= nil or i == 1) then
		                t[i] = value
		                t[key] = nil
		                break
		            end

		            ::continue::
		        end
		    end
		end

		return _array

	end

	__bundler__.__files__["src.utils.value"] = function()
		local table = __bundler__.__loadFile__("src.utils.table")

		---@class Freemaker.utils.value
		local _value = {}

		---@generic T
		---@param x T
		---@return T
		function _value.copy(x)
		    local typeStr = type(x)
		    if typeStr == "table" then
		        return table.copy(x)
		    end

		    return x
		end

		---@generic T
		---@param value T | nil
		---@param default_value T
		---@return T
		function _value.default(value, default_value)
		    if value == nil then
		        return default_value
		    end

		    return value
		end

		return _value

	end

	__bundler__.__files__["src.utils.stopwatch"] = function()
		local _number = __bundler__.__loadFile__("src.utils.number")

		---@class Freemaker.utils.stopwatch
		---@field private running boolean
		---
		---@field start_time number
		---@field end_time number
		---@field private elapesd_milliseconds integer
		---
		---@field private last_lap_time number | nil
		local _stopwatch = {}

		---@return Freemaker.utils.stopwatch
		function _stopwatch.new()
		    return setmetatable({
		        running = false,

		        start_time = 0,
		        end_time = 0,
		        elapesd_milliseconds = 0,
		    }, { __index = _stopwatch })
		end

		---@return Freemaker.utils.stopwatch
		function _stopwatch.start_new()
		    local instance = _stopwatch.new()
		    instance:start()
		    return instance
		end

		function _stopwatch:start()
		    if self.running then
		        return
		    end

		    self.start_time = os.clock()
		    self.running = true
		end

		function _stopwatch:stop()
		    if not self.running then
		        return
		    end

		    self.end_time = os.clock()
		    local elapesd_time = self.end_time - self.start_time
		    self.running = false

		    self.elapesd_milliseconds = _number.round(elapesd_time * 1000)
		end

		---@return integer
		function _stopwatch:get_elapesd_milliseconds()
		    if self.running then
		        return 0
		    end

		    return self.elapesd_milliseconds
		end

		---@return integer elapesd_milliseconds
		function _stopwatch:lap()
		    if not self.running then
		        return 0
		    end

		    local lap_time = os.clock()
		    local previous_lap = self.last_lap_time or self.start_time
		    self.last_lap_time = lap_time

		    local elapesd_time = lap_time - previous_lap

		    return _number.round(elapesd_time * 1000)
		end

		return _stopwatch

	end

	__bundler__.__files__["__main__"] = function()
		---@class Freemaker.utils
		---@field number Freemaker.utils.number
		---@field string Freemaker.utils.string
		---@field table Freemaker.utils.table
		---@field array Freemaker.utils.array
		---@field value Freemaker.utils.value
		---
		---@field stopwatch Freemaker.utils.stopwatch
		local utils = {}

		utils.number = __bundler__.__loadFile__("src.utils.number")
		utils.string = __bundler__.__loadFile__("src.utils.string.init")
		utils.table = __bundler__.__loadFile__("src.utils.table")
		utils.array = __bundler__.__loadFile__("src.utils.array")
		utils.value = __bundler__.__loadFile__("src.utils.value")

		utils.stopwatch = __bundler__.__loadFile__("src.utils.stopwatch")

		return utils

	end

	---@type { [1]: Freemaker.utils }
	local main = { __bundler__.__main__() }
	return table.unpack(main)

end

__bundler__.__files__["third-party.ansicolors"] = function()
	-- Copyright (c) 2009 Rob Hoelz <rob@hoelzro.net>
	--
	-- Permission is hereby granted, free of charge, to any person obtaining a copy
	-- of this software and associated documentation files (the "Software"), to deal
	-- in the Software without restriction, including without limitation the rights
	-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	-- copies of the Software, and to permit persons to whom the Software is
	-- furnished to do so, subject to the following conditions:
	--
	-- The above copyright notice and this permission notice shall be included in
	-- all copies or substantial portions of the Software.
	--
	-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	-- THE SOFTWARE.

	-- Modified

	local utils = __bundler__.__loadFile__("misc.utils")
	local tostring = tostring
	local setmetatable = setmetatable
	local schar = string.char

	---@class ansicolors
	local ansicolors = {}

	---@class ansicolors.color
	---@field value string
	---@operator concat(string): string
	---@operator call(string): string
	local color = {}

	---@private
	function color:__tostring()
	    return schar(27) .. '[' .. tostring(self.value) .. 'm'
	end

	---@private
	function color.__concat(left, right)
	    return tostring(left) .. tostring(right)
	end

	---@private
	function color:__call(s)
	    return self .. s .. ansicolors.reset
	end

	---@param value string
	---@return ansicolors.color
	local function makecolor(value)
	    return setmetatable({ value = value }, color)
	end

	-- attributes

	ansicolors.reset = makecolor("0")
	ansicolors.clear = makecolor("0")
	ansicolors.default = makecolor("0")
	ansicolors.bright = makecolor("1")
	ansicolors.dim = makecolor("2")
	ansicolors.italic = makecolor("3")
	ansicolors.underscore = makecolor("4")
	ansicolors.blink = makecolor("5")
	ansicolors.inverted = makecolor("7")
	ansicolors.hidden = makecolor("8")

	-- foreground

	ansicolors.black = makecolor("30")
	ansicolors.red = makecolor("31")
	ansicolors.green = makecolor("32")
	ansicolors.yellow = makecolor("33")
	ansicolors.blue = makecolor("34")
	ansicolors.magenta = makecolor("35")
	ansicolors.cyan = makecolor("36")
	ansicolors.white = makecolor("37")
	---@param color_code integer
	ansicolors.foreground_extended = function(color_code)
	    color_code = utils.value.clamp(color_code, 0, 255)
	    return makecolor("38;5;" .. tostring(color_code))
	end
	---@param red integer
	---@param green integer
	---@param blue integer
	ansicolors.foreground_24bit = function(red, green, blue)
	    red = utils.value.clamp(red, 0, 255)
	    green = utils.value.clamp(green, 0, 255)
	    blue = utils.value.clamp(blue, 0, 255)
	    return makecolor(("38;2;%s;%s;%s"):format(red, green, blue))
	end

	-- background

	ansicolors.onblack = makecolor("40")
	ansicolors.onred = makecolor("41")
	ansicolors.ongreen = makecolor("42")
	ansicolors.onyellow = makecolor("43")
	ansicolors.onblue = makecolor("44")
	ansicolors.onmagenta = makecolor("45")
	ansicolors.oncyan = makecolor("46")
	ansicolors.onwhite = makecolor("47")
	---@param color_code integer
	ansicolors.background_extended = function(color_code)
	    color_code = utils.value.clamp(color_code, 0, 255)
	    return makecolor("48;5;" .. tostring(color_code))
	end
	---@param red integer
	---@param green integer
	---@param blue integer
	ansicolors.background_24bit = function(red, green, blue)
	    red = utils.value.clamp(red, 0, 255)
	    green = utils.value.clamp(green, 0, 255)
	    blue = utils.value.clamp(blue, 0, 255)
	    return makecolor(("48;2;%s;%s;%s"):format(red, green, blue))
	end

	-- transparent

	---@type ansicolors.color
	ansicolors.transparent = setmetatable({}, {
	    __tostring = function()
	        return ""
	    end,
	    __concat = function(left, right)
	        return tostring(left) .. tostring(right)
	    end,
	    __call = function(self, s)
	        return s
	    end
	})

	return ansicolors

end

__bundler__.__files__["src.misc.maketermfunc"] = function()
	local sformat = string.format

	return function(sequence_fmt)
	    sequence_fmt = '\027[' .. sequence_fmt
	    return function(...)
	        return sformat(sequence_fmt, ...)
	    end
	end

end

__bundler__.__files__["src.misc.cursor"] = function()
	local make_term_func = __bundler__.__loadFile__("src.misc.maketermfunc")

	---@class lua-term.cursor
	local cursor = {
	    ---@type fun() : string
	    home = make_term_func("H"),
	    ---@type fun(line: integer, column: integer)  : string
	    jump = make_term_func("%d;%dH"),
	    ---@type fun(value: integer) : string
	    go_up = make_term_func("%dA"),
	    ---@type fun(value: integer) : string
	    go_down = make_term_func("%dB"),
	    ---@type fun(value: integer) : string
	    go_right = make_term_func("%dC"),
	    ---@type fun(value: integer) : string
	    go_left = make_term_func("%dD"),
	    ---@type fun() : string
	    save = make_term_func("s"),
	    ---@type fun() : string
	    restore = make_term_func("u"),
	}

	return cursor

end

__bundler__.__files__["src.misc.erase"] = function()
	local make_term_func = __bundler__.__loadFile__("src.misc.maketermfunc")

	---@class lua-term.erase
	local erase = {}

	erase.till_end = make_term_func("0J")
	erase.till_begin = make_term_func("1J")
	erase.screen = make_term_func("2J")
	erase.saved_lines = make_term_func("3J")

	erase.till_eol = make_term_func("0K")
	erase.till_bol = make_term_func("1K")
	erase.line = make_term_func("2K")

	return erase

end

__bundler__.__files__["src.segment.entry"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local string_rep = string.rep
	local table_insert = table.insert
	local table_remove = table.remove

	---@class lua-term.segment_entry
	---@field id string
	---@field line integer
	---@field lines string[]
	---@field lines_count integer
	---
	---@field private m_showing_id boolean
	---@field private m_segment lua-term.segment_interface
	local segment_entry_class = {}

	---@param id string
	---@param segment lua-term.segment_interface
	---@return lua-term.segment_entry
	function segment_entry_class.new(id, segment)
	    return setmetatable({
	        id = id,
	        line = 0,
	        lines = {},
	        lines_count = 0,

	        m_showing_id = false,
	        m_segment = segment,
	    }, { __index = segment_entry_class })
	end

	---@return boolean
	function segment_entry_class:requested_update()
	    return self.m_segment:requested_update()
	end

	---@param segment lua-term.segment_interface
	---@return boolean
	function segment_entry_class:has_segment(segment)
	    return self.m_segment == segment
	end

	---@param context lua-term.render_context
	---@return table<integer, string>
	function segment_entry_class:pre_render(context)
	    local buffer, lines = self.m_segment:render(context)

	    if context.show_ids ~= self.m_showing_id then
	        if context.show_ids then
	            local id_str = "---- '" .. self.id .. "' "
	            id_str = id_str .. string_rep("-", 80 - id_str:len())
	            table_insert(buffer, 1, id_str)
	            table_insert(buffer, string_rep("-", 80))
	        else
	            table_remove(self.lines, #self.lines)
	            table_remove(self.lines, 1)
	        end

	        self.m_showing_id = context.show_ids
	    elseif self.m_showing_id then
	        lines = lines + 2

	        local temp = {}
	        for index, line in pairs(buffer) do
	            temp[index + 1] = line
	        end
	        buffer = temp

	        if self.lines_count ~= lines then
	            buffer[lines] = self.lines[self.lines_count]
	        end
	    end

	    for index, content in pairs(buffer) do
	        self.lines[index] = content
	    end
	    for i = lines + 1, self.lines_count do
	        self.lines[i] = nil
	    end
	    self.lines_count = #self.lines

	    return buffer
	end

	return segment_entry_class

end

__bundler__.__files__["src.segment.init"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local string_rep = string.rep
	local debug_traceback = debug.traceback

	---@alias lua-term.segment.func (fun() : string | nil)

	---@class lua-term.segment : lua-term.segment_interface
	---@field private m_func lua-term.segment.func
	---@field private m_requested_update boolean
	---
	---@field private m_parent lua-term.segment_parent
	local segment_class = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@param func lua-term.segment.func
	---@return lua-term.segment
	function segment_class.new(id, parent, func)
	    local instance = setmetatable({
	        m_func = func,
	        m_requested_update = true,

	        m_parent = parent,
	    }, {
	        __index = segment_class,
	        ---@param t lua-term.segment
	        __gc = function(t)
	            t:remove(true)
	        end
	    })
	    parent:add_segment(id, instance)

	    return instance
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function segment_class:render(context)
	    self.m_requested_update = false

	    local pre_render_thread = coroutine.create(self.m_func)
	    local success, str_or_err_msg = coroutine.resume(pre_render_thread)
	    if not success then
	        str_or_err_msg = ("%s\nerror rendering segment:\n%s\n%s"):format(
	            string_rep("-", 80),
	            debug_traceback(pre_render_thread, str_or_err_msg),
	            string_rep("-", 80))
	    end

	    if not str_or_err_msg then
	        return {}, 0
	    end

	    local buffer = utils.string.split(str_or_err_msg, "\n")
	    return buffer, #buffer
	end

	---@param update boolean | nil
	function segment_class:remove(update)
	    update = utils.value.default(update, true)

	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update()
	    end
	end

	---@param update boolean | nil
	function segment_class:changed(update)
	    self.m_requested_update = true

	    if update then
	        self.m_parent:update()
	    end
	end

	function segment_class:requested_update()
	    return self.m_requested_update
	end

	return segment_class

end

__bundler__.__files__["src.components.text"] = function()
	local table_insert = table.insert
	local table_concat = table.concat

	local segment_class = __bundler__.__loadFile__("src.segment.init")

	---@class lua-term.components.text : lua-term.segment_interface
	---@field private m_text string
	---@field private m_segment lua-term.segment
	local _text = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@param text string
	---@return lua-term.components.text
	function _text.new(id, parent, text)
	    local instance = setmetatable({
	        m_text = text
	    }, { __index = _text })
	    instance.m_segment = segment_class.new(id, parent, function()
	        ---@diagnostic disable-next-line: invisible
	        return instance.m_text
	    end)

	    return instance
	end

	---@param parent lua-term.segment_parent
	---@param ... any
	---@return lua-term.segment
	function _text.print(parent, ...)
	    local items = {}
	    for _, value in ipairs({ ... }) do
	        table_insert(items, tostring(value))
	    end
	    local text = table_concat(items, "\t")

	    local segment = segment_class.new("<print>", parent, function()
	        return text
	    end)
	    parent:update()
	    return segment
	end

	---@return boolean update_requested
	function _text:requested_update()
	    return segment_class:requested_update()
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function _text:render(context)
	    return self.m_segment:render(context)
	end

	---@param update boolean | nil
	function _text:remove(update)
	    return self.m_segment:remove(update)
	end

	---@param text string
	---@param update boolean | nil
	function _text:change(text, update)
	    self.m_text = text
	    return self.m_segment:changed(update)
	end

	return _text

end

__bundler__.__files__["src.terminal"] = function()
	local cursor = __bundler__.__loadFile__("src.misc.cursor")
	local erase = __bundler__.__loadFile__("src.misc.erase")

	local pairs = pairs
	local math_abs = math.abs
	local string_rep = string.rep
	local io_type = io.type
	local table_insert = table.insert
	local table_remove = table.remove

	local entry_class = __bundler__.__loadFile__("src.segment.entry")
	local _text = __bundler__.__loadFile__("src.components.text")

	--//TODO: rewrite entire entity and cache system
	--//TODO: currently 2+ caching of same line

	---@class lua-term.render_context
	---@field show_ids boolean

	---@class lua-term.terminal : lua-term.segment_parent
	---@field show_ids boolean | nil
	---@field show_lines boolean | nil
	---
	---@field private m_stream file*
	---
	---@field private m_segments lua-term.segment_entry[]
	---
	---@field private m_org_print function
	---@field private m_cursor_pos integer
	local terminal = {}

	---@param stream file*
	---@return lua-term.terminal
	function terminal.new(stream)
	    if io_type(stream) ~= "file" then
	        error("stream is not valid")
	    end

	    stream:write("\27[?7l")
	    return setmetatable({
	        m_stream = stream,
	        m_segments = {},
	        m_cursor_pos = 1,
	    }, { __index = terminal })
	end

	local stdout_terminal
	---@return lua-term.terminal
	function terminal.stdout()
	    if stdout_terminal then
	        return stdout_terminal
	    end

	    stdout_terminal = terminal.new(io.stdout)
	    return stdout_terminal
	end

	function terminal:close()
	    self.m_stream:write("\27[?7h")
	end

	---@param ... any
	---@return lua-term.segment
	function terminal:print(...)
	    return _text.print(self, ...)
	end

	function terminal:add_segment(id, segment)
	    local entry = entry_class.new(id, segment)
	    table_insert(self.m_segments, entry)
	end

	function terminal:remove_child(child)
	    for index, entry in ipairs(self.m_segments) do
	        if entry:has_segment(child) then
	            table_remove(self.m_segments, index)
	        end
	    end
	end

	function terminal:clear()
	    self.m_segments = {}
	    self:update()
	end

	---@private
	---@param line integer
	function terminal:jump_to_line(line)
	    local jump_lines = line - self.m_cursor_pos
	    if jump_lines == 0 then
	        return
	    end

	    if jump_lines > 0 then
	        self.m_stream:write(cursor.go_down(jump_lines))
	    else
	        self.m_stream:write(cursor.go_up(math_abs(jump_lines)))
	    end
	    self.m_cursor_pos = line
	end

	function terminal:update()
	    local line_buffer_pos = 1
	    ---@type table<integer, string>
	    local line_buffer = {}

	    for _, segment in ipairs(self.m_segments) do
	        if not self.show_ids and not segment:requested_update() then
	            if segment.line ~= line_buffer_pos then
	                for index, line in ipairs(segment.lines) do
	                    line_buffer[line_buffer_pos + index - 1] = line
	                end

	                segment.line = line_buffer_pos
	            end
	        else
	            local context = {
	                show_ids = self.show_ids
	            }
	            local update_lines = segment:pre_render(context)

	            if segment.line ~= line_buffer_pos then
	                for index, line in ipairs(segment.lines) do
	                    line_buffer[line_buffer_pos + index - 1] = line
	                end
	            else
	                for index, line in pairs(update_lines) do
	                    line_buffer[line_buffer_pos + index - 1] = line
	                end
	            end

	            segment.line = line_buffer_pos
	        end

	        line_buffer_pos = line_buffer_pos + segment.lines_count
	    end

	    for line, content in pairs(line_buffer) do
	        self:jump_to_line(line)

	        self.m_stream:write(erase.line())
	        if self.show_lines then
	            local line_str = tostring(line)
	            local space = 3 - line_str:len()
	            self.m_stream:write(line_str, string_rep(" ", space), "|")
	        end
	        self.m_stream:write(content, "\n")
	        self.m_cursor_pos = self.m_cursor_pos + 1
	    end

	    if #self.m_segments > 0 then
	        local last_segment = self.m_segments[#self.m_segments]
	        self:jump_to_line(last_segment.line + last_segment.lines_count)
	    else
	        self:jump_to_line(1)
	    end

	    self.m_stream:write(erase.till_end())
	    self.m_stream:flush()
	end

	return terminal

end

__bundler__.__files__["src.components.loading"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local string_rep = string.rep

	local colors = __bundler__.__loadFile__("third-party.ansicolors")
	local segment_class = __bundler__.__loadFile__("src.segment.init")

	---@class lua-term.components.loading.config.create
	---@field length integer | nil (default: 40)
	---
	---@field color_bg ansicolors.color | nil (default: black)
	---@field color_fg ansicolors.color | nil (default: magenta)
	---
	---@field count integer

	---@class lua-term.components.loading.config
	---@field length integer
	---
	---@field color_bg ansicolors.color
	---@field color_fg ansicolors.color
	---
	---@field count integer

	---@class lua-term.components.loading : lua-term.segment_interface
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
	---@param config lua-term.components.loading.config.create
	---@return lua-term.components.loading
	function loading.new(id, parent, config)
	    config = config or {}

	    config.length = utils.value.default(config.length, 40)

	    config.color_bg = utils.value.default(config.color_bg, colors.onblack)
	    config.color_fg = utils.value.default(config.color_fg, colors.onmagenta)

	    ---@type lua-term.components.loading
	    local instance = setmetatable({
	        id = id,
	        state = 0,

	        config = config,
	    }, { __index = loading })
	    instance.m_segment = segment_class.new(id, parent, function()
	        return instance:render()
	    end)

	    return instance
	end

	---@return string
	function loading:render()
	    local mark_tiles = math.floor(self.config.length * self.state / self.config.count)
	    if mark_tiles == 0 then
	        return self.config.color_bg(string_rep(" ", self.config.length))
	    end

	    return self.config.color_fg(string_rep(" ", mark_tiles))
	        .. self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
	end

	function loading:requested_update()
	    self.m_segment:requested_update()
	end

	---@param state integer | nil
	---@param update boolean | nil
	function loading:changed(state, update)
	    if state then
	        self.state = state
	    end

	    self.m_segment:changed(utils.value.default(update, true))
	end

	---@param state integer
	---@param update boolean | nil
	function loading:changed_relativ(state, update)
	    self.state = self.state + state
	    self.m_segment:changed(utils.value.default(update, true))
	end

	---@param update boolean | nil
	function loading:remove(update)
	    self.m_segment:remove(update)
	end

	return loading

end

__bundler__.__files__["src.components.throbber"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local string_rep = string.rep

	local colors = __bundler__.__loadFile__("third-party.ansicolors")
	local segment_class = __bundler__.__loadFile__("src.segment.init")

	---@class lua-term.components.throbber.config.create
	---@field space integer | nil (default: 2)
	---
	---@field color_bg ansicolors.color | nil (default: transparent)
	---@field color_fg ansicolors.color | nil (default: magenta)

	---@class lua-term.components.throbber.config
	---@field space integer
	---
	---@field color_bg ansicolors.color
	---@field color_fg ansicolors.color

	---@class lua-term.components.throbber
	---@field id string
	---
	---@field config lua-term.components.throbber.config
	---
	---@field private m_rotate_on_every_update boolean
	---
	---@field private m_state integer
	---
	---@field private m_segment lua-term.segment
	local throbber = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@param config lua-term.components.throbber.config.create | nil
	---@return lua-term.components.throbber
	function throbber.new(id, parent, config)
	    config = config or {}
	    config.space = config.space or 2
	    config.color_bg = config.color_bg or colors.transparent
	    config.color_fg = config.color_fg or colors.magenta

	    ---@type lua-term.components.throbber
	    local instance = setmetatable({
	        id = id,
	        m_state = 0,

	        m_rotate_on_every_update = false,

	        config = config
	    }, { __index = throbber })
	    instance.m_segment = segment_class.new(id, parent, function()
	        return instance:render()
	    end)

	    return instance
	end

	function throbber:render()
	    self.m_state = self.m_state + 1
	    if self.m_state > 3 then
	        self.m_state = 0
	    end

	    local state_str
	    if self.m_state == 0 then
	        state_str = "\\"
	    elseif self.m_state == 1 then
	        state_str = "|"
	    elseif self.m_state == 2 then
	        state_str = "/"
	    elseif self.m_state == 3 then
	        state_str = "-"
	    end

	    if self.m_rotate_on_every_update then
	        self.m_segment:changed()
	    end

	    return string_rep(" ", self.config.space) .. self.config.color_bg(self.config.color_fg(state_str))
	end

	function throbber:rotate()
	    self.m_segment:changed(true)
	end

	---@param value boolean | nil
	function throbber:rotate_on_every_update(value)
	    self.m_rotate_on_every_update = utils.value.default(value, true)
	end

	---@param update boolean | nil
	function throbber:remove(update)
	    self.m_segment:remove(update)
	end

	return throbber

end

__bundler__.__files__["src.components.line"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local table_insert = table.insert
	local table_remove = table.remove
	local table_concat = table.concat

	local segment_entry = __bundler__.__loadFile__("src.segment.entry")
	local text_segment = __bundler__.__loadFile__("src.components.text")

	---@class lua-term.components.line : lua-term.segment_interface, lua-term.segment_parent
	---@field private m_requested_update boolean
	---@field private m_childs lua-term.segment_entry[]
	---@field private m_parent lua-term.segment_parent
	local line_class = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@return lua-term.components.line
	function line_class.new(id, parent)
	    local instance = setmetatable({
	        m_childs = {},
	        m_requested_update = false,

	        m_parent = parent,
	    }, { __index = line_class })
	    parent:add_segment(id, instance)

	    return instance
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function line_class:render(context)
	    local line_buffer = {}
	    for _, child_entry in ipairs(self.m_childs) do
	        if not context.show_ids and not child_entry:requested_update() then
	            goto continue
	        end

	        child_entry:pre_render(context)

	        ::continue::

	        for _, line in ipairs(child_entry.lines) do
	            table_insert(line_buffer, line)
	        end
	    end

	    if context.show_ids then
	        return line_buffer, #line_buffer
	    end

	    local line = 0
	    if #line_buffer > 0 then
	        line = 1
	    end
	    return { table_concat(line_buffer) }, line
	end

	---@param update boolean | nil
	function line_class:remove(update)
	    update = utils.value.default(update, true)

	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update()
	    end
	end

	function line_class:requested_update()
	    if self.m_requested_update then
	        return true
	    end

	    for _, child in ipairs(self.m_childs) do
	        if child:requested_update() then
	            return true
	        end
	    end
	end

	----------------------
	--- segment_parent ---
	----------------------

	function line_class:update()
	    self.m_parent:update()
	end

	---@return lua-term.segment
	function line_class:print(...)
	    return text_segment.print(self, ...)
	end

	function line_class:add_segment(id, segment)
	    table_insert(self.m_childs, segment_entry.new(id, segment))
	end

	function line_class:remove_child(child)
	    for index, child_entry in ipairs(self.m_childs) do
	        if child_entry:has_segment(child) then
	            table_remove(self.m_childs, index)
	            break
	        end
	    end

	    self.m_requested_update = true
	end

	return line_class

end

__bundler__.__files__["src.components.group"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local table_insert = table.insert
	local table_remove = table.remove

	local text_component = __bundler__.__loadFile__("src.components.text")
	local entry_class = __bundler__.__loadFile__("src.segment.entry")

	---@class lua-term.components.group : lua-term.segment_interface, lua-term.segment_parent
	---@field private m_requested_update boolean
	---@field private m_childs lua-term.segment_entry[]
	---@field private m_parent lua-term.segment_parent
	local group_class = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@return lua-term.components.group
	function group_class.new(id, parent)
	    local instance = setmetatable({
	        m_childs = {},
	        m_requested_update = false,

	        m_parent = parent,
	    }, { __index = group_class })
	    parent:add_segment(id, instance)

	    return instance
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function group_class:render(context)
	    self.m_requested_update = false
	    if #self.m_childs == 0 then
	        return {}, 0
	    end

	    local line_buffer_pos = 0
	    local line_buffer = {}
	    for _, child in pairs(self.m_childs) do
	        if not context.show_ids and not child:requested_update() then
	            if child.line ~= line_buffer_pos then
	                for index, line in ipairs(child.lines) do
	                    line_buffer[line_buffer_pos + index] = line
	                end
	            end

	            line_buffer_pos = line_buffer_pos + child.lines_count
	            goto continue
	        end

	        local update_lines = child:pre_render(context)
	        child.line = line_buffer_pos
	        for index, line in pairs(update_lines) do
	            line_buffer[line_buffer_pos + index] = line
	        end
	        line_buffer_pos = line_buffer_pos + #update_lines

	        ::continue::
	    end

	    local last_child = self.m_childs[#self.m_childs]
	    local last_line = last_child.line + last_child.lines_count
	    return line_buffer, last_line
	end

	---@param update boolean | nil
	function group_class:remove(update)
	    update = utils.value.default(update, true)

	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update()
	    end
	end

	function group_class:requested_update()
	    if self.m_requested_update then
	        return true
	    end

	    for _, child in ipairs(self.m_childs) do
	        if child:requested_update() then
	            return true
	        end
	    end
	end

	-- lua-term.parent

	function group_class:update()
	    self.m_parent:update()
	end

	---@return lua-term.segment
	function group_class:print(...)
	    return text_component.print(self, ...)
	end

	function group_class:add_segment(id, segment)
	    local entry = entry_class.new(id, segment)
	    table_insert(self.m_childs, entry)
	end

	function group_class:remove_child(child)
	    for index, entry in pairs(self.m_childs) do
	        if entry:has_segment(child) then
	            table_remove(self.m_childs, index)
	            break
	        end
	    end

	    self.m_requested_update = true
	end

	return group_class

end

__bundler__.__files__["src.misc.screen"] = function()
	local table_concat = table.concat

	---@enum lua-term.screen.state
	local state = {
	    Normal = 0,
	    AnsiEscapeCode = 1
	}

	---@class lua-term.screen.line
	---@field [integer] string
	---@field length integer

	---@class lua-term.screen
	---@field private m_read_char_func fun() : string | nil
	---
	---@field private m_cursor_x integer
	---@field private m_cursor_y integer
	---@field private m_screen (lua-term.screen.line|nil)[]
	---@field private m_changed table<integer, true>
	---
	---@field private m_state lua-term.screen.state
	---@field private m_buffer string | nil
	local screen_class = {}

	---@param read_char_func fun() : string | nil
	function screen_class.new(read_char_func)
	    return setmetatable({
	        m_read_char_func = read_char_func,

	        m_cursor_x = 1,
	        m_cursor_y = 1,
	        m_screen = {},
	        m_changed = {},

	        m_state = state.Normal
	    }, { __index = screen_class })
	end

	---@private
	---@param line integer
	---@return lua-term.screen.line
	function screen_class:get_line(line)
	    local _line = self.m_screen[line]
	    if not _line then
	        _line = { length = 0 }
	        self.m_screen[line] = _line
	    end
	    return _line
	end

	function screen_class:get_height()
	    return #self.m_screen
	end

	---@return (string[]|nil)[]
	function screen_class:get_screen()
	    return self.m_screen
	end

	---@return table<integer, string>
	function screen_class:get_changed()
	    ---@type table<integer, string>
	    local buffer = {}
	    for line in pairs(self.m_changed) do
	        buffer[line] = table_concat(self:get_line(line))
	    end
	    return buffer
	end

	function screen_class:clear_changed()
	    self.m_changed = {}
	end

	---@private
	---@param dx integer
	---@param dy integer
	function screen_class:move_cursor(dx, dy)
	    self.m_cursor_x = math.max(1, self.m_cursor_x + dx)
	    self.m_cursor_y = math.max(1, self.m_cursor_y + dy)
	end

	---@private
	---@param seq string
	---@return integer[]
	local function parse_ansi_escape_code_params(seq)
	    local params = {}
	    for param in seq:gmatch("%d+") do
	        table.insert(params, tonumber(param))
	    end
	    return params
	end

	---@private
	---@param command string
	function screen_class:execute_ansi_escape_code(command)
	    local params = parse_ansi_escape_code_params(self.m_buffer:sub(3, -1)) -- Extract parameters

	    -- Process the command
	    if command == "A" then
	        -- Cursor Up (CSI n A)
	        self:move_cursor(0, -(params[1] or 1))
	    elseif command == "B" then
	        -- Cursor Down (CSI n B)
	        self:move_cursor(0, params[1] or 1)
	    elseif command == "C" then
	        -- Cursor Forward (CSI n C)
	        self:move_cursor(params[1] or 1, 0)
	    elseif command == "D" then
	        -- Cursor Back (CSI n D)
	        self:move_cursor(-(params[1] or 1), 0)
	    elseif command == "H" or command == "f" then
	        -- Cursor Position (CSI n;m H or CSI n;m f)
	        self.m_cursor_y = params[1] or 1
	        self.m_cursor_x = params[2] or 1
	    elseif command == "J" then
	        -- Erase in Display (CSI n J)
	        if params[1] == 2 or not params[1] then
	            self.m_screen = {}
	        end
	    elseif command == "K" then
	        -- Erase in Line (CSI n K)
	        local line = self:get_line(self.m_cursor_y)
	        for x = self.m_cursor_x, line.length do
	            line[x] = nil
	        end
	        line.length = self.m_cursor_x
	    else
	        self:write(self.m_buffer)
	    end

	    self.m_state = state.Normal
	    self.m_buffer = nil
	end

	---@private
	---@param buffer string
	function screen_class:write(buffer)
	    for i = 1, #buffer do
	        local char = buffer:sub(i, i)

	        local line = self:get_line(self.m_cursor_y)
	        for x = line.length + 1, self.m_cursor_x - 1 do
	            if not line[x] then
	                line[x] = " "
	            end
	        end

	        line[self.m_cursor_x] = char
	        if line.length < self.m_cursor_x then
	            line.length = self.m_cursor_x
	        end
	        self.m_cursor_x = self.m_cursor_x + 1

	        self.m_changed[self.m_cursor_y] = true
	    end
	end

	---@return string | nil char
	function screen_class:process_char()
	    local char = self.m_read_char_func()
	    if not char then
	        return nil
	    end

	    if char == "\r" then
	        self.m_cursor_x = 1
	        return char
	    elseif char == "\n" then
	        self.m_cursor_x = 1
	        self.m_cursor_y = self.m_cursor_y + 1
	        return char
	    elseif char == "\27" then
	        self.m_buffer = char
	        self.m_state = state.AnsiEscapeCode
	        return char
	    elseif self.m_state == state.Normal then
	        self:write(char)
	        return char
	    end

	    if self.m_state == state.AnsiEscapeCode and #self.m_buffer == 1 and char ~= "[" then
	        self.m_buffer = self.m_buffer .. char
	        self.m_state = state.Normal
	    end

	    if self.m_state == state.Normal and self.m_buffer then
	        self:write(self.m_buffer)
	        self.m_buffer = nil
	    elseif char:find("[A-Za-z]") then
	        self:execute_ansi_escape_code(char)
	    elseif self.m_state == state.AnsiEscapeCode then
	        self.m_buffer = self.m_buffer .. char
	    end

	    return char
	end

	---@return string
	function screen_class:to_string()
	    local pos_y = 0
	    local result = {}
	    for y, row in pairs(self.m_screen) do
	        while pos_y < y do
	            pos_y = pos_y + 1
	            if not result[pos_y] then
	                result[pos_y] = ""
	            end
	        end

	        local pos_x = 0
	        local line = {}
	        for x, char in pairs(row) do
	            while pos_x < x do
	                pos_x = pos_x + 1
	                if not line[pos_x] then
	                    line[pos_x] = " "
	                end
	            end

	            line[x] = char
	        end
	        result[y] = table.concat(line)
	    end
	    return table.concat(result, "\n")
	end

	return screen_class

end

__bundler__.__files__["src.components.stream"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local table_insert = table.insert
	local table_concat = table.concat

	local screen_class = __bundler__.__loadFile__("src.misc.screen")

	---@class lua-term.components.stream.config
	---@field before string | ansicolors.color | nil
	---@field after string | ansicolors.color | nil

	---@class lua-term.components.stream : lua-term.segment_interface
	---@field config lua-term.components.stream.config
	---
	---@field private m_stream file*
	---@field private m_closed boolean
	---
	---@field private m_screen lua-term.screen
	---
	---@field private m_parent lua-term.segment_parent
	---@field private m_requested_update boolean
	local stream_class = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@param stream file*
	---@param config lua-term.components.stream.config | nil
	---@return lua-term.components.stream
	function stream_class.new(id, parent, stream, config)
	    local instance = setmetatable({
	        config = config or {},

	        m_stream = stream,
	        m_closed = false,

	        m_screen = screen_class.new(function()
	            return stream:read(1)
	        end),

	        m_parent = parent,
	        m_requested_update = true,
	    }, { __index = stream_class })
	    parent:add_segment(id, instance)

	    return instance
	end

	function stream_class:remove(update)
	    self.m_parent:remove_child(self)

	    if utils.value.default(update, true) then
	        self.m_parent:update()
	    end
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function stream_class:render(context)
	    local buffer = self.m_screen:get_changed()
	    local height = self.m_screen:get_height()
	    self.m_screen:clear_changed()

	    for line, content in pairs(buffer) do
	        buffer[line] = ("%s%s%s"):format(tostring(self.config.before or ""), content, tostring(self.config.after or ""))
	    end

	    return buffer, height
	end

	function stream_class:requested_update()
	    return self.m_requested_update
	end

	---@private
	function stream_class:read(update)
	    local char = self.m_screen:process_char()
	    if not char then
	        self.m_closed = true
	        return
	    end

	    if utils.value.default(update, true) then
	        self:update()
	    end

	    return char
	end

	---@param update boolean | nil
	function stream_class:read_line(update)
	    while true do
	        local char = self:read(false)
	        if not char then
	            break
	        end

	        if char == "\n" then
	            break
	        end
	    end

	    if utils.value.default(update, true) then
	        self:update()
	    end
	end

	---@param update boolean | nil
	function stream_class:read_all(update)
	    while not self.m_closed do
	        self:read(update)
	    end
	end

	function stream_class:update()
	    self.m_requested_update = true
	    self.m_parent:update()
	end

	return stream_class

end

__bundler__.__files__["src.components.loop_with_end"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local _line = __bundler__.__loadFile__("src.components.line")
	local _segment = __bundler__.__loadFile__("src.segment.init")
	local _loading = __bundler__.__loadFile__("src.components.loading")

	---@class lua-term.components.loop_with_end.config.create : lua-term.components.loading.config.create
	---@field update_on_remove boolean | nil default is `true`
	---@field update_on_every_iterations integer | nil default is `true`
	---@field show_progress_number boolean | nil default is `true`
	---@field show_iterations_per_second boolean | nil default is `false`
	---
	---@field count integer

	---@class lua-term.components.loop.config : lua-term.components.loading.config
	---@field update_on_remove boolean
	---@field update_on_every_iterations boolean
	---@field show_progress_number boolean
	---@field show_iterations_per_second boolean

	---@class lua-term.components.loop_with_end
	---@field stopwatch Freemaker.utils.stopwatch
	---
	---@field loading_line lua-term.components.line
	---@field loading_bar lua-term.components.loading
	---@field info_text lua-term.segment
	---
	---@field config lua-term.components.loop.config
	local _loop_with_end = {}

	---@param id string
	---@param parent lua-term.segment_parent
	---@param config lua-term.components.loop_with_end.config.create
	---@return lua-term.components.loop_with_end
	function _loop_with_end.new(id, parent, config)
	    config.update_on_remove = utils.value.default(config.update_on_remove, true)
	    config.update_on_every_iterations = utils.value.default(config.update_on_every_iterations, 1)
	    config.show_progress_number = utils.value.default(config.show_progress_number, true)
	    config.show_iterations_per_second = utils.value.default(config.show_iterations_per_second, false)

	    local stopwatch = utils.stopwatch.start_new()
	    local loading_line = _line.new(id, parent)
	    local loading_bar = _loading.new(id .. "-loading_bar", loading_line, config)
	    local info_text = _segment.new(id .. "-info", loading_line, function()
	        local builder = utils.string.builder.new()

	        if config.show_progress_number then
	            local count_str = tostring(config.count)
	            local state_str = utils.string.left_pad(tostring(loading_bar.state), count_str:len())
	            builder:append(" <", count_str, "/", state_str, ">")
	        end

	        if config.show_iterations_per_second then
	            local lap_time = stopwatch:lap()
	            if loading_bar.state ~= 0 then
	                local iterations_per_second = 1 / (lap_time / 1000) * config.update_on_every_iterations
	                builder:append(" |", string.format("%.1f", iterations_per_second), "itr/s|")
	            end
	        end

	        return builder:build()
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

	function _loop_with_end:iterate()
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
	---@param parent lua-term.segment_parent
	---@param tbl table<K, V>
	---@param iterator_func (fun(tbl: table<K, V>) : (fun(tbl: table<K, V>, index: K | nil) : K, V))
	---@param config lua-term.components.loop_with_end.config.create
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
	            loop:iterate()
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
	---@param parent lua-term.segment_parent
	---@param tbl table<K, V>
	---@param config lua-term.components.loop_with_end.config.create
	---@return fun(table: table<K, V>, index: K | nil) : K, V
	---@return T
	function _loop_with_end.pairs(id, parent, tbl, config)
	    return _loop_with_end.iterator(id, parent, tbl, pairs, config)
	end

	---@generic T : table, K, V
	---@param id string
	---@param parent lua-term.segment_parent
	---@param tbl table<K, V>
	---@param config lua-term.components.loop_with_end.config.create
	---@return fun(table: table<K, V>, index: K | nil) : K, V
	---@return T
	function _loop_with_end.ipairs(id, parent, tbl, config)
	    return _loop_with_end.iterator(id, parent, tbl, ipairs, config)
	end

	---@class lua-term.components.for_loop.config.create : lua-term.components.loop_with_end.config.create
	---@field count nil

	---@param id string
	---@param parent lua-term.segment_parent
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

	        loop:iterate()

	        if index == _end then
	            loop:remove()
	            return nil, nil
	        end

	        return index + 1, true
	    end
	end

	return _loop_with_end

end

__bundler__.__files__["src.components.init"] = function()
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
	    segment = __bundler__.__loadFile__("src.segment.init"),

	    text = __bundler__.__loadFile__("src.components.text"),
	    loading = __bundler__.__loadFile__("src.components.loading"),
	    throbber = __bundler__.__loadFile__("src.components.throbber"),

	    line = __bundler__.__loadFile__("src.components.line"),
	    group = __bundler__.__loadFile__("src.components.group"),

	    stream = __bundler__.__loadFile__("src.components.stream"),

	    loop_with_end = __bundler__.__loadFile__("src.components.loop_with_end")
	}

	return components

end

__bundler__.__files__["__main__"] = function()
	--- meta files
	__bundler__.__loadFile__("src.segment.interface")
	__bundler__.__loadFile__("src.segment.parent")

	---@class lua-term
	---@field colors ansicolors
	---
	---@field terminal lua-term.terminal
	---@field components lua-term.components
	local term = {
	    colors = __bundler__.__loadFile__("third-party.ansicolors"),

	    terminal = __bundler__.__loadFile__("src.terminal"),
	    components = __bundler__.__loadFile__("src.components.init")
	}

	return term

end

---@type { [1]: lua-term }
local main = { __bundler__.__main__() }
return table.unpack(main)
