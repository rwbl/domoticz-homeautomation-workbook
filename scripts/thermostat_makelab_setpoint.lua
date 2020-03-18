-- thermostat_makelab_setpoint
-- set the setpoint of the radiator thermostat channel HmIP-eTRV-2 000A18A9A64DAC:1
-- set a new setpoint via url example:
-- http://ccu-ip/config/xmlapi/statechange.cgi?ise_id=1584&new_value=17.0
-- response:
-- <result><changed id="1584" new_value="17.0"/></result>

-- Domoticz device idx
local IDX_MAKELAB_THERMOSTAT_SETPOINT = 49;

-- raspmatic datapoint id taken from statelist
-- <datapoint type="SET_POINT_TEMPERATURE" ise_id="1584" name="HmIP-RF.000A18A9A64DAC:1.SET_POINT_TEMPERATURE" operations="7" timestamp="1575709506" valueunit="°C" valuetype="4" value="20.000000"/>
local ID_DATAPOINT_SETPOINT = 1584;

-- url of the raspmatic webserver to set the new setpoint
local URL_RASPMATIC = 'http://ccu-ip/config/xmlapi/statechange.cgi?ise_id=' ..  ID_DATAPOINT_SETPOINT .. '&new_value='

-- callback of the url request - must be unique across all dzevents - use prefix res + script name
local RES_RASPMATIC = 'res_makelab_thermostat_setpoint';

-- helper to round a number to n decimals
local DECIMALS = 1;

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

return {
	on = {
		devices = {
			IDX_MAKELAB_THERMOSTAT_SETPOINT
		},
		httpResponses = {
			RES_RASPMATIC
		}
	},
	execute = function(domoticz, item)
        -- check if the item is the device to than trigger the setpoint change using the levelname (0,17,18,...)
		if (item.isDevice) then
    		domoticz.log('Device ' .. domoticz.devices(IDX_MAKELAB_THERMOSTAT_SETPOINT).name .. ' was changed to ' .. tostring(domoticz.devices(IDX_MAKELAB_THERMOSTAT_SETPOINT).levelName), domoticz.LOG_INFO)
		    -- get the new setpoint from the levelname
		    -- 0%=0(OFF) ; 10%-40%=18-21 ; min=18, max=21
		    local level = domoticz.devices(IDX_MAKELAB_THERMOSTAT_SETPOINT).levelName;
		    local newsetpoint = tonumber(level);
		    -- set the new setpoint
		    domoticz.log('New setpoint:' .. URL_RASPMATIC .. tostring(newsetpoint), domoticz.LOG_INFO);
			domoticz.openURL({url = URL_RASPMATIC ..tostring(newsetpoint), method = 'POST', callback = RES_RASPMATIC});
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then
                -- the full http xml response: domoticz.log(item.data);
			    -- parse the response using XPath
			    -- select the attribute value of the changed element (this is XPath syntax)
			    -- <changed id="1584" new_value="18"/>
                domoticz.log('CCU Response new value: ' .. domoticz_applyXPath(item.data,'//changed[@id="1584"]/@new_value'))
                -- The response could also be logged to an alert or control message device to log changes
			else
				domoticz.log('[ERROR] handling HTTP request:' .. item.statusText, domoticz.LOG_ERROR)
			end
		end
    end
}