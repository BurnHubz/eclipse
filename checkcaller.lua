local FallenGuardActor = getactors()[1]
run_on_actor(FallenGuardActor, [[
    local RealMemUsage = game:GetService("Stats"):GetTotalMemoryUsageMb()

    local statsmeta = getrawmetatable(game:GetService("Stats"))
    local old = statsmeta.__namecall
    setreadonly(statsmeta, false)

    statsmeta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if method == "GetTotalMemoryUsageMb" then
            local spoofVal = (math.random(-2, 2) + (math.random(1514, 6256) / 10000))
            return RealMemUsage + spoofVal
        end

        return old(self, ...)
    end)
]])
