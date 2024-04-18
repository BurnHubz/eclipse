writefile("ECLIPSE_KEY.txt", script_key)

do
    if game.PlaceId == 10228136016 then
        local Loader = loadstring(game:HttpGet("https://raw.githubusercontent.com/BurnHubz/eclipse/main/Loader.lua",true))()
        Loader:Initialize()
        --load
        queue_on_teleport([==[
            if game.CreatorId == 1154360 and game.PlaceId ~= 10228136016 then
                pcall(function()
                    script_key = readfile("ECLIPSE_KEY.txt")
                    memorystats.cache("Gui")
                    task.wait();
                    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b2e293addcf9a470164fe95eff5e92fc.lua"))()
                end)
            end;
        ]==])
    end
end
