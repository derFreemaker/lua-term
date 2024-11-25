local utils = require("misc.utils")

---@class lua-term.components.stream : lua-term.segment_interface
---@field private m_stream file*
---
---@field private m_parent lua-term.segment_parent
---@field private m_requested_update boolean
local stream_class = {}

---@param id string
---@param parent lua-term.segment_parent
---@param stream file*
---@return lua-term.components.stream
function stream_class.new(id, parent, stream)
    local instance = setmetatable({
        m_stream = stream,

        m_parent = parent,
        m_requested_update = true,
    }, { __index = stream_class })
    parent:add_segment(id, instance)

    return instance
end

function stream_class:remove(update)
    update = utils.value.default(update, true)

    self.m_parent:remove_child(self)

    if update then
        self.m_parent:update()
    end
end

function stream_class:render(context)

end



return stream_class
