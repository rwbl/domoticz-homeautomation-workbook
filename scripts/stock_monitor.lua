--[[
    monitor_stocks.lua
    Monitor if a stock has reached its threshold and send out a notification.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190215
]]--

-- External modules:
local utils = require('utils')
local msgbox = require('msgbox')

-- Stock - idx device, idx uservariable threshold, idx uservariable thresholdnotified
local IDX_STOCKA = 152
local IDX_TH_STOCKA = 8
local IDX_TH_STOCKA_NOTIFIED = 9

-- temp var for the threshold value
local thresholdvalue
-- flag to check if notified, to avoid notifying for every change above threshold
local thresholdnotified = 0
-- message
local message

return {
	on = {
		devices = {
			IDX_STOCKA
		}
	},
	execute = function(domoticz, device)
 		domoticz.log('Device ' .. device.name .. ' was changed  to '.. device.state, domoticz.LOG_INFO)

        -- select the device to obtain the thresholdvalue
        if device.idx == IDX_STOCKA then
            thresholdvalue = domoticz.variables(IDX_TH_STOCKA).value
            thresholdnotified = domoticz.variables(IDX_TH_STOCKA_NOTIFIED).value
 		    domoticz.log('Device ' .. device.name .. ': '.. tostring(thresholdvalue) .. ', ' .. tostring(thresholdnotified), domoticz.LOG_INFO)
        end;
        -- add more devices

        -- check if notified flag is set (> -1)
        if (thresholdnotified ~= -1) then
            
            -- reset the message
            message = ''

            -- check if the device value equals or geater threshold (user_variable)
            -- log and notify accordingly
    	    if (tonumber(device.state) >= thresholdvalue) then
                -- update alert message,only if notifiedflag = 0 to avoid duplication
                if thresholdnotified == 0 then
                    thresholdnotified = 1
                    message = device.name .. ' ' .. tonumber(device.state) .. ' reached threshold ' ..  tostring(thresholdvalue)
                    -- DEBUG domoticz.log(message, domoticz.LOG_INFO) 
                end
 	        end
            
            -- below threshold,then reset flag and set message
    	    if (tonumber(device.state) < thresholdvalue) then
    	        if thresholdnotified == 1 then
                    message = device.name .. ' ' .. tonumber(device.state) .. ' below threshold ' ..  tostring(thresholdvalue)
    	            thresholdnotified = 0
                    --  DEBUG domoticz.log(message, domoticz.LOG_INFO) 
        	    end
            end

            -- check if the message is empty
            if (message ~= '') then
                -- update the user variable
                domoticz.variables(IDX_TH_STOCKA_NOTIFIED).set(thresholdnotified)
                -- write to log
                domoticz.log(message, domoticz.LOG_INFO) 
                -- set the alert message
                msgbox.alertmsg(domoticz, domoticz.ALERTLEVEL_ORANGE, message)
                -- and notification
                -- domoticz.notify(message)
            end
      
        end

	end
}
