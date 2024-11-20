# NOT FINISHED & NOT RECOMMENDED
Its a personal project there for its not good code or optimized.

# lua-term
Terminal Utilities library.

## Setup
`term.lua` is the only file you need.

## Usage
```lua
local term = require("term")

local terminal = term.terminal.stdout()
-- same as
local terminal = term.terminal.new(io.stdout)



```

## Features
- `term.colors` from `ansicolors`

## Third-Party
- [ansicolors](https://github.com/hoelzro/ansicolors)
