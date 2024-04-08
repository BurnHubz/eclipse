repeat wait() until game:IsLoaded()
local place_id = game.PlaceId;

if (place_id == 10179538382) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/d2dfa4cebd0410e773e815204a8edbe4.lua", true))()
elseif (place_id == 10228136016) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/bfee51375d5fb9484aff5f92dac805a5.lua", true))()
end
