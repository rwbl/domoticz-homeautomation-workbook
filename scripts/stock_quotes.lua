--[[
    stock_quotes.lua
    Using Alpha Vantage service www.alphavantage.co with free API key
    Each stock is defined in a JSON string, i.e. '{"symbol":"SYMBOLA","idx":152,"response":"SQMRESA"}'
    Example HTTP API request for a stock symbol:
    https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=SYMBOLA&apikey=YOURAPIKEY
    With response:
    {
    "Global Quote": {
        "01. symbol": "YOURSYMBOL",
        "02. open": "25.7500",
        "03. high": "25.7700",
        "04. low": "25.7350",
        "05. price": "25.7700",
        "06. volume": "5250",
        "07. latest trading day": "2019-12-05",
        "08. previous close": "25.6200",
        "09. change": "0.1500",
        "10. change percent": "0.5855%"
        }
    }    
    Project: domoticz-homeautomation-workbook
    Interpreter: dzVents
    Author: Robert W.B. Linn
    Version: 20191205
]]--

-- HTTP API KEY, URL, JSON response keys used (check out JSON response) and the symbols
local SQM_APIKEY    = '****'   -- Your API Key
local SQM_URL       = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&apikey=' .. SQM_APIKEY .. '&symbol='
-- JSON response keys used - case sensitive (see comments above)
local KEYGLOBALQUOTE    = 'Global Quote'
local KEYSYMBOL         = '01. symbol'
local KEYPRICE          = '05. price'

-- Stocks with Symbol, device idx, unique HTTP response
JSON = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()
local STOCKA = JSON:decode('{"symbol":"YOURSYMBOL","idx":152,"response":"SQMRESA"}')
-- add more
-- local STOCKE = JSON:decode('{"symbol":"YOURSYMBOL","idx":NNN,"response":"SQMRESE"}')

return {
	on = {
		timer = { 'every 30 minutes' },
		-- timer = { 'every minute' }, -- for tests
		httpResponses = {
		    STOCKA.response,STOCKB.response,STOCKC.response,STOCKD.response,
		    --STOCKE.response,
		}
    },
	execute = function(domoticz, item)
	
		if (item.isTimer) then
			domoticz.openURL({url = SQM_URL .. STOCKA.symbol,method = 'GET',callback = STOCKA.response,})
			--domoticz.openURL({url = SQM_URL .. STOCKE.symbol,method = 'GET',callback = STOCKE.response,})
		end

		if (item.isHTTPResponse) then
    
            domoticz.log('SQM Status Code = ' .. item.statusCode .. ', Name=' .. item.callback)

            --
            -- SQM handle response by checking statuscode and callback. The item is type json (item.isJSON)
			-- The complete item data is in property: domoticz.log('R6C = ' .. item.data)
            --
			if (item.statusCode == 200) then
                domoticz.log('SQM Updating ' .. item.callback)
                local symbol = item.json[KEYGLOBALQUOTE][KEYSYMBOL]
                local price = item.json[KEYGLOBALQUOTE][KEYPRICE]

                -- Log the symbol and the price
				domoticz.log(symbol .. ' = ' .. price)

                -- Select the symbol using the item.callback to update the custom device
                if (item.callback == STOCKA.response) then
                    domoticz.devices(STOCKA.idx).updateCustomSensor(price)
                end
                -- add more
                --if (item.callback == STOCKE.response) then
                --    domoticz.devices(STOCKE.idx).updateCustomSensor(price)
                --end
                
		        return
			else
				domoticz.log('[ERROR]:' .. item.statusText, domoticz.LOG_ERROR)
				-- domoticz.log(item, domoticz.LOG_ERROR)
		        return
			end

		end

    end
}
