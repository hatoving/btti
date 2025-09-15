-- Also shamelessly stolen off Yahimod! Thank you yaher rat!
-- Shamelessly stolen off Cryptid mod! Thank u devs i wouldn'tve figured out https requests in a lifetime

local https = require "SMODS.https"
local json = require "json"

G.BTTI.HTTPS = {
    YOUTUBE_DATA = {}
}

G.BTTI.HTTPS.YOUTUBE_CONSTS = {
    NUMBER_GO_UP = "iXZX_HAmbTU"
}
G.BTTI.HTTPS.URLS = {
    YOUTUBE_DATA = "https://raw.githubusercontent.com/hatoving/btti-https/refs/heads/main/youtube_data.json"
}

function G.BTTI.HTTPS.getYouTubeData()
    local status, body, headers = https.request(G.BTTI.HTTPS.URLS.YOUTUBE_DATA, {method = "GET"})
    if body ~= nil then
        local parsed = json.decode(body)
        if type(parsed) ~= "table" then
        else
            G.BTTI.HTTPS.YOUTUBE_DATA.NUMBER_GO_UP = (parsed["views"])[G.BTTI.HTTPS.YOUTUBE_CONSTS.NUMBER_GO_UP]
        end
    end
end