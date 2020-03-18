-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tfrgbledv2_set_color
-- Setter Example
-- The script is triggered by a switch (Switch Type Push On Button, idx=102) and executes python script.
-- The python script expects an argument with key:value pairs:
-- '{"HOST":"IP-Address","PORT":4223,"UID":"Jng","R":255,"G":255,"B":0}'
-- The keys R,G,B are mandatory
-- The result of the command is a JSON formatted string, i.e.
-- {"status": "OK", "title": "255,0,0"}
-- {"status": "ERROR", "title": "Error message"}
-- VirtualDevices
-- Type: Light/Switch, SubType:Switch,SwitchType: On/Off, Name: Time Control Today, Idx: 12
-- 20200223 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux

local CMD = "python3 /home/pi/domoticz/scripts/python/tfrgbledv2_set_color.py"
local UID = "Jng"

-- Selector switch levels
local IDXSWITCH = 12
local LEVELRED = 10
local LEVELYELLOW = 20
local LEVELGREEN = 30

-- run external command
local function osExecute(cmd)
    local fileHandle     = assert(io.popen(cmd, 'r'))
    local commandOutput  = assert(fileHandle:read('*a'))
    local returnTable    = {fileHandle:close()}
    -- rc[3] contains returnCode
    return commandOutput,returnTable[3]
end

return {
	on = {
		devices = { IDXSWITCH },
    },
	execute = function(domoticz, device)
        -- get the swich level to set the RGB color
        local R,G,B = 0,0,0
		if (device.level == LEVELRED) then R=255 end
		if (device.level == LEVELYELLOW) then R,G=255,255 end
		if (device.level == LEVELGREEN) then G=255 end

        -- define the python command with json argument
        -- example: python3 tf_rgbledv2_set_color.py '{"R":255,"G":255,"B":0}'
        local pycmd = string.format('%s \'{"UID":"%s","R":%d,"G":%d,"B":%d}\'',CMD,UID,R,G,B)
		domoticz.log(pycmd, domoticz.LOG_INFO)
		
		-- run the external python scripts ad handle return code
		local output,rt = osExecute(pycmd)
		-- test result, i.e. for setting color to red
		-- 0:{"status": "OK", "title": "255,0,0"}
        -- domoticz.log(string.format('%d:%s',rt,output), domoticz.LOG_INFO)
        -- decode the result string which is json format, i.e. 
        -- {"status": "OK", "title": "255,0,0"}
        local result = JSON:decode(output);
		-- handle the result of the python command: 0=OK,>0=ERROR
		if rt == 0 then
		    -- handle the result of the tinkerforge scripts
		    if result.status == "OK" then
                domoticz.log(string.format('Status:%s, Title:%s',result.status,result.title), domoticz.LOG_INFO)
            -- tinkerforge script returns an error
            else
                domoticz.log(string.format('Status:%s, Title:%s',result.status,result.title), domoticz.LOG_ERROR)
            end
		-- handle the result of the python command
        else
            domoticz.log(string.format('Python command: RT:%d, Output:%s',rt,output), domoticz.LOG_ERROR)
        end

    end
}
