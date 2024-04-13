writefile("ECLIPSE_KEY.txt", script_key)

if game.CreatorId == 1154360 and game.PlaceId ~= 10228136016 then
    repeat wait() until game:GetService("Players").LocalPlayer.Character
    pcall(function()
        script_key = readfile("ECLIPSE_KEY.txt")
        memorystats.cache("Gui")
        task.wait(.5);
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b2e293addcf9a470164fe95eff5e92fc.lua"))()
    end)
end;
