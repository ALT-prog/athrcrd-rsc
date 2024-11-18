local aethercord = {}
local function LocalizedEntry()
    local function SecureInitialize()
    
        --// Security
        local function __function_disabled()
            return error("This function is disabled")
        end
    
        local io_open = io.open
        os.execute = __function_disabled
        io.open = __function_disabled
        io.popen = __function_disabled
        os.exit = __function_disabled
        os.rename = __function_disabled
        os.remove = __function_disabled
        package.loadlib = __function_disabled
        writefile = (function(name, data)
            return (function()
                local file = io_open("userfile_"..name, "w+")
                if (file == nil) then
                    return false
                end
                file:write(data)
                return file:close()
            end)()
        end)
    
        readfile = (function(name)
            return (function()
                local file = io_open("userfile_"..name, "r")
                if (file == nil) then
                    return false
                end
                local data = file:read()
                file:close()
                return data
            end)
        end)

        debug.getupvalues = (function(f)
            local Upvalues = {}
            while (true) do
                local name, upvalue = debug.getupvalue(f, #Upvalues+1)
                if (upvalue == nil) then
                    break
                end
                Upvalues[#Upvalues+1] = {name,upvalue}
            end
        end)

        debug.getlocals = (function(f)
            local Locals = {}
            while (true) do
                local name, Local = debug.getlocal(f, #Locals+1)
                if (Local == nil) then
                    break
                end
                Locals[#Locals+1] = {name, Local}
            end
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
        local _lock_bitrate = lock_bitrate
        local _unlock_bitrate = unlock_bitrate
        local _secure_call = secure_call
        local _wait = wait
        local _createthread = createthread
        --local _pcall = protected_call
        wait = (function(time)
            return _wait(time)
        end)
        secure_call = (function(proto)
            return _secure_call(proto)
        end)
        unlock_bitrate = (function()
            return _unlock_bitrate()
        end)
        lock_bitrate = (function()
            return _lock_bitrate()
        end)
        lua_exit = (function()
            return _lua_exit()
        end)
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
        createthread = (function(Function)
            return _createthread(Function)
        end)
    end
    SecureInitialize()
    SecureInitialize = nil

    local exit_callbacks = {}
    local fault_callbacks = {}
    local upvalue_callbacks = {}

    --// exit routines
    add_exit_callback = (function(f)
        exit_callbacks[#exit_callbacks+1] = f
        return #exit_callbacks
    end)
    remove_exit_callback = (function(i)
        exit_callbacks[i] = nil
    end)

    --// fault routines
    add_fault_callback = (function(f)
        fault_callbacks[#fault_callbacks+1] = f
        return #fault_callbacks
    end)
    remove_fault_callback = (function(i)
        fault_callbacks[i] = nil
    end)

    add_upvalue_callback = (function(f)
        upvalue_callbacks[#upvalue_callbacks+1] = f
        return #upvalue_callbacks
    end)
    remove_upvalue_callback = (function(i)
        if (i == 1) then --// locked
            return
        end
        upvalue_callbacks[i] = nil
    end)

    setmetatable(_G, {__metatable = "Aethercord", __exit = (function() -- called when aethercord closes through lua calls
        for i,v in pairs(exit_callbacks) do
            if (v) then
                v()
            end
        end
    end), __fault = (function(error_message)
        --// Called when a script is using aethercords protected call wrapper and the script errors
        -- used to protect a script against other scripts analyzing it & used for other things
        for i,v in pairs(fault_callbacks) do
            if (v) then
                v(error_message)
            end
        end
    end), __upvalue = (function(f,index)
        local state = true
        for i,v in pairs(upvalue_callbacks) do
            if (v) then
                if (not v(f,index)) then
                    state = false
                end
            end
        end
        return state
    end), __interrupt = (function()
        
    end)})

    add_upvalue_callback((function(f,i)
        return not (f == add_upvalue_callback or f == remove_upvalue_callback or f == lua_exit or f == secure_call or f == wait or f == unlock_bitrate or f == lock_bitrate or f == set_bitrate or f == set_int16_db or f == set_exploit_db or f == get_current_version or f == get_exploit_db or f == get_int16_db or f == get_bitrate or f == createthread)
    end))
end

LocalizedEntry()
LocalizedEntry = nil
