local utils = require("utils.utils")

local cursor = require("src.cursor")
local erase = require("src.erase")

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
