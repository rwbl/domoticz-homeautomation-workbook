-- thermostat_makelab_setpoint.lua
-- set the setpoint of the thermostat devices
-- HmIP-eTRV-2 000A18A9A64DAC:1
-- Obtain the setpoint (i.e. 12C) 
-- http://ccu-ip/config/xmlapi/state.cgi?datapoint_id=1584
-- <?xml version="1.0" encoding="ISO-8859-1"?><state><datapoint value="12.000000" ise_id="1584"/></state>
-- set a new setpoint via url example:
-- http://ccu-ip/config/xmlapi/statechange.cgi?ise_id=1584&new_value=17.0
-- response:
-- <result><changed id="1584" new_value="17.0"/></result>
-- NOTE
-- This script is replaced by the domoticz python plugin hmip-etrv-2.
-- 20190630 by rwbl

-- Domoticz device switch on/off (named MakeLab Thermostat)
local IDX_THERMOSTAT_MAKELAB_SETPOINT = 176;

-- homematic defines
local ID_DATAPOINT_SETPOINT = 1584;

-- url of the raspmatic webserver to set the new setpoint (in .5 steps)
local URL_CCU = 'http://192.168.1.225/config/xmlapi/statechange.cgi?ise_id=' ..  ID_DATAPOINT_SETPOINT .. '&new_value='

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
