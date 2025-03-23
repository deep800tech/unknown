loadstring([[
local message = "This script has been obfuscated for a challenge. Try to deobfuscate it!"
local script_id = "ddd2523a8d1ea4adf59a24772d357e74"
if lrm_load_script then lrm_load_script(script_id) while wait(1) do end end
local script_url = "https://api.luarmor.net/files/v3/l/"..script_id..".lua"
is_from_loader = {Mode = "fastload"}
local retry_delay = 0.03
l_fastload_enabled = function(command)
    if command == "flush" then
        wait(retry_delay)
        retry_delay = retry_delay + 2
        local success, result
        local http_success, http_response = pcall(function()
            result = game:HttpGet(script_url)
            pcall(writefile, script_id.."-cache.lua",
                "-- "..message.."\n\n if not is_from_loader then warn('Use the loadstring, do not run this directly') return end;\n "..result)
            wait(0.1)
            success = loadstring(result)
        end)
        if not http_success or not success then
            pcall(writefile, "lrm-err-loader-log-httpresp.txt", tostring(result))
            warn("Error while executing loader. Err: "..tostring(http_response).." See lrm-err-loader-log-httpresp.txt in your workspace.")
            return
        end
        success(is_from_loader)
    end
    if command == "rl" then
        pcall(writefile, script_id.."-cache.lua", "recache required")
        wait(0.2)
        pcall(delfile, script_id.."-cache.lua")
    end
end
local cached_func
local ok, err = pcall(function()
    cached_func = readfile(script_id.."-cache.lua")
    if (not cached_func) or (#cached_func < 5) then cached_func = nil return end
    cached_func = loadstring(cached_func)
end)
if not ok or not cached_func then l_fastload_enabled("flush") return end
cached_func(is_from_loader)
]])()
