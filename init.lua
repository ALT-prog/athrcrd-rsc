audio = {}
ui = {}
masking = {}
user = {}
http = {}
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
        local _get_float_db = get_float_db
        local _get_int16_db = get_int16_db
        local _set_float_db = set_float_db
        local _set_int16_db = set_int16_db
        local _lock_bitrate = lock_bitrate
        local _unlock_bitrate = unlock_bitrate
        local _aethercord_audio_subsystem = aethercord_audio_subsystem
        local _secure_call = secure_call
        local _wait = wait
        local _createthread = createthread
        local _mask_window = mask_window
        unlock_bitrate = nil
        lock_bitrate = nil
        get_current_version = nil
        get_bitrate = nil
        set_bitrate = nil
        get_float_db = nil
        get_int16_db = nil
        set_float_db = nil
        set_int16_db = nil
        override_pcm = nil
        sound_distortion = nil
        set_sd_distortion = nil
        set_sd_multiply = nil
        highpass_filter = nil
        stereo_filter = nil
        aethercord_audio_subsystem = nil
        mask_window = nil
        wait = (function(time)
            return _wait(time)
        end)
        secure_call = (function(proto)
            return _secure_call(proto)
        end)
        audio.unlock_bitrate = (function()
            return _unlock_bitrate()
        end)
        audio.lock_bitrate = (function()
            return _lock_bitrate()
        end)
        lua_exit = (function()
            return _lua_exit()
        end)
        user.get_current_version = (function()
            return _get_current_version()
        end)
        audio.get_bitrate = (function()
            return _get_bitrate()
        end)
        audio.set_bitrate = (function(bitrate)
            return _set_bitrate(bitrate)
        end)
        audio.get_float_db = (function()
            return _get_float_db()
        end)
        audio.get_int16_db = (function ()
            return _get_int16_db()
        end)
        audio.set_float_db = (function(db)
            return _set_float_db(db)
        end)
        audio.set_int16_db = (function(db)
            return _set_int16_db(db)
        end)
        audio.override_pcm = (function(pcm_table)
            return _override_pcm(pcm_table)
        end)
        audio.sound_distortion = (function(bool)
            return _sound_distortion(bool)
        end)
        audio.set_sd_distortion = (function(amount)
            return _set_sd_distortion(amount)
        end)
        audio.set_sd_multiply = (function(boolean)
            return _set_sd_multiply(boolean)
        end)
        audio.highpass_filter = (function(boolean)
            return _highpass_filter(boolean)
        end)
        audio.stereo_filter = (function(amount)
            return _stereo_filter(amount)
        end)
        audio.aethercord_audio_subsystem = (function()
            return _aethercord_audio_subsystem()
        end)
        createthread = (function(Function)
            return _createthread(Function)
        end)
        masking.mask_window = (function(boolean)
            return _mask_window(boolean)
        end)
    end
    SecureInitialize()
    SecureInitialize = nil

    local exit_callbacks = {}
    local fault_callbacks = {}
    local upvalue_callbacks = {}
    local encode_callbacks = {}
    local decode_callbacks = {}

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

    local enable_encode_callbacks = _enable_encode_callbacks
    _enable_encode_callbacks = nil
    audio.add_encode_callback = (function(f)
        enable_encode_callbacks()
        encode_callbacks[#encode_callbacks+1] = f
        return #encode_callbacks
    end)
    audio.remove_encode_callback = (function(i)
        encode_callbacks[i] = nil
    end)

    local enable_decode_callbacks = _enable_decode_callbacks
    _enable_decode_callbacks = nil
    audio.add_decode_callback = (function(f)
        enable_decode_callbacks()
        decode_callbacks[#decode_callbacks+1] = f
        return #decode_callbacks
    end)
    audio.remove_decode_callback = (function(i)
        decode_callbacks[i] = nil
        return #decode_callbacks
    end)

    setmetatable(_G, {__metatable = "Aethercord", __exit = (function() -- called when aethercord closes through lua calls
        for i,v in pairs(exit_callbacks) do
            if (v) then
                v()
            end
        end
    end), __fault = (function(error_message, internal)
        --// Called when a script is using aethercords protected call wrapper and the script errors
        -- used to protect a script against other scripts analyzing it & used for other things
        for i,v in pairs(fault_callbacks) do
            if (v) then
                v(error_message, internal)
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
    end), __encode = (function(pcm_table)
        for i,v in pairs(encode_callbacks) do
            pcm_table = v(pcm_table)
        end
        return pcm_table
    end), __decode = (function(pcm_table)
        for i,v in pairs(decode_callbacks) do
            v(pcm_table)
        end
    end)})

    add_upvalue_callback((function(f,i)
        return not (f == audio.add_encode_callback or f == audio.remove_encode_callback or f == audio.add_decode_callback or f == audio.remove_decode_callback or f == audio.aethercord_audio_subsystem or f == audio.highpass_filter or f == audio.set_sd_distortion or f == audio.sound_distortion or f == audio.set_sd_multiply or f == audio.override_pcm or f == audio.stereo_filter or f == audio.add_opus_callback or f == audio.remove_opus_callback or f == add_upvalue_callback or f == remove_upvalue_callback or f == lua_exit or f == secure_call or f == wait or f == unlock_bitrate or f == lock_bitrate or f == set_bitrate or f == set_int16_db or f == set_exploit_db or f == get_current_version or f == get_exploit_db or f == get_int16_db or f == get_bitrate or f == createthread or f == package.loadlib or f == io.open)
    end))
end

LocalizedEntry()
LocalizedEntry = nil
