--[[
    rpi_monitor.lua
    Monitor the Raspberry Pi and notify, via alert message, in case threshold reached or exceeded.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20180910
]]--

-- External modules
local msgbox = require('msgbox')
local utils = require('utils')
 
-- Idx of the devices
local IDX_RPI_MEMORYUSAGE = 1
local IDX_RPI_HDDUSAGE = 3
local IDX_RPI_TEMPERATURE = 4

-- Thresholds are set via user variables, i.e. TH_RPI_MEMORYUSAGE

-- Check if the device state exceeds threshold and update control message
local function checkthreshold(domoticz, device, threshold)
    if (tonumber(device.state) > threshold) then
        local message = device.name .. ' above threshold ' .. threshold .. ' (' .. device.state .. ') ' .. utils.isnowhhmm(domoticz)
        msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_RED, message)
    end
end

return {
	on = {
        -- Devices idx to monitor
		devices = {
			IDX_RPI_MEMORYUSAGE,
			IDX_RPI_HDDUSAGE,
			IDX_RPI_TEMPERATURE
		}
	},
	execute = function(domoticz, device)
        -- Log the change for testing
	    -- domoticz.log('RPi Monitor Device ' .. device.name .. ',' .. device.idx .. ' was changed:' .. device.state .. '/' .. device.rawData[1], domoticz.LOG_INFO)
	    
	    -- select the device
        
        -- RPi Memory Usage
	    if (device.idx == IDX_RPI_MEMORYUSAGE) then
            checkthreshold(domoticz, device, domoticz.variables('TH_RPI_MEMORYUSAGE').value)
		end    

        -- RPi HDD Usage
	    if (device.idx == IDX_RPI_HDDUSAGE) then
            checkthreshold(domoticz, device, domoticz.variables('TH_RPI_HDDUSAGE').value)
		end    

        -- RPi Temperature
	    if (device.idx == IDX_RPI_TEMPERATURE) then
            checkthreshold(domoticz, device, domoticz.variables('TH_RPI_TEMPERATURE').value)
		end    

    end
}

