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
