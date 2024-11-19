local sformat = string.format
local iotype  = io.type
local stdout  = io.stdout

return function(sequence_fmt)
    sequence_fmt = '\027[' .. sequence_fmt

    local func

    func = function(handle, ...)
        if iotype(handle) ~= 'file' then
            return func(stdout, handle, ...)
        end

        return handle:write(sformat(sequence_fmt, ...))
    end

    return func
end
