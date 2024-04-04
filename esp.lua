--vars
local camera = utility.services.workspace.CurrentCamera;
local localplayer = utility.services.players.LocalPlayer;
local local_char = localplayer.Character or localplayer.CharacterAdded:Wait();
local tostring = tostring;
local Color3 = Color3;
local Vector2 = Vector2;
local math_cos = math.cos;
local math_sin = math.sin;
local math_rad = math.rad;
local math_round = math.round;

--// Custom fonts
local Fontz = {
    Minecraftia = {
        Drawing = Drawing.new("Font", "Minecraftia"),
        URL = "https://efial.wtf/fonts/Minecraftia-Regular.ttf"
    },
    SmallestPixel = {
        Drawing = Drawing.new("Font", "SmallestPixel"),
        URL = "https://efial.wtf/fonts/smallest_pixel-7.ttf"
    },
}
for _, fontData in pairs(Fontz) do
    (function()
        fontData.Drawing.Data = game:HttpGet(fontData.URL)
        repeat wait() until fontData.Drawing.Loaded
    end)()
end

--
local Esp_Settings = {
Enabled = false,
Max_Distance = 100,
Font_Family = Fontz.SmallestPixel.Drawing,
Font_Size = 12,
Display_Name = true,
    Target = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Player = nil,
    },
    Highlight_Enemies = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Player = nil
    },
    Highlight_Friendlies = {
        Enabled = false,
        Color = Color3.fromRGB(0, 255, 0),
        Player = nil
    },
    Box = {
        Enabled = false,
        Outline = false,
        Color = Color3.fromRGB(255, 255, 255),
        Type = 'corner',
    },
    Chams = {
        Enabled = false,
        Transparency = 0.8,
        Color = Color3.fromRGB(189, 172, 255),
        Breathe = false,
        VisibleCheck = false,
    },
    FilledBox = {
        Enabled = false,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 30,
    },
    Distance = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255),
    },
    Name = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255),
    },
    ViewAngle = {
        Enabled = false,
        Size = 5,
        Outline = false,
        Color = Color3.fromRGB(255, 255, 255),
    },
    HealthBar = {
        Enabled = false,
        ColorFull = Color3.fromRGB(189, 172, 255),
        ColorEmpty = Color3.fromRGB(0, 0, 0),
        Text = false,
        TextColor = Color3.fromRGB(189, 172, 255),
        Thickness = 5,
    },
    Tool = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255),
    },
    OffScreenArrows = {
        Enabled = false,
        Outline = false,
        Radius = 500,
        Size = 15,
        Color = Color3.fromRGB(189, 172, 255),
        HPBars = false,
        Distance = false,
        Tool = false,
        Name = false,
        Box = false,
    },
}

do -- ESP
    if (_G.Drawings) then
        for _, drawing in pairs(_G.Drawings) do
            drawing:Remove()
        end
    end
    _G.Drawings = {}
    
    if (_G.Connections) then
        for _, connection in pairs(_G.Connections) do
            connection:Disconnect()
        end
    end
    _G.Connections = {}
    
    local Functions
    do
        Functions = {}
        function Functions:GetBoundingBox(model)
            local cframe, size = model:GetBoundingBox()
            return cframe, size, cframe.Position
        end
    
        function Functions:WorldToViewport(position, offsetx, offsety)
            offsetx = offsetx or 0
            offsety = offsety or 0
            local screenPos, onScreen = camera:WorldToViewportPoint(position)
            return Vector2.new(screenPos.X + offsetx, screenPos.Y + offsety), onScreen, screenPos.Z
        end

        function Functions:GetPlayerTool(Character)
            for _, v in ipairs(Character:GetChildren()) do
                if v:IsA("Tool") then
                    return v.Name
                end
            end
            return "Hands"
        end                           
    end
    
    local function AddPlayer(player)
        if (player == localplayer) then
            return
        end
        -- creating ESP
        local ESPDrawings = {
            Text = {
                Name = Drawing.new('Text'),
                Distance = Drawing.new('Text'),
                Tool = Drawing.new('Text'),
            },
            ViewAngle = {
                Line = Drawing.new('Line'),
                Outline = Drawing.new('Line'),
            },
            Box = {
                LineTRV = Drawing.new('Line'),
                LineTRH = Drawing.new('Line'),
                LineTLV = Drawing.new('Line'),
                LineTLH = Drawing.new('Line'),
                LineBRV = Drawing.new('Line'),
                LineBRH = Drawing.new('Line'),
                LineBLV = Drawing.new('Line'),
                LineBLH = Drawing.new('Line'),
            },
            Outline = {
                LineTRV = Drawing.new('Line'),
                LineTRH = Drawing.new('Line'),
                LineTLV = Drawing.new('Line'),
                LineTLH = Drawing.new('Line'),
                LineBRV = Drawing.new('Line'),
                LineBRH = Drawing.new('Line'),
                LineBLV = Drawing.new('Line'),
                LineBLH = Drawing.new('Line'),
            },
            BoxFilled = {
                Box = Drawing.new('Quad'),
            },
            HealthBar = {
                Base = Drawing.new('Square'),
                Health = Drawing.new('Square'),
                Text = Drawing.new('Text'),
            },
            OffScreenArrows = {
                Arrow = Drawing.new('Triangle'),
                Outline = Drawing.new('Triangle'),
            },
        }
        local ESPChams = {
            Chams = {
                Body = Instance.new("BoxHandleAdornment"),
                Head = Instance.new("SphereHandleAdornment")
            },
        }
        local OSA = ESPDrawings.OffScreenArrows
        local HB = ESPDrawings.HealthBar
        local OB = ESPDrawings.Outline
        local BO = ESPDrawings.Box
        local FB = ESPDrawings.BoxFilled
        local VA = ESPDrawings.ViewAngle
        local TE = ESPDrawings.Text
        -- Settings values
        do
            for index, value in pairs(ESPDrawings) do   
                for _, drawing in pairs(value) do
                    drawing.ZIndex = 2
                    drawing.Visible = false
                    table.insert(_G.Drawings, drawing)
                    if (index == 'Text') then
                        drawing.Center = true
                        drawing.Size = Esp_Settings.Font_Size
                        drawing.Font = Esp_Settings.Font_Family
                        drawing.Outline = true
                    elseif (index == 'Outline') then
                        drawing.ZIndex = -1
                        drawing.Thickness = 3
                        drawing.Color = Color3.new(0, 0, 0)
                    elseif (index == 'Box') then
                        drawing.Thickness = 1
                    end
                end 
                HB.Base.Color = Color3.fromRGB(28, 28, 28)
                HB.Base.Filled = true
                HB.Base.ZIndex = 1
                HB.Health.Filled = true
                HB.Text.Center = true
                HB.Text.Size = Esp_Settings.Font_Size
                HB.Text.Font = Esp_Settings.Font_Family
                HB.Text.Outline = true
                OSA.Arrow.Filled = true
                OSA.Outline.Filled = false
                OSA.Outline.Color = Color3.new(0, 0, 0)
                ESPDrawings.BoxFilled.Box.Filled = true
                ESPDrawings.Text.Name.Text = player.Name
            end
        end                               
        -- Drawings functions
        local function HideDrawings()
            for _, value in pairs(ESPDrawings) do
                for _, drawing in pairs(value) do
                    drawing.Visible = false
                end
            end
        end
        local function HideChams(chamsTable)
            for _, value in pairs(chamsTable) do
                for _, chams in pairs(value) do
                    if chams:IsA("BoxHandleAdornment") or chams:IsA("SphereHandleAdornment") then
                        chams.Visible = false
                    end
                end
            end
        end                
        local function DestroyDrawings()
            for _, value in pairs(ESPDrawings) do
                for _, drawing in pairs(value) do
                    drawing:Remove()
                end
            end
        end
        local function ToggleTable(_table, toggle)
            for _, drawing in pairs(ESPDrawings[_table]) do
                drawing.Visible = toggle
            end
        end
        local function SetValue(_table, index, value)
            for _, drawing in pairs(ESPDrawings[_table]) do
                drawing[index] = value
            end
        end
        -- Math functions
        local function RotateVector2(vector2, rotation)
            local cos, sin = math.cos(rotation), math.sin(rotation)
            return Vector2.new(cos * vector2.X - sin * vector2.Y, sin * vector2.X + cos * vector2.Y)
        end
        local function CalculateOffset(vector2, position, size)
            local cframe = CFrame.new(position, camera.CFrame.Position)
            local x, y = -size.X / 2, size.Y / 2
            local tRight = Functions:WorldToViewport((cframe * CFrame.new(x, y, 0)).Position)
            local bRight = Functions:WorldToViewport((cframe * CFrame.new(x, -y, 0)).Position)
            return {
                X = math.max(tRight.X - vector2.X, bRight.X - vector2.X),
                Y = math.max(vector2.Y - tRight.Y, bRight.Y - vector2.Y)
            }
        end
        local function CalculatePoints(offset, vector2)
            local bps = {
                B = Vector2.new(vector2.X, vector2.Y + offset.Y),
                T = Vector2.new(vector2.X, vector2.Y - offset.Y),
                L = Vector2.new(vector2.X - offset.X, vector2.Y),
                R = Vector2.new(vector2.X + offset.X, vector2.Y),
            }
            return {
                BR = Vector2.new(bps.R.X, bps.B.Y),
                TR = Vector2.new(bps.R.X, bps.T.Y),
                TL = Vector2.new(bps.L.X, bps.T.Y),
                BL = Vector2.new(bps.L.X, bps.B.Y),
                B = bps.B,
                T = bps.T,
                L = bps.L,
                R = bps.R,
            }
        end                          
        -- ESP functions
        local function BoxESP(settings, info)
            if (settings.Enabled) then
                local points = info.Points
                if (settings.Type == 'full') then
                    ToggleTable('Box', false)
                    ToggleTable('Outline', false)
                    BO.LineTRV.Visible = true; BO.LineBRV.Visible = true; BO.LineTLV.Visible = true; BO.LineBLV.Visible = true;
                    BO.LineTRV.To = points.TR
                    BO.LineTRV.From = points.BR
                    BO.LineBRV.To = points.BR
                    BO.LineBRV.From = points.BL
                    BO.LineBLV.To = points.BL
                    BO.LineBLV.From = points.TL
                    BO.LineTLV.To = points.TL
                    BO.LineTLV.From = points.TR
                    if (settings.Outline) then
                        OB.LineTRV.Visible = true; OB.LineBRV.Visible = true; OB.LineTLV.Visible = true; OB.LineBLV.Visible = true;
                        for index, drawing in pairs(OB) do
                            if (drawing.Visible) then
                                drawing.To = BO[index].To
                                drawing.From = BO[index].From
                            end
                        end
                    end
                elseif (settings.Type == 'corner') then
                    ToggleTable('Box', false)
                    ToggleTable('Outline', false)
                    BO.LineBRV.Visible = true; BO.LineBRH.Visible = true; BO.LineTRV.Visible = true; BO.LineTRH.Visible = true;BO.LineTLV.Visible = true; BO.LineTLH.Visible = true; BO.LineBLV.Visible = true; BO.LineBLH.Visible = true;
                    BO.LineBRV.To = points.BR
                    BO.LineBRH.To = points.BR
                    BO.LineBRV.From = Vector2.new(points.BR.X, info.Vector2.Y + info.Offset.Y / 2)
                    BO.LineBRH.From = Vector2.new(info.Vector2.X + info.Offset.X / 2, points.BR.Y)
                    BO.LineTRV.To = points.TR
                    BO.LineTRH.To = points.TR
                    BO.LineTRV.From = Vector2.new(points.TR.X, info.Vector2.Y - info.Offset.Y / 2)
                    BO.LineTRH.From = Vector2.new(info.Vector2.X + info.Offset.X / 2, points.TR.Y)
                    BO.LineTLV.To = points.TL
                    BO.LineTLH.To = points.TL
                    BO.LineTLV.From = Vector2.new(points.TL.X, info.Vector2.Y - info.Offset.Y / 2)
                    BO.LineTLH.From = Vector2.new(info.Vector2.X - info.Offset.X / 2, points.TL.Y)
                    BO.LineBLV.To = points.BL
                    BO.LineBLH.To = points.BL
                    BO.LineBLV.From = Vector2.new(points.BL.X, info.Vector2.Y + info.Offset.Y / 2)
                    BO.LineBLH.From = Vector2.new(info.Vector2.X - info.Offset.X / 2, points.BL.Y)
                    if (settings.Outline) then
                        ToggleTable('Outline', true)
                        for index, drawing in pairs(OB) do
                            drawing.To = BO[index].To
                            drawing.From = BO[index].From
                        end
                    end
                end
                if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                    SetValue('Box', 'Color', Esp_Settings.Highlight_Enemies.Color)
                elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                    SetValue('Box', 'Color', Esp_Settings.Highlight_Friendlies.Color)
                else
                    SetValue('Box', 'Color', Esp_Settings.Box.Color)
                end
            else
                ToggleTable('Box', false)
                ToggleTable('Outline', false)
            end
        end
        local function ChamsESP(settings, playerInfo)
            if not Esp_Settings.Chams.Enabled then
                HideChams(ESPChams)
                return
            end
            local characterChildren = playerInfo.Character:GetChildren()
            for i = 1, #characterChildren do
                local part = characterChildren[i]
                if part:IsA("BasePart") and part.Transparency ~= 1 then
                    local chams = part:FindFirstChild("Chams")
                    if not chams then
                        chams = (part == playerInfo.Character.Head) and Instance.new("SphereHandleAdornment", part) or Instance.new("BoxHandleAdornment", part)
                        chams.Name = "Chams"
                        chams.ZIndex = 10
                        chams.Adornee = part
                        ESPChams.Chams[part.Name] = chams
                    end
                    if part ~= playerInfo.Character.Head then
                        chams.Size = part.Size
                    else
                        chams.Radius = 0.75
                    end
                    local breatheFactor = Esp_Settings.Chams.Breathe and math.sin(tick() * 2.25) * 0.5 + 0.5 or 1
                    chams.Transparency = Esp_Settings.Chams.Transparency * breatheFactor
                    if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                        chams.Color3 = Esp_Settings.Highlight_Enemies.Color
                    elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                        chams.Color3 = Esp_Settings.Highlight_Friendlies.Color
                    else
                        chams.Color3 = Esp_Settings.Chams.Color
                    end
                    chams.AlwaysOnTop = not Esp_Settings.Chams.VisibleCheck
                    chams.Visible = settings.Enabled
                end
            end
        end                
        local function FilledBoxESP(settings, info)
            local drawing = FB.Box
            drawing.Visible = settings.Enabled
            if (settings.Enabled) then
                local points = info.Points
                drawing.Visible = true
                drawing.Color = Esp_Settings.FilledBox.Color
                drawing.Transparency = settings.Transparency / 100
                drawing.PointA = points.BR
                drawing.PointB = points.TR
                drawing.PointC = points.TL
                drawing.PointD = points.BL
            end
        end
        local function ViewAngleESP(settings, playerInfo)
        local line = VA.Line
        local outline = VA.Outline
        if not playerInfo or not camera then
            return
        end
        local head = playerInfo.Character and playerInfo.Character.Head
        if not head or not head.Position or not head.CFrame then
            return
        end
        if (settings.Enabled) then
            local headPosition = head.Position
            local headCFrame = head.CFrame
            local viewVector = (headCFrame * CFrame.new(0, 0, -Esp_Settings.ViewAngle.Size)).Position
            local headViewport = camera:WorldToViewportPoint(headPosition)
            local viewViewport = camera:WorldToViewportPoint(viewVector)
        
            line.Visible = settings.Enabled
            line.From = Vector2.new(headViewport.X, headViewport.Y)
            line.To = Vector2.new(viewViewport.X, viewViewport.Y)
            if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                line.Color = Esp_Settings.Highlight_Enemies.Color
            elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                line.Color = Esp_Settings.Highlight_Friendlies.Color
            else
                line.Color = Esp_Settings.ViewAngle.Color
            end

            outline.Visible = Esp_Settings.ViewAngle.Outline
            outline.From = line.From
            outline.To = line.To
            outline.ZIndex = 1
            outline.Thickness = 3
            outline.Color = Color3.new(0, 0, 0)
            else
                line.Visible = false
                outline.Visible = false
            end
        end                            
        local function DistanceESP(settings, info)
            local drawing = TE.Distance
            drawing.Visible = settings.Enabled
            if (settings.Enabled) then
                local offset = 1
                if TE.Tool.Visible then
                    offset = offset + TE.Tool.TextBounds.Y
                end
                drawing.Visible = true
                local color = Esp_Settings.Distance.Color
                if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                    color = Esp_Settings.Highlight_Enemies.Color
                elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                    color = Esp_Settings.Highlight_Friendlies.Color
                end
                drawing.Color = color

                local playerHRP = player.Character:FindFirstChild("HumanoidRootPart")
                local localPlayerHRP = localplayer.Character:FindFirstChild("HumanoidRootPart")
                
                if playerHRP and localPlayerHRP then
                    local distance = tostring(math.floor((playerHRP.Position - localPlayerHRP.Position).Magnitude / 3.5714285714))
                    drawing.Text = '[' .. distance .. ']'
                    drawing.Position = info.Points.B + Vector2.new(0, offset)
                    drawing.Font = Esp_Settings.Font_Family
                    drawing.Size = Esp_Settings.Font_Size
                end    
            end
        end
        local function NameESP(settings, info)
            local drawing = TE.Name 
            drawing.Visible = settings.Enabled
            if (settings.Enabled) then
                if Esp_Settings.Display_Name then
                    ESPDrawings.Text.Name.Text = player.DisplayName
                else
                    ESPDrawings.Text.Name.Text = player.Name
                end
                drawing.Visible = true
                local color = Esp_Settings.Name.Color
                if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                    color = Esp_Settings.Highlight_Enemies.Color
                elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                    color = Esp_Settings.Highlight_Friendlies.Color
                end
                drawing.Color = color
                drawing.Position = info.Points.T + Vector2.new(0, -12)
                drawing.Font = Esp_Settings.Font_Family
                drawing.Size = Esp_Settings.Font_Size
            end
        end
        local function HealthBarESP(settings, info)
            ToggleTable('HealthBar', settings.Enabled)
            if (settings.Enabled) then
                local base, bar, text = HB.Base, HB.Health, HB.Text
    
                local bar_y = info.Offset.Y * 2
                local hp = info.Humanoid.Health
                local hp_perc = (hp / info.Humanoid.MaxHealth)
    
                base.Size = Vector2.new(settings.Thickness, bar_y)
                base.Position = info.Points.TL + Vector2.new(-settings.Thickness - 2, 0)
    
                bar.Size = Vector2.new(settings.Thickness - 2, (bar_y - 2) * hp_perc)
                bar.Position = base.Position + Vector2.new(1, (bar_y - 1) - bar.Size.Y)
                bar.Color = settings.ColorEmpty:Lerp((Esp_Settings.Target.Enabled and Esp_Settings.Target.Player == player and Esp_Settings.Target.Color) or Esp_Settings.HealthBar.ColorFull, hp_perc)
            
                if (not settings.Text) then
                    text.Visible = false
                    return
                end
                text.Text = tostring(math_round(hp))
                text.Color = (Esp_Settings.Target.Enabled and Esp_Settings.Target.Player == player and Esp_Settings.Target.Color) or Esp_Settings.HealthBar.TextColor
                text.Position = bar.Position + Vector2.new(-text.TextBounds.X / 2 - 2, -text.TextBounds.Y / 2)
                text.Font = Esp_Settings.Font_Family
                text.Size = Esp_Settings.Font_Size
            end
        end
        local function ToolESP(settings, info)
            local drawing = TE.Tool
            drawing.Visible = settings.Enabled
            if (settings.Enabled) then
                drawing.Visible = true
                if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                    drawing.Color = Esp_Settings.Highlight_Enemies.Color
                elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                    drawing.Color = Esp_Settings.Highlight_Friendlies.Color
                else
                    drawing.Color = Esp_Settings.Tool.Color
                end
                local tool = Functions:GetPlayerTool(player.Character)
                drawing.Text = ''..tostring(tool)..''
                drawing.Position = info.Points.B + Vector2.new(0, 1)
                drawing.Font = Esp_Settings.Font_Family
                drawing.Size = Esp_Settings.Font_Size
            end
        end
        local function OffScreenArrowESP(settings, info)
            if (settings.Enabled) then
                local arrow = OSA.Arrow
                local outline = OSA.Outline
    
                arrow.Visible = true
                if Esp_Settings.Highlight_Enemies.Enabled and Esp_Settings.Highlight_Enemies.Player == player.Name then
                    arrow.Color = Esp_Settings.Highlight_Enemies.Color
                elseif Esp_Settings.Highlight_Friendlies.Enabled and Esp_Settings.Highlight_Friendlies.Player == player.Name then
                    arrow.Color = Esp_Settings.Highlight_Friendlies.Color
                else
                    arrow.Color = Esp_Settings.OffScreenArrows.Color
                end
    
                local proj = camera.CFrame:PointToObjectSpace(info.Position)
                local angle = math.atan2(proj.Z, proj.X)
                local direction = Vector2.new(math_cos(angle), math_sin(angle))
                local pos = (direction * settings.Radius / 2) + camera.ViewportSize / 2
                arrow.PointA = pos
                arrow.PointB = pos - RotateVector2(direction, math_rad(35)) * settings.Size
                arrow.PointC = pos - RotateVector2(direction, -math_rad(35)) * settings.Size
    
                if (settings.Outline) then
                    outline.Visible = true
                    outline.PointA = arrow.PointA
                    outline.PointB = arrow.PointB
                    outline.PointC = arrow.PointC
                else
                    outline.Visible = false
                end
                local arrow_info = {
                    Offset = Vector2.new(settings.Size / 2, settings.Size / 2),
                    Vector2 = pos - RotateVector2(direction, math_rad(0)) * (settings.Size / 2),
                    Position = info.Position,
                    Humanoid = info.Humanoid,
                    Character = info.Character,
                }
                arrow_info.Points = CalculatePoints(arrow_info.Offset, arrow_info.Vector2)
                if (settings.HPBars) then
                    HealthBarESP(Esp_Settings.HealthBar, arrow_info)
                end
                if (settings.Name) then
                    NameESP(Esp_Settings.Name, arrow_info)
                end
                if (settings.Box) then
                    BoxESP(Esp_Settings.Box, arrow_info)
                end
                if (settings.Tool) then
                    ToolESP(Esp_Settings.Tool, arrow_info)
                end
                if (settings.Distance) then
                    DistanceESP(Esp_Settings.Distance, arrow_info)
                end
                if (settings.FilledBox) then
                    FilledBoxESP(Esp_Settings.FilledBox, arrow_info)
                end
            end
        end
        -- Loop
        local connection; connection = game.RunService.RenderStepped:Connect(function()
            if (not player) then
                DestroyDrawings()
                connection:Disconnect()
                return
            end
            local info = { Character = player.Character }
            if not (Esp_Settings.Enabled and info.Character) then
                HideDrawings()
                HideChams(ESPChams)
                return
            end
            info.Humanoid = info.Character:FindFirstChild('Humanoid')
            info.RootPart = info.Character:FindFirstChild('HumanoidRootPart')
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart") then
                    local playerPosition = player.Character.HumanoidRootPart.Position
                    local localPlayerPosition = localplayer.Character.HumanoidRootPart.Position
                    local distance = (playerPosition - localPlayerPosition).Magnitude / 3.5714285714
                    if distance >= Esp_Settings.Max_Distance then
                        HideDrawings()
                        HideChams(ESPChams)
                        return
                    end
                end
            end                                
            if not (info.Humanoid and info.Humanoid.Health > 0 and info.RootPart) then
                HideDrawings()
                HideChams(ESPChams)
                return
            end    
            info.Orientation, info.Size, info.Position = Functions:GetBoundingBox(info.Character)
            info.Vector2, info.OnScreen = Functions:WorldToViewport(info.Position)
            if (not info.OnScreen) then
                HideDrawings()
                HideChams(ESPChams)
                OffScreenArrowESP(Esp_Settings.OffScreenArrows, info)
                return
            end
            info.Offset = CalculateOffset(info.Vector2, info.Position, info.Size)
            info.Points = CalculatePoints(info.Offset, info.Vector2)
            HealthBarESP(Esp_Settings.HealthBar, info)
            DistanceESP(Esp_Settings.Distance, info)
            NameESP(Esp_Settings.Name, info)
            ViewAngleESP(Esp_Settings.ViewAngle, info)
            BoxESP(Esp_Settings.Box, info)
            ToolESP(Esp_Settings.Tool, info)
            FilledBoxESP(Esp_Settings.FilledBox, info)
            ChamsESP(Esp_Settings.Chams, info)
            ToggleTable('OffScreenArrows', false)
        end)
    end
    
    for _, player in pairs(game.Players:GetPlayers()) do
        AddPlayer(player)
    end
    local childAddedConnection = game.Players.ChildAdded:Connect(function(player)
        AddPlayer(player)
    end)
    table.insert(_G.Connections, childAddedConnection)
end
return Esp_Settings
