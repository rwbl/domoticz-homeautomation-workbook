--[[
    monitor_stocks.lua
    Monitor if a stock has reached its threshold and send out a notification.
	This version uses persistent data to keep track if notified toavoid constant notifying if data has changed.
    Project: atHome
    Interpreter: dzVents, Device
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190303
]]--

-- Stock constants
-- idx device
local IDX_STOCK_RDS = 152           -- price
local IDX_TH_STOCK_RDS = 8          -- threshold
local IDX_STOCK_RDS_TOTAL = 156     -- total value all shares
local IDX_DEF_STOCK_RDS_COUNT = 12  -- number of shares

-- temp vars
local thresholdvalue
local stockvalue = 0
-- message
local message

return {
	on = {
		devices = {
			IDX_STOCK_RDS
		},
	},
	data = {
        -- flag to check if notified, to avoid notifying for every change above threshold
	    thresholdnotified = { initial = 0 }    
	},
	execute = function(domoticz, device)

		    domoticz.log('Device ' .. device.name .. ' was changed  to '.. device.state, domoticz.LOG_INFO)

            -- select the device to obtain the thresholdvalue
            if device.idx == IDX_STOCK_RDS then
                -- get threshold
                thresholdvalue = domoticz.variables(IDX_TH_STOCK_RDS).value
 		        domoticz.log('Device ' .. device.name .. ': '.. tostring(thresholdvalue) .. ', ' .. tostring(domoticz.data.thresholdnotified), domoticz.LOG_INFO)
 		        
 		        -- update total value custom sensor
 		        stockvalue = math.floor(domoticz.variables(IDX_DEF_STOCK_RDS_COUNT).value * tonumber(device.state))
 		        domoticz.log('Device ' .. device.name .. ' Stock Value: '.. tostring(stockvalue), domoticz.LOG_INFO)
                domoticz.devices(IDX_STOCK_RDS_TOTAL).updateCustomSensor(stockvalue)
            end
            -- add more devices

            -- check if notified flag is set (> -1)
            if (domoticz.data.thresholdnotified ~= -1) then
            
                -- reset the message
                message = ''

                -- check if the device value equals or geater threshold (user_variable)
                -- log and notify accordingly
    	        if (tonumber(device.state) >= thresholdvalue) then
                    -- update alert message,only if notifiedflag = 0 to avoid duplication
                    if domoticz.data.thresholdnotified == 0 then
                        domoticz.data.thresholdnotified = 1
                        message = device.name .. ' ' .. tonumber(device.state) .. ' reached threshold ' ..  tostring(thresholdvalue)
                        -- DEBUG domoticz.log(message, domoticz.LOG_INFO) 
                    end
 	            end
            
                -- below threshold,then reset flag and set message
    	        if (tonumber(device.state) < thresholdvalue) then
    	            if domoticz.data.thresholdnotified == 1 then
                        message = device.name .. ' ' .. tonumber(device.state) .. ' below threshold ' ..  tostring(thresholdvalue)
    	                domoticz.data.thresholdnotified = 0
                        --  DEBUG domoticz.log(message, domoticz.LOG_INFO) 
        	        end
                end

                -- check if the message is empty
                if (message ~= '') then
                    -- write to log
                    domoticz.log(message, domoticz.LOG_INFO) 
                    -- set the alert message
                    domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_ORANGE, message)
                    -- and notification
                    -- domoticz.notify(message)
                end
      
           end

	    end
}

