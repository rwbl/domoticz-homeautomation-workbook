-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tflcd20x4_set_text
-- Setter Example
-- The script is triggered by a selector switch (idx=12,3 levels) and executes python script.
-- The python scripts writes 4 lines to the lcd display with R=NNN,G=NNN,B=NNN,Color
-- The python script expects an argument with key:value pairs. Example:
-- python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py '{"UID":"BHN","LCDLINES":[{"line":0,"position":0,"clear":1,"text":"R=255"},{"line":1,"position":5,"clear":1,"text":"G=0"},{"line":2,"position":10,"clear":1,"text":"B=0"},{"line":3,"position":15,"clear":1,"text":"Color"}]}'
-- The result of the command is a JSON formatted string, i.e.
-- {"status": "OK", "title": "Lines written #4"}
-- {"status": "ERROR", "title": "Error message"}
-- 20200225 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux

local CMD = "python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py"

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
        local R,G,B = 0,0,0
		if (device.level == LEVELRED) then R=255 end
		if (device.level == LEVELYELLOW) then R,G=255,255 end
		if (device.level == LEVELGREEN) then G=255 end

	    local lcdlines = '[' ..
		        '{"line":0,"position":0,"clear":1,"text":"R=%d"},' ..
		        '{"line":1,"position":5,"clear":1,"text":"G=%d"},' ..
		        '{"line":2,"position":10,"clear":1,"text":"B=%d"},' ..
		        '{"line":3,"position":15,"clear":1,"text":"Color"}' ..
		        ']'
 
		-- domoticz.log(linetime, domoticz.LOG_INFO)
        local args = string.format('{"UID":"%s","LCDLINES":%s}',"BHN",string.format(lcdlines,R,G,B))
		-- domoticz.log(args, domoticz.LOG_INFO)

        -- define the python command with json argument.
        local pycmd = string.format('%s \'%s\'',CMD,args)
		domoticz.log(pycmd, domoticz.LOG_INFO)
		
		-- run the external python scripts ad handle return code
		local output,rt = osExecute(pycmd)
		-- test result, i.e. for setting color to red
		-- 0:{"status": "OK", "title": "255,0,0"}
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

