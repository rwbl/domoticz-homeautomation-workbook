-- Domoticz Home Automation Workbook - Function Tinkerforge
-- dzVents Automation Script: tflcd20x4_set_rpi_monitor
-- Setter Example
-- Display the CPU Usage (%) Temperature (C), RAM & Disc usage (%) and the time triggered by timer every minute.
-- The values are rounded with no decimals.
-- The python scripts writes 4 lines to the lcd display.
-- The python script expects an argument with key:value pairs. Example:
-- python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py '{"UID":"BHN","LCDLINES":[{"line":0,"position":14,"clear":1,"text":"\u000913:32"},{"line":1,"position":0,"clear":1,"text":"CPU 11%"},{"line":1,"position":9,"clear":0,"text":"46\u00DFC"},{"line":2,"position":0,"clear":1,"text":"RAM 45%"},{"line":3,"position":0,"clear":1,"text":"DISC 69%"}]}'
-- The result of the command is a JSON formatted string, i.e.
-- {"status": "OK", "title": "Lines written #4"}
-- {"status": "ERROR", "title": "Error message"}
-- Domoticz device keeps the text:
-- Idx=112,Hardware=VirtualDevices,name=LCD Text,Type=General,SubType=Text
-- 20200308 by rwbL

-- json library
local JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux

local CMD = "python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py"

-- Tinkerforge
UIDLCD20X4 = "BHN"

-- Idx devices.
IDXRPICPUTEMP = 2
IDXRPICPUUSAGE = 39
IDXRPIRAMUSAGE = 3
IDXRPIDISCUSAGE = 8
IDXLCDTEXT = 112    -- LCD line 0-3 set by JSON string array

-- split a string by delimiter
-- return array, i.e. array[1], array[2]
function splitstring(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- get the current time from the domoticz instance with time object
-- return time now, i.e. 09:09:00
function isnowtime(domoticz)
    return domoticz.time.rawTime
end

-- get the current time from the domoticz instance with time object
-- return time now, i.e. 09:09
function isnowhhmm(domoticz)
    timearray = splitstring(domoticz.time.rawTime, ':')
    return timearray[1] .. ':' .. timearray[2]
end

function roundnumber(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

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
		domoticz.log('Timer event was triggered by ' .. timer.trigger, domoticz.LOG_INFO)

    	-- Get the data to be displayed (monitored)
    	local cpuusage = roundnumber(tonumber(domoticz.devices(IDXRPICPUUSAGE).sValue), 0)
    	local cputemp = roundnumber(tonumber(domoticz.devices(IDXRPICPUTEMP).sValue), 0)
        local ramusage = roundnumber(tonumber(domoticz.devices(IDXRPIRAMUSAGE).sValue), 0)
        local discusage = roundnumber(tonumber(domoticz.devices(IDXRPIDISCUSAGE).sValue), 0)

        -- Define the JSON string for the lines to be displayed
        -- The % character needs to be escaped with % to %%
        -- The time is displayed line 0 at the right with special character time symbol (index 1 = \u0009)
        local lcdtime = string.format('{"line":0,"position":14,"clear":1,"text":"\\u0009%s"}', isnowhhmm(domoticz) )
        local lcdcpuusage = string.format('{"line":1,"position":0,"clear":1,"text":"CPU  %d%%"}', cpuusage )
        -- To display degree C use the unicode hex value for ° character which is \u00DF (see LCD character table)
        local lcdcputemp = string.format('{"line":1,"position":9,"clear":0,"text":"%d\\u00DFC"}', cputemp )
        local lcdramusage = string.format('{"line":2,"position":0,"clear":1,"text":"RAM  %d%%"}', ramusage )
        local lcddiscusage = string.format('{"line":3,"position":0,"clear":1,"text":"DISC %d%%"}', discusage )
	   	local lcdlines = string.format('[%s,%s,%s,%s,%s]', lcdtime,lcdcpuusage,lcdcputemp,lcdramusage,lcddiscusage)
        domoticz.devices(IDXLCDTEXT).updateText(lcdlines)

        local args = string.format('{"UID":"%s","LCDLINES":%s}',UIDLCD20X4,lcdlines)
		domoticz.log(args, domoticz.LOG_INFO)

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

        -- Clear the device log
        domoticz.openURL('http://localhost:8080/json.htm?type=command&param=clearlightlog&idx=' .. IDXLCDTEXT)
    end
}

