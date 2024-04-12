for _, actor in next, getactors() do
    run_on_actor(actor, [[
        local RunService = cloneref(game:GetService("RunService"))
        local Stats = cloneref(game:GetService("Stats"))

        local CurrMem = Stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Gui);
        local Rand = 0

        RunService.Stepped:Connect(function()
            local random = Random.new()
            Rand = random:NextNumber(-0.1, 0.1);
        end)

        local function GetReturn()
            return CurrMem + Rand;
        end

        local _MemBypass
        _MemBypass = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod();

            if not checkcaller() then
                if typeof(self) == "Instance" and (method == "GetMemoryUsageMbForTag" or method == "getMemoryUsageMbForTag") and self.ClassName == "Stats" then
                    return GetReturn();
                end
            end

            return _MemBypass(self, ...);
        end)
    ]])
end
