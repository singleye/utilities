description = [[
This is a script to detect QNAP nas.
]]

categories = {"safe", "discover"}

local shortport = require("shortport")
local http = require("http")
local math = require("math")
local os = require("os")

-- portrule = shortport.port_or_service(80, "http")
portrule = shortport.http

math.randomseed(os.time())

local function get_random()
    return math.floor(math.random()*1000000)
end

action = function(host, port)
    local response
    local ri
    local ref_url
    ri = get_random()

    ref_url = string.format("/cgi-bin/QTS.cgi?count=%d", ri)
    response = http.get(host, port, ref_url, {redirect_ok=false})
    print(string.format("QNAP scanning: %s", ref_url))

    if response.status and response.status ~= 302 then
        return
    end

    local redirect_ref, redirect_url
    redirect_ref = response.header['location']
    if redirect_ref and redirect_ref:find "cgi%-bin/login.html" then
        return string.format("QNAP nas found been found at %s:%d", host, port)
    end
end
