-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tfio4v2_set_channel
-- Set
-- The script is triggered by a selector switch and executes python script.
-- The python script expects an argument with key:value pairs. Example:
-- Turn channel 0 led on or off
-- python3 /home/pi/domoticz/scripts/python/tfio4v2_set_channel.py '{"UID":"G4d","CHANNELS":[{"channel":0,"value":1}]}'
-- python3 /home/pi/domoticz/scripts/python/tfio4v2_set_channel.py '{"UID":"G4d","CHANNELS":[{"channel":0,"value":0}]}'
-- The result of the command is a JSON formatted string. if ok the tile contains channelvalue
-- {"status": "OK", "title": "channel:0 value:1"}
-- {"status": "ERROR", "title": "Error message"}
-- 20200225 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux

local CMD = "python3 /home/pi/domoticz/scripts/python/tfio4v2_set_channel.py"

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
		domoticz.log(string.format('Device changed:%s to %s.',device.name, device.state), domoticz.LOG_INFO)
        -- get the swich level to set the RGB color
        local value = 0
		if (device.level == LEVELRED) then value=1 end
		if (device.level == LEVELYELLOW) then value=1 end
		if (device.level == LEVELGREEN) then value=0 end
        local args = string.format('{"UID":"%s","CHANNELS":[{"channel":%d,"value":%d}]}',"G4d",0,value)
		-- domoticz.log(args, domoticz.LOG_INFO)

        -- define the python command with json argument.
        local pycmd = string.format('%s \'%s\'',CMD,args)
		domoticz.log(pycmd, domoticz.LOG_INFO)
		
		-- run the external python scripts ad handle return code
		local output,rt = osExecute(pycmd)
		-- result, i
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

