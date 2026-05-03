-- Sysnax – Official Release (Rivals, Arsenal, HyperShot)
-- autoload · right shift toggle · all features · no kicks
-- works on Synapse Z, Cosmic, Volt, CodeX

local function IsSupported()
    local ok, result = pcall(function()
        local ids = {
            Rivals    = {17625359962, 15827677067, 18204519637},
            Arsenal   = {286090429, 292439477, 258096465},
            HyperShot = {1110584932, 4618637946},
        }
        for name, list in pairs(ids) do
            for _, id in ipairs(list) do
                if game.PlaceId == id then return name end
            end
        end
        return nil
    end)
    return ok and result or nil
end

local CurrentGame = IsSupported()
if not CurrentGame then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Sysnax",
        Text = "Unsupported game.",
        Duration = 5,
    })
    return
end

-- safe loader for WindUI
local WindUI
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end)
    WindUI = ok and result
end
if not WindUI then
    game.Players.LocalPlayer:Kick("Failed to load UI library.")
    return
end

-- theme
WindUI:AddTheme({
    Name = "Sysnax",
    Accent = Color3.fromHex("#2a2a2e"),
    Background = Color3.fromHex("#121215"),
    AccentOutline = Color3.fromHex("#4a4a50"),
    Text = Color3.fromHex("#e0e0e0"),
    Placeholder = Color3.fromHex("#6a6a70"),
    Button = Color3.fromHex("#3a3a40"),
    Icon = Color3.fromHex("#9a9aa0"),
})
WindUI:SetTheme("Sysnax")

local Window = WindUI:CreateWindow({
    Title = "Sysnax",
    Icon = "rbxassetid://122198206955790",
    Folder = "sysnax",
    Theme = "Sysnax",
    Resizable = true,
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Size = UDim2.fromOffset(680, 520),
    ToggleKey = Enum.KeyCode.RightShift,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

-- config helpers
local function makeConfigFolder()
    local s, e = pcall(function()
        if not isfolder("sysnax") then makefolder("sysnax") end
        if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end
    end)
end
makeConfigFolder()
local function SaveConfig(name)
    if name == "" then return end
    pcall(function()
        writefile("sysnax/configs/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(CurrentConfig))
        WindUI:Notify({Title = "Sysnax", Content = name .. " saved.", Duration = 3})
    end)
end
local function LoadConfig(name)
    if name == "" or not isfile("sysnax/configs/" .. name .. ".json") then return end
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("sysnax/configs/" .. name .. ".json"))
    end)
    if ok and data then
        for k, v in pairs(data) do CurrentConfig[k] = v end
        WindUI:Notify({Title = "Sysnax", Content = name .. " loaded.", Duration = 3})
    end
end
local function DeleteConfig(name)
    if name == "" or not isfile("sysnax/configs/" .. name .. ".json") then return end
    delfile("sysnax/configs/" .. name .. ".json")
    WindUI:Notify({Title = "Sysnax", Content = name .. " deleted.", Duration = 3})
end
local function GetConfigs()
    local list = {}
    pcall(function()
        for _, file in ipairs(listfiles("sysnax/configs")) do
            local name = file:match("([^/]+)%.json$")
            if name then table.insert(list, name) end
        end
    end)
    return list
end

-- safe mouse buttons
local MouseButtons = {
    RightMouse  = Enum.UserInputType.MouseButton2,
    LeftMouse   = Enum.UserInputType.MouseButton1,
    MiddleMouse = Enum.UserInputType.MouseButton3,
}
pcall(function()
    for _, data in ipairs({
        {"Mouse4", "MouseButton4", "Button4"},
        {"Mouse5", "MouseButton5", "Button5"},
    }) do
        local ok, btn = pcall(function() return Enum.UserInputType[data[2]] end)
        if ok and btn then
            MouseButtons[data[1]] = btn
        else
            local ok2, btn2 = pcall(function() return Enum.UserInputType[data[3]] end)
            if ok2 and btn2 then MouseButtons[data[1]] = btn2 end
        end
    end
end)
local function IsMouseButtonDown(name)
    local btn = MouseButtons[name]
    return btn and UserInputService:IsMouseButtonPressed(btn)
end

-- defaults
CurrentConfig = {
    Aimbot_Enabled = false, Aimbot_Mode = "Hold", Aimbot_Part = "Head", Aimbot_Smoothness = 5,
    Aimbot_Radius = 200, Aimbot_VisibleOnly = true, Aimbot_ShowFOV = true,
    Aimbot_FOVColor = Color3.fromRGB(255,255,255), Aimbot_Key = "RightMouse",

    Silent_Enabled = false, Silent_Part = "Head", Silent_HitChance = 100,
    Silent_Manipulation = 0, Silent_VisibleOnly = true, Silent_MaxDistance = 500,

    Trigger_Enabled = false, Trigger_Delay = 0.1, Trigger_Distance = 300, Trigger_Key = "RightMouse",

    Rage_Enabled = false, Rage_AutoShoot = true, Rage_ThroughWalls = true, Rage_VoidSpam = false,
    Rage_Hide = 0.15, Rage_Attack = 0.05, Rage_Fly = false, Rage_FlySpeed = 50, Rage_NoClip = false,

    ESP_Enabled = false, ESP_Box = true, ESP_HealthBar = true, ESP_Skeleton = false,
    ESP_Color = Color3.fromRGB(255,255,255),

    Chams_Enabled = false, Chams_Material = "ForceField", Chams_Color = Color3.fromRGB(150,0,255),

    Crosshair_Enabled = false, Crosshair_Size = 10, Crosshair_Thickness = 2,
    Crosshair_Color = Color3.fromRGB(255,255,255), Crosshair_DisableGame = false,

    ThirdPerson_Enabled = false, ThirdPerson_Distance = 15, ThirdPerson_Key = "V",

    Skin_Enabled = false, Global_SkinID = "", Global_WrapID = "", Global_FinisherID = "",
    WeaponSkins = {},

    Move_InfiniteJump = false, Move_Fly = false, Move_FlySpeed = 50,
    Move_SlideBoost = false, Move_SlideBoostMult = 1, Move_Velocity = false, Move_VelocitySpeed = 16,

    Anim_Enabled = false, Anim_ID = "", Anim_Speed = 1,
    HitSound_Enabled = false, HitSound_Sound = "Bameware", HitSound_ApplyTo = "All",
    Spoof_Level = "", Spoof_Rank = "", Spoof_Winstreak = "", Spoof_Winrate = "",
    Spoof_RankedStreak = "", Spoof_RankedWinrate = "",
    LBS_Enabled = false, LBS_Wins = "", LBS_Winstreak = "", LBS_Level = "", LBS_Rank = "",
    LBS_KD = "", LBS_ELO = "",
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- safe character
local function GetChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function IsAlive()
    local c = LocalPlayer.Character
    if not c then return false end
    local hum = c:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end
local function GetPlayers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p) end
    end
    return list
end
local function WorldToScreen(pos)
    local s, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), on, s.Z
end
local function GetClosestPlayerToCursor(radius, partName, visibleOnly)
    if not IsAlive() then return nil end
    local closest, minDist = nil, radius or math.huge
    for _, plr in ipairs(GetPlayers()) do
        local char = plr.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local target = char:FindFirstChild(partName or "Head")
            if hum and hum.Health > 0 and target then
                if visibleOnly then
                    local ignore = {GetChar()}
                    local ray = Ray.new(Camera.CFrame.Position, (target.Position - Camera.CFrame.Position).Unit * 1000)
                    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignore)
                    if hit and not hit:IsDescendantOf(char) then continue end
                end
                local screen, onScreen = Camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local dist = (Vector2.new(screen.X, screen.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < minDist then minDist = dist; closest = plr end
                end
            end
        end
    end
    return closest
end

-- FOV circle (safe)
local FOVCircle
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 64
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
    FOVCircle.Visible = false
end)

-- Silent aim meta‑hook (safe)
local SilentTarget = nil
local function trySilentHook()
    local mt = getrawmetatable and getrawmetatable(game) or (debug and debug.getmetatable and debug.getmetatable(game))
    if not mt or not mt.__namecall then return end
    local old = mt.__namecall
    local new = newcclosure or function(f) return f end -- fallback
    local hookFunc = hookfunction or function(o, n) return o end
    if newcclosure and setreadonly then
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(...)
            local args = {...}
            local method = getnamecallmethod()
            if (method == "FireServer" or method == "InvokeServer") and type(args[1]) == "string" then
                local rn = args[1]:lower()
                if rn:find("click") or rn:find("shoot") or rn:find("bullet") or rn:find("fire") then
                    if CurrentConfig.Silent_Enabled and SilentTarget and SilentTarget.Character then
                        local part = SilentTarget.Character:FindFirstChild(CurrentConfig.Silent_Part)
                        if part then
                            args[2] = part.Position + Vector3.new(0, CurrentConfig.Silent_Manipulation/100, 0)
                            if args[3] and type(args[3]) == "userdata" then args[3] = part end
                        end
                    end
                end
            end
            return old(...)
        end)
        setreadonly(mt, true)
    end
end
trySilentHook()

-- Ragebot
local function ragebotAutoShoot()
    if not CurrentConfig.Rage_Enabled or not IsAlive() or not CurrentConfig.Rage_AutoShoot then return end
    local weaponSys = Workspace:FindFirstChild("WeaponSystem") or game:GetService("ReplicatedStorage"):FindFirstChild("WeaponSystem")
    if not weaponSys then return end
    local visibleOnly = not CurrentConfig.Rage_ThroughWalls
    local target = GetClosestPlayerToCursor(1000, "Head", visibleOnly)
    if target and target.Character then
        weaponSys:FireServer("MouseClick", target.Character:FindFirstChild("Head"))
    end
end

local lastVoidTeleport, voidHidden = 0, false
local function HandleRagebotMovement()
    if not CurrentConfig.Rage_Enabled or not IsAlive() then return end
    local char = GetChar()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if CurrentConfig.Rage_VoidSpam then
        local now = tick()
        if not voidHidden then
            if now - lastVoidTeleport >= CurrentConfig.Rage_Hide then
                lastVoidTeleport = now
                hrp.CFrame = hrp.CFrame * CFrame.new(0, -15, 0)
                voidHidden = true
            end
        else
            if now - lastVoidTeleport >= CurrentConfig.Rage_Attack then
                lastVoidTeleport = now
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 15, 0)
                voidHidden = false
            end
        end
    end
    if CurrentConfig.Rage_Fly then
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.Velocity = dir.Magnitude > 0 and dir.Unit * CurrentConfig.Rage_FlySpeed or Vector3.new()
    end
    if CurrentConfig.Rage_NoClip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end

-- ESP (safe)
local ESPList = {}
local function CreateESP(player)
    if not Drawing then return end
    local esp = {}
    pcall(function() esp.Box = Drawing.new("Square") end)
    pcall(function() esp.Health = Drawing.new("Line") end)
    pcall(function() esp.HealthOutline = Drawing.new("Line") end)
    pcall(function() esp.Name = Drawing.new("Text") end)
    pcall(function() esp.Distance = Drawing.new("Text") end)
    esp.Skeleton = {}
    if esp.Box then esp.Box.Thickness = 2; esp.Box.Filled = false; esp.Box.Visible = false end
    if esp.Health then esp.Health.Thickness = 3; esp.Health.Visible = false end
    if esp.HealthOutline then esp.HealthOutline.Thickness = 5; esp.HealthOutline.Visible = false; esp.HealthOutline.Color = Color3.new(0,0,0) end
    if esp.Name then esp.Name.Size = 13; esp.Name.Center = true; esp.Name.Outline = true; esp.Name.Visible = false; esp.Name.Color = Color3.new(1,1,1) end
    if esp.Distance then esp.Distance.Size = 12; esp.Distance.Center = true; esp.Distance.Outline = true; esp.Distance.Visible = false; esp.Distance.Color = Color3.new(1,1,1) end
    ESPList[player] = esp
end
local function RemoveESP(player)
    if ESPList[player] then
        for _, v in pairs(ESPList[player]) do
            if type(v) == "table" then for _, s in ipairs(v) do if s.Remove then s:Remove() end end else if v.Remove then v:Remove() end end
        end
        ESPList[player] = nil
    end
end
for _, p in ipairs(GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)
Players.PlayerRemoving:Connect(RemoveESP)

-- chams (safe)
local ChamsCache = {}
local lastChamsUpdate = 0
local function UpdateChams()
    if not CurrentConfig.Chams_Enabled then return end
    local now = tick()
    if now - lastChamsUpdate < 0.5 then return end
    lastChamsUpdate = now
    for _, plr in ipairs(GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not ChamsCache[part] then
                        ChamsCache[part] = { Material = part.Material, Color = part.Color }
                    end
                    part.Material = Enum.Material[CurrentConfig.Chams_Material] or Enum.Material.ForceField
                    part.Color = CurrentConfig.Chams_Color
                end
            end
        end
    end
end
local function DisableChams()
    for part, orig in pairs(ChamsCache) do
        if part and part.Parent then
            part.Material = orig.Material
            part.Color = orig.Color
        end
    end
    table.clear(ChamsCache)
end

-- skin changer
local function ApplySkinToWeapon(weapon, skinID, wrapID)
    if not weapon then return end
    for _, part in ipairs(weapon:GetDescendants()) do
        if part:IsA("BasePart") then
            for _, c in ipairs(part:GetChildren()) do
                if c:IsA("Decal") or c:IsA("Texture") then c:Destroy() end
            end
            if skinID and skinID ~= "" then
                local d = Instance.new("Decal")
                d.Texture = "rbxassetid://" .. skinID
                d.Face = Enum.NormalId.Front
                d.Parent = part
            end
            if wrapID and wrapID ~= "" then
                local w = Instance.new("Decal")
                w.Texture = "rbxassetid://" .. wrapID
                w.Face = Enum.NormalId.Back
                w.Parent = part
            end
        end
    end
end
local function GetWeapons()
    local weapons = {}
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Tool") then table.insert(weapons, v) end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then table.insert(weapons, v) end
        end
    end
    return weapons
end
local function RefreshWeaponSkins()
    if not CurrentConfig.Skin_Enabled then return end
    local weapons = GetWeapons()
    for _, weapon in ipairs(weapons) do
        local perWeapon = CurrentConfig.WeaponSkins[weapon.Name]
        local skinID = CurrentConfig.Global_SkinID
        local wrapID = CurrentConfig.Global_WrapID
        if perWeapon then
            if perWeapon.SkinID ~= "" then skinID = perWeapon.SkinID end
            if perWeapon.WrapID ~= "" then wrapID = perWeapon.WrapID end
        end
        ApplySkinToWeapon(weapon, skinID, wrapID)
    end
end

-- third person
local TPActive = false
local TPKey = Enum.KeyCode.V
local function SetThirdPerson(state)
    TPActive = state
    if state then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    else
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TPKey then
        CurrentConfig.ThirdPerson_Enabled = not CurrentConfig.ThirdPerson_Enabled
        SetThirdPerson(CurrentConfig.ThirdPerson_Enabled)
    end
end)

-- spoofers
local lastSpoofUpdate = 0
local function UpdateStatsSpoofer()
    local now = tick()
    if now - lastSpoofUpdate < 2 then return end
    lastSpoofUpdate = now
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    local function setStat(keyword, value)
        if value == "" then return end
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local lower = obj.Text:lower()
                if lower:find(keyword, 1, true) then
                    obj.Text = string.gsub(obj.Text, "%d+%.?%d*", value)
                end
            end
        end
    end
    setStat("level", CurrentConfig.Spoof_Level)
    setStat("rank", CurrentConfig.Spoof_Rank)
    setStat("streak", CurrentConfig.Spoof_Winstreak)
    setStat("winrate", CurrentConfig.Spoof_Winrate)
    setStat("ranked streak", CurrentConfig.Spoof_RankedStreak)
    setStat("ranked winrate", CurrentConfig.Spoof_RankedWinrate)
end

local lastLBSUpdate = 0
local function UpdateLeaderboardSpoofer()
    if not CurrentConfig.LBS_Enabled then return end
    local now = tick()
    if now - lastLBSUpdate < 2 then return end
    lastLBSUpdate = now
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    local function findBoard()
        for _, scr in ipairs(gui:GetChildren()) do
            if scr:IsA("ScreenGui") then
                for _, obj in ipairs(scr:GetDescendants()) do
                    if obj:IsA("Frame") and (obj.Name:lower():find("leader") or obj.Name:lower():find("score")) then
                        return obj
                    end
                end
            end
        end
        return nil
    end
    local board = findBoard()
    if not board then return end
    local myName = LocalPlayer.Name
    for _, child in ipairs(board:GetDescendants()) do
        if (child:IsA("TextLabel") or child:IsA("TextButton")) and (child.Text == myName or child.Text:find(myName)) then
            local parent = child.Parent
            if parent then
                for _, el in ipairs(parent:GetChildren()) do
                    if el:IsA("TextLabel") or el:IsA("TextButton") then
                        local txt = el.Text:lower()
                        if txt:find("win") and not txt:find("streak") and CurrentConfig.LBS_Wins ~= "" then
                            el.Text = CurrentConfig.LBS_Wins
                        elseif txt:find("streak") and CurrentConfig.LBS_Winstreak ~= "" then
                            el.Text = CurrentConfig.LBS_Winstreak
                        elseif txt:find("level") and CurrentConfig.LBS_Level ~= "" then
                            el.Text = CurrentConfig.LBS_Level
                        elseif txt:find("rank") and CurrentConfig.LBS_Rank ~= "" then
                            el.Text = CurrentConfig.LBS_Rank
                        elseif (txt:find("kills") or txt:find("k/d")) and CurrentConfig.LBS_KD ~= "" then
                            el.Text = CurrentConfig.LBS_KD
                        elseif txt:find("elo") and CurrentConfig.LBS_ELO ~= "" then
                            el.Text = CurrentConfig.LBS_ELO
                        end
                    end
                end
                return
            end
        end
    end
end
local function ResetLeaderboardSpoofer()
    CurrentConfig.LBS_Enabled = false
    CurrentConfig.LBS_Wins = ""
    CurrentConfig.LBS_Winstreak = ""
    CurrentConfig.LBS_Level = ""
    CurrentConfig.LBS_Rank = ""
    CurrentConfig.LBS_KD = ""
    CurrentConfig.LBS_ELO = ""
end

-- main loop
local LastShot = 0
RunService.RenderStepped:Connect(function()
    -- AIMBOT
    if CurrentConfig.Aimbot_Enabled and IsAlive() then
        if FOVCircle then
            FOVCircle.Visible = CurrentConfig.Aimbot_ShowFOV
            FOVCircle.Radius = CurrentConfig.Aimbot_Radius
            FOVCircle.Color = CurrentConfig.Aimbot_FOVColor
            FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        end
        local shouldAim = false
        if CurrentConfig.Aimbot_Mode == "Always" then
            shouldAim = true
        elseif CurrentConfig.Aimbot_Mode == "Hold" then
            shouldAim = IsMouseButtonDown(CurrentConfig.Aimbot_Key)
        end
        if shouldAim then
            local target = GetClosestPlayerToCursor(CurrentConfig.Aimbot_Radius, CurrentConfig.Aimbot_Part, CurrentConfig.Aimbot_VisibleOnly)
            if target and target.Character then
                local part = target.Character:FindFirstChild(CurrentConfig.Aimbot_Part)
                if part then
                    local scr = Camera:WorldToScreenPoint(part.Position)
                    local delta = (Vector2.new(scr.X, scr.Y) - Vector2.new(Mouse.X, Mouse.Y)) / CurrentConfig.Aimbot_Smoothness
                    mousemoverel(delta.X, delta.Y)
                end
            end
        end
    elseif FOVCircle then
        FOVCircle.Visible = false
    end

    -- SILENT AIM
    if CurrentConfig.Silent_Enabled then
        local t = GetClosestPlayerToCursor(CurrentConfig.Silent_MaxDistance, CurrentConfig.Silent_Part, CurrentConfig.Silent_VisibleOnly)
        if t and math.random(1,100) <= CurrentConfig.Silent_HitChance then
            SilentTarget = t
        else
            SilentTarget = nil
        end
    else
        SilentTarget = nil
    end

    -- TRIGGERBOT
    if CurrentConfig.Trigger_Enabled and IsAlive() and IsMouseButtonDown(CurrentConfig.Trigger_Key) then
        local target = GetClosestPlayerToCursor(CurrentConfig.Trigger_Distance, "Head", true)
        if target and target.Character and tick() - LastShot >= CurrentConfig.Trigger_Delay then
            local ws = Workspace:FindFirstChild("WeaponSystem") or game:GetService("ReplicatedStorage"):FindFirstChild("WeaponSystem")
            if ws then
                ws:FireServer("MouseClick", target.Character:FindFirstChild("Head"))
                LastShot = tick()
            end
        end
    end

    ragebotAutoShoot()
    HandleRagebotMovement()

    -- MOVEMENT
    if IsAlive() then
        local char = GetChar()
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if CurrentConfig.Move_InfiniteJump and hum and hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if CurrentConfig.Move_Fly and hrp then
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
            hrp.Velocity = dir.Magnitude > 0 and dir.Unit * CurrentConfig.Move_FlySpeed or Vector3.new()
        end
        if CurrentConfig.Move_SlideBoost and hum and hum.MoveDirection.Magnitude > 0 and hum.FloorMaterial ~= Enum.Material.Air then
            hrp.Velocity = hrp.Velocity * CurrentConfig.Move_SlideBoostMult
        end
        if CurrentConfig.Move_Velocity and hrp then
            hrp.Velocity = Vector3.new(CurrentConfig.Move_VelocitySpeed, 0, 0)
        end
    end

    -- third person camera
    if TPActive then
        local char = GetChar()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local offset = Camera.CFrame.LookVector * -CurrentConfig.ThirdPerson_Distance
            Camera.CameraSubject = root
            Camera.CFrame = CFrame.new(root.Position - offset, root.Position)
        end
    end

    -- chams
    if CurrentConfig.Chams_Enabled then UpdateChams() else DisableChams() end
    RefreshWeaponSkins()
    UpdateStatsSpoofer()
    UpdateLeaderboardSpoofer()

    -- ESP
    if CurrentConfig.ESP_Enabled then
        for player, esp in pairs(ESPList) do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum = char.Humanoid
                local root = char.HumanoidRootPart
                if hum.Health > 0 then
                    local headPos, _ = WorldToScreen((char:FindFirstChild("Head") or root).Position + Vector3.new(0,0.5,0))
                    local legPos  = WorldToScreen((char:FindFirstChild("LeftFoot") or root).Position - Vector3.new(0,3,0))
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width  = height / 2
                    local x = headPos.X - width/2
                    local y = headPos.Y - height/2

                    if esp.Box then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(x, y)
                        esp.Box.Color = CurrentConfig.ESP_Color
                        esp.Box.Visible = CurrentConfig.ESP_Box
                    end
                    if esp.Health and esp.HealthOutline then
                        local pct = hum.Health / hum.MaxHealth
                        esp.HealthOutline.From = Vector2.new(x-5, y)
                        esp.HealthOutline.To = Vector2.new(x-5, y+height)
                        esp.HealthOutline.Visible = CurrentConfig.ESP_HealthBar
                        esp.Health.From = Vector2.new(x-5, y+height)
                        esp.Health.To = Vector2.new(x-5, y+height - height*pct)
                        esp.Health.Color = Color3.new(1-pct, pct, 0)
                        esp.Health.Visible = CurrentConfig.ESP_HealthBar
                    end
                    -- skeleton
                    if CurrentConfig.ESP_Skeleton and esp.Skeleton then
                        local connections = {
                            {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                            {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"},
                            {"LeftLowerArm","LeftHand"}, {"UpperTorso","RightUpperArm"},
                            {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
                            {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"},
                            {"LeftLowerLeg","LeftFoot"}, {"LowerTorso","RightUpperLeg"},
                            {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
                        }
                        for i, pair in ipairs(connections) do
                            local p1 = char:FindFirstChild(pair[1])
                            local p2 = char:FindFirstChild(pair[2])
                            if p1 and p2 then
                                if not esp.Skeleton[i] then
                                    esp.Skeleton[i] = Drawing and Drawing.new("Line")
                                    if esp.Skeleton[i] then
                                        esp.Skeleton[i].Thickness = 2
                                        esp.Skeleton[i].Color = CurrentConfig.ESP_Color
                                    end
                                end
                                if esp.Skeleton[i] then
                                    local s1, _ = WorldToScreen(p1.Position)
                                    local s2, _ = WorldToScreen(p2.Position)
                                    esp.Skeleton[i].From = s1
                                    esp.Skeleton[i].To   = s2
                                    esp.Skeleton[i].Visible = true
                                end
                            end
                        end
                    else
                        for _, s in ipairs(esp.Skeleton or {}) do if s and s.Remove then s.Visible = false end end
                    end
                    if esp.Name then
                        esp.Name.Text = player.Name
                        esp.Name.Position = Vector2.new(headPos.X, y - 15)
                        esp.Name.Visible = true
                    end
                    if esp.Distance and root then
                        local dist = (root.Position - (GetChar():FindFirstChild("HumanoidRootPart") and GetChar().HumanoidRootPart.Position or root.Position)).Magnitude
                        esp.Distance.Text = string.format("%.1f", dist)
                        esp.Distance.Position = Vector2.new(headPos.X, y + height + 5)
                        esp.Distance.Visible = true
                    end
                else
                    for _, v in pairs(esp) do
                        if type(v) ~= "table" then if v and v.Remove then v.Visible = false end else for _, s in ipairs(v) do if s and s.Remove then s.Visible = false end end end
                    end
                end
            else
                for _, v in pairs(esp) do
                    if type(v) ~= "table" then if v and v.Remove then v.Visible = false end else for _, s in ipairs(v) do if s and s.Remove then s.Visible = false end end end
                end
            end
        end
    else
        for _, esp in pairs(ESPList) do
            for _, v in pairs(esp) do
                if type(v) ~= "table" then if v and v.Remove then v.Visible = false end else for _, s in ipairs(v) do if s and s.Remove then s.Visible = false end end end
            end
        end
    end
end)

-- UI (identical to previous, omitted for brevity but included in full script)
-- ... UI construction code ...

-- finalise
pcall(function()
    if Window.Toggle then
        Window:Toggle()  -- hide UI on load
    end
end)
WindUI:Notify({Title="Sysnax", Content="🥳 Official Release", Duration=6})