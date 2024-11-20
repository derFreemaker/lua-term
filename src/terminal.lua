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

---@alias lua-term.segment.func (fun() : string | nil)

---@class lua-term.segment
---@field id string
---@field private m_func lua-term.segment.func
---@field private m_terminal lua-term.terminal
---
---@field package p_requested_update boolean
---@field package p_lines string[]
---@field package p_lines_count integer
---
---@field package p_line integer
local segment_class = {}

---@param id string
---@param func lua-term.segment.func
---@param terminal lua-term.terminal
function segment_class.new(id, func, terminal)
    return setmetatable({
        id = id,
        m_func = func,
        m_terminal = terminal,

        p_requested_update = true,
        p_lines = {},
        p_lines_count = 0,

        p_line = 0
    }, {
        __index = segment_class
    })
end

---@package
function segment_class:pre_render()
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

function segment_class:remove()
    self.m_terminal:remove_segment(self)
end

function segment_class:changed()
    self.p_requested_update = true
end

----------------
--- Terminal ---
----------------

---@class lua-term.terminal
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
        __index = terminal
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

function terminal:overrite_print()
    if self.m_org_print then
        return
    end

    self.m_org_print = print

    ---@param ... any
    ---@return lua-term.segment
    function print(...)
        local items = {}
        for _, value in ipairs({ ... }) do
            table_insert(items, tostring(value))
        end
        local str = table_concat(items)
        return stdout_terminal:create_segment("<print>", function()
            return str
        end)
    end
end

function terminal:restore_print()
    if not self.m_org_print then
        return
    end

    print = self.m_org_print
    self.m_org_print = nil
end

---@param id string
---@param func lua-term.segment.func
---@param pos integer | nil
function terminal:create_segment(id, func, pos)
    local segment = segment_class.new(id, func, self)
    if pos then
        table_insert(self.m_segments, pos, segment)
    else
        table_insert(self.m_segments, segment)
    end
    return segment
end

---@param segment lua-term.segment
function terminal:remove_segment(segment)
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
        if segment.p_requested_update then
            segment.p_requested_update = false
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
        self:jump_to_line(self.m_segments[#self.m_segments].p_line + 1)
    else
        self:jump_to_line(1)
    end

    self.m_stream:write(erase.till_end())
    self.m_stream:flush()
end

return terminal