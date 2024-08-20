local function SecureInitialize()

    --// Security
    local function __function_disabled()
        return error("This function is disabled")
    end
    os.execute = __function_disabled
    io.open = __function_disabled
    os.exit = __function_disabled
    os.rename = __function_disabled
    os.remove = __function_disabled
    package.loadlib = __function_disabled

    _writefile = writefile
    writefile = (function(name, data)
        return writefile("userfile_"..name, data)
    end)

    _readfile = readfile
    readfile = (function(name)
        return _readfile("workspace\\"..name)
    end)

    --// Anti-hook protection
    local _lua_exit = lua_exit
    local _get_current_version = get_current_version
    local _get_bitrate = get_bitrate
    local _set_bitrate = set_bitrate
    local _get_exploit_db = get_exploit_db
    local _get_int16_db = get_int16_db
    local _set_exploit_db = set_exploit_db
    local _set_int16_db = set_int16_db
    get_current_version = (function()
        return _get_current_version()
    end)
    get_bitrate = (function()
        return _get_bitrate()
    end)
    set_bitrate = (function(bitrate)
        return _set_bitrate(bitrate)
    end)
    get_exploit_db = (function()
        return _get_exploit_db()
    end)
    get_int16_db = (function ()
        return _get_int16_db()
    end)
    set_exploit_db = (function(db)
        return _set_exploit_db(db)
    end)
    set_int16_db = (function(db)
        return _set_int16_db(db)
    end)
end

SecureInitialize()
SecureInitialize = nil
lua_exit = nil
setmetatable(_G, {__metatable = "Locked"})
