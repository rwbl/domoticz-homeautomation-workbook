-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tflcd20x4_set_text
-- Setter Example
-- The script is triggered by a switch (Switch Type Push On Button, idx=102) and executes python script.
-- The python script expects an argument with key:value pairs:
-- python3 tflcd20x4_set_text.py '{"UID":"BHN", "LCDLINES":[{"line":0,"position":1,"clear":1,"text":"Text 0"},{"line":1,"position":1,"clear":1,"text":"Text 1"},{"line":2,"position":1,"clear":1,"text":"Text 2"},{"line":3,"position":1,"clear":1,"text":"Text 3"}]}'
-- The result of the command is a JSON formatted string, i.e.
-- {"status": "OK", "title": "Lines written #4"}
-- {"status": "ERROR", "title": "Error message"}
-- VirtualDevices
-- Type: Light/Switch, SubType:Switch,SwitchType: On/Off, Name: Time Control Today, Idx: 12
-- 20200225 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux

local CMD = "python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py"

-- run external command
local function osExecute(cmd)
    local fileHandle     = assert(io.popen(cmd, 'r'))
    local commandOutput  = assert(fileHandle:read('*a'))
    local returnTable    = {fileHandle:close()}
    -- rc[3] contains returnCode
    return commandOutput,returnTable[3]
end

-- split a string by delimiter
-- return array, i.e. array[1], array[2]
function splitstring(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- get the current time from the domoticz instance with time object
-- return time now, i.e. 09:09
function isnowhhmm(domoticz)
    timearray = splitstring(domoticz.time.rawTime, ':')
    return timearray[1] .. ':' .. timearray[2]
end

return {
	on = {
		timer = {
			'every minute',
	   },
    },
	execute = function(domoticz, timer)
		domoticz.log('Timer event was triggered by ' .. timer.trigger, domoticz.LOG_INFO)

        -- JSON
        -- The JSON array has a single entry to set the CHH:MM at line, position
        -- Use string format for only line 3 and clear the display prior writing text
        -- Special character is writte prior time - \u0009 is the second special character (index 1).
        -- Ensure to escape \ and DO NOT USE hex format \xNN as not supported by json.load = use unicode format \uNNNN
        local linetime = '{"line":%d,"position":%d,"clear":2,"text":"%s%s"}'
        -- Random line and position
        local l = math.floor(math.random(0,3))
        local p = math.floor(math.random(0,14))
        linetime = string.format(linetime, l, p, "\\u0009", isnowhhmm(domoticz) )
		-- domoticz.log(linetime, domoticz.LOG_INFO)
        local args = string.format('{"UID":"%s","LCDLINES":[%s]}',"BHN",linetime)
		-- domoticz.log(args, domoticz.LOG_INFO)

        -- define the python command with json argument. example:
        -- python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py '{"UID":"BHN","LCDLINES":[{"line":2,"position":5,"clear":2,"text":"\u000910:59"}]}'
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

