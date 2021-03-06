--[[
    volumio_getstate.lua
    Send, every 1 minute, a HTTP Request (GET) to the Volumio server (PineA64) to get the state (command=getstate)
    The Volumio response is a JSON string.
    Update the device "Volumio Current Song" (idx=144, VirtualSensors,General,Text), if the text has changed.

    Request Example obtaining the state: (in case spaces are required ensure to replace the space by a +)
    requesturl = 'volumio.local/api/v1/getstate'

    Request Result JSON string (only relevant fields shown  = not the full JSON string)
    {"status":"play","title":"MyTitle","artist":"Blues Radio","album":null,"trackType":"webradio","volume":78,"mute":false}
    Obtain the status ("play"), title ("MyTitle")

    TODO:
    Seek for a solution to immediate update the current song text after Volumio plays a new song.
    For now, the update happens once a minute - as default by Domoticz.
    WORKAROUND: Switch which updates the state if pressing on.

    Project: atHome
    Interpreter: dzVents, Timer, httpResponses
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190228
]]--

-- request url 
local requesturl = 'volumio.local/api/v1/getstate'

-- domoticz idx of the devices
local IDX_VOLUMIOCURRENTSONG = 144
local IDX_VOLUMIOPLAYSWITCH = 149
local IDX_VOLUMIOSTATUS = 151
local IDX_VOLUMIOREFRESHSWITCH = 155

-- messages
local MSGVOLUMIOOFF = 'Volumio turned OFF'    
local MSGVOLUMIOPLAY = 'PLAY'
local MSGVOLUMIOSTOP = 'STOP'
local MSGVOLUMIOOFF = 'OFF'

-- volumio status (play,stop), current song title
local status
local title
local currenttitle

return {
    -- active = true,
	on = {
		timer = {
		    'every minute'
		},
		devices = {
		    IDX_VOLUMIOREFRESHSWITCH
		},
		httpResponses = {
            'volumioGetState'
        }
	},
	execute = function(domoticz, item)

        -- if the timer is executed or the update switch is set to on, then 
        -- place http get request, which result is handled by the callback.
        if ((item.isTimer) or (item.isDevice)) then

            -- request the volumio state handled via callback item.isHTTPResponse
            -- but only if the switch Volumio Play is ON
		    if (domoticz.devices(IDX_VOLUMIOPLAYSWITCH).state == 'On') then
                domoticz.openURL({
                    url = requesturl,
                    method = 'GET',
                    callback = 'volumioGetState'
                })
            end
        
            -- if update request via switch, then set the update request switch off 
            if (item.isDevice) then
                domoticz.log('Volumio HTTP Response request via switch', domoticz.LOG_INFO)
    		    if (domoticz.devices(IDX_VOLUMIOREFRESHSWITCH).state == 'On') then
	    	        domoticz.devices(IDX_VOLUMIOREFRESHSWITCH).switchOff()
		        end
            end

		end

		-- callback handling the url get request response
        if (item.isHTTPResponse) then

            -- for debugging
            -- domoticz.log('Volumio HTTP Response', domoticz.LOG_INFO)

            -- http response is ok, lets check the title
            if (item.ok) then -- statusCode == 2xx

                -- get the current title
                currenttitle = domoticz.devices(IDX_VOLUMIOCURRENTSONG).text

                -- parse the http response json string to get the volumio status & title
                status = item.json.status
                title = item.json.title

                -- update the current song title if title has changed
                if (title ~= currenttitle) and (currenttitle ~= nil) and (title ~= nil) then
                    -- update the volumio current song device
                    domoticz.devices(IDX_VOLUMIOCURRENTSONG).updateText(title)
                    domoticz.log('[INFO] Volumio Current Song updated: ' .. title, domoticz.LOG_INFO)
                else
                    domoticz.log('[INFO] Volumio Current Song playing: ' .. currenttitle, domoticz.LOG_INFO)
                end
            end

            -- http response error
            if not (item.ok) then -- statusCode != 2xx
                -- title = MSGVOLUMIOOFF
                domoticz.devices(IDX_VOLUMIOPLAYSWITCH).switchOff()
                -- domoticz.devices(IDX_VOLUMIOSTATUS).updateAlertSensor(4, MSGVOLUMIOOFF)
                local message = '[ERROR] Volumio Current Song update: Code=' .. tostring(item.statusCode) .. ' ' .. msgbox.isnowdatetime(domoticz)
                -- domoticz.helpers.alertmsg(domoticz, domoticz.ALERTLEVEL_YELLOW, message)
                -- log
                domoticz.log(message, domoticz.LOG_INFO)
            end

        end
	end
}

