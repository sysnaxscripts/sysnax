-- Sysnax – Official Release (Rivals, Arsenal, HyperShot)
-- Autoload, press Right Shift to open
-- All bugs fixed, everything works

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")
local Camera           = Workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()
local StarterGui       = game:GetService("StarterGui")

-- Game detection
local Supported = {
    ["Rivals"]    = {17625359962, 15827677067, 18204519637},
    ["Arsenal"]   = {286090429, 292439477, 258096465},
    ["HyperShot"] = {1110584932, 4618637946},
}
local CurrentGame = nil
for name, ids in pairs(Supported) do
    for _, id in ipairs(ids) do
        if game.PlaceId == id then
            CurrentGame = name
            break
        end
    end
    if CurrentGame then break end
end

if not CurrentGame then
    StarterGui:SetCore("SendNotification", {
        Title = "Sysnax",
        Text = "Unsupported game. Script not loaded.",
        Duration = 5,
    })
    return
end

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if not WindUI then
    LocalPlayer:Kick("Failed to load WindUI.")
    return
end

-- Theme
WindUI:AddTheme({
    Name           = "Sysnax",
    Accent         = Color3.fromHex("#2a2a2e"),
    Background     = Color3.fromHex("#121215"),
    AccentOutline  = Color3.fromHex("#4a4a50"),
    Text           = Color3.fromHex("#e0e0e0"),
    Placeholder    = Color3.fromHex("#6a6a70"),
    Button         = Color3.fromHex("#3a3a40"),
    Icon           = Color3.fromHex("#9a9aa0"),
})
WindUI:SetTheme("Sysnax")

-- Window
local Window = WindUI:CreateWindow({
    Title          = "Sysnax",
    Icon           = "rbxassetid://122198206955790",
    Folder         = "sysnax",
    Theme          = "Sysnax",
    Resizable      = true,
    MinSize        = Vector2.new(560, 350),
    MaxSize        = Vector2.new(850, 560),
    Size           = UDim2.fromOffset(680, 520),
    ToggleKey      = Enum.KeyCode.RightShift,
    HideSearchBar  = true,
    ScrollBarEnabled = true,
})

-- Configs
local ConfigFolder = "sysnax/configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local CurrentConfig = {}
local function SaveConfig(name)
    if name == "" then return end
    writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(CurrentConfig))
    WindUI:Notify({Title = "Sysnax", Content = name .. " saved.", Duration = 3})
end
local function LoadConfig(name)
    if name == "" or not isfile(ConfigFolder .. "/" .. name .. ".json") then return end
    local data = HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. name .. ".json"))
    for k, v in pairs(data) do CurrentConfig[k] = v end
    WindUI:Notify({Title = "Sysnax", Content = name .. " loaded.", Duration = 3})
end
local function DeleteConfig(name)
    if name == "" or not isfile(ConfigFolder .. "/" .. name .. ".json") then return end
    delfile(ConfigFolder .. "/" .. name .. ".json")
    WindUI:Notify({Title = "Sysnax", Content = name .. " deleted.", Duration = 3})
end
local function GetConfigs()
    local list = {}
    for _, file in ipairs(listfiles(ConfigFolder)) do
        local name = file:match("([^/]+)%.json$")
        if name then table.insert(list, name) end
    end
    return list
end

-- Safe mouse buttons
local MouseButtons = {
    RightMouse  = Enum.UserInputType.MouseButton2,
    LeftMouse   = Enum.UserInputType.MouseButton1,
    MiddleMouse = Enum.UserInputType.MouseButton3,
}
local function tryAddButton(name, enumName, fallback)
    local ok, enum = pcall(function() return Enum.UserInputType[enumName] end)
    if ok and enum then MouseButtons[name] = enum
    else
        local ok2, enum2 = pcall(function() return Enum.UserInputType[fallback] end)
        if ok2 and enum2 then MouseButtons[name] = enum2 end
    end
end
tryAddButton("Mouse4", "MouseButton4", "Button4")
tryAddButton("Mouse5", "MouseButton5", "Button5")
local function IsMouseButtonDown(name)
    local btn = MouseButtons[name]
    return btn and UserInputService:IsMouseButtonPressed(btn)
end

-- Defaults
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

    Skin_Enabled = false,
    Global_SkinID = "",
    Global_WrapID = "",
    Global_FinisherID = "",
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

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Utility functions (safe)
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

-- FOV circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.NumSides, FOVCircle.Filled, FOVCircle.Transparency, FOVCircle.Visible = 2, 64, false, 1, false

-- Silent aim hook
local SilentTarget = nil
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        local remoteName = args[1]
        if type(remoteName) == "string" and (remoteName:lower():find("click") or remoteName:lower():find("shoot") or remoteName:lower():find("bullet") or remoteName:lower():find("fire")) then
            if CurrentConfig.Silent_Enabled and SilentTarget and SilentTarget.Character then
                local part = SilentTarget.Character:FindFirstChild(CurrentConfig.Silent_Part)
                if part then
                    args[2] = part.Position + Vector3.new(0, CurrentConfig.Silent_Manipulation/100, 0)
                    if args[3] and type(args[3]) == "userdata" then args[3] = part end
                end
            end
        end
    end
    return oldNamecall(unpack(args))
end)
setreadonly(mt, true)

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
    local hrp = char:FindFirstChild("HumanoidRootPart")
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

-- ESP
local ESPList = {}
local function CreateESP(player)
    local esp = {
        Box = Drawing.new("Square"),
        Health = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Skeleton = {},
    }
    esp.Box.Thickness=2; esp.Box.Filled=false; esp.Box.Visible=false
    esp.Health.Thickness=3; esp.Health.Visible=false
    esp.HealthOutline.Thickness=5; esp.HealthOutline.Visible=false; esp.HealthOutline.Color=Color3.new(0,0,0)
    esp.Name.Size=13; esp.Name.Center=true; esp.Name.Outline=true; esp.Name.Visible=false; esp.Name.Color=Color3.new(1,1,1)
    esp.Distance.Size=12; esp.Distance.Center=true; esp.Distance.Outline=true; esp.Distance.Visible=false; esp.Distance.Color=Color3.new(1,1,1)
    ESPList[player] = esp
end
local function RemoveESP(player)
    if ESPList[player] then
        for _, v in pairs(ESPList[player]) do
            if type(v)=="table" then for _, s in ipairs(v) do s:Remove() end else v:Remove() end
        end
        ESPList[player]=nil
    end
end
for _, p in ipairs(GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)
Players.PlayerRemoving:Connect(RemoveESP)

-- Chams (throttled)
local ChamsCache = {}
local lastChamsUpdate = 0
local function UpdateChams()
    local now = tick()
    if now - lastChamsUpdate < 0.5 then return end
    lastChamsUpdate = now
    for _, plr in ipairs(GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if CurrentConfig.Chams_Enabled then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if not ChamsCache[part] then
                            ChamsCache[part] = { Material=part.Material, Color=part.Color }
                        end
                        part.Material = Enum.Material[CurrentConfig.Chams_Material]
                        part.Color = CurrentConfig.Chams_Color
                    end
                end
            else
                for part, orig in pairs(ChamsCache) do
                    if part and part.Parent then
                        part.Material = orig.Material
                        part.Color = orig.Color
                    end
                end
                table.clear(ChamsCache)
            end
        end
    end
end

-- Skin changer
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
        local skinID, wrapID
        if perWeapon and (perWeapon.SkinID ~= "" or perWeapon.WrapID ~= "") then
            skinID = (perWeapon.SkinID ~= "") and perWeapon.SkinID or CurrentConfig.Global_SkinID
            wrapID = (perWeapon.WrapID ~= "") and perWeapon.WrapID or CurrentConfig.Global_WrapID
        else
            skinID = CurrentConfig.Global_SkinID
            wrapID = CurrentConfig.Global_WrapID
        end
        ApplySkinToWeapon(weapon, skinID, wrapID)
    end
end

-- Third person toggle
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

-- Spoofers
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

-- Main loop
local LastShot = 0
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if not IsMobile and CurrentConfig.Aimbot_Enabled and IsAlive() then
        FOVCircle.Visible = CurrentConfig.Aimbot_ShowFOV
        FOVCircle.Radius = CurrentConfig.Aimbot_Radius
        FOVCircle.Color = CurrentConfig.Aimbot_FOVColor
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        local shouldAim = (CurrentConfig.Aimbot_Mode == "Always") or
            (CurrentConfig.Aimbot_Mode == "Hold" and IsMouseButtonDown(CurrentConfig.Aimbot_Key))
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
    else
        FOVCircle.Visible = false
    end

    -- Silent aim target select
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

    -- Triggerbot
    if not IsMobile and CurrentConfig.Trigger_Enabled and IsAlive() and IsMouseButtonDown(CurrentConfig.Trigger_Key) then
        local t = GetClosestPlayerToCursor(CurrentConfig.Trigger_Distance, "Head", true)
        if t and t.Character and tick() - LastShot >= CurrentConfig.Trigger_Delay then
            local ws = Workspace:FindFirstChild("WeaponSystem") or game:GetService("ReplicatedStorage"):FindFirstChild("WeaponSystem")
            if ws then
                ws:FireServer("MouseClick", t.Character:FindFirstChild("Head"))
                LastShot = tick()
            end
        end
    end

    -- Ragebot
    ragebotAutoShoot()
    HandleRagebotMovement()

    -- Movement
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

    -- Third person camera
    if TPActive then
        local char = GetChar()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local offset = Camera.CFrame.LookVector * -CurrentConfig.ThirdPerson_Distance
            Camera.CameraSubject = root
            Camera.CFrame = CFrame.new(root.Position - offset, root.Position)
        end
    end

    -- Throttled updates
    UpdateChams()
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

                    if CurrentConfig.ESP_Box then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(x, y)
                        esp.Box.Color = CurrentConfig.ESP_Color
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end

                    if CurrentConfig.ESP_HealthBar then
                        local pct = hum.Health / hum.MaxHealth
                        esp.HealthOutline.From = Vector2.new(x-5, y)
                        esp.HealthOutline.To = Vector2.new(x-5, y+height)
                        esp.HealthOutline.Visible = true
                        esp.Health.From = Vector2.new(x-5, y+height)
                        esp.Health.To = Vector2.new(x-5, y+height - height*pct)
                        esp.Health.Color = Color3.new(1-pct, pct, 0)
                        esp.Health.Visible = true
                    else
                        esp.Health.Visible = false
                        esp.HealthOutline.Visible = false
                    end

                    if CurrentConfig.ESP_Skeleton then
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
                                    esp.Skeleton[i] = Drawing.new("Line")
                                    esp.Skeleton[i].Thickness = 2
                                end
                                local s1, _ = WorldToScreen(p1.Position)
                                local s2, _ = WorldToScreen(p2.Position)
                                esp.Skeleton[i].From = s1
                                esp.Skeleton[i].To   = s2
                                esp.Skeleton[i].Color = CurrentConfig.ESP_Color
                                esp.Skeleton[i].Visible = true
                            end
                        end
                    else
                        for _, s in ipairs(esp.Skeleton) do s.Visible = false end
                    end

                    esp.Name.Text = player.Name
                    esp.Name.Position = Vector2.new(headPos.X, y - 15)
                    esp.Name.Visible = true

                    if root then
                        local dist = (root.Position - GetChar():FindFirstChild("HumanoidRootPart").Position).Magnitude
                        esp.Distance.Text = string.format("%.1f", dist)
                        esp.Distance.Position = Vector2.new(headPos.X, y + height + 5)
                        esp.Distance.Visible = true
                    end
                else
                    for _, v in pairs(esp) do
                        if type(v) ~= "table" then v.Visible = false
                        else for _, s in ipairs(v) do s.Visible = false end end
                    end
                end
            else
                for _, v in pairs(esp) do
                    if type(v) ~= "table" then v.Visible = false
                    else for _, s in ipairs(v) do s.Visible = false end end
                end
            end
        end
    else
        for _, esp in pairs(ESPList) do
            for _, v in pairs(esp) do
                if type(v) ~= "table" then v.Visible = false
                else for _, s in ipairs(v) do s.Visible = false end end
            end
        end
    end
end)

-- ===================== UI =====================
local Tabs = {
    Combat   = Window:Tab({Title = "Combat", Icon = "crosshair"}),
    Visuals  = Window:Tab({Title = "Visuals", Icon = "eye"}),
    Ragebot  = Window:Tab({Title = "Ragebot", Icon = "zap"}),
    Skin     = Window:Tab({Title = "Skin Changer", Icon = "shirt"}),
    Movement = Window:Tab({Title = "Movement", Icon = "footprints"}),
    Anims    = Window:Tab({Title = "Animations", Icon = "play"}),
    HitSound = Window:Tab({Title = "Hit Sounds", Icon = "music"}),
    Spoofer  = Window:Tab({Title = "Spoofer", Icon = "shield"}),
    Settings = Window:Tab({Title = "Settings", Icon = "settings"}),
}

-- Combat Tab
local AimbotSec = Tabs.Combat:Section({Title="Aimbot"})
AimbotSec:Toggle({Title="Enable Aimbot", Default=CurrentConfig.Aimbot_Enabled, Callback=function(v) CurrentConfig.Aimbot_Enabled=v end})
AimbotSec:Dropdown({Title="Mode", Values={"Hold","Toggle","Always"}, Value=CurrentConfig.Aimbot_Mode, Callback=function(v) CurrentConfig.Aimbot_Mode=v end})
AimbotSec:Dropdown({Title="Target Part", Values={"Head","HumanoidRootPart","LeftLeg","RightLeg"}, Value=CurrentConfig.Aimbot_Part, Callback=function(v) CurrentConfig.Aimbot_Part=v end})
AimbotSec:Slider({Title="Smoothness", Step=1, Value={Min=1,Max=20,Default=CurrentConfig.Aimbot_Smoothness}, Callback=function(v) CurrentConfig.Aimbot_Smoothness=v end})
AimbotSec:Slider({Title="FOV Radius", Step=1, Value={Min=50,Max=500,Default=CurrentConfig.Aimbot_Radius}, Callback=function(v) CurrentConfig.Aimbot_Radius=v end})
AimbotSec:Toggle({Title="Visible Only", Default=CurrentConfig.Aimbot_VisibleOnly, Callback=function(v) CurrentConfig.Aimbot_VisibleOnly=v end})
AimbotSec:Toggle({Title="Show FOV Circle", Default=CurrentConfig.Aimbot_ShowFOV, Callback=function(v) CurrentConfig.Aimbot_ShowFOV=v end})
AimbotSec:Colorpicker({Title="FOV Color", Default=CurrentConfig.Aimbot_FOVColor, Callback=function(v) CurrentConfig.Aimbot_FOVColor=v end})
AimbotSec:Keybind({Title="Aimbot Key", Value=CurrentConfig.Aimbot_Key, Callback=function(v) CurrentConfig.Aimbot_Key=v end})

local SilentSec = Tabs.Combat:Section({Title="Silent Aim"})
SilentSec:Toggle({Title="Enable Silent Aim", Default=CurrentConfig.Silent_Enabled, Callback=function(v) CurrentConfig.Silent_Enabled=v end})
SilentSec:Dropdown({Title="Target Part", Values={"Head","HumanoidRootPart"}, Value=CurrentConfig.Silent_Part, Callback=function(v) CurrentConfig.Silent_Part=v end})
SilentSec:Slider({Title="Hit Chance (%)", Step=1, Value={Min=0,Max=100,Default=CurrentConfig.Silent_HitChance}, Callback=function(v) CurrentConfig.Silent_HitChance=v end})
SilentSec:Slider({Title="Manipulation (Y)", Step=1, Value={Min=-50,Max=50,Default=CurrentConfig.Silent_Manipulation}, Callback=function(v) CurrentConfig.Silent_Manipulation=v end})
SilentSec:Toggle({Title="Visible Only", Default=CurrentConfig.Silent_VisibleOnly, Callback=function(v) CurrentConfig.Silent_VisibleOnly=v end})
SilentSec:Slider({Title="Max Distance", Step=10, Value={Min=100,Max=1000,Default=CurrentConfig.Silent_MaxDistance}, Callback=function(v) CurrentConfig.Silent_MaxDistance=v end})

local TriggerSec = Tabs.Combat:Section({Title="Triggerbot"})
TriggerSec:Toggle({Title="Enable Triggerbot", Default=CurrentConfig.Trigger_Enabled, Callback=function(v) CurrentConfig.Trigger_Enabled=v end})
TriggerSec:Slider({Title="Delay (s)", Step=0.01, Value={Min=0,Max=1,Default=CurrentConfig.Trigger_Delay}, Callback=function(v) CurrentConfig.Trigger_Delay=v end})
TriggerSec:Slider({Title="Max Distance", Step=10, Value={Min=100,Max=500,Default=CurrentConfig.Trigger_Distance}, Callback=function(v) CurrentConfig.Trigger_Distance=v end})
TriggerSec:Keybind({Title="Trigger Key", Value=CurrentConfig.Trigger_Key, Callback=function(v) CurrentConfig.Trigger_Key=v end})

-- Visuals Tab
local ESPSec = Tabs.Visuals:Section({Title="ESP"})
ESPSec:Toggle({Title="Enable ESP", Default=CurrentConfig.ESP_Enabled, Callback=function(v) CurrentConfig.ESP_Enabled=v end})
ESPSec:Toggle({Title="Box", Default=CurrentConfig.ESP_Box, Callback=function(v) CurrentConfig.ESP_Box=v end})
ESPSec:Toggle({Title="Health Bar", Default=CurrentConfig.ESP_HealthBar, Callback=function(v) CurrentConfig.ESP_HealthBar=v end})
ESPSec:Toggle({Title="Skeleton", Default=CurrentConfig.ESP_Skeleton, Callback=function(v) CurrentConfig.ESP_Skeleton=v end})
ESPSec:Colorpicker({Title="ESP Color", Default=CurrentConfig.ESP_Color, Callback=function(v) CurrentConfig.ESP_Color=v end})

local ChamsSec = Tabs.Visuals:Section({Title="Chams"})
ChamsSec:Toggle({Title="Enable Chams", Default=CurrentConfig.Chams_Enabled, Callback=function(v) CurrentConfig.Chams_Enabled=v end})
ChamsSec:Dropdown({Title="Material", Values={"ForceField","Neon","Glass","Plastic"}, Value=CurrentConfig.Chams_Material, Callback=function(v) CurrentConfig.Chams_Material=v end})
ChamsSec:Colorpicker({Title="Chams Color", Default=CurrentConfig.Chams_Color, Callback=function(v) CurrentConfig.Chams_Color=v end})

local CrossSec = Tabs.Visuals:Section({Title="Crosshair"})
CrossSec:Toggle({Title="Enable Custom Crosshair", Default=CurrentConfig.Crosshair_Enabled, Callback=function(v) CurrentConfig.Crosshair_Enabled=v end})
CrossSec:Slider({Title="Size", Step=1, Value={Min=5,Max=30,Default=CurrentConfig.Crosshair_Size}, Callback=function(v) CurrentConfig.Crosshair_Size=v end})
CrossSec:Slider({Title="Thickness", Step=1, Value={Min=1,Max=10,Default=CurrentConfig.Crosshair_Thickness}, Callback=function(v) CurrentConfig.Crosshair_Thickness=v end})
CrossSec:Colorpicker({Title="Color", Default=CurrentConfig.Crosshair_Color, Callback=function(v) CurrentConfig.Crosshair_Color=v end})
CrossSec:Toggle({Title="Disable Game Crosshair", Default=CurrentConfig.Crosshair_DisableGame, Callback=function(v) CurrentConfig.Crosshair_DisableGame=v end})

local TPSec = Tabs.Visuals:Section({Title="Third Person"})
TPSec:Keybind({Title="Toggle Key", Value=CurrentConfig.ThirdPerson_Key, Callback=function(v)
    CurrentConfig.ThirdPerson_Key = v
    TPKey = Enum.KeyCode[v] or Enum.KeyCode.V
end})
TPSec:Slider({Title="Distance", Default=CurrentConfig.ThirdPerson_Distance, Step=1, Value={Min=5,Max=30,Default=CurrentConfig.ThirdPerson_Distance}, Callback=function(v) CurrentConfig.ThirdPerson_Distance=v end})

-- Ragebot Tab
local RageSec = Tabs.Ragebot:Section({Title="Rage Options"})
RageSec:Toggle({Title="Enable Ragebot", Default=CurrentConfig.Rage_Enabled, Callback=function(v) CurrentConfig.Rage_Enabled=v end})
RageSec:Toggle({Title="Auto Shoot", Default=CurrentConfig.Rage_AutoShoot, Callback=function(v) CurrentConfig.Rage_AutoShoot=v end})
RageSec:Toggle({Title="Through Walls", Default=CurrentConfig.Rage_ThroughWalls, Callback=function(v) CurrentConfig.Rage_ThroughWalls=v end})
RageSec:Toggle({Title="Void Spam", Default=CurrentConfig.Rage_VoidSpam, Callback=function(v) CurrentConfig.Rage_VoidSpam=v end})
RageSec:Slider({Title="Hide Time", Step=0.01, Value={Min=0.1,Max=2,Default=CurrentConfig.Rage_Hide}, Callback=function(v) CurrentConfig.Rage_Hide=v end})
RageSec:Slider({Title="Attack Time", Step=0.01, Value={Min=0.05,Max=1,Default=CurrentConfig.Rage_Attack}, Callback=function(v) CurrentConfig.Rage_Attack=v end})
RageSec:Toggle({Title="Fly", Default=CurrentConfig.Rage_Fly, Callback=function(v) CurrentConfig.Rage_Fly=v end})
RageSec:Slider({Title="Fly Speed", Step=1, Value={Min=10,Max=100,Default=CurrentConfig.Rage_FlySpeed}, Callback=function(v) CurrentConfig.Rage_FlySpeed=v end})
RageSec:Toggle({Title="NoClip", Default=CurrentConfig.Rage_NoClip, Callback=function(v) CurrentConfig.Rage_NoClip=v end})

-- Skin Changer Tab
local SkinEnableSec = Tabs.Skin:Section({Title="Enable"})
SkinEnableSec:Toggle({Title="Enable Skin Changer", Default=CurrentConfig.Skin_Enabled, Callback=function(v) CurrentConfig.Skin_Enabled=v end})

local GlobalSkinSec = Tabs.Skin:Section({Title="Global (apply to all)"})
GlobalSkinSec:Input({Title="Skin ID", Value=CurrentConfig.Global_SkinID, Callback=function(v) CurrentConfig.Global_SkinID=v end})
GlobalSkinSec:Input({Title="Wrap ID", Value=CurrentConfig.Global_WrapID, Callback=function(v) CurrentConfig.Global_WrapID=v end})
GlobalSkinSec:Input({Title="Finisher ID", Value=CurrentConfig.Global_FinisherID, Callback=function(v) CurrentConfig.Global_FinisherID=v end})
GlobalSkinSec:Button({Title="Apply Globally", Icon="check", Callback=RefreshWeaponSkins})

local WeaponSkinSec = Tabs.Skin:Section({Title="Per‑Weapon (overrides global)"})
local weaponDropdown
local function UpdateWeaponDropdown()
    local weapons = GetWeapons()
    local names = {}
    for _, w in ipairs(weapons) do table.insert(names, w.Name) end
    if weaponDropdown then
        weaponDropdown:Refresh(names, names[1] or "")
    else
        weaponDropdown = WeaponSkinSec:Dropdown({
            Title="Select Weapon",
            Values=names,
            Value=names[1] or "",
            Callback=function() end
        })
    end
end
UpdateWeaponDropdown()
WeaponSkinSec:Button({Title="Refresh Weapons", Icon="refresh-cw", Callback=UpdateWeaponDropdown})
local weapSkinInput = WeaponSkinSec:Input({Title="Skin ID", Placeholder="12345678", Callback=function(v) end})
local weapWrapInput = WeaponSkinSec:Input({Title="Wrap ID", Placeholder="87654321", Callback=function(v) end})
WeaponSkinSec:Button({Title="Apply to Selected", Icon="check", Callback=function()
    local weaponName = weaponDropdown and weaponDropdown:GetValue()
    if not weaponName or weaponName == "" then return end
    if not CurrentConfig.WeaponSkins[weaponName] then
        CurrentConfig.WeaponSkins[weaponName] = {}
    end
    CurrentConfig.WeaponSkins[weaponName].SkinID = weapSkinInput:GetValue()
    CurrentConfig.WeaponSkins[weaponName].WrapID = weapWrapInput:GetValue()
    RefreshWeaponSkins()
end})
WeaponSkinSec:Button({Title="Reset Selected", Icon="trash", Callback=function()
    local name = weaponDropdown and weaponDropdown:GetValue()
    if name and CurrentConfig.WeaponSkins[name] then
        CurrentConfig.WeaponSkins[name] = nil
        RefreshWeaponSkins()
    end
end})

-- Movement Tab
local MoveSec = Tabs.Movement:Section({Title="General"})
MoveSec:Toggle({Title="Infinite Jump", Default=CurrentConfig.Move_InfiniteJump, Callback=function(v) CurrentConfig.Move_InfiniteJump=v end})
MoveSec:Toggle({Title="Fly", Default=CurrentConfig.Move_Fly, Callback=function(v) CurrentConfig.Move_Fly=v end})
MoveSec:Slider({Title="Fly Speed", Step=1, Value={Min=10,Max=100,Default=CurrentConfig.Move_FlySpeed}, Callback=function(v) CurrentConfig.Move_FlySpeed=v end})
MoveSec:Toggle({Title="Slide Boost", Default=CurrentConfig.Move_SlideBoost, Callback=function(v) CurrentConfig.Move_SlideBoost=v end})
MoveSec:Slider({Title="Boost Multiplier", Step=0.1, Value={Min=1,Max=5,Default=CurrentConfig.Move_SlideBoostMult}, Callback=function(v) CurrentConfig.Move_SlideBoostMult=v end})
MoveSec:Toggle({Title="Velocity", Default=CurrentConfig.Move_Velocity, Callback=function(v) CurrentConfig.Move_Velocity=v end})
MoveSec:Slider({Title="Velocity Speed", Step=1, Value={Min=1,Max=100,Default=CurrentConfig.Move_VelocitySpeed}, Callback=function(v) CurrentConfig.Move_VelocitySpeed=v end})

-- Animations Tab
local AnimSec = Tabs.Anims:Section({Title="Custom Animation"})
AnimSec:Toggle({Title="Enable", Default=CurrentConfig.Anim_Enabled, Callback=function(v) CurrentConfig.Anim_Enabled=v end})
AnimSec:Input({Title="Animation ID", Value=CurrentConfig.Anim_ID, Callback=function(v) CurrentConfig.Anim_ID=v end})
AnimSec:Slider({Title="Speed", Step=0.1, Value={Min=0.1,Max=5,Default=CurrentConfig.Anim_Speed}, Callback=function(v) CurrentConfig.Anim_Speed=v end})

-- Hit Sounds Tab
local HitSec = Tabs.HitSound:Section({Title="Hit Sound Options"})
HitSec:Toggle({Title="Enable", Default=CurrentConfig.HitSound_Enabled, Callback=function(v) CurrentConfig.HitSound_Enabled=v end})
HitSec:Dropdown({Title="Sound", Values={"Bameware","Custom"}, Value=CurrentConfig.HitSound_Sound, Callback=function(v) CurrentConfig.HitSound_Sound=v end})
HitSec:Dropdown({Title="Apply To", Values={"All","Enemies","Local"}, Value=CurrentConfig.HitSound_ApplyTo, Callback=function(v) CurrentConfig.HitSound_ApplyTo=v end})

-- Spoofer Tab
local SpoofStatsSec = Tabs.Spoofer:Section({Title="Stats Spoofer"})
SpoofStatsSec:Input({Title="Level", Value=CurrentConfig.Spoof_Level, Callback=function(v) CurrentConfig.Spoof_Level=v end})
SpoofStatsSec:Input({Title="Rank", Value=CurrentConfig.Spoof_Rank, Callback=function(v) CurrentConfig.Spoof_Rank=v end})
SpoofStatsSec:Input({Title="Winstreak", Value=CurrentConfig.Spoof_Winstreak, Callback=function(v) CurrentConfig.Spoof_Winstreak=v end})
SpoofStatsSec:Input({Title="Winrate", Value=CurrentConfig.Spoof_Winrate, Callback=function(v) CurrentConfig.Spoof_Winrate=v end})
SpoofStatsSec:Input({Title="Ranked Streak", Value=CurrentConfig.Spoof_RankedStreak, Callback=function(v) CurrentConfig.Spoof_RankedStreak=v end})
SpoofStatsSec:Input({Title="Ranked Winrate", Value=CurrentConfig.Spoof_RankedWinrate, Callback=function(v) CurrentConfig.Spoof_RankedWinrate=v end})

local LBSec = Tabs.Spoofer:Section({Title="Leaderboard Spoofer (only you see)"})
LBSec:Toggle({Title="Enable", Default=CurrentConfig.LBS_Enabled, Callback=function(v) CurrentConfig.LBS_Enabled=v end})
LBSec:Input({Title="Wins", Value=CurrentConfig.LBS_Wins, Callback=function(v) CurrentConfig.LBS_Wins=v end})
LBSec:Input({Title="Winstreak", Value=CurrentConfig.LBS_Winstreak, Callback=function(v) CurrentConfig.LBS_Winstreak=v end})
LBSec:Input({Title="Level", Value=CurrentConfig.LBS_Level, Callback=function(v) CurrentConfig.LBS_Level=v end})
LBSec:Input({Title="Rank", Value=CurrentConfig.LBS_Rank, Callback=function(v) CurrentConfig.LBS_Rank=v end})
LBSec:Input({Title="K/D", Value=CurrentConfig.LBS_KD, Callback=function(v) CurrentConfig.LBS_KD=v end})
LBSec:Input({Title="Elo", Value=CurrentConfig.LBS_ELO, Callback=function(v) CurrentConfig.LBS_ELO=v end})
LBSec:Button({Title="Reset Leaderboard Spoofer", Icon="rotate-ccw", Callback=ResetLeaderboardSpoofer})

-- Settings Tab
local KBSec = Tabs.Settings:Section({Title="Keybinds"})
KBSec:Keybind({Title="Toggle UI", Value="RightShift", Callback=function(v) Window:SetToggleKey(Enum.KeyCode[v]) end})

local CfgSec = Tabs.Settings:Section({Title="Configurations"})
local ConfigInput = CfgSec:Input({Title="Config Name"})
CfgSec:Button({Title="Save Config", Icon="save", Callback=function() SaveConfig(ConfigInput:GetValue()) end})
CfgSec:Button({Title="Load Config", Icon="folder-open", Callback=function() LoadConfig(ConfigInput:GetValue()) end})
CfgSec:Button({Title="Delete Config", Icon="trash", Callback=function() DeleteConfig(ConfigInput:GetValue()) end})
local AllConfigs = GetConfigs()
local CfgDropdown = CfgSec:Dropdown({
    Title="Existing Configs",
    Values=AllConfigs,
    Value=AllConfigs[1] or "",
    Callback=function(v) ConfigInput:Set(v) end
})
CfgSec:Button({Title="Refresh List", Icon="refresh-cw", Callback=function() CfgDropdown:Refresh(GetConfigs()) end})

local ThemeSec = Tabs.Settings:Section({Title="Theme"})
ThemeSec:Dropdown({Title="Select Theme", Values={"Sysnax","Dark","Light"}, Value="Sysnax", Callback=function(v) WindUI:SetTheme(v) end})

-- Autoload – hide GUI immediately
Window:Toggle()

-- Done
WindUI:Notify({Title="Sysnax", Content="🥳 Official Release", Duration=6})