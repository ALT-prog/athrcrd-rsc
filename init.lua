writefile = (function()end)
readfile = (function()end)

local function SecureInitialize()
    local _get_current_version = get_current_version
    get_current_version = (function()
        return _get_current_version()
    end)
end
SecureInitialize()
SecureInitialize = nil
lua_exit = nil

os.exit = (function()
    return error("Missing permissions")
end)
os.rename = (function()
    return error("Missing permissions")
end)
os.remove = (function()
    return error("Missing permissions")
end)
package.loadlib = (function()
    return error("Missing permissions")
end)

