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
	            -- for i = 1, #content do
	                -- local byte = tonumber(content[i], 16)
	                -- file:write(string.char(byte))
	            -- end
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
	    coroutine.close(loading_thread)
	    __bundler__.__cleanup__()
	    return table.unpack(items)
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
	function color:__concat(other)
	    return tostring(self) .. tostring(other)
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
	    if color_code < 0 or color_code > 255 then
	        return ansicolors.clear
	    end

	    return makecolor("38;5;" .. tostring(color_code))
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
	    if color_code < 0 or color_code > 255 then
	        return ansicolors.clear
	    end

	    return makecolor("48;5;" .. tostring(color_code))
	end

	return ansicolors

end

__bundler__.__files__["utils.utils"] = function()
	---@diagnostic disable

	local __bundler__ = {
	    __files__ = {},
	    __binary_files__ = {},
	    __cache__ = {},
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
	            local os_type = __bundler__.__get_os__()
	            local file_path = "." .. os.tmpname()
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
	            for i = 1, #content do
	                local byte = tonumber(content[i], 16)
	                file:write(string.char(byte))
	            end
	            file:close()
	            __bundler__.__cache__[module] = { package.loadlib(file_path, "luaopen_" .. module)() }
	        else
	            __bundler__.__cache__[module] = { __bundler__.__files__[module]() }
	        end
	    end
	    return table.unpack(__bundler__.__cache__[module])
	end
	__bundler__.__files__["src.utils.string"] = function()
		---@class Freemaker.utils.string
		local _string = {}

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

		return _string

	end

	__bundler__.__files__["src.utils.table"] = function()
		---@class Freemaker.utils.table
		local _table = {}

		---@param t table
		---@param copy table
		---@param seen table<table, table>
		local function copy_table_to(t, copy, seen)
		    if seen[t] then
		        return seen[t]
		    end

		    seen[t] = copy

		    for key, value in next, t do
		        if type(value) == "table" then
		            if type(copy[key]) ~= "table" then
		                copy[key] = {}
		            end
		            copy_table_to(value, copy[key], seen)
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
		end

		---@generic T
		---@param t T
		---@return T table
		function _table.copy(t)
		    local copy = {}
		    copy_table_to(t, copy, {})
		    return copy
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

		--- removes all spaces between
		---@param t any[]
		function _table.clean(t)
		    for key, value in pairs(t) do
		        for i = key - 1, 1, -1 do
		            if key ~= 1 then
		                if t[i] == nil and (t[i - 1] ~= nil or i == 1) then
		                    t[i] = value
		                    t[key] = nil
		                    break
		                end
		            end
		        end
		    end
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
		---@param t T
		---@param func fun(key: any, value: any) : boolean
		---@return T
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
		---@param t T
		---@param func fun(key: any, value: any) : boolean
		---@return T
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
		-- caching globals for more performance
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
		local array = {}

		---@generic T
		---@param t T[]
		---@param amount integer
		---@return T[]
		function array.take_front(t, amount)
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
		function array.take_back(t, amount)
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
		function array.drop_front_implace(t, amount)
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
		function array.drop_back_implace(t, amount)
		    local length = #t
		    local start = length - amount + 1

		    for i = start, length, 1 do
		        t[i] = nil
		    end
		    return t
		end

		---@generic T
		---@param t T[]
		---@param func fun(key: any, value: T) : boolean
		---@return T[]
		function array.select(t, func)
		    local copy = {}
		    for key, value in pairs(t) do
		        if func(key, value) then
		            table_insert(copy, value)
		        end
		    end
		    return copy
		end

		---@generic T
		---@param t T[]
		---@param func fun(key: any, value: T) : boolean
		---@return T[]
		function array.select_implace(t, func)
		    for key, value in pairs(t) do
		        if func(key, value) then
		            t[key] = nil
		            insert_first_nil(t, value)
		        else
		            t[key] = nil
		        end
		    end
		    return t
		end

		return array

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

		---@param value number
		---@param min number
		---@return number
		function _value.min(value, min)
		    if value < min then
		        return min
		    end
		    return value
		end

		---@param value number
		---@param max number
		---@return number
		function _value.max(value, max)
		    if value > max then
		        return max
		    end
		    return value
		end

		return _value

	end

	__bundler__.__files__["__main__"] = function()
		---@class Freemaker.utils
		---@field string Freemaker.utils.string
		---@field table Freemaker.utils.table
		---@field array Freemaker.utils.array
		---@field value Freemaker.utils.value
		local utils = {}

		utils.string = __bundler__.__loadFile__("src.utils.string")
		utils.table = __bundler__.__loadFile__("src.utils.table")
		utils.array = __bundler__.__loadFile__("src.utils.array")
		utils.value = __bundler__.__loadFile__("src.utils.value")

		return utils

	end

	---@type { [1]: Freemaker.utils }
	local main = { __bundler__.__loadFile__("__main__") }
	return table.unpack(main)

end

__bundler__.__files__["src.maketermfunc"] = function()
	local sformat = string.format

	return function(sequence_fmt)
	    sequence_fmt = '\027[' .. sequence_fmt
	    return function(...)
	        return sformat(sequence_fmt, ...)
	    end
	end

end

__bundler__.__files__["src.cursor"] = function()
	local make_term_func = __bundler__.__loadFile__("src.maketermfunc")

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

__bundler__.__files__["src.erase"] = function()
	local make_term_func = __bundler__.__loadFile__("src.maketermfunc")

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

__bundler__.__files__["src.terminal"] = function()
	local utils = __bundler__.__loadFile__("utils.utils")

	local cursor = __bundler__.__loadFile__("src.cursor")
	local erase = __bundler__.__loadFile__("src.erase")

	local pairs = pairs
	local string_rep = string.rep
	local math_abs = math.abs
	local io_type = io.type
	local table_insert = table.insert
	local table_remove = table.remove
	local table_concat = table.concat
	local debug_traceback = debug.traceback

	---@class lua-term.parent
	local parent_class = {}

	function parent_class:update()
	end

	---@param id string
	---@param func lua-term.segment.func
	---@return lua-term.segment
	function parent_class:create_segment(id, func)
	    ---@diagnostic disable-next-line: missing-return
	end

	---@param id string
	---@param childs lua-term.segment[] | nil
	function parent_class:create_group(id, childs)
	    ---@diagnostic disable-next-line: missing-return
	end

	---@param child lua-term.segment
	function parent_class:remove_child(child)
	end

	---@alias lua-term.segment.func (fun() : string | nil)

	---@class lua-term.segment
	---@field id string
	---@field protected m_parent lua-term.parent
	---
	---@field private m_func lua-term.segment.func
	---@field private m_requested_update boolean
	---
	---@field package p_lines string[]
	---@field package p_lines_count integer
	---
	---@field package p_line integer
	local segment_class = {}

	---@param id string
	---@param func lua-term.segment.func
	---@param parent lua-term.parent
	function segment_class.new(id, func, parent)
	    return setmetatable({
	        id = id,
	        m_parent = parent,

	        m_func = func,
	        m_requested_update = true,

	        p_lines = {},
	        p_lines_count = 0,

	        p_line = 0
	    }, {
	        __index = segment_class
	    })
	end

	---@package
	function segment_class:pre_render()
	    self.m_requested_update = false

	    local pre_render_thread = coroutine.create(self.m_func)
	    local success, str_or_err_msg = coroutine.resume(pre_render_thread)
	    if not success then
	        str_or_err_msg =
	            string_rep("-", 80) .. "\n" ..
	            "error pre rendering segement '" .. self.id .. "':\n" ..
	            debug_traceback(pre_render_thread, str_or_err_msg) .. "\n" ..
	            string_rep("-", 80)
	    end
	    coroutine.close(pre_render_thread)

	    if not str_or_err_msg or str_or_err_msg == "" then
	        self.p_lines = {}
	    else
	        self.p_lines = utils.string.split(str_or_err_msg, "\n")
	        if self.p_lines[#self.p_lines] == "" then
	            self.p_lines[#self.p_lines] = nil
	        end
	    end

	    self.p_lines_count = #self.p_lines
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

	-------------
	--- Group ---
	-------------

	---@class lua-term.segment.group : lua-term.segment, lua-term.parent
	---@field private m_requested_update boolean
	---@field private m_childs lua-term.segment[]
	local group_class = {}

	---@param id string
	---@param parent lua-term.parent
	---@param childs lua-term.segment[] | nil
	---@return lua-term.segment.group
	function group_class.new(id, parent, childs)
	    return setmetatable({
	        id = id,

	        m_childs = childs or {},
	        m_requested_update = false,

	        m_parent = parent,

	        p_lines = {},
	        p_lines_count = 0,

	        p_line = 0
	    }, { __index = group_class })
	end

	function group_class:pre_render()
	    self.p_lines = {}

	    for _, child in pairs(self.m_childs) do
	        if child:requested_update() then
	            child:pre_render()
	        end

	        for _, line in ipairs(child.p_lines) do
	            table_insert(self.p_lines, line)
	        end
	    end

	    self.p_lines_count = #self.p_lines

	    self.m_requested_update = false
	end

	---@param update boolean | nil
	function group_class:remove(update)
	    update = utils.value.default(update, true)

	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update()
	    end
	end

	---@param update boolean | nil
	function group_class:changed(update)
	    self.p_requested_update = true

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

	function group_class:create_segment(id, func)
	    local segment = segment_class.new(id, func, self)
	    table_insert(self.m_childs, segment)
	    return segment
	end

	function group_class:create_group(id, childs)
	    local group = group_class.new(id, self, childs)
	    table_insert(self.m_childs, group)
	    return group
	end

	function group_class:remove_child(child)
	    for index, value in pairs(self.m_childs) do
	        if value == child then
	            table_remove(self.m_childs, index)
	        end
	    end

	    self.m_requested_update = true
	end

	----------------
	--- Terminal ---
	----------------

	---@class lua-term.terminal : lua-term.parent
	---@field show_ids boolean
	---
	---@field private m_stream file*
	---
	---@field private m_segments lua-term.segment[]
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

	    return setmetatable({
	        show_ids = false,

	        m_stream = stream,
	        m_segments = {},
	        m_cursor_pos = 1,
	    }, {
	        __index = terminal,
	    })
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

	---@param ... any
	---@return lua-term.segment
	function terminal:print(...)
	    local items = {}
	    for _, value in ipairs({ ... }) do
	        table_insert(items, tostring(value))
	    end
	    local str = table_concat(items, "\t")
	    local print_segment = stdout_terminal:create_segment("<print>", function()
	        return str
	    end)
	    self:update()
	    return print_segment
	end

	function terminal:create_segment(id, func)
	    local segment = segment_class.new(id, func, self)
	    table_insert(self.m_segments, segment)
	    return segment
	end

	function terminal:create_group(id, childs)
	    local group = group_class.new(id, self, childs)
	    table_insert(self.m_segments, group)
	    return group
	end

	function terminal:remove_child(segment)
	    for index, segment_value in ipairs(self.m_segments) do
	        if segment_value == segment then
	            table_remove(self.m_segments, index)
	        end
	    end
	end

	---@private
	---@param ... string
	function terminal:write_line(...)
	    self.m_stream:write(...)
	    self.m_stream:write("\n")
	    self.m_cursor_pos = self.m_cursor_pos + 1
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
	    local function insert_line(line)
	        line_buffer[line_buffer_pos] = line
	        line_buffer_pos = line_buffer_pos + 1
	    end

	    for _, segment in ipairs(self.m_segments) do
	        if segment:requested_update() then
	            segment:pre_render()
	        elseif segment.p_line == line_buffer_pos then
	            line_buffer_pos = line_buffer_pos + segment.p_lines_count
	            goto continue
	        end

	        if self.show_ids then
	            local id_str = "---- seg id: " .. segment.id .. " "
	            local str = id_str .. string_rep("-", 80 - id_str:len())
	            insert_line(str)
	        end

	        segment.p_line = line_buffer_pos
	        for _, line in ipairs(segment.p_lines) do
	            insert_line(line)
	        end

	        if self.show_ids then
	            insert_line(string_rep("-", 80))
	        end

	        ::continue::
	    end

	    for line, content in pairs(line_buffer) do
	        self:jump_to_line(line)
	        self:write_line(
	            erase.line(),
	            content)
	    end

	    if #self.m_segments > 0 then
	        local last_segment = self.m_segments[#self.m_segments]
	        self:jump_to_line(last_segment.p_line + last_segment.p_lines_count)
	    else
	        self:jump_to_line(1)
	    end

	    self.m_stream:write(erase.till_end())
	    self.m_stream:flush()
	end

	return terminal

end

__bundler__.__files__["src.components"] = function()
	local utils = __bundler__.__loadFile__("utils.utils")

	local colors = __bundler__.__loadFile__("third-party.ansicolors")

	local string_rep = string.rep

	---@class lua-term.components
	local components = {}

	---------------
	--- loading ---
	---------------

	---@class lua-term.components.loading.config.create
	---@field length integer | nil (default: 40)
	---@field state_percent integer | nil in percent (default: 0)
	---
	---@field color_bg ansicolors.color | nil (default: black)
	---@field color_fg ansicolors.color | nil (default: magenta)

	---@class lua-term.components.loading.config
	---@field length integer
	---
	---@field color_bg ansicolors.color
	---@field color_fg ansicolors.color

	---@class lua-term.components.loading
	---@field id string
	---@field state_percent integer
	---
	---@field config lua-term.components.loading.config
	---
	---@field private m_segment lua-term.segment
	local loading = {}
	components.loading = loading

	---@param id string
	---@param parent lua-term.parent
	---@param config lua-term.components.loading.config.create | nil
	---@return lua-term.components.loading
	function loading.new(id, parent, config)
	    config = config or {}
	    config.color_bg = config.color_bg or colors.onblack
	    config.color_fg = config.color_fg or colors.onmagenta
	    config.length = config.length or 40

	    ---@type lua-term.components.loading
	    local instance = setmetatable({
	        id = id,
	        state_percent = config.state_percent or 0,

	        config = config,
	    }, { __index = loading })
	    instance.m_segment = parent:create_segment(id, function()
	        return instance:render()
	    end)

	    config.state_percent = nil

	    return instance
	end

	---@return string
	function loading:render()
	    local mark_tiles = math.floor(self.config.length * self.state_percent / 100)
	    return self.config.color_fg(string_rep(" ", mark_tiles)) .. self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
	end

	---@param state_percent integer | nil
	---@param update boolean | nil
	function loading:changed(state_percent, update)
	    if state_percent then
	        self.state_percent = state_percent
	    end

	    self.m_segment:changed(update or true)
	end

	---@param state_percent integer
	---@param update boolean | nil
	function loading:changed_relativ(state_percent, update)
	    self.state_percent = self.state_percent + state_percent
	    self.m_segment:changed(update or true)
	end

	---@param update boolean | nil
	function loading:remove(update)
	    self.m_segment:remove(update)
	end

	----------------
	--- throbber ---
	----------------

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
	components.throbber = throbber

	---@param id string
	---@param parent lua-term.parent
	---@param config lua-term.components.throbber.config.create | nil
	---@return lua-term.components.throbber
	function throbber.new(id, parent, config)
	    config = config or {}
	    config.space = config.space or 2
	    config.color_bg = config.color_bg or colors.reset
	    config.color_fg = config.color_fg or colors.magenta

	    ---@type lua-term.components.throbber
	    local instance = setmetatable({
	        id = id,
	        m_state = 0,

	        m_rotate_on_every_update = false,

	        config = config
	    }, { __index = throbber })
	    instance.m_segment = parent:create_segment(id, function()
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

	return components

end

__bundler__.__files__["__main__"] = function()
	---@class lua-term
	---@field colors ansicolors
	---
	---@field terminal lua-term.terminal
	---@field components lua-term.components
	local term = {
	    colors = __bundler__.__loadFile__("third-party.ansicolors"),

	    terminal = __bundler__.__loadFile__("src.terminal"),
	    components = __bundler__.__loadFile__("src.components")
	}

	return term

end

---@type { [1]: lua-term }
local main = { __bundler__.__main__() }
return table.unpack(main)
