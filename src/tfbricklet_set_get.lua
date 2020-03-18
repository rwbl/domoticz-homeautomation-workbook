-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tfbricklet_set_get
-- Template for setting or getting bricklet values.
-- The dzVents Lua script controlles the functionality and run a Python script executing Tinkerforge API functions for the bricklet.
-- The logic is handled by the Domoticz script whereas the Python script sets or gets bricklet vaue(s) only.
-- Python Script
-- The script is triggered every minute or by a device (i.e. switch) and executes python script.
-- The python script expects a string argument (enclosed in '') with key:value pairs:
-- '{"HOST":"IP-Address","PORT":4223,"UID":"yyc"}'
-- The UID argument is mandatory, HOST and PORT are optional. The keys must in UPPERCASE!
-- In addition key:value pairs can be defined, depending on the functionality and if getter or setter.
-- Examples Bricklets:
-- RGB LED 2.0: set color = '{"HOST":"IP-Address","PORT":4223,"UID":"Jng","R":255,"G":255,"B":0}'
-- LCD 20x4: set text 4 lines = '{"UID":"BHN","LCDLINES":[{"line":0,"position":0,"clear":1,"text":"R=255"},{"line":1,"position":5,"clear":1,"text":"G=0"},{"line":2,"position":10,"clear":1,"text":"B=0"},{"line":3,"position":15,"clear":1,"text":"Color"}]}'
-- Result
-- The result of the command is a JSON formatted string containing the key:value pairs:
-- {"status": "OK", "title": ""} or {"status": "ERROR", "title": "Error message"}
-- For a getter, the requested values are added to the result.
-- Examples Bricklets:
-- Ambient Light 2.0: get lux = {"status": "OK", "title": "", "lux":"146.21"}
--
-- 20200226 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux
-- define the path to the python script
local CMD = "python3 /home/pi/domoticz/scripts/python/tfbricklet_set_get.py"

-- Idx of the devices used, i.e. a switch (set) or a device (get) to be updated
local IDXDEVICE = NNN
-- TF Bricklet parameter
local TFUID = "UID"

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
		-- select the function
		timer = { 'every minute' },
		devices = { IDXDEVICE },
    },
	-- select the function
	execute = function(domoticz, timer)
		domoticz.log('Timer event was triggered by ' .. timer.trigger, domoticz.LOG_INFO)

	execute = function(domoticz, device)
		domoticz.log(string.format('Device changed:%s to %s.',device.name, device.state), domoticz.LOG_INFO)

        -- define the python command with json argument
        -- example: python3 tfbricklet_set_get.py '{"UID":"yyc"}'
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
				-- setter uses status and result only
                domoticz.log(string.format('Status:%s, Title:%s',result.status,result.title), domoticz.LOG_INFO)

				-- getter to get the value and update domoticz deice
                domoticz.log(string.format('Status:%s, Title:%s, Value:%s',result.status,result.title,result.value), domoticz.LOG_INFO)
                domoticz.devices(IDXDEVICE).updateLux(result.value)
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
