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

local utils = require("misc.utils")
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
