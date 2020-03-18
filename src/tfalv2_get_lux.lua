-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tfalv2_get_lux_python
-- Getter Example
-- The script is triggered every minute and executes python script.
-- The python script expects an argument with key:value pairs:
-- '{"HOST":"IP-Address","PORT":4223,"UID":"yyc"}'
-- At least 1 argument is mandatory.
-- The result of the command is a JSON formatted string, i.e.
-- {"status": "OK", "title": "", "lux":"146.21"}
-- {"status": "ERROR", "title": "Error message"}
-- VirtualDevice
-- Type:Lux, SubType:Lux, Name: MakeLab Lux, Idx: 106
-- 20200224 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux

local CMD = "python3 /home/pi/domoticz/scripts/python/tfalv2_get_lux.py"

-- Idx of the devices
local IDXLUX = 107
-- TF Bricklet parameter
local TFUID = "yyc"

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
		timer = {
			'every minute',
	   },
    },
	execute = function(domoticz, timer)
        -- define the python command with json argument
        -- example: python3 tfalv2_get_lux.py '{"UID":"yyc"}'
        local pycmd = string.format('%s \'{\"UID\":"%s"}\'',CMD,TFUID)
		domoticz.log(pycmd, domoticz.LOG_INFO)
		
		-- run the external python scripts ad handle return code
		local output,rt = osExecute(pycmd)
        -- domoticz.log(string.format('%d:%s',rt,output), domoticz.LOG_INFO)
        -- decode the result string which is json format, i.e. 
        -- {"status": "OK", "title": "", "lux":"146.21"}
        -- {"status": "ERROR", "title": "Error message"}
        local result = JSON:decode(output);
        -- domoticz.log(string.format('TEST Status:%s, Title:%s, Lux:%s',result.status,result.title,result.lux), domoticz.LOG_INFO)
		-- handle the result of the python command: 0=OK,>0=ERROR
		if rt == 0 then
		    -- handle the result of the tinkerforge scripts
		    if result.status == "OK" then
                domoticz.log(string.format('Status:%s, Title:%s, Lux:%s',result.status,result.title,result.lux), domoticz.LOG_INFO)
                domoticz.devices(IDXLUX).updateLux(result.lux)
            -- tinkerforge script returns an error
            else
                domoticz.log(string.format('Status:%s, Title:%s, Lux:%s',result.status,result.title,result.lux), domoticz.LOG_ERROR)
            end
		-- handle the result of the python command
        else
            domoticz.log(string.format('Python command: RT:%d, Output:%s',rt,output), domoticz.LOG_ERROR)
        end

    end
}
