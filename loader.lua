local FallenId = 10228136016
writefile("ECLIPSE_KEY.txt", script_key)

if game.PlaceId == FallenId then
        queue_on_teleport([[
        pcall(function()
            script_key = readfile("ECLIPSE_KEY.txt")
            repeat task.wait() until getactors()[1] and getactors()[2] repeat wait() until game:GetService("Players").LocalPlayer.Character
            memorystats.cache("Gui")
            task.wait(.5);
            loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b2e293addcf9a470164fe95eff5e92fc.lua"))()
        end)
    ]]);
end;
