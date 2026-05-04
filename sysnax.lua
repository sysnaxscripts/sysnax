-- Sysnax – Stable Release (Rivals / Arsenal / HyperShot)
-- UI: UwuWare 2.x (gray/black) • Right Shift toggle • Autoload

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/UI-Libraries/master/scripts/uwuware-2.x.lua"))()
if not Library then
    game.Players.LocalPlayer:Kick("Failed to load UI library")
    return
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

-- Supported games
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
    StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Unsupported game.",Duration=5})
    return
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

-- Theme: gray / black
local Window = Library:CreateWindow("Sysnax", Color3.fromRGB(30,30,35))
Window:SetIcon("rbxassetid://122198206955790")

-- Config folder
if not isfolder("sysnax") then makefolder("sysnax") end
if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end

-- Settings table
local Config = {
    -- Aim Assist
    Aimbot_Enabled = false, Aimbot_Mode = "Hold", Aimbot_Part = "Head", Aimbot_Smoothness = 3,
    Aimbot_FOV = 105, Aimbot_VisibleOnly = true, Aimbot_ShowFOV = true,
    Aimbot_FOVColor = Color3.fromRGB(255,255,255), Aimbot_Key = "RightMouse",
    -- Bullet Redirection (Silent Aim)
    Silent_Enabled = false, Silent_Part = "Head", Silent_HitChance = 100,
    Silent_Manipulation = 0, Silent_VisibleOnly = true, Silent_MaxDistance = 500,
    Silent_FOV = 105, Silent_DrawFOV = true,
    -- Extend Hitbox
    Hitbox_Enabled = false, Hitbox_Part = "Head", Hitbox_ExtendRate = 10,
    -- Trigger Bot
    Trigger_Enabled = false, Trigger_Delay = 0.1, Trigger_Distance = 300, Trigger_Key = "RightMouse",
    -- Recoil Control
    Recoil_Enabled = false, Recoil_Model = 100, Recoil_Camera = 100,
    -- Ragebot
    Rage_Enabled = false, Rage_AutoShoot = true, Rage_ThroughWalls = true,
    Rage_Prediction = 0.165, Rage_MaxShots = 6,
    Rage_VoidSpam = false, Rage_VoidHide = 0.15, Rage_VoidAttack = 0.05,
    Rage_Fly = false, Rage_FlySpeed = 50, Rage_NoClip = false,
    -- ESP
    ESP_Enabled = false, ESP_Box = true, ESP_HealthBar = true, ESP_Skeleton = false,
    ESP_Color = Color3.fromRGB(255,255,255),
    -- Chams
    Chams_Enabled = false, Chams_Material = "ForceField", Chams_Color = Color3.fromRGB(150,0,255),
    -- Crosshair
    Crosshair_Enabled = false, Crosshair_Size = 10, Crosshair_Thickness = 2,
    Crosshair_Color = Color3.fromRGB(255,255,255), Crosshair_DisableGame = false,
    -- Third Person
    ThirdPerson_Enabled = false, ThirdPerson_Distance = 15, ThirdPerson_Key = "V",
    -- Desync
    Desync_Enabled = false, Desync_Delay = 0.5, Desync_OffsetX = 3, Desync_OffsetY = 0, Desync_OffsetZ = 0,
    -- Skin Changer
    Skin_Enabled = false, Global_SkinID = "", Global_WrapID = "", Global_FinisherID = "",
    WeaponSkins = {},
    -- Movement
    Move_InfiniteJump = false, Move_Fly = false, Move_FlySpeed = 50,
    Move_SlideBoost = false, Move_SlideBoostMult = 1, Move_Velocity = false, Move_VelocitySpeed = 16,
    -- Spoofer
    NameSpoof_Enabled = false, NameSpoof_Text = "",
    Spoof_Level = "", Spoof_Rank = "", Spoof_Winstreak = "", Spoof_Winrate = "",
    Spoof_RankedStreak = "", Spoof_RankedWinrate = "",
    LBS_Enabled = false, LBS_Wins = "", LBS_Winstreak = "", LBS_Level = "", LBS_Rank = "",
    LBS_KD = "", LBS_ELO = "",
}

-- Config helpers
local function saveCfg(name)
    if name == "" then return end
    pcall(function()
        writefile("sysnax/configs/"..name..".json", HttpService:JSONEncode(Config))
        Window:Notify(name.." saved.", 3)
    end)
end
local function loadCfg(name)
    if name == "" or not isfile("sysnax/configs/"..name..".json") then return end
    local ok,data = pcall(function() return HttpService:JSONDecode(readfile("sysnax/configs/"..name..".json")) end)
    if ok and data then for k,v in pairs(data) do Config[k]=v end Window:Notify(name.." loaded.", 3) end
end
local function delCfg(name)
    if name == "" or not isfile("sysnax/configs/"..name..".json") then return end
    delfile("sysnax/configs/"..name..".json")
    Window:Notify(name.." deleted.", 3)
end
local function listCfgs()
    local t = {}
    pcall(function() for _,f in ipairs(listfiles("sysnax/configs")) do local n=f:match("([^/]+)%.json$"); if n then table.insert(t,n) end end end)
    return t
end

-- Mouse buttons (safe)
local MouseBtns = {
    RightMouse = Enum.UserInputType.MouseButton2,
    LeftMouse  = Enum.UserInputType.MouseButton1,
    MiddleMouse= Enum.UserInputType.MouseButton3,
}
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
local function isMB(name)
    local b = MouseBtns[name]
    return b and UserInputService:IsMouseButtonPressed(b)
end

-- Helpers
local function getChar() return LocalPlayer.Character end
local function isAlive()
    local c = LocalPlayer.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function getPlayers()
    local t={}
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
                    if dist < minDist then minDist = dist; closest = plr end
                end
            end
        end
    end
    return closest
end

-- Drawing objects
local function safeDrawing(t)
    if Drawing and type(Drawing.new)=="function" then
        local ok,obj = pcall(Drawing.new,t)
        if ok then return obj end
    end
    return nil
end
local fovCircle = safeDrawing("Circle")
if fovCircle then fovCircle.Thickness=2; fovCircle.NumSides=48; fovCircle.Filled=false; fovCircle.Transparency=1; fovCircle.Visible=false end
local silentFOV = safeDrawing("Circle")
if silentFOV then silentFOV.Thickness=2; silentFOV.NumSides=48; silentFOV.Filled=false; silentFOV.Transparency=1; silentFOV.Visible=false end

-- Find weapon remote (stable)
local remoteFire = nil
pcall(function()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("bullet") or v.Name:lower():find("click")) then
            remoteFire = v; break
        end
    end
    if not remoteFire then
        remoteFire = Workspace:FindFirstChild("WeaponSystem") or game:GetService("ReplicatedStorage"):FindFirstChild("WeaponSystem")
    end
end)

-- ==================== SILENT AIM (hookfunction) ====================
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
                        local origSize = hp.Size
                        hp.Size = origSize + Vector3.new(Config.Hitbox_ExtendRate/10, Config.Hitbox_ExtendRate/10, Config.Hitbox_ExtendRate/10)
                        spawn(function() wait(0.05) pcall(function() hp.Size = origSize end) end)
                    end
                end
                args[2] = part.Position + Vector3.new(0, Config.Silent_Manipulation/100, 0)
                if args[3] and type(args[3])=="userdata" then args[3] = part end
            end
        end
        return oldFire(self, unpack(args))
    end
    hookfunction(remoteFire.FireServer, newFire)  -- safer method
end

-- ==================== RAGEBOT ====================
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
    local char = getChar(); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local now = tick()
    if not voidHidden then
        if now - lastVoid >= Config.Rage_VoidHide then lastVoid=now; hrp.CFrame = hrp.CFrame*CFrame.new(0,-15,0); voidHidden=true end
    else
        if now - lastVoid >= Config.Rage_VoidAttack then lastVoid=now; hrp.CFrame = hrp.CFrame*CFrame.new(0,15,0); voidHidden=false end
    end
end
local function ragebotFly()
    if not Config.Rage_Fly or not isAlive() then return end
    local char = getChar(); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
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
    local char = getChar()
    for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end

-- Desync (stable teleport model)
local desyncModel, posHistory = nil, {}
local function createDesyncModel()
    if desyncModel then desyncModel:Destroy() end
    desyncModel = Instance.new("Model"); desyncModel.Name = "DesyncClone"
    local part = Instance.new("Part"); part.Size=Vector3.new(2,1,1); part.CanCollide=false; part.Anchored=true
    part.Transparency=0.7; part.Color=Color3.fromRGB(255,0,0); part.Material=Enum.Material.ForceField; part.Parent=desyncModel
    desyncModel.Parent = Workspace
end
local function updateDesync()
    if not Config.Desync_Enabled then if desyncModel then desyncModel:Destroy(); desyncModel=nil end return end
    if not desyncModel then createDesyncModel() end
    local char = getChar(); if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    table.insert(posHistory, {cf=hrp.CFrame, time=tick()})
    local cutoff = tick() - Config.Desync_Delay
    while #posHistory>0 and posHistory[1].time < cutoff do table.remove(posHistory,1) end
    if #posHistory>0 then
        local delayed = posHistory[1].cf
        local offset = Vector3.new(Config.Desync_OffsetX, Config.Desync_OffsetY, Config.Desync_OffsetZ)
        desyncModel:SetPrimaryPartCFrame(delayed * CFrame.new(offset))
    end
end

-- ESP
local espCache = {}
local function createESP(plr)
    local esp = {}
    esp.Box = safeDrawing("Square"); esp.Health = safeDrawing("Line"); esp.HealthOutline = safeDrawing("Line")
    esp.Name = safeDrawing("Text"); esp.Distance = safeDrawing("Text"); esp.Skeleton = {}
    if esp.Box then esp.Box.Thickness=2; esp.Box.Filled=false; esp.Box.Visible=false end
    if esp.Health then esp.Health.Thickness=3; esp.Health.Visible=false end
    if esp.HealthOutline then esp.HealthOutline.Thickness=5; esp.HealthOutline.Visible=false; esp.HealthOutline.Color=Color3.new(0,0,0) end
    if esp.Name then esp.Name.Size=13; esp.Name.Center=true; esp.Name.Outline=true; esp.Name.Visible=false; esp.Name.Color=Color3.new(1,1,1) end
    if esp.Distance then esp.Distance.Size=12; esp.Distance.Center=true; esp.Distance.Outline=true; esp.Distance.Visible=false; esp.Distance.Color=Color3.new(1,1,1) end
    espCache[plr]=esp
end
local function removeESP(plr)
    if espCache[plr] then
        for _,v in pairs(espCache[plr]) do
            if type(v)=="table" then for _,s in ipairs(v) do if s.Remove then s:Remove() end end else if v.Remove then v:Remove() end end
        end
        espCache[plr]=nil
    end
end
for _,p in ipairs(getPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then createESP(p) end end)
Players.PlayerRemoving:Connect(removeESP)

-- Chams
local chamCache, lastCham = {}, 0
local function updateChams()
    if Config.Chams_Enabled then
        local now = tick()
        if now-lastCham<0.5 then return end; lastCham=now
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
        for p,orig in pairs(chamCache) do if p and p.Parent then p.Material=orig.Material; p.Color=orig.Color end end
        table.clear(chamCache)
    end
end

-- Skin changer utilities
local function getAllWeapons()
    local tools = {}
    local char = LocalPlayer.Character
    if char then for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v) end end end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v) end end end
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
            if skinID and skinID~="" then
                local d = Instance.new("Decal"); d.Texture = "rbxassetid://"..skinID; d.Face = Enum.NormalId.Front; d.Parent = part
            end
            if wrapID and wrapID~="" then
                local w = Instance.new("Decal"); w.Texture = "rbxassetid://"..wrapID; w.Face = Enum.NormalId.Back; w.Parent = part
            end
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
local function setTP(active)
    tpActive = active
    if active then LocalPlayer.CameraMode = Enum.CameraMode.Classic else LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson end
end
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == tpKey then
        Config.ThirdPerson_Enabled = not Config.ThirdPerson_Enabled
        setTP(Config.ThirdPerson_Enabled)
    end
end)

-- Spoofers
local lastSpoof = 0
local function spoofStats()
    local now = tick()
    if now-lastSpoof<2 then return end; lastSpoof=now
    local gui = LocalPlayer:FindFirstChild("PlayerGui"); if not gui then return end
    local function set(keyw, val)
        if val=="" then return end
        for _,obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if obj.Text:lower():find(keyw,1,true) then obj.Text = string.gsub(obj.Text, "%d+%.?%d*", val) end
            end
        end
    end
    set("level", Config.Spoof_Level)
    set("rank", Config.Spoof_Rank)
    set("streak", Config.Spoof_Winstreak)
    set("winrate", Config.Spoof_Winrate)
    set("ranked streak", Config.Spoof_RankedStreak)
    set("ranked winrate", Config.Spoof_RankedWinrate)
    if Config.NameSpoof_Enabled and Config.NameSpoof_Text ~= "" then
        for _,obj in ipairs(gui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text == LocalPlayer.Name then obj.Text = Config.NameSpoof_Text end
        end
    end
end
local lastLBS = 0
local function spoofLeaderboard()
    if not Config.LBS_Enabled then return end
    local now = tick()
    if now-lastLBS<2 then return end; lastLBS=now
    local gui = LocalPlayer:FindFirstChild("PlayerGui"); if not gui then return end
    local function findBoard()
        for _,screen in ipairs(gui:GetChildren()) do
            if screen:IsA("ScreenGui") then
                for _,obj in ipairs(screen:GetDescendants()) do
                    if obj:IsA("Frame") and (obj.Name:lower():find("leader") or obj.Name:lower():find("score")) then return obj end
                end
            end
        end
    end
    local board = findBoard(); if not board then return end
    local myName = LocalPlayer.Name
    for _,row in ipairs(board:GetChildren()) do
        if row:IsA("Frame") or row:IsA("GuiObject") then
            local hasName = false
            for _,cell in ipairs(row:GetDescendants()) do
                if (cell:IsA("TextLabel") or cell:IsA("TextButton")) and cell.Text == myName then hasName = true break end
            end
            if hasName then
                for _,cell in ipairs(row:GetDescendants()) do
                    if cell:IsA("TextLabel") or cell:IsA("TextButton") then
                        local txt = cell.Text:lower()
                        if txt:find("win") and not txt:find("streak") and Config.LBS_Wins ~= "" then cell.Text = Config.LBS_Wins
                        elseif txt:find("streak") and Config.LBS_Winstreak ~= "" then cell.Text = Config.LBS_Winstreak
                        elseif txt:find("level") and Config.LBS_Level ~= "" then cell.Text = Config.LBS_Level
                        elseif txt:find("rank") and Config.LBS_Rank ~= "" then cell.Text = Config.LBS_Rank
                        elseif (txt:find("kills") or txt:find("k/d")) and Config.LBS_KD ~= "" then cell.Text = Config.LBS_KD
                        elseif txt:find("elo") and Config.LBS_ELO ~= "" then cell.Text = Config.LBS_ELO
                        end
                    end
                end
                return
            end
        end
    end
end
local function ResetLB()
    Config.LBS_Enabled = false
    Config.LBS_Wins,Config.LBS_Winstreak,Config.LBS_Level,Config.LBS_Rank,Config.LBS_KD,Config.LBS_ELO = "","","","","",""
end

-- Main loop
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
        silentFOV.Radius = Config.Silent_FOV
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

    -- Desync
    updateDesync()

    -- Movement
    if isAlive() then
        local char = getChar(); local hum = char and char:FindFirstChildOfClass("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if Config.Move_InfiniteJump and hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            if Config.Move_Fly then
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
                hrp.Velocity = dir.Magnitude > 0 and dir.Unit * Config.Move_FlySpeed or Vector3.new()
            end
            if Config.Move_SlideBoost and hum.MoveDirection.Magnitude > 0 and hum.FloorMaterial ~= Enum.Material.Air then
                hrp.Velocity = hrp.Velocity * Config.Move_SlideBoostMult
            end
            if Config.Move_Velocity then hrp.Velocity = Vector3.new(Config.Move_VelocitySpeed, 0, 0) end
        end
    end

    -- Third person camera
    if tpActive then
        local char = getChar()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local offset = Camera.CFrame.LookVector * -Config.ThirdPerson_Distance
            Camera.CameraSubject = root
            Camera.CFrame = CFrame.new(root.Position - offset, root.Position)
        end
    end

    updateChams(); refreshAllSkins(); spoofStats(); spoofLeaderboard()

    -- ESP
    if Config.ESP_Enabled then
        for plr,esp in pairs(espCache) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum = char.Humanoid; local root = char.HumanoidRootPart
                if hum.Health > 0 then
                    local headPos,_ = w2s((char:FindFirstChild("Head") or root).Position + Vector3.new(0,0.5,0))
                    local legPos,_  = w2s((char:FindFirstChild("LeftFoot") or root).Position - Vector3.new(0,3,0))
                    local h = math.abs(headPos.Y - legPos.Y); local w = h/2
                    local x = headPos.X - w/2; local y = headPos.Y - h/2

                    if esp.Box then
                        esp.Box.Size = Vector2.new(w,h); esp.Box.Position = Vector2.new(x,y)
                        esp.Box.Color = Config.ESP_Color; esp.Box.Visible = Config.ESP_Box
                    end
                    if esp.Health and esp.HealthOutline then
                        local pct = hum.Health / hum.MaxHealth
                        esp.HealthOutline.From = Vector2.new(x-5,y); esp.HealthOutline.To = Vector2.new(x-5,y+h)
                        esp.HealthOutline.Visible = Config.ESP_HealthBar
                        esp.Health.From = Vector2.new(x-5,y+h); esp.Health.To = Vector2.new(x-5,y+h-h*pct)
                        esp.Health.Color = Color3.new(1-pct,pct,0); esp.Health.Visible = Config.ESP_HealthBar
                    end
                    if Config.ESP_Skeleton then
                        local conns = {
                            {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
                            {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
                            {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
                            {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
                            {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
                        }
                        for i,pair in ipairs(conns) do
                            local p1=char:FindFirstChild(pair[1]); local p2=char:FindFirstChild(pair[2])
                            if p1 and p2 then
                                if not esp.Skeleton[i] then
                                    esp.Skeleton[i] = safeDrawing("Line")
                                    if esp.Skeleton[i] then esp.Skeleton[i].Thickness=2; esp.Skeleton[i].Color=Config.ESP_Color end
                                end
                                if esp.Skeleton[i] then
                                    local s1,_=w2s(p1.Position); local s2,_=w2s(p2.Position)
                                    esp.Skeleton[i].From=s1; esp.Skeleton[i].To=s2; esp.Skeleton[i].Visible=true
                                end
                            end
                        end
                    else
                        for _,s in ipairs(esp.Skeleton or {}) do if s then s.Visible=false end end
                    end
                    if esp.Name then esp.Name.Text=plr.Name; esp.Name.Position=Vector2.new(headPos.X,y-15); esp.Name.Visible=true end
                    if esp.Distance and root then
                        local dist = 0
                        if getChar() and getChar():FindFirstChild("HumanoidRootPart") then
                            dist = (root.Position - getChar().HumanoidRootPart.Position).Magnitude
                        end
                        esp.Distance.Text = string.format("%.1f",dist)
                        esp.Distance.Position = Vector2.new(headPos.X,y+h+5); esp.Distance.Visible = true
                    end
                else
                    for _,v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end end
                end
            else
                for _,v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end end
            end
        end
    else
        for _,esp in pairs(espCache) do
            for _,v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end end
        end
    end
end)

-- ==================== UI CONSTRUCTION ====================
local Legit   = Window:AddTab("Legit")
local Rage    = Window:AddTab("Rage")
local Visuals = Window:AddTab("Visuals")
local SkinTab = Window:AddTab("Skin Changer")
local Spoofer = Window:AddTab("Spoofer")
local Settings= Window:AddTab("Settings")

-- Legit
local AimAssist = Legit:AddSection("Aim Assist")
AimAssist:AddToggle("Enabled", Config.Aimbot_Enabled, function(v) Config.Aimbot_Enabled = v end)
AimAssist:AddSlider("Aimbot FOV", 10, 360, Config.Aimbot_FOV, function(v) Config.Aimbot_FOV = v end)
AimAssist:AddSlider("Smoothing Factor", 1, 25, Config.Aimbot_Smoothness, function(v) Config.Aimbot_Smoothness = v end)
AimAssist:AddDropdown("Hit Box", {"Head","HumanoidRootPart","LeftLeg","RightLeg"}, Config.Aimbot_Part, function(v) Config.Aimbot_Part = v end)
AimAssist:AddKeybind("Aimbot Key", Config.Aimbot_Key, function(v) Config.Aimbot_Key = v end)
AimAssist:AddToggle("Draw Fov", Config.Aimbot_ShowFOV, function(v) Config.Aimbot_ShowFOV = v end)
AimAssist:AddSlider("Num Sides", 4, 64, 48, function(v) if fovCircle then fovCircle.NumSides = v end end)

local BulletRedir = Legit:AddSection("Bullet Redirection")
BulletRedir:AddToggle("Enabled", Config.Silent_Enabled, function(v) Config.Silent_Enabled = v end)
BulletRedir:AddSlider("Silent Aim FOV", 10, 360, Config.Silent_FOV, function(v) Config.Silent_FOV = v end)
BulletRedir:AddSlider("Hit Chances", 0, 100, Config.Silent_HitChance, function(v) Config.Silent_HitChance = v end)
BulletRedir:AddDropdown("Redirection Mode", {"P Mode"}, "P Mode", function() end)
BulletRedir:AddDropdown("Hit Box", {"Head","HumanoidRootPart"}, Config.Silent_Part, function(v) Config.Silent_Part = v end)
BulletRedir:AddToggle("Draw Fov", Config.Silent_DrawFOV, function(v) Config.Silent_DrawFOV = v end)
BulletRedir:AddSlider("Num Sides", 4, 64, 48, function(v) if silentFOV then silentFOV.NumSides = v end end)

local ExtendHitbox = Legit:AddSection("Extend Hitbox")
ExtendHitbox:AddToggle("Enabled", Config.Hitbox_Enabled, function(v) Config.Hitbox_Enabled = v end)
ExtendHitbox:AddDropdown("Hit Box", {"Head","HumanoidRootPart"}, Config.Hitbox_Part, function(v) Config.Hitbox_Part = v end)
ExtendHitbox:AddSlider("Extend Rate", 1, 50, Config.Hitbox_ExtendRate, function(v) Config.Hitbox_ExtendRate = v end)

local TriggerBot = Legit:AddSection("Trigger Bot")
TriggerBot:AddToggle("Enabled", Config.Trigger_Enabled, function(v) Config.Trigger_Enabled = v end)
TriggerBot:AddSlider("Delay (s)", 0, 1, Config.Trigger_Delay, 2, function(v) Config.Trigger_Delay = v end)
TriggerBot:AddSlider("Max Distance", 100, 500, Config.Trigger_Distance, 0, function(v) Config.Trigger_Distance = v end)
TriggerBot:AddKeybind("Trigger Key", Config.Trigger_Key, function(v) Config.Trigger_Key = v end)

local RecoilCtrl = Legit:AddSection("Recoil Control")
RecoilCtrl:AddToggle("Enabled", Config.Recoil_Enabled, function(v) Config.Recoil_Enabled = v end)
RecoilCtrl:AddSlider("Model Kick", 0, 100, Config.Recoil_Model, 0, function(v) Config.Recoil_Model = v end)
RecoilCtrl:AddSlider("Camera Kick", 0, 100, Config.Recoil_Camera, 0, function(v) Config.Recoil_Camera = v end)

-- Rage
local RageGroup = Rage:AddSection("Ragebot")
RageGroup:AddToggle("Enable Ragebot", Config.Rage_Enabled, function(v) Config.Rage_Enabled = v end)
RageGroup:AddToggle("Auto Shoot", Config.Rage_AutoShoot, function(v) Config.Rage_AutoShoot = v end)
RageGroup:AddToggle("Through Walls", Config.Rage_ThroughWalls, function(v) Config.Rage_ThroughWalls = v end)
RageGroup:AddSlider("Prediction", 0, 0.5, Config.Rage_Prediction, 3, function(v) Config.Rage_Prediction = v end)
RageGroup:AddSlider("Max Shots/s", 1, 20, Config.Rage_MaxShots, 0, function(v) Config.Rage_MaxShots = v end)
RageGroup:AddToggle("Void Spam", Config.Rage_VoidSpam, function(v) Config.Rage_VoidSpam = v end)
RageGroup:AddSlider("Hide Time", 0.1, 2, Config.Rage_VoidHide, 2, function(v) Config.Rage_VoidHide = v end)
RageGroup:AddSlider("Attack Time", 0.05, 1, Config.Rage_VoidAttack, 2, function(v) Config.Rage_VoidAttack = v end)
RageGroup:AddToggle("Fly", Config.Rage_Fly, function(v) Config.Rage_Fly = v end)
RageGroup:AddSlider("Fly Speed", 10, 100, Config.Rage_FlySpeed, 0, function(v) Config.Rage_FlySpeed = v end)
RageGroup:AddToggle("NoClip", Config.Rage_NoClip, function(v) Config.Rage_NoClip = v end)

-- Visuals
local ESPGroup = Visuals:AddSection("ESP")
ESPGroup:AddToggle("Enable ESP", Config.ESP_Enabled, function(v) Config.ESP_Enabled = v end)
ESPGroup:AddToggle("Box", Config.ESP_Box, function(v) Config.ESP_Box = v end)
ESPGroup:AddToggle("Health Bar", Config.ESP_HealthBar, function(v) Config.ESP_HealthBar = v end)
ESPGroup:AddToggle("Skeleton", Config.ESP_Skeleton, function(v) Config.ESP_Skeleton = v end)
ESPGroup:AddColorPicker("ESP Color", Config.ESP_Color, function(v) Config.ESP_Color = v end)

local ChamsGroup = Visuals:AddSection("Chams")
ChamsGroup:AddToggle("Enable Chams", Config.Chams_Enabled, function(v) Config.Chams_Enabled = v end)
ChamsGroup:AddDropdown("Material", {"ForceField","Neon","Glass","Plastic"}, Config.Chams_Material, function(v) Config.Chams_Material = v end)
ChamsGroup:AddColorPicker("Chams Color", Config.Chams_Color, function(v) Config.Chams_Color = v end)

local CrossGroup = Visuals:AddSection("Crosshair")
CrossGroup:AddToggle("Enable Crosshair", Config.Crosshair_Enabled, function(v) Config.Crosshair_Enabled = v end)
CrossGroup:AddSlider("Size", 5, 30, Config.Crosshair_Size, 0, function(v) Config.Crosshair_Size = v end)
CrossGroup:AddSlider("Thickness", 1, 10, Config.Crosshair_Thickness, 0, function(v) Config.Crosshair_Thickness = v end)
CrossGroup:AddColorPicker("Color", Config.Crosshair_Color, function(v) Config.Crosshair_Color = v end)
CrossGroup:AddToggle("Disable Game Crosshair", Config.Crosshair_DisableGame, function(v) Config.Crosshair_DisableGame = v end)

local TPGroup = Visuals:AddSection("Third Person")
TPGroup:AddKeybind("Toggle Key", Config.ThirdPerson_Key, function(v) Config.ThirdPerson_Key = v; tpKey = Enum.KeyCode[v] or Enum.KeyCode.V end)
TPGroup:AddSlider("Distance", 5, 30, Config.ThirdPerson_Distance, 0, function(v) Config.ThirdPerson_Distance = v end)

local MoveGroup = Visuals:AddSection("Movement")
MoveGroup:AddToggle("Infinite Jump", Config.Move_InfiniteJump, function(v) Config.Move_InfiniteJump = v end)
MoveGroup:AddToggle("Fly", Config.Move_Fly, function(v) Config.Move_Fly = v end)
MoveGroup:AddSlider("Fly Speed", 10, 100, Config.Move_FlySpeed, 0, function(v) Config.Move_FlySpeed = v end)
MoveGroup:AddToggle("Slide Boost", Config.Move_SlideBoost, function(v) Config.Move_SlideBoost = v end)
MoveGroup:AddSlider("Boost Multiplier", 1, 5, Config.Move_SlideBoostMult, 1, function(v) Config.Move_SlideBoostMult = v end)
MoveGroup:AddToggle("Velocity", Config.Move_Velocity, function(v) Config.Move_Velocity = v end)
MoveGroup:AddSlider("Velocity Speed", 1, 100, Config.Move_VelocitySpeed, 0, function(v) Config.Move_VelocitySpeed = v end)

local DesyncGroup = Visuals:AddSection("Desync")
DesyncGroup:AddToggle("Enable Desync", Config.Desync_Enabled, function(v) Config.Desync_Enabled = v end)
DesyncGroup:AddSlider("Delay (s)", 0.1, 2, Config.Desync_Delay, 2, function(v) Config.Desync_Delay = v end)
DesyncGroup:AddSlider("Offset X", -10, 10, Config.Desync_OffsetX, 0, function(v) Config.Desync_OffsetX = v end)
DesyncGroup:AddSlider("Offset Y", -10, 10, Config.Desync_OffsetY, 0, function(v) Config.Desync_OffsetY = v end)
DesyncGroup:AddSlider("Offset Z", -10, 10, Config.Desync_OffsetZ, 0, function(v) Config.Desync_OffsetZ = v end)

-- Skin Changer tab (full)
local SkinEnable = SkinTab:AddSection("Enable")
SkinEnable:AddToggle("Enable Skin Changer", Config.Skin_Enabled, function(v) Config.Skin_Enabled = v; refreshAllSkins() end)

local SkinGlobal = SkinTab:AddSection("Global Settings")
SkinGlobal:AddTextbox("Skin ID", Config.Global_SkinID or "", function(v) Config.Global_SkinID = v end)
SkinGlobal:AddTextbox("Wrap ID", Config.Global_WrapID or "", function(v) Config.Global_WrapID = v end)
SkinGlobal:AddTextbox("Finisher ID", Config.Global_FinisherID or "", function(v) Config.Global_FinisherID = v end)
SkinGlobal:AddButton("Apply to All Weapons", function()
    Config.WeaponSkins = {}
    refreshAllSkins()
end)

local SkinWeapon = SkinTab:AddSection("Weapon Customization")
local weaponCategoryDropdown = SkinWeapon:AddDropdown("Weapon Category", {"All","Melee","Primary","Secondary","Utility"}, "All", function() end)
local weaponListDropdown = SkinWeapon:AddDropdown("Select Weapon", {}, "", function(v)
    local data = Config.WeaponSkins[v]
    if data then
        skinInput:SetText(data.SkinID or "")
        wrapInput:SetText(data.WrapID or "")
        finisherInput:SetText(data.FinisherID or "")
    else
        skinInput:SetText(""); wrapInput:SetText(""); finisherInput:SetText("")
    end
end)

local function updateWeaponList()
    local allWeapons = getAllWeapons()
    local category = weaponCategoryDropdown:GetValue() or "All"
    local names = {}
    for _,tool in ipairs(allWeapons) do
        local cat = categorizeWeaponName(tool.Name)
        if category == "All" or cat == category then
            table.insert(names, tool.Name)
        end
    end
    weaponListDropdown:Refresh(names, #names>0 and names[1] or "")
end

SkinWeapon:AddButton("Refresh Weapons", updateWeaponList)
updateWeaponList()

local skinInput = SkinWeapon:AddTextbox("Skin ID", "", function() end)
local wrapInput = SkinWeapon:AddTextbox("Wrap ID", "", function() end)
local finisherInput = SkinWeapon:AddTextbox("Finisher ID", "", function() end)

SkinWeapon:AddButton("Apply to Selected", function()
    local weaponName = weaponListDropdown:GetValue()
    if not weaponName or weaponName == "" then return end
    if not Config.WeaponSkins[weaponName] then Config.WeaponSkins[weaponName] = {} end
    Config.WeaponSkins[weaponName].SkinID = skinInput:GetText()
    Config.WeaponSkins[weaponName].WrapID = wrapInput:GetText()
    Config.WeaponSkins[weaponName].FinisherID = finisherInput:GetText()
    refreshAllSkins()
end)

SkinWeapon:AddButton("Reset Selected", function()
    local weaponName = weaponListDropdown:GetValue()
    if weaponName and Config.WeaponSkins[weaponName] then
        Config.WeaponSkins[weaponName] = nil
        skinInput:SetText(""); wrapInput:SetText(""); finisherInput:SetText("")
        refreshAllSkins()
    end
end)

-- Spoofer
local StatsSpoof = Spoofer:AddSection("Stats Spoofer")
StatsSpoof:AddTextbox("Level", Config.Spoof_Level, function(v) Config.Spoof_Level = v end)
StatsSpoof:AddTextbox("Rank", Config.Spoof_Rank, function(v) Config.Spoof_Rank = v end)
StatsSpoof:AddTextbox("Winstreak", Config.Spoof_Winstreak, function(v) Config.Spoof_Winstreak = v end)
StatsSpoof:AddTextbox("Winrate", Config.Spoof_Winrate, function(v) Config.Spoof_Winrate = v end)
StatsSpoof:AddTextbox("Ranked Streak", Config.Spoof_RankedStreak, function(v) Config.Spoof_RankedStreak = v end)
StatsSpoof:AddTextbox("Ranked Winrate", Config.Spoof_RankedWinrate, function(v) Config.Spoof_RankedWinrate = v end)

local NameSpoof = Spoofer:AddSection("Name Spoof")
NameSpoof:AddToggle("Enable", Config.NameSpoof_Enabled, function(v) Config.NameSpoof_Enabled = v end)
NameSpoof:AddTextbox("Display Name", Config.NameSpoof_Text, function(v) Config.NameSpoof_Text = v end)

local LBGroup = Spoofer:AddSection("Leaderboard Spoofer (client)")
LBGroup:AddToggle("Enable", Config.LBS_Enabled, function(v) Config.LBS_Enabled = v end)
LBGroup:AddTextbox("Wins", Config.LBS_Wins, function(v) Config.LBS_Wins = v end)
LBGroup:AddTextbox("Winstreak", Config.LBS_Winstreak, function(v) Config.LBS_Winstreak = v end)
LBGroup:AddTextbox("Level", Config.LBS_Level, function(v) Config.LBS_Level = v end)
LBGroup:AddTextbox("Rank", Config.LBS_Rank, function(v) Config.LBS_Rank = v end)
LBGroup:AddTextbox("K/D", Config.LBS_KD, function(v) Config.LBS_KD = v end)
LBGroup:AddTextbox("Elo", Config.LBS_ELO, function(v) Config.LBS_ELO = v end)
LBGroup:AddButton("Reset", ResetLB)

-- Settings
local Keybinds = Settings:AddSection("Keybinds")
Keybinds:AddKeybind("Toggle UI", "RightShift", function(v) Window:SetToggleKey(Enum.KeyCode[v]) end)

local Configs = Settings:AddSection("Configurations")
local cfgName = Configs:AddTextbox("Config Name", "", function() end)
Configs:AddButton("Save", function() saveCfg(cfgName:GetText()) end)
Configs:AddButton("Load", function() loadCfg(cfgName:GetText()) end)
Configs:AddButton("Delete", function() delCfg(cfgName:GetText()) end)
local existingCfgs = listCfgs()
local cfgDrop = Configs:AddDropdown("Existing", existingCfgs, existingCfgs[1] or "", function(v) cfgName:SetText(v) end)
Configs:AddButton("Refresh", function() cfgDrop:Refresh(listCfgs()) end)

local Theme = Settings:AddSection("Theme")
Theme:AddDropdown("Theme", {"Sysnax","Dark","Light"}, "Sysnax", function(v)
    if v == "Sysnax" then
        Window:SetTheme({
            Background = Color3.fromRGB(25,25,30), Tab = Color3.fromRGB(35,35,40), Element = Color3.fromRGB(45,45,50),
            Accent = Color3.fromRGB(160,160,160), Text = Color3.fromRGB(230,230,230),
            TitleBar = Color3.fromRGB(30,30,35), Footer = Color3.fromRGB(60,60,65),
        })
    elseif v == "Dark" then Window:SetTheme("Dark")
    elseif v == "Light" then Window:SetTheme("Light")
    end
end)

-- Autoload hidden
Window:ToggleUI()

Window:Notify("🥳 Official Release  |  Stable on Synapse Z", 6)