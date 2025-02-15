local workspace_dir = ({...})[1]

print("\nbundling term...")
os.execute("cd " .. workspace_dir .. " && lua misc/bundle.lua -o term.lua src/init.lua  -t lua-term -I " .. workspace_dir)
