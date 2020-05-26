-- Domoticz Home Automation Workbook - Function Time Control
-- dzVents Automation Script: time_control_today
-- The script is triggered by a switch (Switch Type Push On Button, idx=102) and executes the sql-command-file.
-- The output of the sql-command-file (as shown previous) is captured and used to update a text device (idx=106).
-- VirtualDevices
-- Type: Light/Switch, SubType:Switch,SwitchType: On/Off, Name: Time Control Today, Idx: 102, Add to dashboard.
-- Type: General, SubType:Text, Name: Time Control Status, Idx: 106, Add to dashboard.
-- 20200221 by rwbL

IDXSWITCH = 102
IDXSTATUS = 106 
SQLCMD = "sqlite3 /home/pi/domoticz/domoticz.db '.read /home/pi/domoticz/scripts/dzVents/scripts/time-control-today.sql'"

-- split a string by delimiter
-- return array, i.e. array[1], array[2]
function splitstring(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

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
	execute = function(domoticz, item)
	    if (item.isDevice) then
		    if (domoticz.devices(IDXSWITCH).state == "On") then
		        output,rt = osExecute(SQLCMD)
                -- local handle = os.execute(sqlcmd)
                rawdate = domoticz.time.rawDate .. " "
                -- add the date to the output
                output = string.format("%s\n%s",rawdate,output)
                domoticz.log(output, domoticz.LOG_INFO)
                -- update the status device
                 domoticz.devices(IDXSTATUS).updateText(output)
                -- Returncode: 0=OK
                domoticz.log(tostring(rt), domoticz.LOG_INFO)
                -- convert the output to a table. Use #outputtable to get the number of entries.
                outputtable = splitstring(output, "\n")
                domoticz.log(outputtable, domoticz.LOG_INFO)
            end
		end 
    end
}
