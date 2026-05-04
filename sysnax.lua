-- Sysnax – Official Release (Rivals / Arsenal / HyperShot)
-- Linoria UI · gray/black · Right Shift toggle · Autoload · All modules

-- Safe library loader
local Library = nil
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Linoria/main/Library.lua"))()
end)
if success and result then
    Library = result
else
    -- Fallback: try the raw GitHub mirror
    success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/UI-Libraries/master/scripts/uwuware-2.x.lua"))()
    end)
    if success and result then
        Library = result
    end
end

if not Library or not Library.CreateWindow then
    game.Players.LocalPlayer:Kick("Sysnax failed to load UI. Try another executor.")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Supported games (no kick on unknown, just notification)
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
    game.StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Unsupported game. Some features may not work.",Duration=5})
end

-- AC bypass (disable all anti‑cheat LocalScripts)
pcall(function()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            local name = obj.Name:lower()
            if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or obj.Name == "LocalScript" then
                obj.Disabled = true
            end
        end
    end
end)

-- Theme: gray / black (Linoria)
local Window = Library:CreateWindow({
    Title = "Sysnax",
    Center = true,
    AutoShow = false,
    Resizable = true,
    ShowCustomCursor = true,
    Theme = {
        Background = Color3.fromRGB(25,25,30),
        Tab = Color3.fromRGB(35,35,40),
        Element = Color3.fromRGB(45,45,50),
        Accent = Color3.fromRGB(160,160,160),
        Text = Color3.fromRGB(230,230,230),
        TitleBar = Color3.fromRGB(30,30,35),
        Footer = Color3.fromRGB(60,60,65),
        Danger = Color3.fromRGB(200,60,60),
    },
    ToggleKey = Enum.KeyCode.RightShift,
    Folder = "sysnax",
})

-- Config folder
if not isfolder("sysnax") then makefolder("sysnax") end
if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end

-- Settings table
local Config = {}
local function saveCfg(name)
    if name == "" then return end
    pcall(function() writefile("sysnax/configs/"..name..".json", HttpService:JSONEncode(Config)) Library:Notify(name.." saved.", 3) end)
end
local function loadCfg(name)
    if name == "" or not isfile("sysnax/configs/"..name..".json") then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile("sysnax/configs/"..name..".json"))
        for k,v in pairs(data) do Config[k]=v end
        Library:Notify(name.." loaded.", 3)
    end)
end
local function delCfg(name)
    if name == "" or not isfile("sysnax/configs/"..name..".json") then return end
    delfile("sysnax/configs/"..name..".json")
    Library:Notify(name.." deleted.", 3)
end
local function listCfgs()
    local t = {}
    pcall(function() for _,f in ipairs(listfiles("sysnax/configs")) do local n=f:match("([^/]+)%.json$") if n then table.insert(t,n) end end end)
    return t
end

-- Default config
Config = {
    Aimbot_Enabled=false, Aimbot_Mode="Hold", Aimbot_Part="Head", Aimbot_Smoothness=3, Aimbot_FOV=105,
    Aimbot_VisibleOnly=true, Aimbot_ShowFOV=true, Aimbot_FOVColor=Color3.fromRGB(255,255,255), Aimbot_Key="RightMouse",
    Silent_Enabled=false, Silent_Part="Head", Silent_HitChance=100, Silent_Manipulation=0,
    Silent_VisibleOnly=true, Silent_MaxDistance=500, Silent_FOV=105, Silent_DrawFOV=true,
    Hitbox_Enabled=false, Hitbox_Part="Head", Hitbox_ExtendRate=10,
    Trigger_Enabled=false, Trigger_Delay=0.1, Trigger_Distance=300, Trigger_Key="RightMouse",
    Recoil_Enabled=false, Recoil_Model=100, Recoil_Camera=100,
    Rage_Enabled=false, Rage_AutoShoot=true, Rage_ThroughWalls=true, Rage_Prediction=0.165, Rage_MaxShots=6,
    Rage_VoidSpam=false, Rage_VoidHide=0.15, Rage_VoidAttack=0.05, Rage_Fly=false, Rage_FlySpeed=50, Rage_NoClip=false,
    ESP_Enabled=false, ESP_Box=true, ESP_HealthBar=true, ESP_Skeleton=false, ESP_Color=Color3.fromRGB(255,255,255),
    Chams_Enabled=false, Chams_Material="ForceField", Chams_Color=Color3.fromRGB(150,0,255),
    Crosshair_Enabled=false, Crosshair_Size=10, Crosshair_Thickness=2, Crosshair_Color=Color3.fromRGB(255,255,255), Crosshair_DisableGame=false,
    ThirdPerson_Enabled=false, ThirdPerson_Distance=15, ThirdPerson_Key="V",
    Skin_Enabled=false, Global_SkinID="", Global_WrapID="", Global_FinisherID="", WeaponSkins={},
    Move_InfiniteJump=false, Move_Fly=false, Move_FlySpeed=50, Move_SlideBoost=false, Move_SlideBoostMult=1, Move_Velocity=false, Move_VelocitySpeed=16,
    NameSpoof_Enabled=false, NameSpoof_Text="",
    Spoof_Level="", Spoof_Rank="", Spoof_Winstreak="", Spoof_Winrate="", Spoof_RankedStreak="", Spoof_RankedWinrate="",
    LBS_Enabled=false, LBS_Wins="", LBS_Winstreak="", LBS_Level="", LBS_Rank="", LBS_KD="", LBS_ELO="",
}

-- Mouse buttons (safe)
local MouseBtns = {RightMouse=Enum.UserInputType.MouseButton2, LeftMouse=Enum.UserInputType.MouseButton1, MiddleMouse=Enum.UserInputType.MouseButton3}
pcall(function()
    local function add(name,en,fn)
        local ok,btn = pcall(function() return Enum.UserInputType[en] end)
        if ok and btn then MouseBtns[name]=btn else
            ok,btn = pcall(function() return Enum.UserInputType[fn] end)
            if ok and btn then MouseBtns[name]=btn end
        end
    end
    add("Mouse4","MouseButton4","Button4")
    add("Mouse5","MouseButton5","Button5")
end)
local function isMB(name) return MouseBtns[name] and UserInputService:IsMouseButtonPressed(MouseBtns[name]) end

-- Utility functions
local function getChar() return LocalPlayer.Character end
local function isAlive()
    local c = LocalPlayer.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function getPlayers()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(t,p) end end
    return t
end
local function w2s(pos)
    local s,on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X,s.Y), on, s.Z
end
local function closestToCursor(radius, partName, visibleOnly)
    if not isAlive() then return nil end
    local closest, minDist = nil, radius or math.huge
    for _,plr in ipairs(getPlayers()) do
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
                    if dist < minDist then minDist=dist; closest=plr end
                end
            end
        end
    end
    return closest
end

-- Drawing (safe)
local function safeDrw(t) if Drawing then local ok,o = pcall(Drawing.new,t) if ok then return o end end return nil end
local fovCircle = safeDrw("Circle") if fovCircle then fovCircle.Thickness=2 fovCircle.NumSides=48 fovCircle.Filled=false fovCircle.Transparency=1 fovCircle.Visible=false end
local silentFOV = safeDrw("Circle") if silentFOV then silentFOV.Thickness=2 silentFOV.NumSides=48 silentFOV.Filled=false silentFOV.Transparency=1 silentFOV.Visible=false end

-- Find weapon remote (safe)
local remoteFire = nil
pcall(function()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("bullet") or v.Name:lower():find("click")) then
            remoteFire = v; break
        end
    end
    if not remoteFire then remoteFire = Workspace:FindFirstChild("WeaponSystem") or game:GetService("ReplicatedStorage"):FindFirstChild("WeaponSystem") end
end)

-- Silent aim (hookfunction)
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
                        spawn(function() wait(0.05) pcall(function() hp.Size = orig end) end)
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

-- Ragebot
local ragebotTarget, ragebotLastShot, ragebotMinInterval = nil, 0, 0
local function ragebotUpdateTarget()
    if not Config.Rage_Enabled or not isAlive() then ragebotTarget=nil return end
    ragebotTarget = closestToCursor(1000, "Head", not Config.Rage_ThroughWalls)
end
local function ragebotAutoShoot()
    if not Config.Rage_AutoShoot or not ragebotTarget or not ragebotTarget.Character or not remoteFire then return end
    local now = tick()
    if Config.Rage_MaxShots>0 then
        ragebotMinInterval = 1/Config.Rage_MaxShots
        if now - ragebotLastShot < ragebotMinInterval then return end
    end
    local th = ragebotTarget.Character:FindFirstChild("Head") if not th then return end
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
    local hrp = getChar() and getChar():FindFirstChild("HumanoidRootPart") if not hrp then return end
    local now = tick()
    if not voidHidden then
        if now - lastVoid >= Config.Rage_VoidHide then lastVoid=now; hrp.CFrame=hrp.CFrame*CFrame.new(0,-15,0); voidHidden=true end
    else
        if now - lastVoid >= Config.Rage_VoidAttack then lastVoid=now; hrp.CFrame=hrp.CFrame*CFrame.new(0,15,0); voidHidden=false end
    end
end
local function ragebotFly()
    if not Config.Rage_Fly or not isAlive() then return end
    local hrp = getChar() and getChar():FindFirstChild("HumanoidRootPart") if not hrp then return end
    local dir = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
    hrp.Velocity = dir.Magnitude>0 and dir.Unit*Config.Rage_FlySpeed or Vector3.new()
end
local function ragebotNoClip()
    if not Config.Rage_NoClip or not isAlive() then return end
    for _,p in ipairs(getChar():GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end

-- ESP
local espCache = {}
local function createESP(p)
    local esp = {}
    esp.Box = safeDrw("Square"); esp.Health = safeDrw("Line"); esp.HealthOutline = safeDrw("Line")
    esp.Name = safeDrw("Text"); esp.Distance = safeDrw("Text"); esp.Skeleton = {}
    if esp.Box then esp.Box.Thickness=2 esp.Box.Filled=false esp.Box.Visible=false end
    if esp.Health then esp.Health.Thickness=3 esp.Health.Visible=false end
    if esp.HealthOutline then esp.HealthOutline.Thickness=5 esp.HealthOutline.Visible=false esp.HealthOutline.Color=Color3.new(0,0,0) end
    if esp.Name then esp.Name.Size=13 esp.Name.Center=true esp.Name.Outline=true esp.Name.Visible=false esp.Name.Color=Color3.new(1,1,1) end
    if esp.Distance then esp.Distance.Size=12 esp.Distance.Center=true esp.Distance.Outline=true esp.Distance.Visible=false esp.Distance.Color=Color3.new(1,1,1) end
    espCache[p]=esp
end
local function removeESP(p)
    if espCache[p] then
        for _,v in pairs(espCache[p]) do
            if type(v)=="table" then for _,s in ipairs(v) do if s.Remove then s:Remove() end end else if v.Remove then v:Remove() end end
        end
        espCache[p]=nil
    end
end
for _,p in ipairs(getPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then createESP(p) end end)
Players.PlayerRemoving:Connect(removeESP)

-- Chams
local chamCache = {}
local function updateChams()
    if Config.Chams_Enabled then
        for _,plr in ipairs(getPlayers()) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _,p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        if not chamCache[p] then chamCache[p]={Material=p.Material, Color=p.Color} end
                        p.Material = Enum.Material[Config.Chams_Material] or Enum.Material.ForceField
                        p.Color = Config.Chams_Color
                    end
                end
            end
        end
    else
        for p,orig in pairs(chamCache) do if p and p.Parent then p.Material=orig.Material p.Color=orig.Color end end
        table.clear(chamCache)
    end
end

-- Skin changer
local function getAllWeapons()
    local tools = {}
    local char = LocalPlayer.Character
    if char then for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(tools,v) end end end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then table.insert(tools,v) end end end
    return tools
end
local function categorizeWeaponName(name)
    name = name:lower()
    if name:find("melee") or name:find("knife") or name:find("sword") then return "Melee"
    elseif name:find("pistol") or name:find("handgun") or name:find("flare") then return "Secondary"
    elseif name:find("grenade") or name:find("utility") or name:find("med") then return "Utility"
    else return "Primary" end
end
local function applySkinToWeapon(weapon, skinID, wrapID)
    if not weapon then return end
    for _,part in ipairs(weapon:GetDescendants()) do
        if part:IsA("BasePart") then
            for _,c in ipairs(part:GetChildren()) do if c:IsA("Decal") or c:IsA("Texture") then c:Destroy() end end
            if skinID and skinID~="" then local d=Instance.new("Decal") d.Texture="rbxassetid://"..skinID d.Face=Enum.NormalId.Front d.Parent=part end
            if wrapID and wrapID~="" then local w=Instance.new("Decal") w.Texture="rbxassetid://"..wrapID w.Face=Enum.NormalId.Back w.Parent=part end
        end
    end
end
local function refreshAllSkins()
    if not Config.Skin_Enabled then return end
    local weapons = getAllWeapons()
    for _,w in ipairs(weapons) do
        local data = Config.WeaponSkins[w.Name]
        local skin = (data and data.SkinID and data.SkinID~="") and data.SkinID or Config.Global_SkinID or ""
        local wrap = (data and data.WrapID and data.WrapID~="") and data.WrapID or Config.Global_WrapID or ""
        applySkinToWeapon(w, skin, wrap)
    end
end

-- Third person
local tpActive, tpKey = false, Enum.KeyCode.V
local function setTP(active) tpActive=active; LocalPlayer.CameraMode = active and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end
UserInputService.InputBegan:Connect(function(input,proc) if not proc and input.KeyCode==tpKey then Config.ThirdPerson_Enabled = not Config.ThirdPerson_Enabled setTP(Config.ThirdPerson_Enabled) end end)

-- Spoofers
local function spoofStats()
    local gui = LocalPlayer:FindFirstChild("PlayerGui") if not gui then return end
    for _,obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local l = obj.Text:lower()
            if Config.Spoof_Level~="" and l:find("level") then obj.Text = string.gsub(obj.Text,"%d+",Config.Spoof_Level) end
            if Config.Spoof_Rank~="" and l:find("rank") then obj.Text = string.gsub(obj.Text,"%d+",Config.Spoof_Rank) end
            if Config.Spoof_Winstreak~="" and l:find("streak") then obj.Text = string.gsub(obj.Text,"%d+",Config.Spoof_Winstreak) end
            if Config.Spoof_Winrate~="" and l:find("winrate") then obj.Text = string.gsub(obj.Text,"%d+%.?%d*",Config.Spoof_Winrate) end
        end
    end
    if Config.NameSpoof_Enabled and Config.NameSpoof_Text~="" then
        for _,obj in ipairs(gui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text == LocalPlayer.Name then obj.Text = Config.NameSpoof_Text end
        end
    end
end
local function spoofLeaderboard()
    if not Config.LBS_Enabled then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui") if not gui then return end
    local board = nil
    for _,scr in ipairs(gui:GetChildren()) do if scr:IsA("ScreenGui") then for _,obj in ipairs(scr:GetDescendants()) do if obj:IsA("Frame") and obj.Name:lower():find("leader") then board=obj break end end end end
    if not board then return end
    for _,row in ipairs(board:GetChildren()) do
        if row:IsA("Frame") then
            local hasName = false
            for _,c in ipairs(row:GetDescendants()) do if (c:IsA("TextLabel") or c:IsA("TextButton")) and c.Text == LocalPlayer.Name then hasName=true break end end
            if hasName then
                for _,c in ipairs(row:GetDescendants()) do
                    if c:IsA("TextLabel") or c:IsA("TextButton") then
                        local txt = c.Text:lower()
                        if txt:find("win") and not txt:find("streak") and Config.LBS_Wins~="" then c.Text = Config.LBS_Wins
                        elseif txt:find("streak") and Config.LBS_Winstreak~="" then c.Text = Config.LBS_Winstreak
                        elseif txt:find("level") and Config.LBS_Level~="" then c.Text = Config.LBS_Level
                        elseif txt:find("rank") and Config.LBS_Rank~="" then c.Text = Config.LBS_Rank
                        elseif (txt:find("kills") or txt:find("k/d")) and Config.LBS_KD~="" then c.Text = Config.LBS_KD
                        elseif txt:find("elo") and Config.LBS_ELO~="" then c.Text = Config.LBS_ELO
                        end
                    end
                end
                return
            end
        end
    end
end

-- Main loop
local lastShot = 0
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Config.Aimbot_Enabled and isAlive() then
        if fovCircle then fovCircle.Visible=Config.Aimbot_ShowFOV fovCircle.Radius=Config.Aimbot_FOV fovCircle.Color=Config.Aimbot_FOVColor fovCircle.Position=Vector2.new(Mouse.X,Mouse.Y) end
        local aim = Config.Aimbot_Mode=="Always" or (Config.Aimbot_Mode=="Hold" and isMB(Config.Aimbot_Key))
        if aim then
            local t = closestToCursor(Config.Aimbot_FOV, Config.Aimbot_Part, Config.Aimbot_VisibleOnly)
            if t and t.Character then
                local part = t.Character:FindFirstChild(Config.Aimbot_Part)
                if part then
                    local scr = Camera:WorldToScreenPoint(part.Position)
                    local delta = (Vector2.new(scr.X,scr.Y)-Vector2.new(Mouse.X,Mouse.Y))/Config.Aimbot_Smoothness
                    mousemoverel(delta.X,delta.Y)
                end
            end
        end
    elseif fovCircle then fovCircle.Visible=false end

    -- Silent aim target
    if Config.Silent_Enabled then
        local t = closestToCursor(Config.Silent_MaxDistance, Config.Silent_Part, Config.Silent_VisibleOnly)
        if t and math.random(1,100)<=Config.Silent_HitChance then silentTarget=t else silentTarget=nil end
    else silentTarget=nil end
    if silentFOV then silentFOV.Visible=Config.Silent_Enabled and Config.Silent_DrawFOV silentFOV.Radius=Config.Silent_FOV silentFOV.Position=Vector2.new(Mouse.X,Mouse.Y) end

    -- Triggerbot
    if Config.Trigger_Enabled and isAlive() and isMB(Config.Trigger_Key) then
        local t = closestToCursor(Config.Trigger_Distance,"Head",true)
        if t and t.Character and tick()-lastShot>=Config.Trigger_Delay then
            if remoteFire then remoteFire:FireServer("MouseClick", t.Character.Head) lastShot=tick() end
        end
    end

    -- Ragebot
    ragebotUpdateTarget(); ragebotAutoShoot(); ragebotVoid(); ragebotFly(); ragebotNoClip()

    -- Movement
    if isAlive() then
        local char=getChar(); local hum=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if Config.Move_InfiniteJump and hum.FloorMaterial~=Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            if Config.Move_Fly then
                local dir=Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.new(0,1,0) end
                hrp.Velocity = dir.Magnitude>0 and dir.Unit*Config.Move_FlySpeed or Vector3.new()
            end
            if Config.Move_SlideBoost and hum.MoveDirection.Magnitude>0 and hum.FloorMaterial~=Enum.Material.Air then hrp.Velocity*=Config.Move_SlideBoostMult end
            if Config.Move_Velocity then hrp.Velocity=Vector3.new(Config.Move_VelocitySpeed,0,0) end
        end
    end

    -- Third person camera
    if tpActive then
        local char = getChar()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            Camera.CameraSubject = root
            Camera.CFrame = CFrame.new(root.Position - Camera.CFrame.LookVector*Config.ThirdPerson_Distance, root.Position)
        end
    end

    updateChams(); refreshAllSkins(); spoofStats(); spoofLeaderboard()

    -- ESP (simplified)
    if Config.ESP_Enabled then
        for plr,esp in pairs(espCache) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum=char.Humanoid; local root=char.HumanoidRootPart
                if hum.Health>0 then
                    local headPos,_ = w2s((char:FindFirstChild("Head") or root).Position+Vector3.new(0,0.5,0))
                    local legPos,_  = w2s((char:FindFirstChild("LeftFoot") or root).Position-Vector3.new(0,3,0))
                    local h = math.abs(headPos.Y-legPos.Y); local w = h/2
                    local x = headPos.X-w/2; local y = headPos.Y-h/2
                    if esp.Box then
                        esp.Box.Size=Vector2.new(w,h); esp.Box.Position=Vector2.new(x,y)
                        esp.Box.Color=Config.ESP_Color; esp.Box.Visible=Config.ESP_Box
                    end
                    if esp.Health and esp.HealthOutline then
                        local pct = hum.Health/hum.MaxHealth
                        esp.HealthOutline.From=Vector2.new(x-5,y); esp.HealthOutline.To=Vector2.new(x-5,y+h)
                        esp.HealthOutline.Visible = Config.ESP_HealthBar
                        esp.Health.From=Vector2.new(x-5,y+h); esp.Health.To=Vector2.new(x-5,y+h-h*pct)
                        esp.Health.Color = Color3.new(1-pct,pct,0); esp.Health.Visible = Config.ESP_HealthBar
                    end
                    if esp.Name then esp.Name.Text=plr.Name; esp.Name.Position=Vector2.new(headPos.X,y-15); esp.Name.Visible=true end
                end
            end
        end
    end
end)

-- UI Tabs
local Legit   = Window:AddTab("Legit")
local Rage    = Window:AddTab("Rage")
local Visuals = Window:AddTab("Visuals")
local SkinTab = Window:AddTab("Skin Changer")
local Spoofer = Window:AddTab("Spoofer")
local Settings= Window:AddTab("Settings")

-- Legit > Aim Assist
local AimGroup = Legit:AddLeftGroupbox("Aim Assist", "crosshair")
AimGroup:AddToggle({Text="Enabled", Default=Config.Aimbot_Enabled, Callback=function(v) Config.Aimbot_Enabled=v end})
AimGroup:AddSlider({Text="Aimbot FOV", Min=10, Max=360, Default=Config.Aimbot_FOV, Rounding=0, Callback=function(v) Config.Aimbot_FOV=v end})
AimGroup:AddSlider({Text="Smoothing Factor", Min=1, Max=25, Default=Config.Aimbot_Smoothness, Rounding=1, Callback=function(v) Config.Aimbot_Smoothness=v end})
AimGroup:AddDropdown({Text="Hit Box", Values={"Head","HumanoidRootPart","LeftLeg","RightLeg"}, Default=Config.Aimbot_Part, Callback=function(v) Config.Aimbot_Part=v end})
AimGroup:AddKeybind({Text="Aimbot Key", Default=Config.Aimbot_Key, Callback=function(v) Config.Aimbot_Key=v end})
AimGroup:AddToggle({Text="Draw Fov", Default=Config.Aimbot_ShowFOV, Callback=function(v) Config.Aimbot_ShowFOV=v end})
AimGroup:AddSlider({Text="Num Sides", Min=4, Max=64, Default=48, Rounding=0, Callback=function(v) if fovCircle then fovCircle.NumSides=v end end})

-- Bullet Redirection
local SilentGroup = Legit:AddRightGroupbox("Bullet Redirection", "eye")
SilentGroup:AddToggle({Text="Enabled", Default=Config.Silent_Enabled, Callback=function(v) Config.Silent_Enabled=v end})
SilentGroup:AddSlider({Text="Silent Aim FOV", Min=10, Max=360, Default=Config.Silent_FOV, Rounding=0, Callback=function(v) Config.Silent_FOV=v end})
SilentGroup:AddSlider({Text="Hit Chances", Min=0, Max=100, Default=Config.Silent_HitChance, Rounding=0, Callback=function(v) Config.Silent_HitChance=v end})
SilentGroup:AddDropdown({Text="Redirection Mode", Values={"P Mode"}, Default="P Mode", Callback=function() end})
SilentGroup:AddDropdown({Text="Hit Box", Values={"Head","HumanoidRootPart"}, Default=Config.Silent_Part, Callback=function(v) Config.Silent_Part=v end})
SilentGroup:AddToggle({Text="Draw Fov", Default=Config.Silent_DrawFOV, Callback=function(v) Config.Silent_DrawFOV=v end})
SilentGroup:AddSlider({Text="Num Sides", Min=4, Max=64, Default=48, Rounding=0, Callback=function(v) if silentFOV then silentFOV.NumSides=v end end})

-- Extend Hitbox
local HitboxGroup = Legit:AddLeftGroupbox("Extend Hitbox", "maximize")
HitboxGroup:AddToggle({Text="Enabled", Default=Config.Hitbox_Enabled, Callback=function(v) Config.Hitbox_Enabled=v end})
HitboxGroup:AddDropdown({Text="Hit Box", Values={"Head","HumanoidRootPart"}, Default=Config.Hitbox_Part, Callback=function(v) Config.Hitbox_Part=v end})
HitboxGroup:AddSlider({Text="Extend Rate", Min=1, Max=50, Default=Config.Hitbox_ExtendRate, Rounding=0, Callback=function(v) Config.Hitbox_ExtendRate=v end})

-- Trigger Bot
local TriggerGroup = Legit:AddRightGroupbox("Trigger Bot", "zap")
TriggerGroup:AddToggle({Text="Enabled", Default=Config.Trigger_Enabled, Callback=function(v) Config.Trigger_Enabled=v end})
TriggerGroup:AddSlider({Text="Delay (s)", Min=0, Max=1, Default=Config.Trigger_Delay, Rounding=2, Callback=function(v) Config.Trigger_Delay=v end})
TriggerGroup:AddSlider({Text="Max Distance", Min=100, Max=500, Default=Config.Trigger_Distance, Rounding=0, Callback=function(v) Config.Trigger_Distance=v end})
TriggerGroup:AddKeybind({Text="Trigger Key", Default=Config.Trigger_Key, Callback=function(v) Config.Trigger_Key=v end})

-- Recoil Control
local RecoilGroup = Legit:AddLeftGroupbox("Recoil Control", "minus")
RecoilGroup:AddToggle({Text="Enabled", Default=Config.Recoil_Enabled, Callback=function(v) Config.Recoil_Enabled=v end})
RecoilGroup:AddSlider({Text="Model Kick", Min=0, Max=100, Default=Config.Recoil_Model, Rounding=0, Callback=function(v) Config.Recoil_Model=v end})
RecoilGroup:AddSlider({Text="Camera Kick", Min=0, Max=100, Default=Config.Recoil_Camera, Rounding=0, Callback=function(v) Config.Recoil_Camera=v end})

-- Rage
local RageGroup = Rage:AddLeftGroupbox("Ragebot", "zap")
RageGroup:AddToggle({Text="Enable Ragebot", Default=Config.Rage_Enabled, Callback=function(v) Config.Rage_Enabled=v end})
RageGroup:AddToggle({Text="Auto Shoot", Default=Config.Rage_AutoShoot, Callback=function(v) Config.Rage_AutoShoot=v end})
RageGroup:AddToggle({Text="Through Walls", Default=Config.Rage_ThroughWalls, Callback=function(v) Config.Rage_ThroughWalls=v end})
RageGroup:AddSlider({Text="Prediction", Min=0, Max=0.5, Default=Config.Rage_Prediction, Rounding=3, Callback=function(v) Config.Rage_Prediction=v end})
RageGroup:AddSlider({Text="Max Shots/s", Min=1, Max=20, Default=Config.Rage_MaxShots, Rounding=0, Callback=function(v) Config.Rage_MaxShots=v end})
RageGroup:AddToggle({Text="Void Spam", Default=Config.Rage_VoidSpam, Callback=function(v) Config.Rage_VoidSpam=v end})
RageGroup:AddSlider({Text="Hide Time", Min=0.1, Max=2, Default=Config.Rage_VoidHide, Rounding=2, Callback=function(v) Config.Rage_VoidHide=v end})
RageGroup:AddSlider({Text="Attack Time", Min=0.05, Max=1, Default=Config.Rage_VoidAttack, Rounding=2, Callback=function(v) Config.Rage_VoidAttack=v end})
RageGroup:AddToggle({Text="Fly", Default=Config.Rage_Fly, Callback=function(v) Config.Rage_Fly=v end})
RageGroup:AddSlider({Text="Fly Speed", Min=10, Max=100, Default=Config.Rage_FlySpeed, Rounding=0, Callback=function(v) Config.Rage_FlySpeed=v end})
RageGroup:AddToggle({Text="NoClip", Default=Config.Rage_NoClip, Callback=function(v) Config.Rage_NoClip=v end})

-- Visuals / ESP
local ESPGroup = Visuals:AddLeftGroupbox("ESP", "camera")
ESPGroup:AddToggle({Text="Enable ESP", Default=Config.ESP_Enabled, Callback=function(v) Config.ESP_Enabled=v end})
ESPGroup:AddToggle({Text="Box", Default=Config.ESP_Box, Callback=function(v) Config.ESP_Box=v end})
ESPGroup:AddToggle({Text="Health Bar", Default=Config.ESP_HealthBar, Callback=function(v) Config.ESP_HealthBar=v end})
ESPGroup:AddToggle({Text="Skeleton", Default=Config.ESP_Skeleton, Callback=function(v) Config.ESP_Skeleton=v end})
ESPGroup:AddColorPicker({Text="ESP Color", Default=Config.ESP_Color, Callback=function(v) Config.ESP_Color=v end})

-- Chams
local ChamsGroup = Visuals:AddRightGroupbox("Chams", "eye")
ChamsGroup:AddToggle({Text="Enable Chams", Default=Config.Chams_Enabled, Callback=function(v) Config.Chams_Enabled=v end})
ChamsGroup:AddDropdown({Text="Material", Values={"ForceField","Neon","Glass","Plastic"}, Default=Config.Chams_Material, Callback=function(v) Config.Chams_Material=v end})
ChamsGroup:AddColorPicker({Text="Chams Color", Default=Config.Chams_Color, Callback=function(v) Config.Chams_Color=v end})

-- Crosshair
local CrossGroup = Visuals:AddLeftGroupbox("Crosshair", "plus")
CrossGroup:AddToggle({Text="Enable Crosshair", Default=Config.Crosshair_Enabled, Callback=function(v) Config.Crosshair_Enabled=v end})
CrossGroup:AddSlider({Text="Size", Min=5, Max=30, Default=Config.Crosshair_Size, Rounding=0, Callback=function(v) Config.Crosshair_Size=v end})
CrossGroup:AddSlider({Text="Thickness", Min=1, Max=10, Default=Config.Crosshair_Thickness, Rounding=0, Callback=function(v) Config.Crosshair_Thickness=v end})
CrossGroup:AddColorPicker({Text="Color", Default=Config.Crosshair_Color, Callback=function(v) Config.Crosshair_Color=v end})
CrossGroup:AddToggle({Text="Disable Game Crosshair", Default=Config.Crosshair_DisableGame, Callback=function(v) Config.Crosshair_DisableGame=v end})

-- Third Person
local TPGroup = Visuals:AddRightGroupbox("Third Person", "user")
TPGroup:AddKeybind({Text="Toggle Key", Default=Config.ThirdPerson_Key, Callback=function(v) Config.ThirdPerson_Key=v; tpKey=Enum.KeyCode[v] or Enum.KeyCode.V end})
TPGroup:AddSlider({Text="Distance", Min=5, Max=30, Default=Config.ThirdPerson_Distance, Rounding=0, Callback=function(v) Config.ThirdPerson_Distance=v end})

-- Movement
local MoveGroup = Visuals:AddLeftGroupbox("Movement", "footprints")
MoveGroup:AddToggle({Text="Infinite Jump", Default=Config.Move_InfiniteJump, Callback=function(v) Config.Move_InfiniteJump=v end})
MoveGroup:AddToggle({Text="Fly", Default=Config.Move_Fly, Callback=function(v) Config.Move_Fly=v end})
MoveGroup:AddSlider({Text="Fly Speed", Min=10, Max=100, Default=Config.Move_FlySpeed, Rounding=0, Callback=function(v) Config.Move_FlySpeed=v end})
MoveGroup:AddToggle({Text="Slide Boost", Default=Config.Move_SlideBoost, Callback=function(v) Config.Move_SlideBoost=v end})
MoveGroup:AddSlider({Text="Boost Multiplier", Min=1, Max=5, Default=Config.Move_SlideBoostMult, Rounding=1, Callback=function(v) Config.Move_SlideBoostMult=v end})
MoveGroup:AddToggle({Text="Velocity", Default=Config.Move_Velocity, Callback=function(v) Config.Move_Velocity=v end})
MoveGroup:AddSlider({Text="Velocity Speed", Min=1, Max=100, Default=Config.Move_VelocitySpeed, Rounding=0, Callback=function(v) Config.Move_VelocitySpeed=v end})

-- Skin Changer tab
local SkinEnable = SkinTab:AddLeftGroupbox("Enable", "shirt")
SkinEnable:AddToggle({Text="Enable Skin Changer", Default=Config.Skin_Enabled, Callback=function(v) Config.Skin_Enabled=v; refreshAllSkins() end})

local SkinGlobal = SkinTab:AddRightGroupbox("Global Settings", "globe")
SkinGlobal:AddInput({Text="Skin ID", Default=Config.Global_SkinID or "", Callback=function(v) Config.Global_SkinID=v end})
SkinGlobal:AddInput({Text="Wrap ID", Default=Config.Global_WrapID or "", Callback=function(v) Config.Global_WrapID=v end})
SkinGlobal:AddInput({Text="Finisher ID", Default=Config.Global_FinisherID or "", Callback=function(v) Config.Global_FinisherID=v end})
SkinGlobal:AddButton({Text="Apply to All Weapons", Callback=function() Config.WeaponSkins = {} refreshAllSkins() end})

local SkinWeapon = SkinTab:AddLeftGroupbox("Weapon Customization", "crosshair")
local weaponCatDD = SkinWeapon:AddDropdown({Text="Weapon Category", Values={"All","Melee","Primary","Secondary","Utility"}, Default="All", Callback=function() end})
local weaponListDD = SkinWeapon:AddDropdown({Text="Select Weapon", Values={}, Default="", Callback=function(v)
    local data = Config.WeaponSkins[v]
    if data then
        skinInput:SetValue(data.SkinID or "")
        wrapInput:SetValue(data.WrapID or "")
        finisherInput:SetValue(data.FinisherID or "")
    else
        skinInput:SetValue(""); wrapInput:SetValue(""); finisherInput:SetValue("")
    end
end})
local function updateWL()
    local all = getAllWeapons()
    local cat = weaponCatDD.Value or "All"
    local names = {}
    for _,tool in ipairs(all) do
        if cat == "All" or categorizeWeaponName(tool.Name) == cat then
            table.insert(names, tool.Name)  -- Actually insert the name
        end
    end
    weaponListDD:Refresh(names, #names>0 and names[1] or "")
end
SkinWeapon:AddButton({Text="Refresh Weapons", Callback=updateWL})
updateWL()

local skinInput = SkinWeapon:AddInput({Text="Skin ID", Default="", Callback=function(v) end})
local wrapInput = SkinWeapon:AddInput({Text="Wrap ID", Default="", Callback=function(v) end})
local finisherInput = SkinWeapon:AddInput({Text="Finisher ID", Default="", Callback=function(v) end})

SkinWeapon:AddButton({Text="Apply to Selected", Callback=function()
    local weaponName = weaponListDD.Value
    if not weaponName or weaponName == "" then return end
    if not Config.WeaponSkins[weaponName] then Config.WeaponSkins[weaponName] = {} end
    Config.WeaponSkins[weaponName].SkinID = skinInput.Value
    Config.WeaponSkins[weaponName].WrapID = wrapInput.Value
    Config.WeaponSkins[weaponName].FinisherID = finisherInput.Value
    refreshAllSkins()
end})
SkinWeapon:AddButton({Text="Reset Selected", Callback=function()
    local weaponName = weaponListDD.Value
    if weaponName and Config.WeaponSkins[weaponName] then
        Config.WeaponSkins[weaponName] = nil
        skinInput:SetValue(""); wrapInput:SetValue(""); finisherInput:SetValue("")
        refreshAllSkins()
    end
end})

-- Spoofer tab
local StatsSpoof = Spoofer:AddLeftGroupbox("Stats Spoofer", "shield")
StatsSpoof:AddInput({Text="Level", Default=Config.Spoof_Level, Callback=function(v) Config.Spoof_Level=v end})
StatsSpoof:AddInput({Text="Rank", Default=Config.Spoof_Rank, Callback=function(v) Config.Spoof_Rank=v end})
StatsSpoof:AddInput({Text="Winstreak", Default=Config.Spoof_Winstreak, Callback=function(v) Config.Spoof_Winstreak=v end})
StatsSpoof:AddInput({Text="Winrate", Default=Config.Spoof_Winrate, Callback=function(v) Config.Spoof_Winrate=v end})
StatsSpoof:AddInput({Text="Ranked Streak", Default=Config.Spoof_RankedStreak, Callback=function(v) Config.Spoof_RankedStreak=v end})
StatsSpoof:AddInput({Text="Ranked Winrate", Default=Config.Spoof_RankedWinrate, Callback=function(v) Config.Spoof_RankedWinrate=v end})

local NameSpoof = Spoofer:AddRightGroupbox("Name Spoof", "user")
NameSpoof:AddToggle({Text="Enable", Default=Config.NameSpoof_Enabled, Callback=function(v) Config.NameSpoof_Enabled=v end})
NameSpoof:AddInput({Text="Display Name", Default=Config.NameSpoof_Text, Callback=function(v) Config.NameSpoof_Text=v end})

local LBGroup = Spoofer:AddLeftGroupbox("Leaderboard Spoofer (client)", "trophy")
LBGroup:AddToggle({Text="Enable", Default=Config.LBS_Enabled, Callback=function(v) Config.LBS_Enabled=v end})
LBGroup:AddInput({Text="Wins", Default=Config.LBS_Wins, Callback=function(v) Config.LBS_Wins=v end})
LBGroup:AddInput({Text="Winstreak", Default=Config.LBS_Winstreak, Callback=function(v) Config.LBS_Winstreak=v end})
LBGroup:AddInput({Text="Level", Default=Config.LBS_Level, Callback=function(v) Config.LBS_Level=v end})
LBGroup:AddInput({Text="Rank", Default=Config.LBS_Rank, Callback=function(v) Config.LBS_Rank=v end})
LBGroup:AddInput({Text="K/D", Default=Config.LBS_KD, Callback=function(v) Config.LBS_KD=v end})
LBGroup:AddInput({Text="Elo", Default=Config.LBS_ELO, Callback=function(v) Config.LBS_ELO=v end})
LBGroup:AddButton({Text="Reset", Callback=function()
    Config.LBS_Enabled=false
    Config.LBS_Wins=""; Config.LBS_Winstreak=""; Config.LBS_Level=""; Config.LBS_Rank=""; Config.LBS_KD=""; Config.LBS_ELO=""
end})

-- Settings tab
local KeybindsGroup = Settings:AddLeftGroupbox("Keybinds", "settings")
KeybindsGroup:AddKeybind({Text="Toggle UI", Default="RightShift", Callback=function(v) Window:SetToggleKey(Enum.KeyCode[v]) end})

local ConfigGroup = Settings:AddRightGroupbox("Configurations", "folder")
local cfgInput = ConfigGroup:AddInput({Text="Config Name", Default=""})
ConfigGroup:AddButton({Text="Save", Callback=function() saveCfg(cfgInput.Value) end})
ConfigGroup:AddButton({Text="Load", Callback=function() loadCfg(cfgInput.Value) end})
ConfigGroup:AddButton({Text="Delete", Callback=function() delCfg(cfgInput.Value) end})
local cfgList = listCfgs()
local cfgDrop = ConfigGroup:AddDropdown({Text="Existing", Values=cfgList, Default=cfgList[1] or "", Callback=function(v) cfgInput:SetValue(v) end})
ConfigGroup:AddButton({Text="Refresh", Callback=function() cfgDrop:Refresh(listCfgs()) end})

local ThemeGroup = Settings:AddLeftGroupbox("Theme", "palette")
ThemeGroup:AddDropdown({Text="Theme", Values={"Sysnax","Dark","Light"}, Default="Sysnax", Callback=function(v)
    if v == "Sysnax" then
        Window:SetTheme({
            Background = Color3.fromRGB(25,25,30), Tab = Color3.fromRGB(35,35,40), Element = Color3.fromRGB(45,45,50),
            Accent = Color3.fromRGB(160,160,160), Text = Color3.fromRGB(230,230,230),
            TitleBar = Color3.fromRGB(30,30,35), Footer = Color3.fromRGB(60,60,65),
        })
    elseif v == "Dark" then Window:SetTheme("Dark")
    elseif v == "Light" then Window:SetTheme("Light")
    end
end})

-- Autoload hidden
Window:Toggle()
Library:Notify("🥳 Official Release  |  Stable on Synapse Z  |  All modules", 6)