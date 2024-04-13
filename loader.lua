local creator_id = game.CreatorId
local fallen_id = 10228136016
writefile("ECLIPSE_KEY.txt", script_key)

if creator_id == 1154360 and game.PlaceId == fallen_id then
    pcall(function()
        script_key = readfile("ECLIPSE_KEY.txt")
        memorystats.cache("Gui")
        task.wait(.5);
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b2e293addcf9a470164fe95eff5e92fc.lua"))()
    end)
end;
