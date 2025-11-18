
local Atlas = loadstring(game:HttpGet("https://raw.githubusercontent.com/shiawaseu/Atlas-Lib-Mirror/main/Atlas.lua"))()

local Owner = "developiing_scriptss" 
local CorrectKey = "XIEBE2024-PREMIUM-ACCESS"
local LootLink = "https://loot-link.com/s?lgn4Xs7C"

local LP = game.Players.LocalPlayer
local IsOwner = (LP.Name == Owner or LP.DisplayName == Owner or LP.UserId == 1396011873)  -- Added UserId fallback

local UI = Atlas.new({
    Name = "Xiebe Hub – Owner Edition",
    ConfigFolder = "XiebeHub",
    Color = Color3.fromRGB(255,0,127),
    Bind = "RightAlt",
    UseLoader = not IsOwner,
    FullName = "Xiebe Hub Premium",
    CheckKey = function(key) return key == CorrectKey end,
    Discord = LootLink
})

if IsOwner then
    UI:Notify({Title="OWNER",Content="Welcome back developiing_scriptss – God mode activated"})
else
    setclipboard(LootLink)
    UI:Notify({Title="Key System",Content="Link copied! Key: XIEBE2024-PREMIUM-ACCESS"})
end

UI:Notify({Title="Xiebe Hub",Content="Loaded with Aimbot, Triggerbot, Fullbright, Serverhop & more!"})

local Plrs = game:GetService("Players")
local Cam = workspace.CurrentCamera
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TeleportService")
local HS = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Mouse = LP:GetMouse()
local Flags = UI.Flags

local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

local ESP = {}
for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP then
    local box = Drawing.new("Square") box.Thickness=2 box.Color=Color3.new(1,0,0) box.Filled=false box.Transparency=1
    local name = Drawing.new("Text") name.Size=16 name.Center=true name.Outline=true name.Color=Color3.new(1,1,1) name.Font=2
    local tracer = Drawing.new("Line") tracer.Thickness=2 tracer.Color=Color3.new(1,0,0)
    ESP[p] = {Box=box, Name=name, Tracer=tracer}
end end

Plrs.PlayerAdded:Connect(function(p) if p ~= LP then
    local box = Drawing.new("Square") box.Thickness=2 box.Color=Color3.new(1,0,0) box.Filled=false box.Transparency=1
    local name = Drawing.new("Text") name.Size=16 name.Center=true name.Outline=true name.Color=Color3.new(1,1,1) name.Font=2
    local tracer = Drawing.new("Line") tracer.Thickness=2 tracer.Color=Color3.new(1,0,0)
    ESP[p] = {Box=box, Name=name, Tracer=tracer}
end end)

Run.RenderStepped:Connect(function()
    for plr, e in pairs(ESP) do
        if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            local head = Cam:WorldToViewportPoint(plr.Character.Head.Position)
            local root = Cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            local dist = math.floor((Root.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
            if head.Z > 0 then
                local h = math.abs(head.Y - root.Y) * 2
                e.Box.Size = Vector2.new(h/2, h)
                e.Box.Position = Vector2.new(root.X - h/4, root.Y - h/2)
                e.Box.Visible = Flags.ESP

                e.Name.Text = plr.Name.." ["..dist.."m]"
                e.Name.Position = Vector2.new(root.X, head.Y - 25)
                e.Name.Visible = Flags.ESP

                e.Tracer.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
                e.Tracer.To = Vector2.new(root.X, root.Y + h/2)
                e.Tracer.Visible = Flags.Tracers
            else
                e.Box.Visible = false e.Name.Visible = false e.Tracer.Visible = false
            end
        else
            e.Box.Visible = false e.Name.Visible = false e.Tracer.Visible = false
        end
    end
end)

-- Aimbot (Hold Right Click)
local function GetClosest()
    local closest, dist = nil, Flags.AimbotFOV or 200
    for _, plr in pairs(Plrs:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onScreen = Cam:WorldToViewportPoint(plr.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if onScreen and mag < dist then
                dist = mag
                closest = plr
            end
        end
    end
    return closest
end

Run.RenderStepped:Connect(function()
    if Flags.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosest()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

Run.RenderStepped:Connect(function()
    if Flags.Triggerbot then
        local target = Mouse.Target
        if target and target.Parent then
            local plr = Plrs:GetPlayerFromCharacter(target.Parent)
            if plr and plr ~= LP then
                mouse1press()
                task.wait(0.05)
                mouse1release()
            end
        end
    end
end)

local function DoFullbright()
    Lighting.Brightness = 3
    Lighting.ClockTime = 12
    Lighting.FogEnd = 9e9
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
end

local VirtualUser = game:GetService("VirtualUser")
LP.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Main = UI:CreatePage("Main")
local Combat = UI:CreatePage("Combat")
local Visual = UI:CreatePage("Visual")
local Teleport = UI:CreatePage("Teleport")
local Server = UI:CreatePage("Server")

local M = Main:CreateSection("Movement")
M:CreateToggle({Name="Fly",Flag="Fly"})
M:CreateSlider({Name="Fly Speed",Flag="FlySpd",Min=16,Max=500,Default=150})
M:CreateToggle({Name="Noclip",Flag="Noclip"})
M:CreateToggle({Name="Infinite Jump",Flag="InfJump"})
M:CreateToggle({Name="Click Teleport (Ctrl + Click)",Flag="ClickTP"})
M:CreateSlider({Name="WalkSpeed",Flag="WS",Min=16,Max=1000,Default=100,Callback=function(v)Hum.WalkSpeed=v end,CallbackOnCreation=true})
M:CreateSlider({Name="JumpPower",Flag="JP",Min=50,Max=500,Default=50,Callback=function(v)Hum.JumpPower=v end,CallbackOnCreation=true})

local C = Combat:CreateSection("Combat")
C:CreateToggle({Name="Aimbot (Hold RMB)",Flag="Aimbot"})
C:CreateSlider({Name="Aimbot FOV",Flag="AimbotFOV",Min=50,Max=500,Default=150})
C:CreateToggle({Name="Triggerbot",Flag="Triggerbot"})
C:CreateToggle({Name="Kill Aura",Flag="KillAura"})
C:CreateSlider({Name="Kill Aura Range",Flag="AuraRange",Min=10,Max=50,Default=25})

local V = Visual:CreateSection("Visuals")
V:CreateToggle({Name="ESP Boxes",Flag="ESP",Default=true})
V:CreateToggle({Name="Tracers",Flag="Tracers",Default=true})
V:CreateToggle({Name="Fullbright",Flag="Fullbright",Callback=function(v)if v then DoFullbright() end end})
V:CreateSlider({Name="Custom FOV",Flag="FOV",Min=30,Max=120,Default=70,Callback=function(v)Cam.FieldOfView=v end})

local TP = Teleport:CreateSection("Player Teleport")
local Dropdown = TP:CreateDropdown({
    Name = "Select Player",
    Options = {},
    Callback = function(name)
        local p = Plrs:FindFirstChild(name)
        if p and p.Character then
            Root.CFrame = p.Character.HumanoidRootPart.CFrame
        end
    end
})

task.spawn(function()
    while task.wait(2) do
        local t = {}
        for _, p in Plrs:GetPlayers() do if p ~= LP then table.insert(t, p.Name) end end
        Dropdown:Update(t)
    end
end)

local S = Server:CreateSection("Server")
S:CreateButton({Name="Serverhop (Low Players)",Callback=function()
    local servers = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    local good = {}
    for _,v in pairs(servers) do if v.playing < v.maxPlayers and v.playing < 12 then table.insert(good, v.id) end end
    if #good > 0 then TS:TeleportToPlaceInstance(game.PlaceId, good[math.random(#good)], LP) end
end})
S:CreateButton({Name="Rejoin",Callback=function() TS:Teleport(game.PlaceId, LP) end})

-- Fly + Noclip + ClickTP + KillAura
local BV
Run.Heartbeat:Connect(function()
    if Flags.Fly and Root then
        if not BV then BV = Instance.new("BodyVelocity",Root) BV.MaxForce=Vector3.new(1e5,1e5,1e5) BV.P=3000 end
        local dir = Vector3.new(
            UIS:IsKeyDown(Enum.KeyCode.D) and 1 or UIS:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
            UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or UIS:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0,
            UIS:IsKeyDown(Enum.KeyCode.W) and 1 or UIS:IsKeyDown(Enum.KeyCode.S) and -1 or 0
        )
        BV.Velocity = (Cam.CFrame.LookVector*dir.Z + Cam.CFrame.RightVector*dir.X + Vector3.new(0,dir.Y,0)) * Flags.FlySpd
    elseif BV then BV:Destroy() BV=nil end

    if Flags.Noclip and Char then
        for _,v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end
    end

    if Flags.ClickTP and UIS:IsKeyDown(Enum.KeyCode.LeftControl) and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        Root.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0,5,0))
    end

    if Flags.KillAura then
        for _, plr in pairs(Plrs:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (Root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist <= Flags.AuraRange then
                    Hum:MoveTo(plr.Character.HumanoidRootPart.Position)
                end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function() if Flags.InfJump then Hum:ChangeState("Jumping") end end)

LP.CharacterAdded:Connect(function(c)
    Char=c Hum=c:WaitForChild("Humanoid") Root=c:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    Hum.WalkSpeed = Flags.WS or 100
    Hum.JumpPower = Flags.JP or 50
    if Flags.Fullbright then DoFullbright() end
end)

UI:Toggle(true)
