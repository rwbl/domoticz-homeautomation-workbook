local utils = require('utils')

return {
	on = {
		timer = {
			'every minute'
		}
	},
	execute = function(domoticz, timer)
	    domoticz.log("Running Python...")
	    os.execute('bash um.sh')
	end
}
