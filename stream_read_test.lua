local function foo()
    local handle = io.popen("ping 1.1.1.1")
    if not handle then
        error("unable to open process handle")
    end

    local buffer = ""                -- To hold the processed output
    while true do
        local chunk = handle:read(1) -- Read one character at a time
        if not chunk then break end  -- Exit if EOF

        -- Handle carriage return (\r)
        if chunk == "\r" then
            -- Clear the current line in the buffer
            buffer = buffer:match("^(.-)%s*$") -- Remove trailing content for overwrite
        elseif chunk:byte() == 27 then         -- Check for ESC (ANSI sequence start)
            local seq = handle:read(2)         -- Read next two characters to form an ANSI code
            -- Handle known sequences (e.g., clear, cursor move, etc.)
            if seq:sub(1, 1) == "[" then
                local rest = seq:sub(2) .. handle:read("l") -- Handle more if needed
                print("ANSI Sequence:", rest)                   -- Debugging purposes
            end
        else
            buffer = buffer .. chunk -- Add to buffer
        end

        -- Process buffer (e.g., print updated lines)
        io.write("\r" .. buffer)
        io.flush()
    end
    handle:close()
end

foo()
