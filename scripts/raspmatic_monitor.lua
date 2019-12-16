--[[
    raspmatic_monitor.lua
    Perform checks on the RaspberryMatic server.
    Update the alert message.
    Issue:
    If using the XML-API request on the statelist, the response item.data size is too large to be handled.
    Workaround: XM-API requests on datapoints.
    
    Project: domoticz-homeautomation-workbook
    Interpreter: dzVents
    Author: Robert W.B. Linn
    Version: 20191209
]]--

-- homematic device datapoint id's
local URL_RASPMATIC = 'http://192.168.1.225/config/xmlapi/state.cgi?datapoint_id=';
-- datapoints
JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux
local DATAPOINT2543 = JSON:decode('{"name":"Postbox Notifier Voltage","id":2543,"xpath":"//datapoint[@ise_id=2543]/@value","response":"RESRASPMATICMONITOR2543"}');
-- swdo devices: low voltage threshold
local TH_SWDO_LOW_VOLTAGE = 1.0;

return {
	on = {
	    timer = {
	        'every 30 minutes'    
        },
		httpResponses = {
			DATAPOINT2543.response,
		}
	},
	execute = function(domoticz, item)
        -- check if the item is a device, then request information
		if (item.isTimer) then
		    domoticz.openURL({url = URL_RASPMATIC .. DATAPOINT2543.id, method = 'GET', callback = DATAPOINT2543.response,})
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then

                domoticz.log(item.data);

                -- Select the callback
                if (item.callback == DATAPOINT2543.response) then
                    -- OPERATING_VOLTAGE Postbox Notifier Datapoint 2543
                    -- <datapoint ise_id="2543" name="HmIP-RF.0000DA498D5859:0.OPERATING_VOLTAGE" operations="5" timestamp="1575914670" valueunit="" valuetype="4" value="1.500000" type="OPERATING_VOLTAGE"/>
                    -- local voltage = tonumber(domoticz_applyXPath(item.data,'//datapoint[@ise_id="2543"]/@value'))
                    local voltage = tonumber(domoticz_applyXPath(item.data, DATAPOINT2543.xpath))
                    domoticz.log(DATAPOINT2543.name .. ': ' .. voltage) 
                    if voltage < TH_SWDO_LOW_VOLTAGE then
                        local message= DATAPOINT2543.name .. ':Low Voltage ' .. voltage .. ' ' .. domoticz.helpers.isnowhhmm(domoticz)
                        domoticz.log(message) 
                        -- domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_GREEN, message)
                    end
                end
			else
				domoticz.log('[ERROR] Request:' .. item.statusText, domoticz.LOG_ERROR)
			end
		end

    end
}

