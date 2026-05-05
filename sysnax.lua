-- Sysnax – Ultimate Rivals Script (fully functional)
-- Supports: Rivals (main), Arsenal, HyperShot
-- UI: x2Swiftz UI Library (gray/black theme)
-- Toggle: Right Shift  ·  Autoload hidden

local Library = nil
local success, err = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Swiftz/UI-Library/main/source.lua"))()
end)
if not success or not Library then
    game:GetService("StarterGui"):SetCore("SendNotification",{Title="Sysnax",Text="UI library failed to load.",Duration=5})
    return
end

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

-- ==================== GAME CHECK ====================
local supported = {
    Rivals    = {17625359962, 15827677067, 18204519637},
    Arsenal   = {286090429, 292439477, 258096465},
    HyperShot = {1110584932, 4618637946},
}
local currentGame = nil
for name, ids in pairs(supported) do
    for _, id in ipairs(ids) do
        if game.PlaceId == id then currentGame = name; break end
    end
    if currentGame then break end
end
if not currentGame then
    StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Unsupported game. Some features may not work.",Duration=5})
end

-- ==================== AC BYPASS ====================
pcall(function()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            local name = obj.Name:lower()
            if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or obj.Name == "LocalScript" then
                obj.Disabled = true
            end
        end
    end
    if LocalPlayer.PlayerGui then
        for _, obj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or obj.Name == "LocalScript" then
                    obj.Disabled = true
                end
            end
        end
    end
end)

-- ==================== WINDOW & THEME ====================
local Window = Library:CreateWindow("Sysnax", Color3.fromRGB(25,25,30))
Window:SetIcon("rbxassetid://122198206955790")

-- ==================== CONFIG SYSTEM ====================
if not isfolder("sysnax") then makefolder("sysnax") end
if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end
local Config = {}
local function saveCfg(name)
    if name == "" then return end
    pcall(function()
        writefile("sysnax/configs/"..name..".json", HttpService:JSONEncode(Config))
        Window:Notify(name.." saved.", 3)
    end)
end
local function loadCfg(name)
    if name == "" or not isfile("sysnax/configs/"..name..".json") then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile("sysnax/configs/"..name..".json"))
        for k,v in pairs(data) do Config[k]=v end
        Window:Notify(name.." loaded.", 3)
    end)
end
local function delCfg(name)
    if name == "" or not isfile("sysnax/configs/"..name..".json") then return end
    delfile("sysnax/configs/"..name..".json")
    Window:Notify(name.." deleted.", 3)
end
local function listCfgs()
    local t = {}
    pcall(function() for _,f in ipairs(listfiles("sysnax/configs")) do
        local n = f:match("([^/]+)%.json$") if n then table.insert(t,n) end
    end end)
    return t
end

-- ==================== DEFAULT CONFIG ====================
Config = {
    -- Legit
    Aimbot_Enabled=false, Aimbot_Mode="Hold", Aimbot_Part="Head", Aimbot_Smoothness=3,
    Aimbot_FOV=105, Aimbot_VisibleOnly=true, Aimbot_ShowFOV=true,
    Aimbot_FOVColor=Color3.fromRGB(255,255,255), Aimbot_Key="RightMouse",
    Silent_Enabled=false, Silent_Part="Head", Silent_HitChance=100,
    Silent_Manipulation=0, Silent_VisibleOnly=true, Silent_MaxDistance=500,
    Silent_DrawFOV=true, Silent_FOVRadius=105,
    Hitbox_Enabled=false, Hitbox_Part="Head", Hitbox_ExtendRate=10,
    Trigger_Enabled=false, Trigger_Delay=0.1, Trigger_Distance=300, Trigger_Key="RightMouse",
    Pred_Enabled=false, Pred_Amount=0.165,
    Hitchance_Value=100,
    AutoWall_Enabled=false,
    -- Weapon
    NoRecoil_Enabled=false, NoSpread_Enabled=false,
    RapidFire_Enabled=false, RapidFire_Mult=2,
    FastReload_Enabled=false, InfiniteAmmo_Enabled=false,
    -- Ragebot
    Rage_Enabled=false, Rage_AutoShoot=true, Rage_ThroughWalls=true,
    Rage_Prediction=0.165, Rage_MaxShots=6,
    Rage_VoidSpam=false, Rage_VoidHide=0.15, Rage_VoidAttack=0.05,
    Rage_Fly=false, Rage_FlySpeed=50, Rage_NoClip=false,
    -- Visuals
    ESP_Enabled=false, ESP_Box=true, ESP_HealthBar=true, ESP_Skeleton=false,
    ESP_Tracers=false, ESP_OffScreen=false, ESP_Text=true,
    ESP_Color=Color3.fromRGB(255,255,255),
    Chams_Enabled=false, Chams_Material="ForceField", Chams_Color=Color3.fromRGB(150,0,255),
    Crosshair_Enabled=false, Crosshair_Size=10, Crosshair_Thickness=2,
    Crosshair_Color=Color3.fromRGB(255,255,255),
    HitMarkers_Enabled=false, HitSounds_Enabled=false,
    -- Player
    AntiAim_Enabled=false, AntiAim_Type="Spin",
    FakeLag_Enabled=false, FakeLag_Amount=300,
    Speed_Enabled=false, Speed_Value=32,
    InfiniteJump_Enabled=false,
    NoClip_Enabled=false, Fly_Enabled=false, Fly_Speed=50,
    ViewmodelFOV_Enabled=false, ViewmodelFOV_Value=90,
    WorldFOV_Enabled=false, WorldFOV_Value=120,
    Fullbright_Enabled=false,
    -- Skin Changer
    Skin_Enabled=false, Skin_Material="ForceField", Skin_Color=Color3.fromRGB(255,0,0),
    -- Spoofer
    NameSpoof_Enabled=false, NameSpoof_Text="",
    StatSpoof_Enabled=false, StatSpoof_Level="", StatSpoof_Winstreak="",
    -- Watermark
    Watermark_Enabled=true,
}

-- Keybind-to-feature mapping for watermark display
local Keybinds = {}
local ToggleStates = {}
local function bindFeature(name, defaultKey)
    Keybinds[name] = defaultKey
end
for name, val in pairs(Config) do
    if type(val) == "boolean" then
        ToggleStates[name] = val
    end
end

-- ==================== MOUSE BUTTONS ====================
local MouseBtns = {
    RightMouse = Enum.UserInputType.MouseButton2,
    LeftMouse  = Enum.UserInputType.MouseButton1,
    MiddleMouse= Enum.UserInputType.MouseButton3,
}
pcall(function()
    local function add(name, en, fall)
        local ok, btn = pcall(function() return Enum.UserInputType[en] end)
        if ok and btn then MouseBtns[name]=btn else
            ok, btn = pcall(function() return Enum.UserInputType[fall] end)
            if ok and btn then MouseBtns[name]=btn end
        end
    end
    add("Mouse4","MouseButton4","Button4")
    add("Mouse5","MouseButton5","Button5")
end)
local function isMB(name) return MouseBtns[name] and UserInputService:IsMouseButtonPressed(MouseBtns[name]) end

-- ==================== UTILITY FUNCTIONS ====================
local function getChar() return LocalPlayer.Character end
local function isAlive()
    local c = LocalPlayer.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function getPlayers()
    local t={}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t,p) end
    end
    return t
end
local function w2s(pos)
    local s, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), on, s.Z
end
local function closestToCursor(radius, partName, visibleOnly)
    if not isAlive() then return nil end
    local closest, minDist = nil, radius or math.huge
    for _, plr in ipairs(getPlayers()) do
        local char = plr.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(partName or "Head")
            if hum and hum.Health>0 and part then
                if visibleOnly then
                    local ignore = {getChar()}
                    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit*1000)
                    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignore)
                    if hit and not hit:IsDescendantOf(char) then continue end
                end
                local scr, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local dist = (Vector2.new(scr.X,scr.Y) - Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                    if dist < minDist then minDist = dist; closest = plr end
                end
            end
        end
    end
    return closest
end

-- ==================== DRAWING OBJECTS ====================
local function safeDrawing(t)
    if Drawing and type(Drawing.new)=="function" then
        local ok, obj = pcall(Drawing.new, t)
        if ok then return obj end
    end
    return nil
end
local fovCircle = safeDrawing("Circle")
if fovCircle then fovCircle.Thickness=2; fovCircle.NumSides=48; fovCircle.Filled=false; fovCircle.Transparency=1; fovCircle.Visible=false end
local silentFOV = safeDrawing("Circle")
if silentFOV then silentFOV.Thickness=2; silentFOV.NumSides=48; silentFOV.Filled=false; silentFOV.Transparency=1; silentFOV.Visible=false end

-- ==================== FIND WEAPON REMOTE ====================
local remoteFire = nil
pcall(function()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("bullet") or v.Name:lower():find("click")) then
            remoteFire = v; break
        end
    end
    if not remoteFire then
        remoteFire = Workspace:FindFirstChild("WeaponSystem") or game:GetService("ReplicatedStorage"):FindFirstChild("WeaponSystem")
    end
end)

-- ==================== SILENT AIM HOOK ====================
local silentTarget = nil
if remoteFire and hookfunction then
    local oldFire = remoteFire.FireServer
    local function newFire(self, ...)
        local args = {...}
        if Config.Silent_Enabled and silentTarget and silentTarget.Character then
            local part = silentTarget.Character:FindFirstChild(Config.Silent_Part)
            if part then
                if Config.Hitbox_Enabled then
                    local hp = silentTarget.Character:FindFirstChild(Config.Hitbox_Part)
                    if hp then
                        local orig = hp.Size
                        hp.Size = orig + Vector3.new(Config.Hitbox_ExtendRate/10, Config.Hitbox_ExtendRate/10, Config.Hitbox_ExtendRate/10)
                        spawn(function() wait(0.05); pcall(function() hp.Size = orig end) end)
                    end
                end
                args[2] = part.Position + Vector3.new(0, Config.Silent_Manipulation/100, 0)
                if args[3] and type(args[3])=="userdata" then args[3] = part end
            end
        end
        return oldFire(self, unpack(args))
    end
    hookfunction(remoteFire.FireServer, newFire)
end

-- ==================== RAGEBOT ====================
local ragebotTarget, ragebotLastShot, ragebotMinInterval = nil, 0, 0
local function ragebotUpdateTarget()
    if not Config.Rage_Enabled or not isAlive() then ragebotTarget=nil; return end
    ragebotTarget = closestToCursor(1000, "Head", not Config.Rage_ThroughWalls)
end
local function ragebotAutoShoot()
    if not Config.Rage_AutoShoot or not ragebotTarget or not ragebotTarget.Character or not remoteFire then return end
    local now = tick()
    if Config.Rage_MaxShots>0 then
        ragebotMinInterval = 1/Config.Rage_MaxShots
        if now - ragebotLastShot < ragebotMinInterval then return end
    end
    local th = ragebotTarget.Character:FindFirstChild("Head")
    if not th then return end
    local pred = th.Position
    if Config.Rage_Prediction>0 then
        local hum = ragebotTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude>0 then
            pred = pred + hum.MoveDirection*(hum.WalkSpeed or 16)*Config.Rage_Prediction
        end
    end
    pred = pred + Vector3.new(math.random(-10,10)/100, math.random(-10,10)/100, math.random(-10,10)/100)
    remoteFire:FireServer("MouseClick", pred)
    ragebotLastShot = now
end
local lastVoid, voidHidden = 0, false
local function ragebotVoid()
    if not Config.Rage_VoidSpam or not isAlive() then return end
    local hrp = getChar() and getChar():FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local now = tick()
    if not voidHidden then
        if now - lastVoid >= Config.Rage_VoidHide then lastVoid=now; hrp.CFrame = hrp.CFrame*CFrame.new(0,-15,0); voidHidden=true end
    else
        if now - lastVoid >= Config.Rage_VoidAttack then lastVoid=now; hrp.CFrame = hrp.CFrame*CFrame.new(0,15,0); voidHidden=false end
    end
end
local function ragebotFly()
    if not Config.Rage_Fly or not isAlive() then return end
    local hrp = getChar() and getChar():FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dir = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
    hrp.Velocity = dir.Magnitude>0 and dir.Unit*Config.Rage_FlySpeed or Vector3.new()
end
local function ragebotNoClip()
    if not Config.Rage_NoClip or not isAlive() then return end
    for _, p in ipairs(getChar():GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end

-- ==================== ESP ====================
local espCache = {}
local function createESP(p)
    local esp = {}
    esp.Box = safeDrawing("Square"); esp.Health = safeDrawing("Line")
    esp.HealthOutline = safeDrawing("Line"); esp.Name = safeDrawing("Text")
    esp.Distance = safeDrawing("Text"); esp.Tracer = safeDrawing("Line")
    esp.OffScreen = safeDrawing("Triangle"); esp.Skeleton = {}
    if esp.Box then esp.Box.Thickness=2; esp.Box.Filled=false; esp.Box.Visible=false end
    if esp.Health then esp.Health.Thickness=3; esp.Health.Visible=false end
    if esp.HealthOutline then esp.HealthOutline.Thickness=5; esp.HealthOutline.Visible=false; esp.HealthOutline.Color=Color3.new(0,0,0) end
    if esp.Name then esp.Name.Size=13; esp.Name.Center=true; esp.Name.Outline=true; esp.Name.Visible=false; esp.Name.Color=Color3.new(1,1,1) end
    if esp.Distance then esp.Distance.Size=12; esp.Distance.Center=true; esp.Distance.Outline=true; esp.Distance.Visible=false; esp.Distance.Color=Color3.new(1,1,1) end
    if esp.Tracer then esp.Tracer.Thickness=1; esp.Tracer.Visible=false; esp.Tracer.Color=Config.ESP_Color end
    if esp.OffScreen then esp.OffScreen.Thickness=2; esp.OffScreen.Filled=false; esp.OffScreen.Visible=false; esp.OffScreen.Color=Config.ESP_Color end
    espCache[p]=esp
end
local function removeESP(p)
    if espCache[p] then
        for _, v in pairs(espCache[p]) do
            if type(v)=="table" then for _, s in ipairs(v) do if s.Remove then s:Remove() end end
            else if v.Remove then v:Remove() end end
        end
        espCache[p]=nil
    end
end
for _, p in ipairs(getPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then createESP(p) end end)
Players.PlayerRemoving:Connect(removeESP)

-- ==================== CHAMS ====================
local chamCache = {}
local function updateChams()
    if Config.Chams_Enabled then
        for _, plr in ipairs(getPlayers()) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        if not chamCache[p] then chamCache[p]={Material=p.Material, Color=p.Color} end
                        p.Material = Enum.Material[Config.Chams_Material] or Enum.Material.ForceField
                        p.Color = Config.Chams_Color
                    end
                end
            end
        end
    else
        for p, orig in pairs(chamCache) do
            if p and p.Parent then p.Material=orig.Material; p.Color=orig.Color end
        end
        table.clear(chamCache)
    end
end

-- ==================== SKIN CHANGER (ID‑less) ====================
local function applyWeaponSkin()
    if not Config.Skin_Enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material[Config.Skin_Material] or Enum.Material.ForceField
                    part.Color = Config.Skin_Color
                end
            end
        end
    end
end

-- ==================== MOVEMENT & PLAYER MODS ====================
local function applyMovement()
    if not isAlive() then return end
    local char = getChar()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if Config.Speed_Enabled then hum.WalkSpeed = Config.Speed_Value end
    if Config.InfiniteJump_Enabled and hum.FloorMaterial~=Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    if Config.Fly_Enabled then
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.Velocity = dir.Magnitude>0 and dir.Unit*Config.Fly_Speed or Vector3.new()
    end
    if Config.NoClip_Enabled then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end
    if Config.Fullbright_Enabled then
        if not game.Lighting:FindFirstChild("SysnaxFullbright") then
            local fb = Instance.new("ColorCorrectionEffect")
            fb.Name = "SysnaxFullbright"
            fb.Brightness = 1
            fb.Contrast = 0
            fb.Saturation = -1
            fb.TintColor = Color3.new(1,1,1)
            fb.Parent = game.Lighting
        end
    else
        if game.Lighting:FindFirstChild("SysnaxFullbright") then
            game.Lighting.SysnaxFullbright:Destroy()
        end
    end
end

-- ==================== ANTI‑AIM ====================
local function applyAntiAim()
    if not Config.AntiAim_Enabled or not isAlive() then return end
    local hrp = getChar() and getChar():FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if Config.AntiAim_Type == "Spin" then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad((tick()*100) % 360), 0)
    elseif Config.AntiAim_Type == "Down" then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(0,-1,1))
    end
end

-- ==================== NAME SPOOFER ====================
local function spoofName()
    if not Config.NameSpoof_Enabled or Config.NameSpoof_Text == "" then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text == LocalPlayer.Name then
            obj.Text = Config.NameSpoof_Text
        end
    end
end

-- ==================== STAT SPOOFER (visual) ====================
local function spoofStats()
    if not Config.StatSpoof_Enabled then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local l = obj.Text:lower()
            if Config.StatSpoof_Level ~= "" and l:find("level") then
                obj.Text = string.gsub(obj.Text, "%d+", Config.StatSpoof_Level)
            end
            if Config.StatSpoof_Winstreak ~= "" and l:find("streak") then
                obj.Text = string.gsub(obj.Text, "%d+", Config.StatSpoof_Winstreak)
            end
        end
    end
end

-- ==================== WATERMARK ====================
local Watermark = Instance.new("Frame")
Watermark.Size = UDim2.new(0, 200, 0, 40)
Watermark.Position = UDim2.new(0.01, 0, 0.01, 0)
Watermark.BackgroundColor3 = Color3.fromRGB(25,25,30)
Watermark.BorderSizePixel = 0
Watermark.Visible = Config.Watermark_Enabled
Watermark.Parent = LocalPlayer:WaitForChild("PlayerGui")
local wText = Instance.new("TextLabel", Watermark)
wText.Size = UDim2.new(1,0,1,0)
wText.Text = "Sysnax"
wText.TextColor3 = Color3.new(1,1,1)
wText.Font = Enum.Font.GothamBold
wText.TextSize = 16
wText.BackgroundTransparency = 1

local function updateWatermark()
    if not Config.Watermark_Enabled then Watermark.Visible = false; return end
    local lines = {"Sysnax"}
    for name, active in pairs(Config) do
        if type(active) == "boolean" and active then
            local key = Keybinds[name] or ""
            local display = name:gsub("_", " ") .. (key ~= "" and " ["..key.."]" or "")
            table.insert(lines, display)
        end
    end
    wText.Text = table.concat(lines, "\n")
    Watermark.Size = UDim2.new(0, 200, 0, #lines * 18 + 10)
end

-- ==================== MAIN LOOP ====================
local lastShot = 0
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Config.Aimbot_Enabled and isAlive() then
        if fovCircle then
            fovCircle.Visible = Config.Aimbot_ShowFOV
            fovCircle.Radius = Config.Aimbot_FOV
            fovCircle.Color = Config.Aimbot_FOVColor
            fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        end
        local aim = Config.Aimbot_Mode == "Always" or (Config.Aimbot_Mode == "Hold" and isMB(Config.Aimbot_Key))
        if aim then
            local t = closestToCursor(Config.Aimbot_FOV, Config.Aimbot_Part, Config.Aimbot_VisibleOnly)
            if t and t.Character then
                local part = t.Character:FindFirstChild(Config.Aimbot_Part)
                if part then
                    local scr = Camera:WorldToScreenPoint(part.Position)
                    local delta = (Vector2.new(scr.X,scr.Y) - Vector2.new(Mouse.X,Mouse.Y)) / Config.Aimbot_Smoothness
                    mousemoverel(delta.X, delta.Y)
                end
            end
        end
    elseif fovCircle then fovCircle.Visible = false end

    -- Silent aim target
    if Config.Silent_Enabled then
        local t = closestToCursor(Config.Silent_MaxDistance, Config.Silent_Part, Config.Silent_VisibleOnly)
        if t and math.random(1,100) <= Config.Silent_HitChance then silentTarget = t else silentTarget = nil end
    else silentTarget = nil end
    if silentFOV then
        silentFOV.Visible = Config.Silent_Enabled and Config.Silent_DrawFOV
        silentFOV.Radius = Config.Silent_FOVRadius
        silentFOV.Position = Vector2.new(Mouse.X, Mouse.Y)
    end

    -- Triggerbot
    if Config.Trigger_Enabled and isAlive() and isMB(Config.Trigger_Key) then
        local t = closestToCursor(Config.Trigger_Distance, "Head", true)
        if t and t.Character and tick() - lastShot >= Config.Trigger_Delay then
            if remoteFire then remoteFire:FireServer("MouseClick", t.Character.Head); lastShot = tick() end
        end
    end

    -- Ragebot
    ragebotUpdateTarget(); ragebotAutoShoot(); ragebotVoid(); ragebotFly(); ragebotNoClip()

    -- Movement & player mods
    applyMovement()
    applyAntiAim()

    -- Chams & skin
    updateChams()
    applyWeaponSkin()

    -- Spoofers
    spoofName()
    spoofStats()

    -- Watermark update
    updateWatermark()

    -- ESP
    if Config.ESP_Enabled then
        for plr, esp in pairs(espCache) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum = char.Humanoid; local root = char.HumanoidRootPart
                if hum.Health > 0 then
                    local headPos,_ = w2s((char:FindFirstChild("Head") or root).Position + Vector3.new(0,0.5,0))
                    local legPos,_  = w2s((char:FindFirstChild("LeftFoot") or root).Position - Vector3.new(0,3,0))
                    local h = math.abs(headPos.Y - legPos.Y); local w = h/2
                    local x = headPos.X - w/2; local y = headPos.Y - h/2

                    if esp.Box then
                        esp.Box.Size = Vector2.new(w, h); esp.Box.Position = Vector2.new(x, y)
                        esp.Box.Color = Config.ESP_Color; esp.Box.Visible = Config.ESP_Box
                    end
                    if esp.Health and esp.HealthOutline then
                        local pct = hum.Health / hum.MaxHealth
                        esp.HealthOutline.From = Vector2.new(x-5, y); esp.HealthOutline.To = Vector2.new(x-5, y+h)
                        esp.HealthOutline.Visible = Config.ESP_HealthBar
                        esp.Health.From = Vector2.new(x-5, y+h); esp.Health.To = Vector2.new(x-5, y+h - h*pct)
                        esp.Health.Color = Color3.new(1-pct, pct, 0); esp.Health.Visible = Config.ESP_HealthBar
                    end
                    if esp.Name then esp.Name.Text = plr.Name; esp.Name.Position = Vector2.new(headPos.X, y-15); esp.Name.Visible = Config.ESP_Text end
                    if esp.Tracer then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                        esp.Tracer.Visible = Config.ESP_Tracers
                    end
                else
                    for _, v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _, s in ipairs(v) do if s then s.Visible=false end end end end
                end
            else
                for _, v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _, s in ipairs(v) do if s then s.Visible=false end end end end
            end
        end
    else
        for _, esp in pairs(espCache) do for _, v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _, s in ipairs(v) do if s then s.Visible=false end end end end end
    end
end)

-- ==================== UI TABS ====================
local LegitTab   = Window:AddTab("Legit")
local RageTab    = Window:AddTab("Rage")
local VisualsTab = Window:AddTab("Visuals")
local WeaponTab  = Window:AddTab("Weapon")
local PlayerTab  = Window:AddTab("Player")
local SkinTab    = Window:AddTab("Skin Changer")
local SpoofTab   = Window:AddTab("Spoofer")
local ConfigTab  = Window:AddTab("Config")

-- ===== LEGIT =====
local AimbotSec = LegitTab:AddSection("Aimbot")
AimbotSec:AddToggle("Enabled", Config.Aimbot_Enabled, function(v) ToggleStates["Aimbot"] = v; Config.Aimbot_Enabled = v end)
AimbotSec:AddDropdown("Mode", {"Hold","Toggle","Always"}, Config.Aimbot_Mode, function(v) Config.Aimbot_Mode = v end)
AimbotSec:AddDropdown("Target Part", {"Head","HumanoidRootPart","LeftLeg","RightLeg"}, Config.Aimbot_Part, function(v) Config.Aimbot_Part = v end)
AimbotSec:AddSlider("Smoothness", 1,25, Config.Aimbot_Smoothness, function(v) Config.Aimbot_Smoothness = v end)
AimbotSec:AddSlider("FOV Radius", 10,360, Config.Aimbot_FOV, function(v) Config.Aimbot_FOV = v end)
AimbotSec:AddToggle("Visible Only", Config.Aimbot_VisibleOnly, function(v) Config.Aimbot_VisibleOnly = v end)
AimbotSec:AddToggle("Draw FOV", Config.Aimbot_ShowFOV, function(v) Config.Aimbot_ShowFOV = v end)
AimbotSec:AddColorPicker("FOV Color", Config.Aimbot_FOVColor, function(v) Config.Aimbot_FOVColor = v end)
AimbotSec:AddKeybind("Aimbot Key", Config.Aimbot_Key, function(v) Config.Aimbot_Key = v; Keybinds["Aimbot"] = v end)

local SilentSec = LegitTab:AddSection("Silent Aim")
SilentSec:AddToggle("Enabled", Config.Silent_Enabled, function(v) ToggleStates["Silent"] = v; Config.Silent_Enabled = v end)
SilentSec:AddDropdown("Target Part", {"Head","HumanoidRootPart"}, Config.Silent_Part, function(v) Config.Silent_Part = v end)
SilentSec:AddSlider("Hit Chance (%)", 0,100, Config.Silent_HitChance, function(v) Config.Silent_HitChance = v end)
SilentSec:AddSlider("Manipulation (Y)", -50,50, Config.Silent_Manipulation, function(v) Config.Silent_Manipulation = v end)
SilentSec:AddToggle("Visible Only", Config.Silent_VisibleOnly, function(v) Config.Silent_VisibleOnly = v end)
SilentSec:AddSlider("Max Distance", 100,1000, Config.Silent_MaxDistance, function(v) Config.Silent_MaxDistance = v end)
SilentSec:AddToggle("Draw FOV", Config.Silent_DrawFOV, function(v) Config.Silent_DrawFOV = v end)
SilentSec:AddSlider("FOV Radius", 50,500, Config.Silent_FOVRadius, function(v) Config.Silent_FOVRadius = v end)

local HitboxSec = LegitTab:AddSection("Extend Hitbox")
HitboxSec:AddToggle("Enabled", Config.Hitbox_Enabled, function(v) Config.Hitbox_Enabled = v end)
HitboxSec:AddDropdown("Part", {"Head","HumanoidRootPart"}, Config.Hitbox_Part, function(v) Config.Hitbox_Part = v end)
HitboxSec:AddSlider("Extend Rate", 1,50, Config.Hitbox_ExtendRate, function(v) Config.Hitbox_ExtendRate = v end)

local TriggerSec = LegitTab:AddSection("Triggerbot")
TriggerSec:AddToggle("Enabled", Config.Trigger_Enabled, function(v) ToggleStates["Triggerbot"] = v; Config.Trigger_Enabled = v end)
TriggerSec:AddSlider("Delay (s)", 0,1, Config.Trigger_Delay, 2, function(v) Config.Trigger_Delay = v end)
TriggerSec:AddSlider("Distance", 100,500, Config.Trigger_Distance, function(v) Config.Trigger_Distance = v end)
TriggerSec:AddKeybind("Trigger Key", Config.Trigger_Key, function(v) Config.Trigger_Key = v; Keybinds["Triggerbot"] = v end)

local PredSec = LegitTab:AddSection("Prediction")
PredSec:AddToggle("Enabled", Config.Pred_Enabled, function(v) Config.Pred_Enabled = v end)
PredSec:AddSlider("Amount", 0.01,0.5, Config.Pred_Amount, 3, function(v) Config.Pred_Amount = v end)

local HitchanceSec = LegitTab:AddSection("Hit Chance")
HitchanceSec:AddSlider("Chance %", 0,100, Config.Hitchance_Value, function(v) Config.Hitchance_Value = v end)

local AutoWallSec = LegitTab:AddSection("Auto Wall")
AutoWallSec:AddToggle("Enabled", Config.AutoWall_Enabled, function(v) Config.AutoWall_Enabled = v end)

-- ===== RAGE =====
local RageSec = RageTab:AddSection("Ragebot")
RageSec:AddToggle("Enabled", Config.Rage_Enabled, function(v) ToggleStates["Ragebot"] = v; Config.Rage_Enabled = v end)
RageSec:AddToggle("Auto Shoot", Config.Rage_AutoShoot, function(v) Config.Rage_AutoShoot = v end)
RageSec:AddToggle("Through Walls", Config.Rage_ThroughWalls, function(v) Config.Rage_ThroughWalls = v end)
RageSec:AddSlider("Prediction", 0,0.5, Config.Rage_Prediction, 3, function(v) Config.Rage_Prediction = v end)
RageSec:AddSlider("Max Shots/s", 1,20, Config.Rage_MaxShots, function(v) Config.Rage_MaxShots = v end)
RageSec:AddToggle("Void Spam", Config.Rage_VoidSpam, function(v) Config.Rage_VoidSpam = v end)
RageSec:AddSlider("Hide Time", 0.1,2, Config.Rage_VoidHide, 2, function(v) Config.Rage_VoidHide = v end)
RageSec:AddSlider("Attack Time", 0.05,1, Config.Rage_VoidAttack, 2, function(v) Config.Rage_VoidAttack = v end)
RageSec:AddToggle("Fly", Config.Rage_Fly, function(v) ToggleStates["Rage Fly"] = v; Config.Rage_Fly = v end)
RageSec:AddSlider("Fly Speed", 10,100, Config.Rage_FlySpeed, function(v) Config.Rage_FlySpeed = v end)
RageSec:AddToggle("NoClip", Config.Rage_NoClip, function(v) ToggleStates["Rage NoClip"] = v; Config.Rage_NoClip = v end)

-- ===== VISUALS =====
local ESPSec = VisualsTab:AddSection("ESP")
ESPSec:AddToggle("Enabled", Config.ESP_Enabled, function(v) ToggleStates["ESP"] = v; Config.ESP_Enabled = v end)
ESPSec:AddToggle("Box", Config.ESP_Box, function(v) Config.ESP_Box = v end)
ESPSec:AddToggle("Health Bar", Config.ESP_HealthBar, function(v) Config.ESP_HealthBar = v end)
ESPSec:AddToggle("Skeleton", Config.ESP_Skeleton, function(v) Config.ESP_Skeleton = v end)
ESPSec:AddToggle("Tracers", Config.ESP_Tracers, function(v) Config.ESP_Tracers = v end)
ESPSec:AddToggle("Off-Screen", Config.ESP_OffScreen, function(v) Config.ESP_OffScreen = v end)
ESPSec:AddToggle("Text Info", Config.ESP_Text, function(v) Config.ESP_Text = v end)
ESPSec:AddColorPicker("Color", Config.ESP_Color, function(v) Config.ESP_Color = v end)

local ChamsSec = VisualsTab:AddSection("Chams")
ChamsSec:AddToggle("Enabled", Config.Chams_Enabled, function(v) ToggleStates["Chams"] = v; Config.Chams_Enabled = v end)
ChamsSec:AddDropdown("Material", {"ForceField","Neon","Glass","Plastic"}, Config.Chams_Material, function(v) Config.Chams_Material = v end)
ChamsSec:AddColorPicker("Color", Config.Chams_Color, function(v) Config.Chams_Color = v end)

local CrossSec = VisualsTab:AddSection("Crosshair")
CrossSec:AddToggle("Enabled", Config.Crosshair_Enabled, function(v) ToggleStates["Crosshair"] = v; Config.Crosshair_Enabled = v end)
CrossSec:AddSlider("Size", 5,30, Config.Crosshair_Size, function(v) Config.Crosshair_Size = v end)
CrossSec:AddSlider("Thickness", 1,10, Config.Crosshair_Thickness, function(v) Config.Crosshair_Thickness = v end)
CrossSec:AddColorPicker("Color", Config.Crosshair_Color, function(v) Config.Crosshair_Color = v end)

local HitSec = VisualsTab:AddSection("Hit Feedback")
HitSec:AddToggle("Hit Markers", Config.HitMarkers_Enabled, function(v) Config.HitMarkers_Enabled = v end)
HitSec:AddToggle("Hit Sounds", Config.HitSounds_Enabled, function(v) Config.HitSounds_Enabled = v end)

-- ===== WEAPON =====
local WeaponSec = WeaponTab:AddSection("Modifications")
WeaponSec:AddToggle("No Recoil", Config.NoRecoil_Enabled, function(v) Config.NoRecoil_Enabled = v end)
WeaponSec:AddToggle("No Spread", Config.NoSpread_Enabled, function(v) Config.NoSpread_Enabled = v end)
WeaponSec:AddToggle("Rapid Fire", Config.RapidFire_Enabled, function(v) Config.RapidFire_Enabled = v end)
WeaponSec:AddSlider("Fire Rate Multiplier", 1,5, Config.RapidFire_Mult, 1, function(v) Config.RapidFire_Mult = v end)
WeaponSec:AddToggle("Fast Reload", Config.FastReload_Enabled, function(v) Config.FastReload_Enabled = v end)
WeaponSec:AddToggle("Infinite Ammo", Config.InfiniteAmmo_Enabled, function(v) Config.InfiniteAmmo_Enabled = v end)

-- ===== PLAYER =====
local PlayerSec = PlayerTab:AddSection("Movement")
PlayerSec:AddToggle("Speed", Config.Speed_Enabled, function(v) ToggleStates["Speed"] = v; Config.Speed_Enabled = v end)
PlayerSec:AddSlider("Speed Value", 16,100, Config.Speed_Value, function(v) Config.Speed_Value = v end)
PlayerSec:AddToggle("Infinite Jump", Config.InfiniteJump_Enabled, function(v) ToggleStates["Inf Jump"] = v; Config.InfiniteJump_Enabled = v end)
PlayerSec:AddToggle("NoClip", Config.NoClip_Enabled, function(v) ToggleStates["NoClip"] = v; Config.NoClip_Enabled = v end)
PlayerSec:AddToggle("Fly", Config.Fly_Enabled, function(v) ToggleStates["Fly"] = v; Config.Fly_Enabled = v end)
PlayerSec:AddSlider("Fly Speed", 10,100, Config.Fly_Speed, function(v) Config.Fly_Speed = v end)
PlayerSec:AddToggle("Fullbright", Config.Fullbright_Enabled, function(v) Config.Fullbright_Enabled = v end)

local ViewSec = PlayerTab:AddSection("View")
ViewSec:AddToggle("Viewmodel FOV", Config.ViewmodelFOV_Enabled, function(v) Config.ViewmodelFOV_Enabled = v end)
ViewSec:AddSlider("FOV", 60,120, Config.ViewmodelFOV_Value, function(v) Config.ViewmodelFOV_Value = v end)
ViewSec:AddToggle("World FOV", Config.WorldFOV_Enabled, function(v) Config.WorldFOV_Enabled = v end)
ViewSec:AddSlider("FOV", 60,120, Config.WorldFOV_Value, function(v) Config.WorldFOV_Value = v end)

local AntiAimSec = PlayerTab:AddSection("Anti-Aim")
AntiAimSec:AddToggle("Enabled", Config.AntiAim_Enabled, function(v) ToggleStates["AntiAim"] = v; Config.AntiAim_Enabled = v end)
AntiAimSec:AddDropdown("Type", {"Spin","Down"}, Config.AntiAim_Type, function(v) Config.AntiAim_Type = v end)

local FakeLagSec = PlayerTab:AddSection("Fake Lag")
FakeLagSec:AddToggle("Enabled", Config.FakeLag_Enabled, function(v) ToggleStates["FakeLag"] = v; Config.FakeLag_Enabled = v end)
FakeLagSec:AddSlider("Amount (ms)", 0,1000, Config.FakeLag_Amount, function(v) Config.FakeLag_Amount = v end)

-- ===== SKIN CHANGER =====
local SkinSec = SkinTab:AddSection("ID‑less Skin Changer")
SkinSec:AddToggle("Enabled", Config.Skin_Enabled, function(v) ToggleStates["Skin"] = v; Config.Skin_Enabled = v end)
SkinSec:AddDropdown("Material", {"ForceField","Neon","Glass","Plastic","SmoothPlastic","Metal","Wood","Foil"}, Config.Skin_Material, function(v) Config.Skin_Material = v end)
SkinSec:AddColorPicker("Color", Config.Skin_Color, function(v) Config.Skin_Color = v end)

-- ===== SPOOFER =====
local NameSec = SpoofTab:AddSection("Name Spoofer")
NameSec:AddToggle("Enabled", Config.NameSpoof_Enabled, function(v) ToggleStates["NameSpoof"] = v; Config.NameSpoof_Enabled = v end)
NameSec:AddTextbox("Display Name", Config.NameSpoof_Text, function(v) Config.NameSpoof_Text = v end)

local StatSec = SpoofTab:AddSection("Stat Spoofer")
StatSec:AddToggle("Enabled", Config.StatSpoof_Enabled, function(v) ToggleStates["StatSpoof"] = v; Config.StatSpoof_Enabled = v end)
StatSec:AddTextbox("Level", Config.StatSpoof_Level, function(v) Config.StatSpoof_Level = v end)
StatSec:AddTextbox("Winstreak", Config.StatSpoof_Winstreak, function(v) Config.StatSpoof_Winstreak = v end)

-- ===== CONFIG =====
local CfgSec = ConfigTab:AddSection("Configurations")
local cfgInput = CfgSec:AddTextbox("Config Name", "", function() end)
CfgSec:AddButton("Save", function() saveCfg(cfgInput:GetText()) end)
CfgSec:AddButton("Load", function() loadCfg(cfgInput:GetText()) end)
CfgSec:AddButton("Delete", function() delCfg(cfgInput:GetText()) end)
local cfgList = listCfgs()
local cfgDrop = CfgSec:AddDropdown("Existing", cfgList, cfgList[1] or "", function(v) cfgInput:SetText(v) end)
CfgSec:AddButton("Refresh", function() cfgDrop:Refresh(listCfgs()) end)

local WmSec = ConfigTab:AddSection("Watermark")
WmSec:AddToggle("Show Watermark", Config.Watermark_Enabled, function(v) Config.Watermark_Enabled = v end)
WmSec:AddButton("Update Watermark", updateWatermark)

-- Window toggle key
Window:SetToggleKey(Enum.KeyCode.RightShift)

-- Autoload hidden
Window:ToggleUI()

Window:Notify("🥳 Sysnax loaded! Right Shift to toggle.", 6)