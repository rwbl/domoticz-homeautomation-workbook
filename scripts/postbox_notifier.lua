--[[
    postbox_notifier.lua
    If the switch postboxnotifier (idx=189) is turned on via a RaspMatic script, than sent a notification.
    The notification contains a hint to turn the switch off manually.
    The state of the homematicIP device "Postbox Notifier" using datapoint Name: HmIP-RF.0000DA498D5859:1.STATE, ID: 2560 triggers setting the domoticz switch.

    The homematicIP device (SWDO) uses a battery which is monitored every 30 minutes if low voltage.
    Datapoint: Device: Postbox Notifier, Name: HmIP-RF.0000DA498D5859:0.OPERATING_VOLTAGE, ID: 2543, Value: 1.500000
    <datapoint ise_id="2543" name="HmIP-RF.0000DA498D5859:0.OPERATING_VOLTAGE" operations="5" timestamp="1575914670" valueunit="" valuetype="4" value="1.500000" type="OPERATING_VOLTAGE"/>

    Interpreter: dzVents
    Author: Robert W.B. Linn
    Version: 20190713
]]--

-- Domoticz Idx
local IDX_POSTBOXNOTIFIER = 189
-- homematic device datapoint id
local URL_RASPMATIC = 'http://192.168.1.225/config/xmlapi/state.cgi?datapoint_id=';
-- datapoint
JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()  -- For Linux
local DATAPOINT2543 = JSON:decode('{"name":"Postbox Notifier Voltage","id":2543,"xpath":"//datapoint[@ise_id=2543]/@value","response":"RESPOSTBOXNOTIFIER"}');
-- swdo devices: low voltage threshold
local TH_SWDO_LOW_VOLTAGE = 1.0;

return {
    -- Combined rules defined
	on = {
	        -- Check the operating voltage datapoint of the SWDO homematicIp device by submitting http xml-pi request
            timer = { 'every 30 minutes' },
            -- Check if the state of the postbox notifier switch has changed to on as triggered by raspmatic script
            devices = { IDX_POSTBOXNOTIFIER },
            -- Handle the response of the http xml-api url request
            httpResponses = { DATAPOINT2543.response, }
    },
	data = {
	    -- set a flag if already notified
	    pbnnotified = { initial = 0 }
    },

    -- Handle rules for the item isDevice, isTimer, isHTTPResponse
	execute = function(domoticz, item)

        -- Handle state change
        if (item.isDevice) then
    		domoticz.log('Device ' .. device.name .. ' changed ' .. domoticz.devices(IDX_POSTBOXNOTIFIER).state .. ' = ' .. tostring(domoticz.data.pbnnotified) )
            -- Send email notification in case device is switched on
            -- Only the subject is used
            if (domoticz.devices(IDX_POSTBOXNOTIFIER).state == 'On') and (domoticz.data.pbnnotified == 0) then
                local subject = 'Postbox opened (' .. domoticz.helpers.isnowhhmm(domoticz) .. ')'
                local message = 'Postbox Notifier: Ensure to reset switch.'
                domoticz.data.pbnnotified = 1
                -- notify via email
                domoticz.notify(subject, message, domoticz.PRIORITY_HIGH)
                -- update the alert message with level orange (3) = does not sent an email if user var TH_ALERTTOEMAIL = 4
                domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_YELLOW, message)
		        domoticz.log('POSTBOXNOTIFIER ' .. device.name .. ' notification sent: ' .. subject .. ' (' .. message .. ')' )
		    end

            -- Reset the notify flag is switch is manually switched Off
            if (domoticz.devices(IDX_POSTBOXNOTIFIER).state == 'Off') and (domoticz.data.pbnnotified == 1) then
                domoticz.data.pbnnotified = 0
		    end
        end

        -- check if the item is a device, then request datapoint information
		if (item.isTimer) then
		    domoticz.openURL({url = URL_RASPMATIC .. DATAPOINT2543.id, method = 'GET', callback = DATAPOINT2543.response,})
		end

        -- check if the item is a httpresponse from the openurl callback
		if (item.isHTTPResponse) then
			if (item.statusCode == 200) then
                -- domoticz.log(item.data);
                -- Select the callback
                if (item.callback == DATAPOINT2543.response) then
                    local voltage = tonumber(domoticz_applyXPath(item.data, DATAPOINT2543.xpath))
                    domoticz.log(DATAPOINT2543.name .. ': ' .. voltage) 
                    if voltage < TH_SWDO_LOW_VOLTAGE then
                        local message= DATAPOINT2543.name .. ':Low Voltage ' .. voltage .. ' ' .. domoticz.helpers.isnowhhmm(domoticz)
                        domoticz.log(message) 
                        domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_RED, message)
                    end
                end
			else
				domoticz.log('[ERROR] Request:' .. item.statusText, domoticz.LOG_ERROR)
			end
        end
    end
}
