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
                local upvalue = debug.getupvalue(f, #Upvalues+1)
                if (upvalue == nil) then
                    break
                end
                Upvalues[#Upvalues+1] = upvalue
            end
        end)

        debug.getlocals = (function(f)
            local Locals = {}
            while (true) do
                local Local = debug.getlocal(f, #Locals+1)
                if (Local == nil) then
                    break
                end
                Locals[#Locals+1] = Local
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
        --local _pcall = protected_call
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

    local exit_routines = {}
    local fault_routines = {}
    local lock_routines = {}
    local release_routines = {}
    local ctd_routines = {}

    --// exit routines
    add_exit_routine = (function(f)
        exit_routines[#exit_routines+1] = f
        return #exit_routines
    end)
    remove_exit_routine = (function(i)
        exit_routines[i] = nil
    end)

    --// fault routines
    add_fault_routine = (function(f)
        fault_routines[#fault_routines+1] = f
        return #fault_routines
    end)
    remove_fault_routine = (function(i)
        fault_routines[i] = nil
    end)

    --// lock routines
    add_lock_routine = (function(f)
        lock_routines[#lock_routines+1] = f
        return #lock_routines
    end)
    remove_lock_routine = (function(i)
        lock_routines[i] = nil
    end)

    --// release routines
    add_release_routine = (function(f)
        release_routines[#release_routines+1] = f
        return #release_routines
    end)
    remove_release_routine = (function(i)
        release_routines[i] = nil
    end)

    --// release routines
    add_criticalthreaddied_routine = (function(f)
        ctd_routines[#ctd_routines+1] = f
        return #ctd_routines
    end)
    remove_criticalthreaddied_routine = (function(i)
        ctd_routines[i] = nil
    end)

    setmetatable(_G, {__metatable = "Locked", __exit_asserted = (function(reason) -- called when aethercord closes through lua calls
        for i,v in pairs(exit_routines) do
            v(reason)
        end
    end), __fault = (function(thread)
        --// Called when a script is using aethercords protected call wrapper and the wrapper is somehow folded (bypassed) or if the script errors
        -- used to protect a script against other scripts analyzing it
        for i,v in pairs(fault_routines) do
            v(thread)
        end
    end), __lock_asserted = (function(thread_owner)
        --// Called when a script asserts a script lock which stops all threads except for the callers (useful for multi-thread exchange)
        for i,v in pairs(lock_routines) do
            v(thread_owner)
        end
    end), __release_asserted = (function(thread_owner)
        --// Called when a script asserts the release flag which resumes all threads (useful for multi-thread exchange)
        for i,v in pairs(release_routines) do
            v(thread_owner)
        end
    end), __critical_thread_died = (function(thread, err)
        --// Called if a thread enables a critical section and it throws an error or faults
        for i,v in pairs(ctd_routines) do
            v(thread, err)
        end
    end)})
end

LocalizedEntry()
LocalizedEntry = nil
