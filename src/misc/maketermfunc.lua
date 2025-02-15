local sformat = string.format

return function(sequence_fmt)
    sequence_fmt = '\027[' .. sequence_fmt
    return function(...)
        return sformat(sequence_fmt, ...)
    end
end
