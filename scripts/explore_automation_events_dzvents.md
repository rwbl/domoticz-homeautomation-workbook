# Explore Automation Events
These scripts are not used anymore but kept as learning reference. 

## dzVents Lua
            
### dzVents Lua basement_humidity_monitor_d.lua
```
--~/domoticz/scripts/lua/basement_humidity_monitor_d.lua
-- Monitor the basement humidity if exceeds threshold and write to Domoticz log.
-- Thresholds
-- Set the threshold to monitor the humidity (%RH)
local HumidityThreshold = 70;

-- dzVent
return {
	on = {
		devices = {
			'Keller'
		}
	},
	execute = function(domoticz, device)
	    if (device.name == 'Keller' and device.humidity >= HumidityThreshold) then
	        domoticz.log('Basement Humidity >= ' .. HumidityThreshold .. ' (' .. device.humidity .. ')', domoticz.LOG_INFO)
            -- domoticz.notify('Fire', 'The room is on fire', domoticz.PRIORITY_EMERGENCY)
        end
end
}
```

### dzVents Lua ambient_light_control_espeasy.lua

```
--[[
    ambient_light_control_espeasy.lua
    Measure the ambient light Lux value and if below threshold switch on hue light.
]]--

-- Idx of the devices used
local IDX_AMBIENT_LIGHT = 46
local IDX_HUE_MAKELAB = 118
local IDX_TH_AMBIENT_LIGHT = 10

return {
	on = {
		devices = {
			IDX_AMBIENT_LIGHT
		}
	},
	execute = function(domoticz, device)
	    -- get the threshold
	    local althreshold = domoticz.variables(IDX_TH_AMBIENT_LIGHT).value
	    
		domoticz.log('Device ' .. device.name .. ' changed to ' .. tostring(device.lux) .. ' / ' .. tostring(althreshold), domoticz.LOG_INFO)
		
		-- check threshold
        if (device.lux < althreshold) and (domoticz.devices(IDX_HUE_MAKELAB).state == 'Off') then
    		domoticz.log('Ambient Light below threshold. Switched on light', domoticz.LOG_INFO)
            domoticz.devices(IDX_HUE_MAKELAB).switchOn()
            -- optional check leveland set to default 20%
            if domoticz.devices(IDX_HUE_MAKELAB).level  < 20 then
                domoticz.devices(IDX_HUE_MAKELAB).dimTo(20)
            end
        end
    end
}
```

### dzVents Luael ectric_usage_makelab.lua

```
--[[
-- electric_usage_makelab.lua
-- url request from the homematic (raspberrymatic) server, to obtain power & energy data from a single device.
-- url 'http://ccu-ip-addressconfig/xmlapi/state.cgi?device_id=1418'
-- device HMIP-PSM is an actuator switch with status report measured value channel
-- NOTE:
-- This script is replaced by the domoticz python plugin hmip-psm.
]]--

-- domoticz device hw virtualsensors, type general, subtype kwh
local IDX_ELECTRICUSAGEMAKELAB = 174;

-- homematic defines
local ID_DEVICE = 1418;

-- url of the CCU to obtain device information
local URL_CCU = 'http://ccu-ip-address/config/xmlapi/state.cgi?device_id=' .. ID_DEVICE;

-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'electricusagemakelab';

-- helper to round a number to n decimals
local DECIMALS = 2;

return {
	on = {
		timer = {
			'every minute'
			-- 'every 5 minutes'
		},
		httpResponses = {
			RES_CCU -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)

        -- check the timer to place the url request
		if (item.isTimer) then
			domoticz.openURL({ url = URL_CCU, method = 'GET', callback = RES_CCU })
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then

                -- multiple datapoints
			    -- domoticz.log(item.data);
			    -- parse the response using XPath
			    -- select the attribute value of the datapoint element (this is XPath syntax)
                local powervalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1471"]/@value')   -- W
                local energyvalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1467"]/@value')  -- Wh
                domoticz.log('Power Value: ' .. powervalue) 
                domoticz.log('Energy Value: ' .. energyvalue) 
				-- update the energy device with power and energyvalue
				domoticz.devices(IDX_ELECTRICUSAGEMAKELAB).updateElectricity(
				    domoticz.helpers.roundnumber(tonumber(powervalue),2),     -- W
				    domoticz.helpers.roundnumber(tonumber(energyvalue),2) )   -- Wh
                			    
			else

				domoticz.log('[ERROR] Problem handling the request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end

	end
}
```

### dzVents Lua hue_control.lua

```
local IDX_HUE_MAKELAB = 118;

return {
	on = {
	    devices = { IDX_HUE_MAKELAB }
    },
	execute = function(domoticz, device)
		domoticz.log('Device ' .. device.name .. ' changed to ' .. device.state, domoticz.LOG_INFO)
		if (device.state == 'On') then
            local msg = device.name .. ' switched on at ' .. domoticz.helpers.isnow(domoticz)
            domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_YELLOW, msg)
		    domoticz.log(msg, domoticz.LOG_INFO)
		end
	end
}
```

### dzVents Lua hue_control_espeasy.lua

```
--[[
    hue_control_espeasy.lua
    Control a Hue Light via ESO8266 NodeMCU running ESPEasy.
]]--

-- Idx of the devices used
local IDX_ESPEASY_HUE_LIGHT = 154
local IDX_HUE_MAKELAB = 118

return {
	on = {
		devices = {
		    IDX_ESPEASY_HUE_LIGHT
		},
	},
    data = {
      prevvalue = { initial = -1 }
    },
	execute = function(domoticz, device)
        local currvalue = math.floor(tonumber(device.text))
	    if domoticz.data.prevvalue == -1 then
	        domoticz.data.prevvalue = currvalue 
	    end
		domoticz.log('Device ' .. device.name .. ' changed from ' ..  tostring(domoticz.data.prevvalue) .. ' to ' .. tostring(currvalue), domoticz.LOG_INFO)
        --  handle noise, i.e. make changes delta > 1
        if (math.abs(domoticz.data.prevvalue - currvalue)) > 1 then
            domoticz.data.prevvalue = currvalue
	        if (domoticz.devices(IDX_HUE_MAKELAB).state == 'Off') then
	            domoticz.devices(IDX_HUE_MAKELAB).switchOn()
		    end
            domoticz.devices(IDX_HUE_MAKELAB).dimTo(currvalue)
        end
	end
}
```

### dzVents Lua powerswitch_makelab.lua

```
--[[
-- powerswitch_makelab.lua
-- switch the homematic powerplug device (located in the makelab) on / off.
-- the device HMIP-PSM is an actuator switch with status report measured value channel.
-- switching is triggered by sending an url request to raspberrymatic server using the xmlapi addon.
-- the url request uses the xmlapi script statechange with the channel id nd the new value.
-- example switching the plug on: http://ccu-ip-address/config/xmlapi/statechange.cgi?ise_id=1451&new_value=true
-- response XML string:
-- <?xml version="1.0" encoding="ISO-8859-1"?><result><changed id="1451" new_value="true"/></result>
-- notes:
-- to obtain the channel id, use the url: http://ccu-ip-addressconfig/xmlapi/statelist.cgi
-- then search for the device, i.e. HMIP-PSM 0001D3C99C6AB3 which is taken from the HomeMatic Web-UI
-- NOTE:
-- This scripts is replaced by the domoticz python plugin hmip-psm. 
]]--

-- Domoticz device switch on/off (named MakeLab Powerswitch)
local IDX_POWERSWITCH_MAKELAB = 177;

-- RaspMatic switch datapoint id (name="HmIP-RF.0001D3C99C6AB3:3.STATE") from device HMIP-PSM 0001D3C99C6AB3:3
-- <channel ise_id="1446" name="HMIP-PSM 0001D3C99C6AB3:3" operate="true" visible="true" index="3">
--  <datapoint ise_id="1451" name="HmIP-RF.0001D3C99C6AB3:3.STATE" type="STATE" operations="7" timestamp="1561132973" valueunit="" valuetype="2" value="false"/>
-- </channel>
local ID_DATAPOINT_STATE = 1451

-- CCU url to switch on/off. use statechange.cgi with value true/false
local URL_CCU = 'http://ccu-ip-address/config/xmlapi/statechange.cgi?ise_id=' .. ID_DATAPOINT_STATE .. '&new_value='
-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'powerswitchmakelab';

return {
	on = {
		devices = {
			IDX_POWERSWITCH_MAKELAB
		},
		httpResponses = {
			RES_CCU -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)

        if (item.isDevice) then
    		domoticz.log('Device ' .. domoticz.devices(IDX_POWERSWITCH_MAKELAB).name .. ' was changed to ' .. domoticz.devices(IDX_POWERSWITCH_MAKELAB).state, domoticz.LOG_INFO);
            local state = 'true';		
		    -- check the switch state
		    if domoticz.devices(IDX_POWERSWITCH_MAKELAB).state == 'Off' then
		        state = 'false';
		    end

            -- send the url
            domoticz.openURL({ url = URL_CCU .. state, method = 'GET',	callback = RES_CCU });
        end;

        -- check if the item is a http response from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then
				domoticz.log('[INFO] Switch : ' .. item.statusText)
			else
				domoticz.log('[ERROR] Can not switch :' .. item.statusText, domoticz.LOG_ERROR)
			end
		end

	end
}
```

### dzVents Lua thermostat_dining_control

```
-- thermostat_dining_control
-- control thermostat dining room: set setpoint, get temperature, get operating voltage

-- homematic http xml-api request url
local URL_RASPMATIC_GET = 'http://ccu-ip-address/config/xmlapi/state.cgi?datapoint_id=';
-- datapoints defined as JSON key:value pairs. required the library JSON.lua (for Linux):
JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()

-- Thermostat Dining (Domoticz idx/RaspMatic datapoint)
-- setpoint idx=191/ise_id=3418, temperature idx=192/ise_id=3401, voltage=193/ise_id=3387
local DP3418 = JSON:decode('{"name":"Thermostat Dining Setpoint","idx":191,"id":3418,"xpath":"//changed[@id=3418]/@new_value","response":"RESDP3418"}');
local DP3401 = JSON:decode('{"name":"Thermostat Dining Temperature","idx":192,"id":3401,"xpath":"//datapoint[@ise_id=3401]/@value","response":"RESDP3401"}');
local DP3387 = JSON:decode('{"name":"Thermostat Dining Voltage","idx":193,"id":3387,"xpath":"//datapoint[@ise_id=3387]/@value","response":"RESDP3387"}');
-- etrv-b device: set low voltage threshold (same as the RaspberryMatic device parameter. Can be defined as user variable.
local TH_ETRVB_LOW_VOLTAGE = 3.0;

-- helper to submit an url (openurl) for changing the setpoint of a homematicip thermostat device
-- get the new setpoint from the levelname
function changesetpoint(domoticz,id,newvalue)
    local urlraspmatic = 'http://ccu-ip-address/config/xmlapi/statechange.cgi?ise_id=' .. id .. '&new_value=' .. newvalue
    domoticz.openURL({url = urlraspmatic, method = 'POST', callback = 'RESDP' .. id});
    domoticz.log('New setpoint:' .. urlraspmatic, domoticz.LOG_INFO);
end

-- helper to round a number to n decimals
local DECIMALS = 1;
function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

return {
	on = {
	    timer = {
	        -- 'every minute'      -- for tests
	        'every 30 minutes'    
        },
		devices = {
			DP3418.idx, DP3401.idx, DP3387.idx
		},
		httpResponses = {
			DP3418.response, DP3401.response, DP3387.response
		}
	},
	execute = function(domoticz, item)
        if (item.isTimer) then
            domoticz.log('TIMER');
            domoticz.openURL({url = URL_RASPMATIC_GET .. DP3401.id, method = 'GET', callback = DP3401.response})
            domoticz.openURL({url = URL_RASPMATIC_GET .. DP3387.id, method = 'GET', callback = DP3387.response})
        end

        -- check if the item is the device to than trigger the setpoint change using the levelname (0,17,18,...)
		if (item.isDevice) then
		    domoticz.log('DEVICE:' .. item.idx .. '=' .. item.name);

            -- select the device
            -- thermostat dining setpoint
            if (item.idx == DP3418.idx) then
    		    local newsetpoint = tonumber(domoticz.devices(DP3418.idx).levelName)
		        -- set the new setpoint
                changesetpoint(domoticz,DP3418.id, newsetpoint)                
            end

		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
            domoticz.log('HTTP:' .. item.callback);
			if (item.statusCode == 200) then
			    -- select the response
                -- setpoint has changed
			    if (item.callback == DP3418.response) then
                    -- "xpath":"//changed[@id=3418]/@new_value
			        -- <changed id="3418" new_value="20" /></result>
			        domoticz.log('DP3418 setpoint changed:' .. domoticz_applyXPath(item.data, DP3418.xpath))
			    end
			    -- Temperature
			    if (item.callback == DP3401.response) then
                    -- "xpath":"//datapoint[@ise_id=3401]/@value"
                    -- <datapoint value="19.400000" ise_id="3401"/>
                    local temperature = tonumber(domoticz_applyXPath(item.data, DP3401.xpath))
                    domoticz.devices(DP3401.idx).updateTemperature(temperature)
			    end
                -- Voltage			    
			    if (item.callback == DP3387.response) then
                    -- <datapoint value="3.100000" ise_id="3387"/>			    
                    local voltage = tonumber(domoticz_applyXPath(item.data, DP3387.xpath))
                    domoticz.devices(DP3387.idx).updateVoltage(voltage)
			    end
			    
			else
				domoticz.log('[ERROR] handling HTTP request:' .. item.statusText, domoticz.LOG_ERROR)
			end
		end
    end
}
```

### dzVents Lua thermostat_makelab_info.lua

```
-- thermostat_makelab_info.lua
-- get information from the makelab Thermostat
-- HmIP-eTRV-2 000A18A9A64DAC:1
-- Obtain the setpoint
-- http://cu-ip/config/xmlapi/state.cgi?datapoint_id=1584
-- <?xml version="1.0" encoding="ISO-8859-1"?><state><datapoint value="12.000000" ise_id="1584"/></state>
-- NOTE:
-- This script is replaced by the domoticz python plugin hmip-etrv-2.

-- Domoticz device text (named MakeLab Thermostat Info)
local IDX_THERMOSTAT_MAKELAB_INFO = 175;

-- homematic defines
local ID_DEVICE = 1541;

-- url of the CCU to obtain device information
local URL_CCU = 'http://ccu-ip-address/config/xmlapi/state.cgi?device_id=' .. ID_DEVICE;

-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'thermostatmakelabinfo';

-- helper to round a number to n decimals
local DECIMALS = 2;

return {
	on = {
	    timer = {
	        'every minute'    
        },
		httpResponses = {
			RES_CCU -- must match with the callback passed to the openURL command
		}
	},
	execute = function(domoticz, item)
		-- domoticz.log('Device ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).name .. ' was changed to ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_INFO).state, domoticz.LOG_INFO)

        -- check if the item is a device, then request information
		if (item.isTimer) then
			domoticz.openURL({ url = URL_CCU, method = 'GET', callback = RES_CCU })
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then

                -- multiple datapoints
			    -- domoticz.log(item.data);
			    -- parse the response using XPath
			    -- select the attribute value of the datapoint element (this is XPath syntax)
			    
			    -- SETPOINT
			    -- <datapoint ise_id="1584" name="HmIP-RF.000A18A9A64DAC:1.SET_POINT_TEMPERATURE" operations="7" timestamp="1561200486" valueunit="Â°C" valuetype="4" value="4.500000" type="SET_POINT_TEMPERATURE"/>
                local setpointvalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1584"]/@value')   -- C
                -- TEMPERATURE
                -- <datapoint ise_id="1567" name="HmIP-RF.000A18A9A64DAC:1.ACTUAL_TEMPERATURE" operations="5" timestamp="1561200486" valueunit="" valuetype="4" value="23.900000" type="ACTUAL_TEMPERATURE"/>
                local temperaturevalue = domoticz_applyXPath(item.data,'//datapoint[@ise_id="1567"]/@value')  -- Wh
                
                -- log
                domoticz.log('Setpoint: ' .. setpointvalue) 
                domoticz.log('Temperature: ' .. temperaturevalue) 
                local msg = 'Setpoint: ' .. tostring(domoticz.helpers.roundnumber(setpointvalue,1)) .. ', Temperature: ' .. tostring(domoticz.helpers.roundnumber(temperaturevalue,1))
				
				-- update the thermostat info device
				domoticz.devices(IDX_THERMOSTAT_MAKELAB_INFO).updateText(msg);
				
			else

				domoticz.log('[ERROR] Problem handling the request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end

    end
}
```

### dzVents Lua thermostat_makelab_setpoint.lua

```
-- thermostat_makelab_setpoint.lua
-- set the setpoint of the thermostat devices
-- HmIP-eTRV-2 000A18A9A64DAC:1
-- Obtain the setpoint (i.e. 12C) 
-- http://ccu-ip-addressconfig/xmlapi/state.cgi?datapoint_id=1584
-- <?xml version="1.0" encoding="ISO-8859-1"?><state><datapoint value="12.000000" ise_id="1584"/></state>
-- set a new setpoint via url example:
-- http://ccu-ip-addressconfig/xmlapi/statechange.cgi?ise_id=1584&new_value=17.0
-- response:
-- <result><changed id="1584" new_value="17.0"/></result>
-- NOTE
-- This script is replaced by the domoticz python plugin hmip-etrv-2.

-- Domoticz device switch on/off (named MakeLab Thermostat)
local IDX_THERMOSTAT_MAKELAB_SETPOINT = 176;

-- homematic defines
local ID_DATAPOINT_SETPOINT = 1584;

-- url of the raspmatic webserver to set the new setpoint (in .5 steps)
local URL_CCU = 'http://ccu-ip-address/config/xmlapi/statechange.cgi?ise_id=' ..  ID_DATAPOINT_SETPOINT .. '&new_value='

-- callback of the url request - must be unique across all dzevents
local RES_CCU = 'thermostatmakelabsetpoint';

-- helper to round a number to n decimals
local DECIMALS = 2;

return {
	on = {
		devices = {
			IDX_THERMOSTAT_MAKELAB_SETPOINT
		},
		httpResponses = {
			RES_CCU
		}
	},
	execute = function(domoticz, item)
		domoticz.log('Device ' .. domoticz.devices(IDX_THERMOSTAT_MAKELAB_SETPOINT).name .. ' was changed to ' .. tostring(domoticz.devices(IDX_THERMOSTAT_MAKELAB_SETPOINT).level), domoticz.LOG_INFO)

        -- check the timer to place the url request
		if (item.isDevice) then
		    -- get the new SETPOINT
		    -- 0%=0(OFF) ; 10%-40%=18-21 ; min=18, max=21
		    local level = domoticz.devices(IDX_THERMOSTAT_MAKELAB_SETPOINT).level;
		    local newsetpoint = 0;
		    if level > 0 then
		        newsetpoint = 17 + (level * 0.1);
	        end
		    -- set the new setpoint
		    domoticz.log('New setpoint:' .. URL_CCU .. tostring(newsetpoint), domoticz.LOG_INFO);
			domoticz.openURL({ url = URL_CCU ..tostring(newsetpoint), method = 'POST', callback = RES_CCU });
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then

                -- multile datapoints
			    domoticz.log(item.data);
			    -- parse the response using XPath
			    -- select the attribute value of the datapoint element (this is XPath syntax)
                -- domoticz.log(domoticz_applyXPath(item.data,'//datapoint[@ise_id="1584"]/@value')

			else

				domoticz.log('[ERROR] Problem handling the request:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
			end
		end



    end
}
```

### dzVents Lua security_reset.lua

```
--[[
    security_reset.lua
    Reset the state to Normal for X10 switches as these do not reset by themselves from state Alarm + Tamper.
]]--

-- Idx of the devices used
-- User variable holding the state of the alarm(0=Normal, 1=Alarm)
local IDX_DEF_SECURITY_ALARM = 13
-- The push button to reset the contacts
local IDX_SECURITY_RESET = 162
-- Array of the idx for the security devices: security front door, ...
local SECURITYDEVICES = {160}

return {
	on = {
		devices = {
			IDX_SECURITY_RESET
		}
	},
	execute = function(domoticz, device)
		domoticz.log('SECURITY RESET: ' .. device.name, domoticz.LOG_INFO)
		
        -- Loop over the array of device idx's and set state to normal
        for i, idx in ipairs(SECURITYDEVICES) do
            domoticz.devices(idx).setState('Normal')
        end

        -- Reset the user variable, holding the alarm state, to 0
        if (domoticz.variables(IDX_DEF_SECURITY_ALARM).value == 1) then
            domoticz.variables(IDX_DEF_SECURITY_ALARM).set(0)
        end

		-- Send notification
		-- domoticz.email('Security Alert', 'The devices are resetted to state Normal ', 'someone@the.world.org')

	end
}
```

### dzVents Lua monitor_stocks.lua

```
--[[
    monitor_stocks.lua
    Monitor if a stock has reached its threshold and send out a notification.
	This version uses persistent data to keep track if notified toavoid constant notifying if data has changed.
]]--

-- Stock constants
-- idx device
local IDX_STOCKA = 152           -- price
local IDX_TH_STOCKA = 8          -- threshold
local IDX_STOCKA_TOTAL = 156     -- total value all shares
local IDX_DEF_STOCKA_COUNT = 12  -- number of shares

-- temp vars
local thresholdvalue
local stockvalue = 0
-- message
local message

return {
	on = {
		devices = {
			IDX_STOCKA
		},
	},
	data = {
        -- flag to check if notified, to avoid notifying for every change above threshold
	    thresholdnotified = { initial = 0 }    
	},
	execute = function(domoticz, device)

		    domoticz.log('Device ' .. device.name .. ' was changed  to '.. device.state, domoticz.LOG_INFO)

            -- select the device to obtain the thresholdvalue
            if device.idx == IDX_STOCKA then
                -- get threshold
                thresholdvalue = domoticz.variables(IDX_TH_STOCKA).value
 		        domoticz.log('Device ' .. device.name .. ': '.. tostring(thresholdvalue) .. ', ' .. tostring(domoticz.data.thresholdnotified), domoticz.LOG_INFO)
 		        
 		        -- update total value custom sensor
 		        stockvalue = math.floor(domoticz.variables(IDX_DEF_STOCKA_COUNT).value * tonumber(device.state))
 		        domoticz.log('Device ' .. device.name .. ' Stock Value: '.. tostring(stockvalue), domoticz.LOG_INFO)
                domoticz.devices(IDX_STOCKA_TOTAL).updateCustomSensor(stockvalue)
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
```

### dzVents Lua thermostat_timer.lua

```
--[[
    thermostat_timer.lua
    Turn thermostat OFF by given time to ensure heating not running overnight
    Update the alert message.
]]--

-- Idx of the devices
local IDX_THERMOSTAT_MAKELAB = 183
local IDX_THERMOSTAT_DINING = 189

-- Update alert message with alert level green.
local function setalertmsg(domoticz, state)
	local message= state .. ' ' .. domoticz.helpers.isnowhhmm(domoticz)
    domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_GREEN, message)
end

local function thermostatswitchon(domoticz,idx)
	domoticz.devices(idx).switchOn()
    setalertmsg(domoticz, 'MakeLab Thermostat on')
end

local function thermostatswitchoff(domoticz,idx)
	domoticz.devices(idx).switchOff()
    setalertmsg(domoticz, 'MakeLab Thermostat off')
end

return {
    active = true,
    on = {
        timer = {
	        'at 19:00',
	        'at 22:11',
	        'at 07:00'
        }
    },
    execute = function(domoticz, timer)

        if (timer.trigger == 'at 19:00') then
            thermostatswitchoff(domoticz,IDX_THERMOSTAT_MAKELAB)
        end

        if (timer.trigger == 'at 22:11') then
            domoticz.devices(IDX_THERMOSTAT_DINING).switchSelector(10)
            setalertmsg(domoticz, 'Thermostat Dining 10%')
        end

        if (timer.trigger == 'at 07:00') then
            domoticz.devices(IDX_THERMOSTAT_DINING).switchSelector(40)
            setalertmsg(domoticz, 'Thermostat Dining 40%')
        end

    end
}
```

### dzVents Lua waste_calendar_notifier.lua

```
--[[
    waste_calendar_notifier.lua
    The notifier informs via email 
    (receipients defined in the Domoticz Settings Email and Notification) 
    if the waste target date is 1 days from actual date.
]]--

-- Check if the difference between now and the targetdate is 1
function checknotify(domoticz,device,threshold)
	-- domoticz.log('Device ' .. device.name .. ', Text:' .. device.text, domoticz.LOG_INFO)
    -- split the device text holding the wastecal date in format DD-MM-YYYY
	targetdate = domoticz.helpers.split(device.text, '-')
	-- calculate the remaining days
    daysremaining = domoticz.helpers.datediffnow(tonumber(targetdate[1]), tonumber(targetdate[2]), tonumber(targetdate[3]))
    -- check against threshold and notify
    if (daysremaining == threshold) then
        message = '[ACHTUNG] ' .. device.name .. ' ' .. device.text
        -- update alert message
        domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_RED, message)
    	domoticz.log(message, domoticz.LOG_INFO)
        domoticz.notify(message)
    end
end

-- Idx of the devices
local IDX_BIOTONNEPI = 98
local IDX_PAPIERPI = 99
local IDX_RESTMUELLPI = 100
local IDX_GELBERSACKPI = 101
local IDX_SCHADSTOFFPI = 102
local IDX_BIOTONNEHO = 103
local IDX_PAPIERHO = 104
local IDX_RESTMUELLHO = 105
local IDX_GELBERSACKHO = 106

-- threshold in days to notify
-- if the difference of the current day to a wastecalendarday equals threshold
-- then notify
local TH_WASTECAL = 1

return {
	on = {
	    timer = {
            'at 01:00'
            -- 'every minute'
	    },
	},
	execute = function(domoticz)
	    
	    checknotify(domoticz,domoticz.devices(IDX_BIOTONNEPI),TH_WASTECAL)
	    checknotify(domoticz,domoticz.devices(IDX_PAPIERPI),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_RESTMUELLPI),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_GELBERSACKPI),TH_WASTECAL)
        -- checknotify(domoticz,domoticz.devices(IDX_SCHADSTOFFPI),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_BIOTONNEHO),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_PAPIERHO),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_RESTMUELLHO),TH_WASTECAL)
        checknotify(domoticz,domoticz.devices(IDX_GELBERSACKHO),TH_WASTECAL)

    end
}
```
