local audio = {}
local ui = {}
local masking = {}
local user = {}
local http = {}
local function LocalizedEntry()
    local function SecureInitialize()
    
        --// Security
        local function __function_disabled()
            return error("This function is disabled")
        end
    
        local io_open = io.open
        io.open = (function(filename, ...)
            if (filename:find("C:\\") or filename:find("Windows") or filename:find("System32") or filename:find(":\\") or filename:find("..")) then
                return "Access denied"
            end
            return io_open(filename, ...)
        end)
        io.popen = __function_disabled
        os.execute = __function_disabled
        os.exit = __function_disabled
        os.rename = __function_disabled
        os.remove = __function_disabled
        local package_loadlib = package.loadlib
        package.loadlib = (function(library, routine)
            if (library:find("libc") or routine:find("hook") or routine:find("system")) then
                return
            end
            return package_loadlib(library, routine)
        end)
        --package.loadlib = __function_disabled

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
        local _sound_distortion = sound_distortion
        local _set_sd_distortion = set_sd_distortion
        local _set_sd_multiply = set_sd_multiply
        local _highpass_filter = highpass_filter
        local _stereo_filter = stereo_filter
        local _override_pcm = override_pcm
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
        unlock_bitrate = nil
        audio.unlock_bitrate = (function()
            return _unlock_bitrate()
        end)
        lock_bitrate = nil
        audio.lock_bitrate = (function()
            return _lock_bitrate()
        end)
        lua_exit = (function()
            return _lua_exit()
        end)
        get_current_version = nil
        user.get_current_version = (function()
            return _get_current_version()
        end)
        get_bitrate = nil
        audio.get_bitrate = (function()
            return _get_bitrate()
        end)
        set_bitrate = nil
        audio.set_bitrate = (function(bitrate)
            return _set_bitrate(bitrate)
        end)
        get_exploit_db = nil
        audio.get_exploit_db = (function()
            return _get_exploit_db()
        end)
        get_int16_db = nil
        audio.get_int16_db = (function ()
            return _get_int16_db()
        end)
        set_exploit_db = nil
        audio.set_exploit_db = (function(db)
            return _set_exploit_db(db)
        end)
        set_int16_db = nil
        audio.set_int16_db = (function(db)
            return _set_int16_db(db)
        end)
        override_pcm = nil
        audio.override_pcm = (function(pcm_table)
            return _override_pcm(pcm_table)
        end)
        sound_distortion = nil
        audio.sound_distortion = (function(bool)
            return _sound_distortion(bool)
        end)
        set_sd_distortion = nil
        audio.set_sd_distortion = (function(amount)
            return _set_sd_distortion(amount)
        end)
        set_sd_multiply = nil
        audio.set_sd_multiply = (function(boolean)
            return _set_sd_multiply(boolean)
        end)
        highpass_filter = nil
        audio.highpass_filter = (function(boolean)
            return _highpass_filter(boolean)
        end)
        stereo_filter = nil
        audio.stereo_filter = (function(amount)
            return _stereo_filter(amount)
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
    local opus_callbacks = {}

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

    audio.add_opus_callback = (function(f)
        opus_callbacks[#opus_callbacks+1] = f
        return #opus_callbacks
    end)
    audio.remove_opus_callback = (function(i)
        opus_callbacks[i] = nil
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
    end), __opus = (function(pcm_table)
        for i,v in pairs(opus_callbacks) do
            pcm_table = v(pcm_table)
        end
        return pcm_table
    end)})

    add_upvalue_callback((function(f,i)
        return not (f == audio.highpass_filter or f == audio.set_sd_distortion or f == audio.sound_distortion or f == audio.set_sd_multiply or f == audio.override_pcm or f == audio.stereo_filter or f == audio.add_opus_callback or f == audio.remove_opus_callback or f == add_upvalue_callback or f == remove_upvalue_callback or f == lua_exit or f == secure_call or f == wait or f == unlock_bitrate or f == lock_bitrate or f == set_bitrate or f == set_int16_db or f == set_exploit_db or f == get_current_version or f == get_exploit_db or f == get_int16_db or f == get_bitrate or f == createthread or f == package.loadlib or f == io.open)
    end))
end

LocalizedEntry()
LocalizedEntry = nil
