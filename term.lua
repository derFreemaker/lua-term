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
	__bundler__.__files__["misc.class_system"] = function()
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
		__bundler__.__files__["src.config"] = function()
		---@class class-system.configs
		local configs = {}

		--- All meta methods that should be added as meta method to the class.
		configs.all_meta_methods = {
		    --- Before Constructor
		    __preinit = true,
		    --- Constructor
		    __init = true,
		    --- Garbage Collection
		    __gc = true,
		    --- Out of Scope
		    __close = true,

		    --- Special
		    __call = true,
		    __newindex = true,
		    __index = true,
		    __pairs = true,
		    __ipairs = true,
		    __tostring = true,

		    -- Operators
		    __add = true,
		    __sub = true,
		    __mul = true,
		    __div = true,
		    __mod = true,
		    __pow = true,
		    __unm = true,
		    __idiv = true,
		    __band = true,
		    __bor = true,
		    __bxor = true,
		    __bnot = true,
		    __shl = true,
		    __shr = true,
		    __concat = true,
		    __len = true,
		    __eq = true,
		    __lt = true,
		    __le = true
		}

		--- Blocks meta methods on the blueprint of an class.
		configs.block_meta_methods_on_blueprint = {
		    __pairs = true,
		    __ipairs = true
		}

		--- Blocks meta methods if not set by the class.
		configs.block_meta_methods_on_instance = {
		    __pairs = true,
		    __ipairs = true
		}

		--- Meta methods that should not be set to the classes metatable, but remain in the type.MetaMethods.
		configs.indirect_meta_methods = {
		    __preinit = true,
		    __gc = true,
		    __index = true,
		    __newindex = true
		}

		-- Indicates that the __close method is called from the ClassSystem.Deconstruct method.
		configs.deconstructing = {}

		-- Placeholder is used to indicate that this member should be set by super class of the abstract class
		---@type any
		configs.abstract_placeholder = {}

		-- Placeholder is used to indicate that this member should be set by super class of the interface
		---@type any
		configs.interface_placeholder = {}

		return configs

	end

	__bundler__.__files__["src.meta"] = function()
		---@meta

		----------------------------------------------------------------
		-- MetaMethods
		----------------------------------------------------------------

		---@class class-system.object-meta-methods
		---@field protected __preinit (fun(...) : any) | nil self(...) before contructor
		---@field protected __init (fun(self: object, ...)) | nil self(...) constructor
		---@field protected __call (fun(self: object, ...) : ...) | nil self(...) after construction
		---@field protected __close (fun(self: object, errObj: any) : any) | nil invoked when the object gets out of scope
		---@field protected __gc fun(self: object) | nil class-system.deconstruct(self) or on garbageCollection
		---@field protected __add (fun(self: object, other: any) : any) | nil (self) + (value)
		---@field protected __sub (fun(self: object, other: any) : any) | nil (self) - (value)
		---@field protected __mul (fun(self: object, other: any) : any) | nil (self) * (value)
		---@field protected __div (fun(self: object, other: any) : any) | nil (self) / (value)
		---@field protected __mod (fun(self: object, other: any) : any) | nil (self) % (value)
		---@field protected __pow (fun(self: object, other: any) : any) | nil (self) ^ (value)
		---@field protected __idiv (fun(self: object, other: any) : any) | nil (self) // (value)
		---@field protected __band (fun(self: object, other: any) : any) | nil (self) & (value)
		---@field protected __bor (fun(self: object, other: any) : any) | nil (self) | (value)
		---@field protected __bxor (fun(self: object, other: any) : any) | nil (self) ~ (value)
		---@field protected __shl (fun(self: object, other: any) : any) | nil (self) << (value)
		---@field protected __shr (fun(self: object, other: any) : any) | nil (self) >> (value)
		---@field protected __concat (fun(self: object, other: any) : any) | nil (self) .. (value)
		---@field protected __eq (fun(self: object, other: any) : any) | nil (self) == (value)
		---@field protected __lt (fun(t1: any, t2: any) : any) | nil (self) < (value)
		---@field protected __le (fun(t1: any, t2: any) : any) | nil (self) <= (value)
		---@field protected __unm (fun(self: object) : any) | nil -(self)
		---@field protected __bnot (fun(self: object) : any) | nil  ~(self)
		---@field protected __len (fun(self: object) : any) | nil #(self)
		---@field protected __pairs (fun(t: table) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any)) | nil pairs(self)
		---@field protected __ipairs (fun(t: table) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number)) | nil ipairs(self)
		---@field protected __tostring (fun(t):string) | nil tostring(self)
		---@field protected __index (fun(class, key) : any) | nil xxx = self.xxx | self[xxx]
		---@field protected __newindex fun(class, key, value) | nil self.xxx = xxx | self[xxx] = xxx

		---@class object : class-system.object-meta-methods, function

		---@class class-system.meta-methods
		---@field __gc fun(self: object) | nil class-system.Deconstruct(self) or garbageCollection
		---@field __close (fun(self: object, errObj: any) : any) | nil invoked when the object gets out of scope
		---@field __call (fun(self: object, ...) : ...) | nil self(...) after construction
		---@field __index (fun(class: object, key: any) : any) | nil xxx = self.xxx | self[xxx]
		---@field __newindex fun(class: object, key: any, value: any) | nil self.xxx | self[xxx] = xxx
		---@field __tostring (fun(t):string) | nil tostring(self)
		---@field __add (fun(left: any, right: any) : any) | nil (left) + (right)
		---@field __sub (fun(left: any, right: any) : any) | nil (left) - (right)
		---@field __mul (fun(left: any, right: any) : any) | nil (left) * (right)
		---@field __div (fun(left: any, right: any) : any) | nil (left) / (right)
		---@field __mod (fun(left: any, right: any) : any) | nil (left) % (right)
		---@field __pow (fun(left: any, right: any) : any) | nil (left) ^ (right)
		---@field __idiv (fun(left: any, right: any) : any) | nil (left) // (right)
		---@field __band (fun(left: any, right: any) : any) | nil (left) & (right)
		---@field __bor (fun(left: any, right: any) : any) | nil (left) | (right)
		---@field __bxor (fun(left: any, right: any) : any) | nil (left) ~ (right)
		---@field __shl (fun(left: any, right: any) : any) | nil (left) << (right)
		---@field __shr (fun(left: any, right: any) : any) | nil (left) >> (right)
		---@field __concat (fun(left: any, right: any) : any) | nil (left) .. (right)
		---@field __eq (fun(left: any, right: any) : any) | nil (left) == (right)
		---@field __lt (fun(left: any, right: any) : any) | nil (left) < (right)
		---@field __le (fun(left: any, right: any) : any) | nil (left) <= (right)
		---@field __unm (fun(self: object) : any) | nil -(self)
		---@field __bnot (fun(self: object) : any) | nil ~(self)
		---@field __len (fun(self: object) : any) | nil #(self)
		---@field __pairs (fun(self: object) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any)) | nil pairs(self)
		---@field __ipairs (fun(self: object) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number)) | nil ipairs(self)

		---@class class-system.type-meta-methods : class-system.meta-methods
		---@field __preinit (fun(...) : any) | nil self(...) before constructor
		---@field __init (fun(self: object, ...)) | nil self(...) constructor

		----------------------------------------------------------------
		-- Type
		----------------------------------------------------------------

		---@class class-system.type
		---@field name string
		---
		---@field base class-system.type | nil
		---@field interfaces table<integer, class-system.type>
		---
		---@field static table<string, any>
		---
		---@field meta_methods class-system.type-meta-methods
		---@field members table<any, any>
		---
		---@field has_pre_constructor boolean
		---@field has_constructor boolean
		---@field has_deconstructor boolean
		---@field has_close boolean
		---@field has_index boolean
		---@field has_new_index boolean
		---
		---@field options class-system.type.options
		---
		---@field instances table<object, boolean>
		---
		---@field blueprint table | nil

		---@class class-system.type.options
		---@field is_abstract boolean | nil
		---@field is_interface boolean | nil

		----------------------------------------------------------------
		-- Metatable
		----------------------------------------------------------------

		---@class class-system.metatable : class-system.meta-methods
		---@field type class-system.type
		---@field instance class-system.instance

		----------------------------------------------------------------
		-- Blueprint
		----------------------------------------------------------------

		---@class class-system.blueprint-metatable : class-system.meta-methods
		---@field type class-system.type

		----------------------------------------------------------------
		-- Instance
		----------------------------------------------------------------

		---@class class-system.instance
		---@field is_constructed boolean
		---
		---@field custom_indexing boolean

		----------------------------------------------------------------
		-- Create Options
		----------------------------------------------------------------

		---@class class-system.create.options : class-system.type.options
		---@field name string | nil
		---
		---@field inherit object[] | object | nil

		---@class class-system.create.options.class.pretty
		---@field is_abstract boolean | nil
		---
		---@field inherit any | any[]

		---@class class-system.create.options.interface.pretty
		---@field inherit any | any[]

	end

	__bundler__.__files__["tools.utils"] = function()
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
			---@generic R
			---@param t T[]
			---@param func fun(index: integer, value: T) : R
			---@return R[]
			function array.select(t, func)
			    local copy = {}
			    for index, value in pairs(t) do
			        copy[index] = func(index, value)
			    end
			    return copy
			end

			---@generic T
			---@generic R
			---@param t T[]
			---@param func fun(index: integer, value: T) : R
			---@return R[]
			function array.select_implace(t, func)
			    for index, value in pairs(t) do
			        local new_value = func(index, value)
			        t[index] = nil
			        if new_value then
			            insert_first_nil(t, new_value)
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
			---@param max number
			---@return number
			function _value.clamp(value, min, max)
			    if value < min then
			        return min
			    end
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
		local main = { __bundler__.__main__() }
		return table.unpack(main)

	end

	__bundler__.__files__["src.class"] = function()
		---@class class-system
		local class = {}

		---@param obj any
		---@return class-system.type | nil
		function class.typeof(obj)
		    if not type(obj) == "table" then
		        return nil
		    end

		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)
		    if not metatable then
		        return nil
		    end

		    return metatable.type
		end

		---@param obj any
		---@return string
		function class.nameof(obj)
		    local type_info = class.typeof(obj)
		    if not type_info then
		        return type(obj)
		    end

		    return type_info.name
		end

		---@param obj object
		---@return class-system.instance | nil
		function class.get_instance_data(obj)
		    if not class.is_class(obj) then
		        return
		    end

		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)
		    return metatable.instance
		end

		---@param obj any
		---@return boolean isClass
		function class.is_class(obj)
		    if type(obj) ~= "table" then
		        return false
		    end

		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)

		    if not metatable then
		        return false
		    end

		    if not metatable.type then
		        return false
		    end

		    if not metatable.type.name then
		        return false
		    end

		    return true
		end

		---@param obj any
		---@param className string
		---@return boolean hasBaseClass
		function class.has_base(obj, className)
		    if not class.is_class(obj) then
		        return false
		    end

		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)

		    ---@param type_info class-system.type
		    local function hasBase(type_info)
		        local typeName = type_info.name
		        if typeName == className then
		            return true
		        end

		        if not type_info.base then
		            return false
		        end

		        return hasBase(type_info.base)
		    end

		    return hasBase(metatable.type)
		end

		---@param obj any
		---@param interfaceName string
		---@return boolean hasInterface
		function class.has_interface(obj, interfaceName)
		    if not class.is_class(obj) then
		        return false
		    end

		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)

		    ---@param type_info class-system.type
		    local function hasInterface(type_info)
		        local typeName = type_info.name
		        if typeName == interfaceName then
		            return true
		        end

		        for _, value in pairs(type_info.interfaces) do
		            if hasInterface(value) then
		                return true
		            end
		        end

		        return false
		    end

		    return hasInterface(metatable.type)
		end

		return class

	end

	__bundler__.__files__["src.object"] = function()
		local utils = __bundler__.__loadFile__("tools.utils")
		local config = __bundler__.__loadFile__("src.config")
		local class = __bundler__.__loadFile__("src.class")

		---@class object
		local object = {}

		---@protected
		---@return string typeName
		function object:__tostring()
		    return class.typeof(self).name
		end

		---@protected
		---@return string
		function object.__concat(left, right)
		    return tostring(left) .. tostring(right)
		end

		---@class class-system.object.modify
		---@field custom_indexing boolean | nil

		---@protected
		---@param func fun(modify: class-system.object.modify)
		function object:raw__modify_behavior(func)
		    ---@type class-system.metatable
		    local metatable = getmetatable(self)

		    local modify = {
		        custom_indexing = metatable.instance.custom_indexing
		    }

		    func(modify)

		    metatable.instance.custom_indexing = modify.custom_indexing
		end

		----------------------------------------
		-- Type Info
		----------------------------------------

		---@type class-system.type
		local object_type_info = {
		    name = "object",
		    base = nil,
		    interfaces = {},

		    static = {},
		    meta_methods = {},
		    members = {},

		    has_pre_constructor = false,
		    has_constructor = false,
		    has_deconstructor = false,
		    has_close = false,
		    has_index = false,
		    has_new_index = false,

		    options = {
		        is_abstract = true,
		    },

		    instances = setmetatable({}, { __mode = 'k' }),

		    -- no blueprint since cannot be constructed
		    blueprint = nil
		}

		for key, value in pairs(object) do
		    if config.all_meta_methods[key] then
		        object_type_info.meta_methods[key] = value
		    else
		        if type(key) == 'string' then
		            local splittedKey = utils.string.split(key, '__')
		            if utils.table.contains(splittedKey, 'Static') then
		                object_type_info.static[key] = value
		            else
		                object_type_info.members[key] = value
		            end
		        else
		            object_type_info.members[key] = value
		        end
		    end
		end

		setmetatable(
		        object_type_info,
		        {
		            __tostring = function(self)
		                return self.Name
		            end
		        }
		    )

		return object_type_info

	end

	__bundler__.__files__["src.type"] = function()
		---@class class-system.type_handler
		local type_handler = {}

		---@param base class-system.type | nil
		---@param interfaces table<class-system.type>
		---@param options class-system.create.options
		function type_handler.create(base, interfaces, options)
		    local type_info = {
		        name = options.name,
		        base = base,
		        interfaces = interfaces,

		        options = options,

		        meta_methods = {},
		        members = {},
		        static = {},

		        instances = setmetatable({}, { __mode = "k" }),
		    }

		    options.name = nil
		    options.inherit = nil
		    ---@cast type_info class-system.type

		    setmetatable(
		        type_info,
		        {
		            __tostring = function(self)
		                return self.Name
		            end
		        }
		    )

		    return type_info
		end

		return type_handler

	end

	__bundler__.__files__["src.instance"] = function()
		local utils = __bundler__.__loadFile__("tools.utils")

		---@class class-system.instance_handler
		local instance_handler = {}

		---@param instance class-system.instance
		function instance_handler.initialize(instance)
		    instance.custom_indexing = true
		    instance.is_constructed = false
		end

		---@param type_info class-system.type
		---@param instance object
		function instance_handler.add(type_info, instance)
		    type_info.instances[instance] = true

		    if type_info.base then
		        instance_handler.add(type_info.base, instance)
		    end

		    for _, parent in pairs(type_info.interfaces) do
		        instance_handler.add(parent, instance)
		    end
		end

		---@param type_info class-system.type
		---@param instance object
		function instance_handler.remove(type_info, instance)
		    type_info.instances[instance] = nil

		    if type_info.base then
		        instance_handler.remove(type_info.base, instance)
		    end

		    for _, parent in pairs(type_info.interfaces) do
		        instance_handler.remove(parent, instance)
		    end
		end

		---@param type_info class-system.type
		---@param name string
		---@param func function
		function instance_handler.update_meta_method(type_info, name, func)
		    type_info.meta_methods[name] = func

		    for instance in pairs(type_info.instances) do
		        local instanceMetatable = getmetatable(instance)

		        if not utils.table.contains_key(instanceMetatable, name) then
		            instanceMetatable[name] = func
		        end
		    end
		end

		---@param type_info class-system.type
		---@param key any
		---@param value any
		function instance_handler.update_member(type_info, key, value)
		    type_info.members[key] = value

		    for instance in pairs(type_info.instances) do
		        if not utils.table.contains_key(instance, key) then
		            rawset(instance, key, value)
		        end
		    end
		end

		return instance_handler

	end

	__bundler__.__files__["src.members"] = function()
		local utils = __bundler__.__loadFile__("tools.utils")

		local config = __bundler__.__loadFile__("src.config")

		local instance_handler = __bundler__.__loadFile__("src.instance")

		---@class class-system.members_handler
		local members_handler = {}

		---@param type_info class-system.type
		function members_handler.update_state(type_info)
		    local metaMethods = type_info.meta_methods

		    type_info.has_constructor = metaMethods.__init ~= nil
		    type_info.has_deconstructor = metaMethods.__gc ~= nil
		    type_info.has_close = metaMethods.__close ~= nil
		    type_info.has_index = metaMethods.__index ~= nil
		    type_info.has_new_index = metaMethods.__newindex ~= nil
		end

		---@param type_info class-system.type
		---@param key string
		function members_handler.get_static(type_info, key)
		    return rawget(type_info.static, key)
		end

		---@param type_info class-system.type
		---@param key string
		---@param value any
		---@return boolean wasFound
		local function assign_static(type_info, key, value)
		    if rawget(type_info.static, key) ~= nil then
		        rawset(type_info.static, key, value)
		        return true
		    end

		    if type_info.base then
		        return assign_static(type_info.base, key, value)
		    end

		    return false
		end

		---@param type_info class-system.type
		---@param key string
		---@param value any
		function members_handler.set_static(type_info, key, value)
		    if not assign_static(type_info, key, value) then
		        rawset(type_info.static, key, value)
		    end
		end

		-------------------------------------------------------------------------------
		-- Index & NewIndex
		-------------------------------------------------------------------------------

		---@param type_info class-system.type
		---@return fun(obj: object, key: any) : any value
		function members_handler.template_index(type_info)
		    return function(obj, key)
		        if type(key) ~= "string" then
		            error("can only use static members in template")
		            return {}
		        end
		        ---@cast key string

		        local splittedKey = utils.string.split(key:lower(), "__")
		        if utils.table.contains(splittedKey, "static") then
		            return members_handler.get_static(type_info, key)
		        end

		        error("can only use static members in template")
		    end
		end

		---@param type_info class-system.type
		---@return fun(obj: object, key: any, value: any)
		function members_handler.template_new_index(type_info)
		    return function(obj, key, value)
		        if type(key) ~= "string" then
		            error("can only use static members in template")
		            return
		        end
		        ---@cast key string

		        local splittedKey = utils.string.split(key:lower(), "__")
		        if utils.table.contains(splittedKey, "static") then
		            members_handler.set_static(type_info, key, value)
		            return
		        end

		        error("can only use static members in template")
		    end
		end

		---@param instance class-system.instance
		---@param type_info class-system.type
		---@return fun(obj: object, key: any) : any value
		function members_handler.instance_index(instance, type_info)
		    return function(obj, key)
		        if type(key) == "string" then
		            ---@cast key string
		            local splittedKey = utils.string.split(key:lower(), "__")
		            if utils.table.contains(splittedKey, "static") then
		                return members_handler.get_static(type_info, key)
		            elseif utils.table.contains(splittedKey, "raw") then
		                return rawget(obj, key)
		            end
		        end

		        if type_info.has_index and instance.custom_indexing then
		            return type_info.meta_methods.__index(obj, key)
		        end

		        return rawget(obj, key)
		    end
		end

		---@param instance class-system.instance
		---@param type_info class-system.type
		---@return fun(obj: object, key: any, value: any)
		function members_handler.instance_new_index(instance, type_info)
		    return function(obj, key, value)
		        if type(key) == "string" then
		            ---@cast key string
		            local splittedKey = utils.string.split(key:lower(), "__")
		            if utils.table.contains(splittedKey, "static") then
		                return members_handler.set_static(type_info, key, value)
		            elseif utils.table.contains(splittedKey, "raw") then
		                rawset(obj, key, value)
		            end
		        end

		        if type_info.has_new_index and instance.custom_indexing then
		            return type_info.meta_methods.__newindex(obj, key, value)
		        end

		        rawset(obj, key, value)
		    end
		end

		-------------------------------------------------------------------------------
		-- Sort
		-------------------------------------------------------------------------------

		---@param type_info class-system.type
		---@param name string
		---@param func function
		local function is_normal_function(type_info, name, func)
		    if utils.table.contains_key(config.all_meta_methods, name) then
		        type_info.meta_methods[name] = func
		        return
		    end

		    type_info.members[name] = func
		end

		---@param type_info class-system.type
		---@param name string
		---@param value any
		local function is_normal_member(type_info, name, value)
		    if type(value) == 'function' then
		        is_normal_function(type_info, name, value)
		        return
		    end

		    type_info.members[name] = value
		end

		---@param type_info class-system.type
		---@param name string
		---@param value any
		local function is_static_member(type_info, name, value)
		    type_info.static[name] = value
		end

		---@param type_info class-system.type
		---@param key any
		---@param value any
		local function sort_member(type_info, key, value)
		    if type(key) == 'string' then
		        ---@cast key string

		        local splittedKey = utils.string.split(key:lower(), '__')
		        if utils.table.contains(splittedKey, 'static') then
		            is_static_member(type_info, key, value)
		            return
		        end

		        is_normal_member(type_info, key, value)
		        return
		    end

		    type_info.members[key] = value
		end

		function members_handler.sort(data, type_info)
		    for key, value in pairs(data) do
		        sort_member(type_info, key, value)
		    end

		    members_handler.update_state(type_info)
		end

		-------------------------------------------------------------------------------
		-- Extend
		-------------------------------------------------------------------------------

		---@param type_info class-system.type
		---@param name string
		---@param func function
		local function update_methods(type_info, name, func)
		    if utils.table.contains_key(type_info.members, name) then
		        error("trying to extend already existing meta method: " .. name)
		    end

		    instance_handler.update_meta_method(type_info, name, func)
		end

		---@param type_info class-system.type
		---@param key any
		---@param value any
		local function update_member(type_info, key, value)
		    if utils.table.contains_key(type_info.members, key) then
		        error("trying to extend already existing member: " .. tostring(key))
		    end

		    instance_handler.update_member(type_info, key, value)
		end

		---@param type_info class-system.type
		---@param name string
		---@param value any
		local function extend_is_static_member(type_info, name, value)
		    if utils.table.contains_key(type_info.static, name) then
		        error("trying to extend already existing static member: " .. name)
		    end

		    type_info.static[name] = value
		end

		---@param type_info class-system.type
		---@param name string
		---@param func function
		local function extend_is_normal_function(type_info, name, func)
		    if utils.table.contains_key(config.all_meta_methods, name) then
		        update_methods(type_info, name, func)
		    end

		    update_member(type_info, name, func)
		end

		---@param type_info class-system.type
		---@param name string
		---@param value any
		local function extend_is_normal_member(type_info, name, value)
		    if type(value) == 'function' then
		        extend_is_normal_function(type_info, name, value)
		        return
		    end

		    update_member(type_info, name, value)
		end

		---@param type_info class-system.type
		---@param key any
		---@param value any
		local function extend_member(type_info, key, value)
		    if type(key) == 'string' then
		        local splittedKey = utils.string.split(key, '__')
		        if utils.table.contains(splittedKey, 'Static') then
		            extend_is_static_member(type_info, key, value)
		            return
		        end

		        extend_is_normal_member(type_info, key, value)
		        return
		    end

		    if not utils.table.contains_key(type_info.members, key) then
		        type_info.members[key] = value
		    end
		end

		---@param data table
		---@param type_info class-system.type
		function members_handler.extend(type_info, data)
		    for key, value in pairs(data) do
		        extend_member(type_info, key, value)
		    end

		    members_handler.update_state(type_info)
		end

		-------------------------------------------------------------------------------
		-- Check
		-------------------------------------------------------------------------------

		---@private
		---@param baseInfo class-system.type
		---@param member string
		---@return boolean
		function members_handler.check_for_meta_method(baseInfo, member)
		    if utils.table.contains_key(baseInfo.meta_methods, member) then
		        return true
		    end

		    if baseInfo.base then
		        return members_handler.check_for_meta_method(baseInfo.base, member)
		    end

		    return false
		end

		---@private
		---@param type_info class-system.type
		---@param member string
		---@return boolean
		function members_handler.check_for_member(type_info, member)
		    if utils.table.contains_key(type_info.members, member)
		        and type_info.members[member] ~= config.abstract_placeholder
		        and type_info.members[member] ~= config.interface_placeholder then
		        return true
		    end

		    if type_info.base then
		        return members_handler.check_for_member(type_info.base, member)
		    end

		    return false
		end

		---@private
		---@param type_info class-system.type
		---@param type_infoToCheck class-system.type
		function members_handler.check_abstract(type_info, type_infoToCheck)
		    for key, value in pairs(type_info.meta_methods) do
		        if value == config.abstract_placeholder then
		            if not members_handler.check_for_meta_method(type_infoToCheck, key) then
		                error(
		                    type_infoToCheck.name
		                    .. " does not implement inherited abstract meta method: "
		                    .. type_info.name .. "." .. tostring(key)
		                )
		            end
		        end
		    end

		    for key, value in pairs(type_info.members) do
		        if value == config.abstract_placeholder then
		            if not members_handler.check_for_member(type_infoToCheck, key) then
		                error(
		                    type_infoToCheck.name
		                    .. " does not implement inherited abstract member: "
		                    .. type_info.name .. "." .. tostring(key)
		                )
		            end
		        end
		    end

		    if type_info.base and type_info.base.options.is_abstract then
		        members_handler.check_abstract(type_info.base, type_infoToCheck)
		    end
		end

		---@private
		---@param type_info class-system.type
		---@param type_infoToCheck class-system.type
		function members_handler.check_interfaces(type_info, type_infoToCheck)
		    for _, interface in pairs(type_info.interfaces) do
		        for key, value in pairs(interface.meta_methods) do
		            if value == config.interface_placeholder then
		                if not members_handler.check_for_meta_method(type_infoToCheck, key) then
		                    error(
		                        type_infoToCheck.name
		                        .. " does not implement inherited interface meta method: "
		                        .. interface.name .. "." .. tostring(key)
		                    )
		                end
		            end
		        end

		        for key, value in pairs(interface.members) do
		            if value == config.interface_placeholder then
		                if not members_handler.check_for_member(type_infoToCheck, key) then
		                    error(
		                        type_infoToCheck.name
		                        .. " does not implement inherited interface member: "
		                        .. interface.name .. "." .. tostring(key)
		                    )
		                end
		            end
		        end
		    end

		    if type_info.base then
		        members_handler.check_interfaces(type_info.base, type_infoToCheck)
		    end
		end

		---@param type_info class-system.type
		function members_handler.check(type_info)
		    if not type_info.options.is_abstract then
		        if utils.table.contains(type_info.meta_methods, config.abstract_placeholder) then
		            error(type_info.name .. " has abstract meta method/s but is not marked as abstract")
		        end

		        if utils.table.contains(type_info.members, config.abstract_placeholder) then
		            error(type_info.name .. " has abstract member/s but is not marked as abstract")
		        end
		    end

		    if not type_info.options.is_interface then
		        if utils.table.contains(type_info.members, config.interface_placeholder) then
		            error(type_info.name .. " has interface meta methods/s but is not marked as interface")
		        end

		        if utils.table.contains(type_info.members, config.interface_placeholder) then
		            error(type_info.name .. " has interface member/s but is not marked as interface")
		        end
		    end

		    if not type_info.options.is_abstract and not type_info.options.is_interface then
		        members_handler.check_interfaces(type_info, type_info)

		        if type_info.base and type_info.base.options.is_abstract then
		            members_handler.check_abstract(type_info.base, type_info)
		        end
		    end
		end

		return members_handler

	end

	__bundler__.__files__["src.metatable"] = function()
		local utils = __bundler__.__loadFile__("tools.utils")

		local config = __bundler__.__loadFile__("src.config")

		local members_handler = __bundler__.__loadFile__("src.members")

		---@class class-system.metatable_handler
		local metatable_handler = {}

		---@param type_info class-system.type
		---@return class-system.blueprint-metatable metatable
		function metatable_handler.create_template_metatable(type_info)
		    ---@type class-system.blueprint-metatable
		    local metatable = { type = type_info }

		    metatable.__index = members_handler.template_index(type_info)
		    metatable.__newindex = members_handler.template_new_index(type_info)

		    for key in pairs(config.block_meta_methods_on_blueprint) do
		        local function blockMetaMethod()
		            error("cannot use meta method: " .. key .. " on a template from a class")
		        end
		        ---@diagnostic disable-next-line: assign-type-mismatch
		        metatable[key] = blockMetaMethod
		    end

		    metatable.__tostring = function()
		        return type_info.name .. ".__blueprint__"
		    end

		    return metatable
		end

		---@param type_info class-system.type
		---@param instance class-system.instance
		---@param metatable class-system.metatable
		function metatable_handler.create(type_info, instance, metatable)
		    metatable.type = type_info

		    metatable.__index = members_handler.instance_index(instance, type_info)
		    metatable.__newindex = members_handler.instance_new_index(instance, type_info)

		    for key, _ in pairs(config.block_meta_methods_on_instance) do
		        if not utils.table.contains_key(type_info.meta_methods, key) then
		            local function blockMetaMethod()
		                error("cannot use meta method: " .. key .. " on class: " .. type_info.name)
		            end
		            metatable[key] = blockMetaMethod
		        end
		    end
		end

		return metatable_handler

	end

	__bundler__.__files__["src.construction"] = function()
		local utils = __bundler__.__loadFile__("tools.utils")

		local config = __bundler__.__loadFile__("src.config")

		local instance_handler = __bundler__.__loadFile__("src.instance")
		local metatable_handler = __bundler__.__loadFile__("src.metatable")

		---@class class-system.construction_handler
		local construction_handler = {}

		---@param obj object
		---@return class-system.instance instance
		local function construct(obj, ...)
		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)
		    local type_info = metatable.type

		    if type_info.options.is_abstract then
		        error("cannot construct abstract class: " .. type_info.name)
		    end
		    if type_info.options.is_interface then
		        error("cannot construct interface class: " .. type_info.name)
		    end

		    if type_info.has_pre_constructor then
		        local result = type_info.meta_methods.__preinit(...)
		        if result ~= nil then
		            return result
		        end
		    end

		    local class_instance, class_metatable = {}, {}
		    ---@cast class_instance class-system.instance
		    ---@cast class_metatable class-system.metatable
		    class_metatable.instance = class_instance
		    local instance = setmetatable({}, class_metatable)

		    instance_handler.initialize(class_instance)
		    metatable_handler.create(type_info, class_instance, class_metatable)
		    construction_handler.construct(type_info, instance, class_instance, class_metatable, ...)

		    instance_handler.add(type_info, instance)

		    return instance
		end

		---@param data table
		---@param type_info class-system.type
		function construction_handler.create_template(data, type_info)
		    local metatable = metatable_handler.create_template_metatable(type_info)
		    metatable.__call = construct

		    setmetatable(data, metatable)

		    if not type_info.options.is_abstract and not type_info.options.is_interface then
		        type_info.blueprint = data
		    end
		end

		---@param type_info class-system.type
		---@param class table
		local function invoke_deconstructor(type_info, class)
		    if type_info.has_close then
		        type_info.meta_methods.__close(class, config.deconstructing)
		    end
		    if type_info.has_deconstructor then
		        type_info.meta_methods.__gc(class)

		        if type_info.base then
		            invoke_deconstructor(type_info.base, class)
		        end
		    end
		end

		---@param type_info class-system.type
		---@param obj object
		---@param instance class-system.instance
		---@param metatable class-system.metatable
		---@param ... any
		function construction_handler.construct(type_info, obj, instance, metatable, ...)
		    ---@type function
		    local super = nil

		    local function constructMembers()
		        for key, value in pairs(type_info.meta_methods) do
		            if not utils.table.contains_key(config.indirect_meta_methods, key) and not utils.table.contains_key(metatable, key) then
		                metatable[key] = value
		            end
		        end

		        for key, value in pairs(type_info.members) do
		            if obj[key] == nil then
		                rawset(obj, key, utils.value.copy(value))
		            end
		        end

		        for _, interface in pairs(type_info.interfaces) do
		            for key, value in pairs(interface.meta_methods) do
		                if not utils.table.contains_key(config.indirect_meta_methods, key) and not utils.table.contains_key(metatable, key) then
		                    metatable[key] = value
		                end
		            end

		            for key, value in pairs(interface.members) do
		                if not utils.table.contains_key(obj, key) then
		                    obj[key] = value
		                end
		            end
		        end

		        metatable.__gc = function(class)
		            invoke_deconstructor(type_info, class)
		        end

		        setmetatable(obj, metatable)
		    end

		    local base_constructed = false
		    if type_info.base then
		        if type_info.base.has_constructor then
		            function super(...)
		                constructMembers()
		                construction_handler.construct(type_info.base, obj, instance, metatable, ...)
		                base_constructed = true
		                return obj
		            end
		        else
		            constructMembers()
		            construction_handler.construct(type_info.base, obj, instance, metatable)
					base_constructed = true
		        end
		    else
				base_constructed = true
		        constructMembers()
		    end

		    if type_info.has_constructor then
		        if super then
		            type_info.meta_methods.__init(obj, super, ...)
		        else
		            type_info.meta_methods.__init(obj, ...)
		        end
		    end

		    if not base_constructed then
		        error("'" .. type_info.name ..  "' constructor did not invoke '" .. type_info.base.name .. "' (base) constructor")
		    end

		    instance.is_constructed = true
		end

		---@param obj object
		---@param metatable class-system.metatable
		---@param type_info class-system.type
		function construction_handler.deconstruct(obj, metatable, type_info)
		    instance_handler.remove(type_info, obj)
		    invoke_deconstructor(type_info, obj)

		    utils.table.clear(obj)
		    utils.table.clear(metatable)

		    local function blockedNewIndex()
		        error("cannot assign values to deconstruct class: " .. type_info.name, 2)
		    end
		    metatable.__newindex = blockedNewIndex

		    local function blockedIndex()
		        error("cannot get values from deconstruct class: " .. type_info.name, 2)
		    end
		    metatable.__index = blockedIndex

		    setmetatable(obj, metatable)
		end

		return construction_handler

	end

	__bundler__.__files__["__main__"] = function()
		-- required at top to be at the top of the bundled file
		local configs = __bundler__.__loadFile__("src.config")

		-- to package meta in the bundled file
		__bundler__.__loadFile__("src.meta")

		local utils = __bundler__.__loadFile__("tools.utils")

		local class = __bundler__.__loadFile__("src.class")
		local object_type = __bundler__.__loadFile__("src.object")
		local type_handler = __bundler__.__loadFile__("src.type")
		local members_handler = __bundler__.__loadFile__("src.members")
		local construction_handler = __bundler__.__loadFile__("src.construction")

		---@class class-system
		local class_system = {}

		class_system.deconstructing = configs.deconstructing
		class_system.is_abstract = configs.abstract_placeholder
		class_system.is_interface = configs.interface_placeholder

		class_system.object_type = object_type

		class_system.typeof = class.typeof
		class_system.nameof = class.nameof
		class_system.get_instance_data = class.get_instance_data
		class_system.is_class = class.is_class
		class_system.has_base = class.has_base
		class_system.has_interface = class.has_interface

		---@param options class-system.create.options
		---@return class-system.type | nil base, table<class-system.type> interfaces
		local function process_options(options)
		    if type(options.name) ~= "string" then
		        error("name needs to be a string")
		    end

		    options.is_abstract = options.is_abstract or false
		    options.is_interface = options.is_interface or false

		    if options.is_abstract and options.is_interface then
		        error("cannot mark class as interface and abstract class")
		    end

		    if options.inherit then
		        if class_system.is_class(options.inherit) then
		            options.inherit = { options.inherit }
		        end
		    else
		        -- could also return here
		        options.inherit = {}
		    end

		    ---@type class-system.type, table<class-system.type>
		    local base, interfaces = nil, {}
		    for i, parent in ipairs(options.inherit) do
		        local parentType = class_system.typeof(parent)
		        ---@cast parentType class-system.type

		        if options.is_abstract and (not parentType.options.is_abstract and not parentType.options.is_interface) then
		            error("cannot inherit from not abstract or interface class: ".. tostring(parent) .." in an abstract class: " .. options.name)
		        end

		        if parentType.options.is_interface then
		            interfaces[i] = class_system.typeof(parent)
		        else
		            if base ~= nil then
		                error("cannot inherit from more than one (abstract) class: " .. tostring(parent) .. " in class: " .. options.name)
		            end

		            base = parentType
		        end
		    end

		    if not options.is_interface and not base then
		        base = object_type
		    end

		    return base, interfaces
		end

		---@generic TClass
		---@param data TClass
		---@param options class-system.create.options
		---@return TClass
		function class_system.create(data, options)
		    options = options or {}
		    local base, interfaces = process_options(options)

		    local type_info = type_handler.create(base, interfaces, options)

		    members_handler.sort(data, type_info)
		    members_handler.check(type_info)

		    utils.table.clear(data)

		    construction_handler.create_template(data, type_info)

		    return data
		end

		---@generic TClass
		---@param class TClass
		---@param extensions TClass
		---@return TClass
		function class_system.extend(class, extensions)
		    if not class_system.is_class(class) then
		        error("provided class is not an class")
		    end

		    ---@type class-system.metatable
		    local metatable = getmetatable(class)
		    local type_info = metatable.type

		    members_handler.extend(type_info, extensions)

		    return class
		end

		---@param obj object
		function class_system.deconstruct(obj)
		    ---@type class-system.metatable
		    local metatable = getmetatable(obj)
		    local type_info = metatable.type

		    construction_handler.deconstruct(obj, metatable, type_info)
		end

		---@generic TClass : object
		---@param name string
		---@param table TClass
		---@param options class-system.create.options.class.pretty | nil
		---@return TClass
		function _G.class(name, table, options)
		    options = options or {}

		    ---@type class-system.create.options
		    local createOptions = {}
		    createOptions.name = name
		    createOptions.is_abstract = options.is_abstract
		    createOptions.inherit = options.inherit

		    return class_system.create(table, createOptions)
		end

		---@generic TInterface
		---@param name string
		---@param table TInterface
		---@param options class-system.create.options.interface.pretty | nil
		---@return TInterface
		function _G.interface(name, table, options)
		    options = options or {}

		    ---@type class-system.create.options
		    local createOptions = {}
		    createOptions.name = name
		    createOptions.is_interface = true
		    createOptions.inherit = options.inherit

		    return class_system.create(table, createOptions)
		end

		_G.typeof = class_system.typeof
		_G.nameof = class_system.nameof

		return class_system

	end

	---@type { [1]: class-system }
	local main = { __bundler__.__main__() }
	return table.unpack(main)

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

		function _string_builder:clear()
		    self.m_cache = {}
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
		local _table = __bundler__.__loadFile__("src.utils.table")

		---@class Freemaker.utils.stopwatch.lap
		---@field time_sec number
		---@field abs_time_sec number

		---@class Freemaker.utils.stopwatch
		---@field private m_running boolean
		---
		---@field private m_start_time_sec number
		---@field private m_end_time_sec number
		---@field private m_elapesd_milliseconds integer
		---
		---@field private m_laps Freemaker.utils.stopwatch.lap[]
		---@field private m_laps_count integer
		local _stopwatch = {}

		---@return Freemaker.utils.stopwatch
		function _stopwatch.new()
		    return setmetatable({
		        m_running = false,

		        m_start_time_sec = 0,
		        m_end_time_sec = 0,
		        m_elapesd_milliseconds = 0,

		        m_laps = {},
		        m_laps_count = 0,
		    }, { __index = _stopwatch })
		end

		---@return Freemaker.utils.stopwatch
		function _stopwatch.start_new()
		    local instance = _stopwatch.new()
		    instance:start()
		    return instance
		end

		function _stopwatch:start()
		    if self.m_running then
		        return
		    end

		    self.m_start_time_sec = os.clock()
		    self.m_running = true
		end

		function _stopwatch:stop()
		    if not self.m_running then
		        return
		    end

		    self.m_end_time_sec = os.clock()
		    local elapesd_time = self.m_end_time_sec - self.m_start_time_sec
		    self.m_running = false

		    self.m_elapesd_milliseconds = _number.round(elapesd_time * 1000)
		end

		---@return integer elapesd_milliseconds
		function _stopwatch:reset()
		    self:stop()
		    self:start()
		    return self.m_elapesd_milliseconds
		end

		---@return integer
		function _stopwatch:get_elapesd_seconds()
		    return _number.round(self.m_elapesd_milliseconds / 1000)
		end

		---@return integer
		function _stopwatch:get_elapesd_milliseconds()
		    return self.m_elapesd_milliseconds
		end

		---@return integer elapesd_milliseconds
		function _stopwatch:lap()
		    if not self.m_running then
		        return 0
		    end

		    local lap_time = os.clock()

		    local previous_lap
		    if self.m_laps[1] then
		        previous_lap = self.m_laps[self.m_laps_count].abs_time_sec
		    else
		        previous_lap = self.m_start_time_sec
		    end
		    local elapesd_time = lap_time - previous_lap

		    self.m_laps_count = self.m_laps_count + 1
		    self.m_laps[self.m_laps_count] = { time_sec = elapesd_time, abs_time_sec = lap_time }

		    return _number.round(elapesd_time * 1000)
		end

		---@return integer elapesd_milliseconds
		function _stopwatch:avg_lap()
		    if not self.m_running then
		        return 0
		    end

		    self:lap()

		    local sum = 0
		    for _, lap_time in ipairs(self.m_laps) do
		        sum = sum + lap_time.time_sec
		    end

		    return sum / self.m_laps_count
		end

		---@return Freemaker.utils.stopwatch.lap[]
		---@return integer count
		function _stopwatch:get_laps()
		    return _table.copy(self.m_laps), self.m_laps_count
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

__bundler__.__files__["src.misc.maketermfunc"] = function()
	local sformat = string.format

	return function(sequence_fmt)
	    sequence_fmt = '\027[' .. sequence_fmt
	    return function(...)
	        return sformat(sequence_fmt, ...)
	    end
	end

end

__bundler__.__files__["src.misc.erase"] = function()
	local make_term_func = __bundler__.__loadFile__("src.misc.maketermfunc")

	---@class lua-term.erase
	local erase = {
	    ---@type fun() : string
	    till_end = make_term_func("0J"),
	    ---@type fun() : string
	    till_begin = make_term_func("1J"),
	    ---@type fun() : string
	    screen = make_term_func("2J"),
	    ---@type fun() : string
	    saved_lines = make_term_func("3J"),

	    ---@type fun() : string
	    till_eol = make_term_func("0K"),
	    ---@type fun() : string
	    till_bol = make_term_func("1K"),
	    ---@type fun() : string
	    line = make_term_func("2K"),
	}

	return erase

end

__bundler__.__files__["src.misc.cursor"] = function()
	local table_insert = table.insert
	local table_concat = table.concat

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
	    color_code = utils.number.clamp(color_code, 0, 255)
	    return makecolor("38;5;" .. tostring(color_code))
	end
	---@param red integer
	---@param green integer
	---@param blue integer
	ansicolors.foreground_24bit = function(red, green, blue)
	    red = utils.number.clamp(red, 0, 255)
	    green = utils.number.clamp(green, 0, 255)
	    blue = utils.number.clamp(blue, 0, 255)
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
	    color_code = utils.number.clamp(color_code, 0, 255)
	    return makecolor("48;5;" .. tostring(color_code))
	end
	---@param red integer
	---@param green integer
	---@param blue integer
	ansicolors.background_24bit = function(red, green, blue)
	    red = utils.number.clamp(red, 0, 255)
	    green = utils.number.clamp(green, 0, 255)
	    blue = utils.number.clamp(blue, 0, 255)
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

__bundler__.__files__["src.segment.interface"] = function()
	local class_system = __bundler__.__loadFile__("misc.class_system")

	---@class lua-term.segment.single_line_interface : lua-term.segment.interface

	---@class lua-term.segment.interface
	---@field protected m_content_length integer
	local _segment_interface = {}

	---@return string
	function _segment_interface:get_id()
	    ---@diagnostic disable-next-line: missing-return
	end

	_segment_interface.get_id = class_system.is_interface

	---@return integer
	function _segment_interface:get_length()
	    return self.m_content_length or 0
	end

	---@param update boolean | nil
	function _segment_interface:remove(update)
	end

	_segment_interface.remove = class_system.is_interface

	---@return boolean
	function _segment_interface:requested_update()
	    ---@diagnostic disable-next-line: missing-return
	end

	_segment_interface.requested_update = class_system.is_interface

	---@protected
	---@param context lua-term.render_context
	---@return lua-term.render_buffer update_buffer
	---@return integer length
	function _segment_interface:render_impl(context)
	    ---@diagnostic disable-next-line: missing-return
	end

	_segment_interface.render_impl = class_system.is_interface

	---@param context lua-term.render_context
	---@return lua-term.render_buffer update_buffer
	---@return integer length
	function _segment_interface:render(context)
	    local buffer, length = self:render_impl(context)
	    self.m_content_length = length
	    return buffer, length
	end

	return interface("lua-term.segment.interface", _segment_interface)

end

__bundler__.__files__["src.segment.init"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local string_rep = string.rep
	local debug_traceback = debug.traceback

	local _segment_interface = __bundler__.__loadFile__("src.segment.interface")

	---@class lua-term.segment.info
	---@field showing_id boolean
	---@field requested_update boolean
	---
	---@field line integer
	---@field length integer

	---@alias lua-term.segment.func fun(context: lua-term.render_context) : table<integer, string>, integer

	---@class lua-term.segment : object, lua-term.segment.single_line_interface
	---@field id string
	---
	---@field m_requested_update boolean
	---
	---@field private m_content string[]
	---@field private m_content_length integer
	---@field private m_func lua-term.segment.func
	---
	---@field private m_parent lua-term.segment.single_line_parent
	---@overload fun(id: string, parent: lua-term.segment.single_line_parent, func: lua-term.segment.func) : lua-term.segment
	local _segment = {}

	---@alias lua-term.segment.__init fun(id: string, parent: lua-term.segment.single_line_parent, func: lua-term.segment.func)
	---@alias lua-term.segment.__con fun(id: string, parent: lua-term.segment.single_line_parent, func: lua-term.segment.func) : lua-term.segment

	---@deprecated
	---@private
	---@param id string
	---@param parent lua-term.segment.single_line_parent
	---@param func lua-term.segment.func
	function _segment:__init(id, parent, func)
	    self.id = id

	    self.m_requested_update = true

	    self.m_content = {}
	    self.m_content_length = 0
	    self.m_func = func

	    self.m_parent = parent

	    parent:add_child(self)
	end

	---@deprecated
	---@private
	function _segment:__gc()
	    self:remove(true)
	end

	---@param update boolean | nil
	function _segment:remove(update)
	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update()
	    end
	end

	---@param update boolean | nil
	function _segment:changed(update)
	    self.m_requested_update = true

	    if update then
	        self.m_parent:update()
	    end
	end

	-- lua-term.segment_interface

	---@return string
	function _segment:get_id()
	    return self.id
	end

	---@return integer
	function _segment:get_length()
	    return self.m_content_length
	end

	---@return boolean
	function _segment:requested_update()
	    return self.m_requested_update
	end

	---@param render_func lua-term.segment.func
	---@return lua-term.segment.func
	local function create_render_function(render_func)
	    return function(context)
	        local buffer, lines = render_func(context)

	        assert(type(buffer) == "table",
	            "no buffer (string[]) returned from render function (#1 return value)")
	        assert(math.type(lines) == "integer",
	            "no lines count (integer) returned from render function (#2 return value)")

	        return buffer, lines
	    end
	end

	---@return table<integer, string> update_buffer
	---@return integer lines
	function _segment:render_impl(context)
	    if not self.m_requested_update and not context.position_changed then
	        return {}, self.m_content_length
	    end

	    self.m_requested_update = false

	    local pre_render_thread = coroutine.create(create_render_function(self.m_func))
	    ---@type boolean, table<integer, string> | string, integer
	    local success, buffer_or_msg, buffer_length = coroutine.resume(pre_render_thread, context)

	    if not success then
	        buffer_or_msg = utils.string.split(
	            ("%s\nerror rendering segment:\n%s\n%s")
	            :format(
	                string_rep("-", 80),
	                debug_traceback(pre_render_thread, buffer_or_msg),
	                string_rep("-", 80)
	            ),
	            "\n", true)
	        buffer_length = #buffer_or_msg
	    end
	    ---@cast buffer_or_msg -string

	    self.m_content = buffer_or_msg
	    self.m_content_length = buffer_length

	    return utils.table.copy(self.m_content), self.m_content_length
	end

	return class("lua-term.segment", _segment, {
	    inherit = {
	        _segment_interface
	    }
	})

end

__bundler__.__files__["src.components.text"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local table_insert = table.insert
	local table_concat = table.concat

	local _segment = __bundler__.__loadFile__("src.segment.init")

	---@class lua-term.components.text : object, lua-term.segment.interface
	---@field private m_text string[]
	---@field private m_text_length integer
	---@field private m_segment lua-term.segment
	---@overload fun(id: string, parent: lua-term.segment.parent, text: string) : lua-term.components.text
	local _text = {}

	---@alias lua-term.components.text.__init fun(id: string, parent: lua-term.segment.parent, text: string)
	---@alias lua-term.components.text.__con fun(id: string, parent: lua-term.segment.parent, text: string) : lua-term.components.text

	---@deprecated
	---@private
	---@param id string
	---@param parent lua-term.segment.parent
	---@param text string
	function _text:__init(id, parent, text)
	    self.m_text = utils.string.split(text, "\n", true)
	    self.m_text_length = #self.m_text

	    self.m_segment = _segment(id, parent, function()
	        return self.m_text, self.m_text_length
	    end)
	end

	---@param parent lua-term.segment.parent
	---@param ... any
	---@return lua-term.components.text
	function _text.static__print(parent, ...)
	    local items = {}
	    for _, value in ipairs({ ... }) do
	        table_insert(items, tostring(value))
	    end
	    local text = table_concat(items, "\t")

	    ---@diagnostic disable-next-line: param-type-mismatch
	    return _text("<print>", parent, text)
	end

	---@param parent lua-term.segment.single_line_parent
	---@param ... any
	---@return lua-term.components.text
	function _text.static__print_line(parent, ...)
	    local items = {}
	    for _, value in ipairs({ ... }) do
	        table_insert(items, tostring(value))
	    end
	    local text = table_concat(items, "\t")

	    if text:find("\n", nil, true) then
	        error("can not have new line '\\n' in 'static__print_line'. use 'static__print'")
	    end

	    ---@diagnostic disable-next-line: param-type-mismatch
	    return _text("<print>", parent, text)
	end

	---@param update boolean | nil
	function _text:remove(update)
	    return self.m_segment:remove(update)
	end

	---@param text string
	---@param update boolean | nil
	function _text:change(text, update)
	    self.m_text = utils.string.split(text, "\n", true)
	    self.m_text_length = #self.m_text

	    return self.m_segment:changed(update)
	end

	-- lua-term.segment_interface

	---@return string
	function _text:get_id()
	    return self.m_segment:get_id()
	end

	function _text:get_length()
	    return self.m_segment:get_length()
	end

	---@return boolean update_requested
	function _text:requested_update()
	    return _segment:requested_update()
	end

	---@param context lua-term.render_context
	---@return table<integer, string> update_buffer
	---@return integer lines
	function _text:render(context)
	    return self.m_segment:render(context)
	end

	return class("lua-term.components.text", _text)

end

__bundler__.__files__["src.components.loading"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local string_rep = string.rep

	local colors = __bundler__.__loadFile__("third-party.ansicolors")
	local _segment = __bundler__.__loadFile__("src.segment.init")
	local _segment_interface = __bundler__.__loadFile__("src.segment.interface")

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

	---@class lua-term.components.loading : lua-term.segment.single_line_interface, object
	---@field id string
	---
	---@field state integer
	---
	---@field config lua-term.components.loading.config
	---
	---@field private m_segment lua-term.segment
	---@overload fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.loading.config.create) : lua-term.components.loading
	local _loading = {}

	---@alias lua-term.components.loading.__con fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.loading.config.create) : lua-term.components.loading

	---@deprecated
	---@private
	---@param id string
	---@param parent lua-term.segment.single_line_parent
	---@param config lua-term.components.loading.config.create
	function _loading:__init(id, parent, config)
	    config = config or {}
	    config.length = utils.value.default(config.length, 40)
	    config.color_bg = utils.value.default(config.color_bg, colors.onblack)
	    config.color_fg = utils.value.default(config.color_fg, colors.onmagenta)

	    self.state = 0
	    ---@diagnostic disable-next-line: assign-type-mismatch
	    self.config = config

	    self.m_segment = _segment(id, parent, function(_)
	        local mark_tiles = math.floor(self.config.length * self.state / self.config.count)
	        if mark_tiles == 0 then
	            return { self.config.color_bg(string_rep(" ", self.config.length)) }, 1
	        end

	        return {
	            self.config.color_fg(string_rep(" ", mark_tiles))
	            .. self.config.color_bg(string_rep(" ", self.config.length - mark_tiles))
	        }, 1
	    end)
	end

	function _loading:changed(state, update)
	    if state then
	        self.state = utils.number.clamp(state, 0, self.config.count)
	    end

	    self.m_segment:changed(utils.value.default(update, true))
	end

	---@param state integer
	---@param update boolean | nil
	function _loading:changed_relativ(state, update)
	    self:changed(self.state + state, update)
	end

	-- lua-term.segment.single_line_interface

	function _loading:get_id()
	    return self.m_segment:get_id()
	end

	---@param update boolean | nil
	function _loading:remove(update)
	    self.m_segment:remove(update)
	end

	function _loading:requested_update()
	    self.m_segment:requested_update()
	end

	function _loading:render_impl(context)
	    return self.m_segment:render_impl(context)
	end

	return class("lua-term.components.loading", _loading, {
	    inherit = {
	        _segment_interface
	    }
	})

end

__bundler__.__files__["src.components.throbber"] = function()
	local string_rep = string.rep

	local colors = __bundler__.__loadFile__("third-party.ansicolors")
	local _segment = __bundler__.__loadFile__("src.segment.init")
	local _segment_interface = __bundler__.__loadFile__("src.segment.interface")

	---@class lua-term.components.throbber.config.create
	---@field space integer | nil (default: 2)
	---
	---@field color_bg ansicolors.color | nil (default: transparent)
	---@field color_fg ansicolors.color | nil (default: magenta)
	---
	---@field rotate_on_every_update boolean | nil

	---@class lua-term.components.throbber.config
	---@field space integer
	---
	---@field color_bg ansicolors.color
	---@field color_fg ansicolors.color
	---
	---@field rotate_on_every_update boolean

	---@class lua-term.components.throbber : lua-term.segment.single_line_interface, object
	---@field config lua-term.components.throbber.config
	---
	---@field private m_state integer
	---@field private m_segment lua-term.segment
	---@overload fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.throbber.config.create | nil) : lua-term.components.throbber
	local _throbber = {}

	---@alias lua-term.components.throbber.__init fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.throbber.config.create | nil)
	---@alias lua-term.components.throbber.__con fun(id: string, parent: lua-term.segment.single_line_parent, config: lua-term.components.throbber.config.create | nil) : lua-term.components.throbber

	---@deprecated
	---@private
	---@param id string
	---@param parent lua-term.segment.single_line_parent
	---@param config lua-term.components.throbber.config.create | nil
	function _throbber:__init(id, parent, config)
	    config = config or {}
	    config.space = config.space or 2
	    config.color_bg = config.color_bg or colors.transparent
	    config.color_fg = config.color_fg or colors.magenta
	    config.rotate_on_every_update = config.rotate_on_every_update or true
	    ---@diagnostic disable-next-line: assign-type-mismatch
	    self.config = config

	    self.m_state = 0
	    self.m_segment = _segment(id, parent, function(_)
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

	        if self.config.rotate_on_every_update then
	            self.m_segment:changed()
	        end

	        local str = ""
	        if self.config.space > 0 then
	            str = string_rep(" ", self.config.space)
	        end

	        str = str .. self.config.color_bg(self.config.color_fg(state_str))
	        return { str }, 1
	    end)
	end

	function _throbber:rotate()
	    self.m_segment:changed(true)
	end

	-- lua-term.segment.single_line_interface

	function _throbber:get_id()
	    return self.m_segment:get_id()
	end

	function _throbber:requested_update()
	    return self.m_segment:requested_update()
	end

	function _throbber:remove(update)
	    return self.m_segment:remove(update)
	end

	function _throbber:render_impl(context)
	    return self.m_segment:render_impl(context)
	end

	return class("lua-term.components.throbber", _throbber, {
	    inherit = {
	        _segment_interface
	    }
	})

end

__bundler__.__files__["src.segment.entry"] = function()
	local string_rep = string.rep
	local table_insert = table.insert

	---@class lua-term.segment.entry : object
	---@field id string
	---
	---@field private m_line integer
	---
	---@field private m_showing_id boolean
	---@field private m_content_length integer
	---
	---@field private m_segment lua-term.segment.interface
	---@overload fun(segment: lua-term.segment.interface) : lua-term.segment.entry
	local _entry = {}

	---@deprecated
	---@private
	---@param segment lua-term.segment.interface
	function _entry:__init(segment)
	    self.id = segment:get_id()

	    self.m_line = 0

	    self.m_showing_id = false
	    self.m_content_length = 0

	    self.m_segment = segment
	end

	function _entry:get_length()
	    local segment_length = self.m_segment:get_length()

	    if self.m_showing_id then
	        return segment_length + 2
	    end

	    return segment_length
	end

	function _entry:get_line()
	    return self.m_line
	end

	---@param line integer
	function _entry:set_line(line)
	    self.m_line = line
	end

	---@return boolean
	function _entry:requested_update()
	    return self.m_segment:requested_update()
	end

	---@param segment lua-term.segment.interface
	function _entry:wraps_segment(segment)
	    return self.m_segment == segment
	end

	---@private
	---@param buffer table<integer, string>
	---@param width integer
	function _entry:add_id_to_buffer(buffer, length, width)
	    for i = length, 1, -1 do
	        buffer[i + 1] = buffer[i]
	        buffer[i] = nil
	    end

	    local id_str = "---- '" .. self.id .. "' "
	    buffer[1] = id_str .. string_rep("-", width - id_str:len())
	    buffer[length] = "<" .. string_rep("-", width - 2) .. ">"
	end

	---@param context lua-term.render_context
	function _entry:render(context)
	    local buffer, length = self.m_segment:render(context)

	    if self.m_showing_id and self.m_content_length ~= length then
	        length = length + 2
	        self:add_id_to_buffer(buffer, length, context.width)
	    end

	    if context.show_id ~= self.m_showing_id then
	        if context.show_id then
	            length = length + 2

	            self:add_id_to_buffer(buffer, length, context.width)
	        else
	            buffer[1] = nil
	            buffer[length] = nil

	            for index, content in pairs(buffer) do
	                buffer[index - 1] = content
	            end
	            length = length - 2
	        end

	        self.m_showing_id = context.show_id
	    end

	    self.m_content_length = length
	    return buffer, length
	end

	return class("lua-term.segment.entry", _entry)

end

__bundler__.__files__["src.segment.parent"] = function()
	local table_insert = table.insert
	local table_remove = table.remove

	local class_system = __bundler__.__loadFile__("misc.class_system")
	local _entry = __bundler__.__loadFile__("src.segment.entry")
	local _text = __bundler__.__loadFile__("src.components.text")

	---@class lua-term.segment.single_line_parent : object
	---@field protected m_childs lua-term.segment.entry[]
	local _segment_single_line_parent = {}

	---@param only_schedule boolean | nil
	function _segment_single_line_parent:update(only_schedule)
	end

	---@param ... any
	---@return lua-term.components.text
	function _segment_single_line_parent:print(...)
	---@diagnostic disable-next-line: missing-return
	end

	---@param segment lua-term.segment.single_line_interface
	function _segment_single_line_parent:add_child(segment)
	end

	---@param child lua-term.segment.single_line_interface
	function _segment_single_line_parent:remove_child(child)
	end

	---@class lua-term.segment.parent : lua-term.segment.single_line_parent, object
	---@field protected m_childs lua-term.segment.entry[]
	local _segment_parent = {}

	---@alias lua-term.segment.parent.__init fun()

	---@deprecated
	---@private
	function _segment_parent:__init()
	    self.m_childs = {}
	end

	---@param only_schedule boolean | nil
	function _segment_parent:update(only_schedule)
	end

	_segment_parent.update = class_system.is_abstract

	---@param ... any
	---@return lua-term.components.text
	function _segment_parent:print(...)
	    return _text.static__print(self, ...)
	end

	---@param segment lua-term.segment.interface
	function _segment_parent:add_child(segment)
	    table_insert(self.m_childs, _entry(segment))
	end

	---@param child lua-term.segment.interface
	function _segment_parent:remove_child(child)
	    for index, entry in pairs(self.m_childs) do
	        if entry:wraps_segment(child) then
	            table_remove(self.m_childs, index)
	            break
	        end
	    end

	    self:update(true)
	end

	return class("lua-term.segment_parent", _segment_parent, { is_abstract = true })

end

__bundler__.__files__["src.components.line"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")
	local table_insert = table.insert
	local table_remove = table.remove
	local table_concat = table.concat

	local _segment_interface = __bundler__.__loadFile__("src.segment.interface")
	local _segment_parent = __bundler__.__loadFile__("src.segment.parent")

	---@class lua-term.components.line : lua-term.segment.interface, lua-term.segment.single_line_parent, object
	---@field private m_id string
	---
	---@field private m_requested_update boolean
	---
	---@field private m_parent lua-term.segment.parent
	---@overload fun(id: string, parent: lua-term.segment.single_line_parent) : lua-term.components.line
	local _line = {}

	---@alias lua-term.components.line.__init fun(id: string, parent: lua-term.segment.single_line_parent)
	---@alias lua-term.components.line.__con fun(id: string, parent: lua-term.segment.single_line_parent) : lua-term.components.line

	---@deprecated
	---@private
	---@param super lua-term.segment.parent.__init
	---@param id string
	---@param parent lua-term.segment.parent
	function _line:__init(super, id, parent)
	    super()

	    self.m_id = id
	    self.m_requested_update = true

	    self.m_parent = parent
	    parent:add_child(self)
	end

	-- lua-term.segment.interface

	---@return string
	function _line:get_id()
	    return self.m_id
	end

	---@param update boolean | nil
	function _line:remove(update)
	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update(false)
	    end
	end

	function _line:requested_update()
	    if self.m_requested_update then
	        return true
	    end

	    for _, child in ipairs(self.m_childs) do
	        if child:requested_update() then
	            return true
	        end
	    end
	end

	---@return lua-term.render_buffer update_buffer
	---@return integer length
	function _line:render_impl(context)
	    self.m_requested_update = false

	    if context.show_id then
	        local line_buffer = {}
	        local line_buffer_pos = 1

	        for _, entry in ipairs(self.m_childs) do
	            local buffer, length = entry:render(context)
	            line_buffer[line_buffer_pos] = buffer
	            line_buffer_pos = line_buffer_pos + length
	        end

	        return line_buffer, line_buffer_pos - 1
	    end

	    local line_buffer = {}
	    for _, entry in ipairs(self.m_childs) do
	        local buffer = entry:render(context)
	        table_insert(line_buffer, buffer[1])
	    end

	    return { table_concat(line_buffer) }, 1
	end

	-- lua-term.segment.parent

	function _line:update(only_schedule)
	    if only_schedule then
	        self.m_requested_update = true
	        return
	    end

	    self.m_parent:update()
	end

	return class("lua-term.components.line", _line, {
	    inherit = {
	        _segment_interface,
	        _segment_parent,
	    }
	})

end

__bundler__.__files__["src.components.group"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	---@class lua-term.components.group : lua-term.segment.parent, lua-term.segment.interface
	---@field id string
	---
	---@field private m_requested_update boolean
	---
	---@field private m_parent lua-term.segment.parent
	---@overload fun(id: string, parent: lua-term.segment.parent) : lua-term.components.group
	local _group = {}

	---@alias lua-term.components.group.__init fun(id: string, parent: lua-term.segment.parent)
	---@alias lua-term.components.group.__con fun(id: string, parent: lua-term.segment.parent) : lua-term.components.group

	---@deprecated
	---@private
	---@param super lua-term.segment.parent.__init
	---@param id string
	---@param parent lua-term.segment.parent
	function _group:__init(super, id, parent)
	    super()

	    self.id = id

	    self.m_requested_update = false

	    self.m_parent = parent

	    -- lua-term.segment.interface
	    self.m_content_length = 0

	    parent:add_child(self)
	end

	---@param update boolean | nil
	function _group:remove(update)
	    self.m_parent:remove_child(self)

	    if update then
	        self.m_parent:update(false)
	    end
	end

	-- lua-term.segment_parent

	function _group:update(only_schedule)
	    if only_schedule then
	        self.m_requested_update = true
	        return
	    end

	    self.m_parent:update()
	end

	-- lua-term.segment_interface

	---@return string
	function _group:get_id()
	    return self.id
	end

	---@return boolean
	function _group:requested_update()
	    if self.m_requested_update then
	        return true
	    end

	    for _, child in ipairs(self.m_childs) do
	        if child:requested_update() then
	            return true
	        end
	    end

	    return false
	end

	---@return table<integer, string> update_buffer
	---@return integer length
	function _group:render_impl(context)
	    self.m_requested_update = false
	    if #self.m_childs == 0 then
	        return {}, 0
	    end

	    local group_buffer, group_buffer_pos = {}, 1
	    for _, entry in ipairs(self.m_childs) do
	        ---@type lua-term.render_context
	        local child_context = {
	            show_id = context.show_id,
	            width = context.width,
	            position_changed = entry:get_line() ~= group_buffer_pos or context.position_changed
	        }
	        local buffer, length = entry:render(child_context)
	        entry:set_line(group_buffer_pos)

	        group_buffer[group_buffer_pos] = buffer
	        group_buffer_pos = group_buffer_pos + length
	    end

	    self.m_content_length = group_buffer_pos - 1
	    return group_buffer, self.m_content_length
	end

	return class("lua-term.components.group", _group, {
	    inherit = {
	        __bundler__.__loadFile__("src.segment.parent"),
	        __bundler__.__loadFile__("src.segment.interface")
	    },
	})

end

__bundler__.__files__["src.misc.screen"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local table_concat = table.concat

	---@enum lua-term.screen.state
	local state = {
	    Normal = 0,
	    AnsiEscapeCode = 1
	}

	---@class lua-term.screen.line
	---@field buffer string[]
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
	local _screen = {}

	---@param read_char_func fun() : string | nil
	function _screen.new(read_char_func)
	    return setmetatable({
	        m_read_char_func = read_char_func,

	        m_cursor_x = 1,
	        m_cursor_y = 1,
	        m_screen = {},
	        m_changed = {},

	        m_state = state.Normal
	    }, { __index = _screen })
	end

	---@param line integer
	---@return lua-term.screen.line | nil
	function _screen:get_line(line)
	    return self.m_screen[line]
	end

	---@param line integer
	---@return lua-term.screen.line
	function _screen:get_or_create_line(line)
	    local _line = self:get_line(line)
	    if not _line then
	        _line = { buffer = {}, length = 0 }
	        self.m_screen[line] = _line
	        self.m_changed[line] = true

	        if line > 1 then
	            self:get_or_create_line(line - 1)
	        end
	    end

	    return _line
	end

	function _screen:get_height()
	    return utils.table.count(self.m_screen)
	end

	---@return (string[]|nil)[]
	function _screen:get_screen()
	    return self.m_screen
	end

	---@return table<integer, string>
	function _screen:get_changed()
	    ---@type table<integer, string>
	    local buffer = {}
	    for line in pairs(self.m_changed) do
	        ---@diagnostic disable-next-line: param-type-mismatch
	        buffer[line] = table_concat(self:get_line(line))
	    end
	    return buffer
	end

	function _screen:clear_changed()
	    self.m_changed = {}
	end

	---@private
	---@param dx integer
	---@param dy integer
	function _screen:move_cursor(dx, dy)
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
	function _screen:execute_ansi_escape_code(command)
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
	        local line = self:get_or_create_line(self.m_cursor_y)
	        for x = self.m_cursor_x, line.length do
	            line.buffer[x] = nil
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
	function _screen:write(buffer)
	    for i = 1, buffer:len() do
	        local char = buffer:sub(i, i)

	        local line = self:get_or_create_line(self.m_cursor_y)
	        for x = line.length + 1, self.m_cursor_x - 1 do
	            if not line.buffer[x] then
	                line.buffer[x] = " "
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
	function _screen:process_char()
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

	---@return string[]
	function _screen:to_lines()
	    local lines = {}
	    for y, line in ipairs(self.m_screen) do
	        lines[y] = table_concat(line.buffer)
	    end
	    return lines
	end

	---@return string
	function _screen:to_string()
	    return table_concat(self:to_lines(), "\n")
	end

	return _screen

end

__bundler__.__files__["src.components.stream"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local io_type = io.type

	local _segment = __bundler__.__loadFile__("src.segment.init")
	local _screen = __bundler__.__loadFile__("src.misc.screen")

	---@class lua-term.components.stream.config
	---@field before_each_line string | ansicolors.color | nil
	---@field after_each_line string | ansicolors.color | nil

	---@class lua-term.components.stream : lua-term.segment.interface, object
	---@field config lua-term.components.stream.config
	---
	---@field private m_stream file*
	---@field private m_closed boolean
	---
	---@field private m_screen lua-term.screen
	---
	---@field private m_segment lua-term.segment
	---@overload fun(id: string, parent: lua-term.segment.parent, stream: file*, config: lua-term.components.stream.config | nil) : lua-term.components.stream
	local _stream = {}

	---@alias lua-term.components.stream.__init fun(id: string, parent: lua-term.segment.parent, stream: file*, config: lua-term.components.stream.config | nil)
	---@alias lua-term.components.stream.__con fun(id: string, parent: lua-term.segment.parent, stream: file*, config: lua-term.components.stream.config | nil) : lua-term.components.stream

	---@deprecated
	---@private
	---@param id string
	---@param parent lua-term.segment.parent
	---@param stream file*
	---@param config lua-term.components.stream.config | nil
	function _stream:__init(id, parent, stream, config)
	    self.config = config or {}

	    if io_type(stream) ~= "file" then
	        error("stream not valid")
	    end

	    self.m_stream = stream
	    self.m_closed = false

	    self.m_screen = _screen.new(function()
	        return stream:read(1)
	    end)

	    self.m_segment = _segment(id, parent, function(_)
	        local buffer = self.m_screen:get_changed()
	        local length = #buffer

	        for line, content in pairs(buffer) do
	            buffer[line] = ("%s%s%s"):format(tostring(self.config.before_each_line or ""), content,
	                tostring(self.config.after_each_line or ""))
	        end

	        return buffer, length
	    end)
	end

	function _stream:remove(update)
	    self.m_segment:remove(update)
	end

	function _stream:requested_update()
	    return self.m_segment:requested_update()
	end

	---@private
	---@param update boolean | nil
	function _stream:read(update)
	    local char = self.m_screen:process_char()
	    if not char then
	        self.m_closed = true
	        return
	    end

	    if update then
	        self.m_segment:changed(true)
	    end

	    return char
	end

	---@param update boolean | nil
	function _stream:read_line(update)
	    while true do
	        local char = self:read(false)
	        if not char then
	            break
	        end

	        if char == "\n" then
	            break
	        end
	    end

	    if update then
	        self.m_segment:changed(true)
	    end
	end

	---@param update boolean | nil
	function _stream:read_all(update)
	    while not self.m_closed do
	        self:read(update)
	    end
	end

	return class("lua-term.components.screen", _stream)

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
	            local avg_update_time_seconds = stopwatch:reset() / 1000
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

end

__bundler__.__files__["src.components.init"] = function()
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

__bundler__.__files__["src.terminal"] = function()
	local utils = __bundler__.__loadFile__("misc.utils")

	local pairs = pairs
	local string_rep = string.rep
	local table_insert = table.insert
	local table_remove = table.remove

	local _segment_parent = __bundler__.__loadFile__("src.segment.parent")
	local _entry = __bundler__.__loadFile__("src.segment.entry")
	local _text = __bundler__.__loadFile__("src.components.text")

	---@class lua-term.render_context
	---@field show_id boolean
	---
	---@field width integer
	---
	---@field position_changed boolean

	---@alias lua-term.render_buffer table<integer, string | lua-term.render_buffer>

	---@class lua-term.terminal.callbacks.create
	---@field write fun(...: string)
	---@field write_line fun(...: string) | nil
	---@field flush fun() | nil
	---
	---@field erase_line fun()
	---@field erase_till_end fun()
	---
	---@field go_to_line fun(line: integer)

	---@class lua-term.terminal.callbacks
	---@field write fun(...: string)
	---@field write_line fun(...: string)
	---@field flush fun()
	---
	---@field erase_line fun()
	---@field erase_till_end fun()
	---
	---@field go_to_line fun(line: integer)

	---@class lua-term.terminal : object, lua-term.segment.parent
	---
	---@field package m_show_ids boolean
	---@field package m_show_line_numbers boolean
	---@field package m_callbacks lua-term.terminal.callbacks
	---@overload fun(callbacks: lua-term.terminal.callbacks.create) : lua-term.terminal
	local _terminal = {}

	---@alias lua-term.terminal.__init fun(callbacks: lua-term.terminal.callbacks.create)
	---@alias lua-term.terminal.__con fun(callbacks: lua-term.terminal.callbacks.create) : lua-term.terminal

	---@deprecated
	---@private
	---@param super lua-term.segment.parent.__init
	---@param callbacks lua-term.terminal.callbacks.create
	function _terminal:__init(super, callbacks)
	    super()

	    self.m_callbacks = {
	        write = callbacks.write,
	        write_line = callbacks.write_line or function(...)
	            self.m_callbacks.write(..., "\n")
	        end,
	        flush = callbacks.flush or function() end,

	        erase_line = callbacks.erase_line,
	        erase_till_end = callbacks.erase_till_end,

	        go_to_line = callbacks.go_to_line
	    }
	end

	---@param value boolean | nil
	function _terminal:show_ids(value)
	    self.m_show_ids = value or true
	end

	---@param value boolean | nil
	function _terminal:show_line_numbers(value)
	    self.m_show_line_numbers = value or true
	end

	---@param ... any
	---@return lua-term.components.text
	function _terminal:print(...)
	    return _text.static__print(self, ...)
	end

	function _terminal:add_child(segment)
	    local entry = _entry(segment)
	    table_insert(self.m_childs, entry)
	end

	function _terminal:remove_child(child)
	    for index, segment in ipairs(self.m_childs) do
	        if segment:wraps_segment(child) then
	            table_remove(self.m_childs, index)
	            break
	        end
	    end
	end

	function _terminal:clear()
	    self.m_childs = {}
	    self.m_callbacks.go_to_line(1)
	    self.m_callbacks.erase_till_end()
	    self.m_callbacks.flush()
	end

	---@param self lua-term.terminal
	---@param buffer table<integer, string | string[]>
	---@param line_start integer
	local function write_buffer(self, buffer, line_start)
	    for line, content in pairs(buffer) do
	        line = line_start + line

	        if type(content) == "table" then
	            write_buffer(self, content, line - 1)
	            goto continue
	        end

	        self.m_callbacks.go_to_line(line)
	        self.m_callbacks.erase_line()

	        if self.m_show_line_numbers then
	            local line_str = tostring(line)
	            local space = 3 - line_str:len()
	            self.m_callbacks.write(line_str, string_rep(" ", space), "|")
	        end

	        self.m_callbacks.write_line(content)

	        ::continue::
	    end
	end

	function _terminal:update()
	    local buffer = {}
	    local buffer_pos = 1

	    for _, segment in ipairs(self.m_childs) do
	        ---@type lua-term.render_context
	        local context = {
	            show_id = self.m_show_ids,
	            width = 80,
	            position_changed = segment:get_line() ~= buffer_pos
	        }

	        local seg_buffer, seg_length = segment:render(context)
	        buffer[buffer_pos] = seg_buffer

	        segment:set_line(buffer_pos)
	        buffer_pos = buffer_pos + seg_length
	    end

	    write_buffer(self, buffer, 0)

	    if #self.m_childs > 0 then
	        local last_segment = self.m_childs[#self.m_childs]
	        local line = last_segment:get_line()
	        local length = last_segment:get_length()
	        self.m_callbacks.go_to_line(line + length)
	    else
	        self.m_callbacks.go_to_line(1)
	    end

	    self.m_callbacks.erase_till_end()
	    self.m_callbacks.flush()
	end

	return class("lua-term.terminal", _terminal, {
	    inherit = {
	        _segment_parent
	    }
	})

end

__bundler__.__files__["__main__"] = function()
	-- load class system
	__bundler__.__loadFile__("misc.class_system")

	local utils = __bundler__.__loadFile__("misc.utils")

	local erase = __bundler__.__loadFile__("src.misc.erase")
	local cursor = __bundler__.__loadFile__("src.misc.cursor")

	local io_type = io.type
	local math_abs = math.abs

	local ansicolors = __bundler__.__loadFile__("third-party.ansicolors")
	local components = __bundler__.__loadFile__("src.components.init")
	local _terminal = __bundler__.__loadFile__("src.terminal")

	---@class lua-term
	---@field colors ansicolors
	---
	---@field terminal lua-term.terminal.__con
	---
	---@field components lua-term.components
	local term = {
	    colors = ansicolors,
	    components = components,

	    terminal = _terminal,

	    ---@param stream file*
	    ---@return lua-term.terminal
	    asci_terminal = function(stream)
	        local cursor_pos = 1

	        if io_type(stream) ~= "file" then
	            error("stream not valid")
	        end

	        local builder = utils.string.builder.new()
	        return _terminal({
	            write = function(...)
	                builder:append(...)
	            end,
	            write_line = function(...)
	                builder:append_line(...)
	                cursor_pos = cursor_pos + 1
	            end,
	            flush = function()
	                stream:write(builder:build())
	                stream:flush()

	                builder:clear()
	            end,

	            erase_line = function()
	                builder:append(erase.line())
	            end,
	            erase_till_end = function()
	                builder:append(erase.till_end())
	            end,

	            go_to_line = function(line)
	                local jump_lines = line - cursor_pos
	                if jump_lines == 0 then
	                    return
	                end

	                cursor_pos = line
	                if jump_lines > 0 then
	                    builder:append(cursor.go_down(jump_lines))
	                else
	                    builder:append(cursor.go_up(math_abs(jump_lines)))
	                end
	            end,
	        })
	    end,
	}

	return term

end

---@type { [1]: lua-term }
local main = { __bundler__.__main__() }
return table.unpack(main)
