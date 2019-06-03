--[[
    volumio_bookmark.lua
    Bookmark the Volumio current song playing.
    Project: atHome
    Interpreter: dzVents, Devices
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190202
]]--

-- Idx of the devices used
-- Switch Volumio Bookmark
local IDX_VOLUMIO_BOOKMARK = 145
local IDX_VOLUMIO_CURRENTSONG = 144
local IDX_VOLUMIO_FAVORITES = 146

-- Save the bookmarked volumio played song to a file
-- folder: /home/pi/music, file: songtitle (without prefix "Blues Radio ~ ")
function savesong(songtitle)
	local folder = "/home/pi/music/";
	local filename = "";

	-- define the song title
	songtitle = string.gsub(songtitle, "Blues Radio ~ ", "");

	-- set the full filename including folder
	filename = folder .. songtitle;

	-- print (filename);
	
    -- Opens the file in write mode
    file = io.open(filename, "w");
    -- sets the default output file
    io.output(file);
    -- write the title also tot he file
    io.write(songtitle);
    -- closes the open file
    io.close(file)
end

return {
    -- Check which device(s) have a state change
	on = {
		devices = {
			IDX_VOLUMIO_BOOKMARK
		}
	},
    -- Handle the switch if its state has changed to On
	execute = function(domoticz, switch)
		domoticz.log('Device ' .. switch.name .. ' was changed ' .. domoticz.devices(IDX_VOLUMIO_BOOKMARK).state, domoticz.LOG_INFO)
	    if (switch.state == 'On') then
            local message = 'Volumio bookmarked song: ' .. domoticz.devices(IDX_VOLUMIO_CURRENTSONG).text
            domoticz.devices(IDX_VOLUMIO_FAVORITES).updateText(domoticz.devices(IDX_VOLUMIO_CURRENTSONG).text);
            savesong(domoticz.devices(IDX_VOLUMIO_CURRENTSONG).text);
            domoticz.log(message)
	        -- switch.switchOff() NOT REQUIRED as changed to push on button
		end
	end
}


