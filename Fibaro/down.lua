
local hostname = "xxxxx"
local port = "3000"


local nefit = net.HTTPClient({timeout=2000})

current = nefit:request("http://"..hostname..":"..port.."/bridge/ecus/rrc/uiStatus", {
    options={ method = 'GET'},
    success = function(status)
        print "callback"
        data = json.decode(status.data);
        currentTemp = data.value.TSP;
        newTemp = tonumber(currentTemp) - 1
        fibaro:debug("Change temp from "..currentTemp.." to "..newTemp)
        nefit:request("http://"..hostname..":"..port.."/bridge/heatingCircuits/hc1/temperatureRoomManual", {
            options={
                headers = { ["Content-Type"] = "application/json" },
                data = "{\"value\":"..newTemp.."}",
                method = 'POST',
            },
            success = function(status)

                local result = json.decode(status.data);
                print("status");
                fibaro:debug(result);

                if result.status == "ok" then
                    print("successful");
                else
                    print ("failed");
                    print(status.data);
                end
            end,
            error = function(error)
                print "ERROR"
                print(error)
            end
        })
    end
})




