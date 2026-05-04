--[[
    Sysnax – Ultimate Edition
    AC Bypass · Desync · Full Spoofer · Ragebot · Obsidian UI (gray/black)
    Rivals / Arsenal / HyperShot
    Right Shift to open  •  Autoload hidden
--]]

local function main()
    if not loadstring then return end

    -- ==================== SERVICES ====================
    local clone = cloneref or function(v) return v end
    local Players = clone(game:GetService("Players"))
    local RunService = clone(game:GetService("RunService"))
    local UserInputService = clone(game:GetService("UserInputService"))
    local HttpService = clone(game:GetService("HttpService"))
    local Workspace = clone(game:GetService("Workspace"))
    local StarterGui = clone(game:GetService("StarterGui"))
    local ReplicatedStorage = clone(game:GetService("ReplicatedStorage"))
    local Camera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    -- ==================== SUPPORTED GAMES ====================
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

    -- ==================== AC BYPASS ====================
    local function bypassAC()
        -- Disable known anti-cheat LocalScripts
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or name == "localscript3" then
                    pcall(function() obj.Disabled = true end)
                end
            end
        end
        if LocalPlayer.PlayerGui then
            for _, obj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if obj:IsA("LocalScript") then
                    local name = obj.Name:lower()
                    if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or name == "localscript3" then
                        pcall(function() obj.Disabled = true end)
                    end
                end
            end
        end
    end
    pcall(bypassAC)

    -- ==================== LOAD OBSIDIAN UI ====================
    local Obsidian
    pcall(function()
        Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
    end)
    if not Obsidian then
        pcall(function()
            Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Example.lua"))()
        end)
    end
    if not Obsidian or not Obsidian.CreateWindow then
        LocalPlayer:Kick("Failed to load Obsidian UI.")
        return
    end

    -- ==================== THEME (GRAY/BLACK) ====================
    local Window = Obsidian:CreateWindow({
        Title = "Sysnax",
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
        Size = UDim2.fromOffset(700,540),
        Position = UDim2.fromScale(0.5,0.45),
        Resizable = true,
        Icon = "rbxassetid://122198206955790",
        Folder = "sysnax",
    })

    -- ==================== CONFIGS ====================
    if not isfolder("sysnax") then makefolder("sysnax") end
    if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end
    local CurrentConfig = {}
    local function saveCfg(name)
        if name=="" then return end
        pcall(function()
            writefile("sysnax/configs/"..name..".json", HttpService:JSONEncode(CurrentConfig))
            Window:Notify(name.." saved.", 3)
        end)
    end
    local function loadCfg(name)
        if name=="" or not isfile("sysnax/configs/"..name..".json") then return end
        local ok,data = pcall(function() return HttpService:JSONDecode(readfile("sysnax/configs/"..name..".json")) end)
        if ok and data then
            for k,v in pairs(data) do CurrentConfig[k]=v end
            Window:Notify(name.." loaded.", 3)
        end
    end
    local function delCfg(name)
        if name=="" or not isfile("sysnax/configs/"..name..".json") then return end
        delfile("sysnax/configs/"..name..".json")
        Window:Notify(name.." deleted.", 3)
    end
    local function listCfgs()
        local t={}
        pcall(function()
            for _,f in ipairs(listfiles("sysnax/configs")) do
                local n=f:match("([^/]+)%.json$"); if n then table.insert(t,n) end
            end
        end)
        return t
    end

    -- ==================== SAFE MOUSE BUTTONS ====================
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

    -- ==================== DEFAULT SETTINGS ====================
    CurrentConfig = {
        -- Aimbot
        Aimbot_Enabled=false, Aimbot_Mode="Hold", Aimbot_Part="Head", Aimbot_Smoothness=5,
        Aimbot_Radius=200, Aimbot_VisibleOnly=true, Aimbot_ShowFOV=true,
        Aimbot_FOVColor=Color3.fromRGB(255,255,255), Aimbot_Key="RightMouse",

        -- Silent Aim
        Silent_Enabled=false, Silent_Part="Head", Silent_HitChance=100,
        Silent_Manipulation=0, Silent_VisibleOnly=true, Silent_MaxDistance=500,
        Silent_DrawFOV=true, Silent_FOVRadius=100,

        -- Triggerbot
        Trigger_Enabled=false, Trigger_Delay=0.1, Trigger_Distance=300, Trigger_Key="RightMouse",

        -- Ragebot
        Rage_Enabled=false, Rage_AutoShoot=true, Rage_ThroughWalls=true,
        Rage_Prediction=0.165, Rage_MaxShotsPerSec=6,
        Rage_VoidSpam=false, Rage_VoidHide=0.15, Rage_VoidAttack=0.05,
        Rage_Fly=false, Rage_FlySpeed=50, Rage_NoClip=false,

        -- Desync
        Desync_Enabled=false, Desync_Delay=0.5, Desync_Offset=Vector3.new(3,0,0),

        -- Visuals
        ESP_Enabled=false, ESP_Box=true, ESP_HealthBar=true, ESP_Skeleton=false,
        ESP_Color=Color3.fromRGB(255,255,255),
        Chams_Enabled=false, Chams_Material="ForceField", Chams_Color=Color3.fromRGB(150,0,255),
        Crosshair_Enabled=false, Crosshair_Size=10, Crosshair_Thickness=2,
        Crosshair_Color=Color3.fromRGB(255,255,255), Crosshair_DisableGame=false,
        ThirdPerson_Enabled=false, ThirdPerson_Distance=15, ThirdPerson_Key="V",

        -- Skin Changer
        Skin_Enabled=false, Global_SkinID="", Global_WrapID="", Global_FinisherID="",
        WeaponSkins={},

        -- Movement
        Move_InfiniteJump=false, Move_Fly=false, Move_FlySpeed=50,
        Move_SlideBoost=false, Move_SlideBoostMult=1, Move_Velocity=false, Move_VelocitySpeed=16,

        -- Animations
        Anim_Enabled=false, Anim_ID="", Anim_Speed=1,

        -- Hit Sounds
        HitSound_Enabled=false, HitSound_Sound="Bameware", HitSound_ApplyTo="All",

        -- Spoofer
        NameSpoof_Enabled=false, NameSpoof_Text="",
        Spoof_Level="", Spoof_Rank="", Spoof_Winstreak="", Spoof_Winrate="",
        Spoof_RankedStreak="", Spoof_RankedWinrate="",
        LBS_Enabled=false, LBS_Wins="", LBS_Winstreak="", LBS_Level="", LBS_Rank="",
        LBS_KD="", LBS_ELO="",
    }

    -- ==================== UTILITY FUNCTIONS ====================
    local function getChar() return LocalPlayer.Character end
    local function isAlive()
        local c = LocalPlayer.Character
        if not c then return false end
        local h = c:FindFirstChildOfClass("Humanoid")
        return h and h.Health>0
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

    -- ==================== DRAWING OBJECTS (safe) ====================
    local function safeDrawing(typeName)
        if Drawing and type(Drawing.new)=="function" then
            local ok, obj = pcall(Drawing.new, typeName)
            if ok then return obj end
        end
        return nil
    end

    local fovCircle = safeDrawing("Circle")
    if fovCircle then
        fovCircle.Thickness = 2; fovCircle.NumSides = 64
        fovCircle.Filled = false; fovCircle.Transparency = 1; fovCircle.Visible = false
    end

    -- ==================== FIND WEAPON REMOTE ====================
    local remoteFire = nil
    pcall(function()
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():match("fire") or v.Name:lower():match("shoot") or v.Name:lower():match("bullet") or v.Name:lower():match("click") then
                remoteFire = v
                break
            end
        end
        if not remoteFire then
            remoteFire = Workspace:FindFirstChild("WeaponSystem") or ReplicatedStorage:FindFirstChild("WeaponSystem")
        end
    end)

    -- ==================== UNDETECTED SILENT AIM ====================
    local silentTarget = nil
    if remoteFire and remoteFire.FireServer then
        local oldFire = remoteFire.FireServer
        local function newFire(...)
            local args = {...}
            if CurrentConfig.Silent_Enabled and silentTarget and silentTarget.Character then
                local part = silentTarget.Character:FindFirstChild(CurrentConfig.Silent_Part)
                if part then
                    args[2] = part.Position + Vector3.new(0, CurrentConfig.Silent_Manipulation/100, 0)
                    if args[3] and type(args[3])=="userdata" then args[3] = part end
                end
            end
            return oldFire(remoteFire, unpack(args))
        end
        pcall(function() remoteFire.FireServer = newFire end)
    end

    -- ==================== RAGEBOT ====================
    local ragebotTarget = nil
    local ragebotLastShot = 0
    local ragebotMinInterval = 0
    local function ragebotUpdateTarget()
        if not CurrentConfig.Rage_Enabled or not isAlive() then ragebotTarget=nil return end
        ragebotTarget = closestToCursor(1000, "Head", not CurrentConfig.Rage_ThroughWalls)
    end
    local function ragebotAutoShoot()
        if not CurrentConfig.Rage_AutoShoot or not ragebotTarget or not ragebotTarget.Character then return end
        if not remoteFire then return end
        local now = tick()
        if CurrentConfig.Rage_MaxShotsPerSec>0 then
            ragebotMinInterval = 1/CurrentConfig.Rage_MaxShotsPerSec
            if now - ragebotLastShot < ragebotMinInterval then return end
        end
        local targetHead = ragebotTarget.Character:FindFirstChild("Head")
        if not targetHead then return end
        local predictedPos = targetHead.Position
        if CurrentConfig.Rage_Prediction>0 then
            local targetHum = ragebotTarget.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.MoveDirection.Magnitude>0 then
                local vel = targetHum.MoveDirection * (targetHum.WalkSpeed or 16)
                predictedPos = predictedPos + vel * CurrentConfig.Rage_Prediction
            end
        end
        predictedPos = predictedPos + Vector3.new(math.random(-10,10)/100, math.random(-10,10)/100, math.random(-10,10)/100)
        remoteFire:FireServer("MouseClick", predictedPos)
        ragebotLastShot = now
    end

    local lastVoidSwap, voidHidden = 0, false
    local function ragebotVoid()
        if not CurrentConfig.Rage_VoidSpam or not isAlive() then return end
        local char = getChar()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local now = tick()
        if not voidHidden then
            if now - lastVoidSwap >= CurrentConfig.Rage_VoidHide then
                lastVoidSwap = now; hrp.CFrame = hrp.CFrame * CFrame.new(0,-15,0); voidHidden = true
            end
        else
            if now - lastVoidSwap >= CurrentConfig.Rage_VoidAttack then
                lastVoidSwap = now; hrp.CFrame = hrp.CFrame * CFrame.new(0,15,0); voidHidden = false
            end
        end
    end
    local function ragebotFly()
        if not CurrentConfig.Rage_Fly or not isAlive() then return end
        local char = getChar()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.Velocity = dir.Magnitude>0 and dir.Unit*CurrentConfig.Rage_FlySpeed or Vector3.new()
    end
    local function ragebotNoClip()
        if not CurrentConfig.Rage_NoClip or not isAlive() then return end
        local char = getChar()
        for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end

    -- ==================== DESYNC ====================
    local desyncModel = nil
    local positionHistory = {}
    local function createDesyncModel()
        if desyncModel then desyncModel:Destroy() end
        desyncModel = Instance.new("Model")
        desyncModel.Name = "DesyncClone"
        local part = Instance.new("Part")
        part.Size = Vector3.new(2,1,1)
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 0.7
        part.Color = Color3.fromRGB(255,0,0)
        part.Material = Enum.Material.ForceField
        part.Parent = desyncModel
        desyncModel.Parent = Workspace
    end
    local function updateDesync()
        if not CurrentConfig.Desync_Enabled then
            if desyncModel then desyncModel:Destroy(); desyncModel=nil end
            return
        end
        if not desyncModel then createDesyncModel() end
        local char = getChar()
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        -- Record position
        table.insert(positionHistory, {cf=hrp.CFrame, time=tick()})
        -- Remove old entries beyond delay
        local cutoff = tick() - CurrentConfig.Desync_Delay
        while #positionHistory>0 and positionHistory[1].time < cutoff do
            table.remove(positionHistory,1)
        end
        if #positionHistory>0 then
            local delayedCF = positionHistory[1].cf
            local offset = CurrentConfig.Desync_Offset or Vector3.new(3,0,0)
            local targetCF = delayedCF * CFrame.new(offset)
            desyncModel:SetPrimaryPartCFrame(targetCF)
        end
    end

    -- ==================== ESP ====================
    local espCache = {}
    local function createESP(plr)
        local esp = {}
        esp.Box = safeDrawing("Square")
        esp.Health = safeDrawing("Line")
        esp.HealthOutline = safeDrawing("Line")
        esp.Name = safeDrawing("Text")
        esp.Distance = safeDrawing("Text")
        esp.Skeleton = {}
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
                if type(v)=="table" then for _,s in ipairs(v) do if s.Remove then s:Remove() end end
                else if v.Remove then v:Remove() end end
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
        if CurrentConfig.Chams_Enabled then
            local now = tick()
            if now-lastCham<0.5 then return end
            lastCham=now
            for _,plr in ipairs(getPlayers()) do
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _,p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            if not chamCache[p] then chamCache[p]={Material=p.Material,Color=p.Color} end
                            p.Material = Enum.Material[CurrentConfig.Chams_Material] or Enum.Material.ForceField
                            p.Color = CurrentConfig.Chams_Color
                        end
                    end
                end
            end
        else
            for p,orig in pairs(chamCache) do
                if p and p.Parent then p.Material=orig.Material; p.Color=orig.Color end
            end
            table.clear(chamCache)
        end
    end

    -- Skin changer
    local function applyWeaponSkin(weapon, skinID, wrapID)
        if not weapon then return end
        for _,part in ipairs(weapon:GetDescendants()) do
            if part:IsA("BasePart") then
                for _,c in ipairs(part:GetChildren()) do if c:IsA("Decal") or c:IsA("Texture") then c:Destroy() end end
                if skinID and skinID~="" then
                    local d=Instance.new("Decal"); d.Texture="rbxassetid://"..skinID; d.Face=Enum.NormalId.Front; d.Parent=part
                end
                if wrapID and wrapID~="" then
                    local w=Instance.new("Decal"); w.Texture="rbxassetid://"..wrapID; w.Face=Enum.NormalId.Back; w.Parent=part
                end
            end
        end
    end
    local function getWeapons()
        local weaps={}
        local char=LocalPlayer.Character
        if char then for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(weaps,v) end end end
        local bp=LocalPlayer:FindFirstChild("Backpack")
        if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then table.insert(weaps,v) end end end
        return weaps
    end
    local function refreshSkins()
        if not CurrentConfig.Skin_Enabled then return end
        local weaps=getWeapons()
        for _,w in ipairs(weaps) do
            local per = CurrentConfig.WeaponSkins[w.Name]
            local skin = CurrentConfig.Global_SkinID
            local wrap = CurrentConfig.Global_WrapID
            if per then
                if per.SkinID~="" then skin=per.SkinID end
                if per.WrapID~="" then wrap=per.WrapID end
            end
            applyWeaponSkin(w, skin, wrap)
        end
    end

    -- Third person
    local tpActive, tpKey = false, Enum.KeyCode.V
    local function setTP(active)
        tpActive=active
        if active then LocalPlayer.CameraMode=Enum.CameraMode.Classic else LocalPlayer.CameraMode=Enum.CameraMode.LockFirstPerson end
    end
    UserInputService.InputBegan:Connect(function(input, proc)
        if proc then return end
        if input.KeyCode==tpKey then
            CurrentConfig.ThirdPerson_Enabled = not CurrentConfig.ThirdPerson_Enabled
            setTP(CurrentConfig.ThirdPerson_Enabled)
        end
    end)

    -- Spoofers
    local lastSpoof = 0
    local function spoofStats()
        local now = tick()
        if now-lastSpoof<2 then return end
        lastSpoof=now
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if not gui then return end
        local function set(keyw, val)
            if val=="" then return end
            for _,obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if obj.Text:lower():find(keyw,1,true) then
                        obj.Text = string.gsub(obj.Text, "%d+%.?%d*", val)
                    end
                end
            end
        end
        set("level", CurrentConfig.Spoof_Level)
        set("rank", CurrentConfig.Spoof_Rank)
        set("streak", CurrentConfig.Spoof_Winstreak)
        set("winrate", CurrentConfig.Spoof_Winrate)
        set("ranked streak", CurrentConfig.Spoof_RankedStreak)
        set("ranked winrate", CurrentConfig.Spoof_RankedWinrate)
        -- Name spoof
        if CurrentConfig.NameSpoof_Enabled and CurrentConfig.NameSpoof_Text ~= "" then
            for _,obj in ipairs(gui:GetDescendants()) do
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text == LocalPlayer.Name then
                    obj.Text = CurrentConfig.NameSpoof_Text
                end
            end
        end
    end

    local lastLBS = 0
    local function spoofLeaderboard()
        if not CurrentConfig.LBS_Enabled then return end
        local now = tick()
        if now-lastLBS<2 then return end
        lastLBS=now
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if not gui then return end
        local function findBoard()
            for _,scr in ipairs(gui:GetChildren()) do
                if scr:IsA("ScreenGui") then
                    for _,obj in ipairs(scr:GetDescendants()) do
                        if obj:IsA("Frame") and (obj.Name:lower():find("leader") or obj.Name:lower():find("score")) then return obj end
                    end
                end
            end
        end
        local board = findBoard()
        if not board then return end
        local name = LocalPlayer.Name
        for _,child in ipairs(board:GetDescendants()) do
            if (child:IsA("TextLabel") or child:IsA("TextButton")) and (child.Text==name or child.Text:find(name)) then
                local par = child.Parent
                if par then
                    for _,el in ipairs(par:GetChildren()) do
                        if el:IsA("TextLabel") or el:IsA("TextButton") then
                            local txt = el.Text:lower()
                            if txt:find("win") and not txt:find("streak") and CurrentConfig.LBS_Wins~="" then el.Text=CurrentConfig.LBS_Wins
                            elseif txt:find("streak") and CurrentConfig.LBS_Winstreak~="" then el.Text=CurrentConfig.LBS_Winstreak
                            elseif txt:find("level") and CurrentConfig.LBS_Level~="" then el.Text=CurrentConfig.LBS_Level
                            elseif txt:find("rank") and CurrentConfig.LBS_Rank~="" then el.Text=CurrentConfig.LBS_Rank
                            elseif (txt:find("kills") or txt:find("k/d")) and CurrentConfig.LBS_KD~="" then el.Text=CurrentConfig.LBS_KD
                            elseif txt:find("elo") and CurrentConfig.LBS_ELO~="" then el.Text=CurrentConfig.LBS_ELO
                            end
                        end
                    end
                    return
                end
            end
        end
    end
    local function ResetLB()
        CurrentConfig.LBS_Enabled=false
        CurrentConfig.LBS_Wins="";CurrentConfig.LBS_Winstreak="";CurrentConfig.LBS_Level=""
        CurrentConfig.LBS_Rank="";CurrentConfig.LBS_KD="";CurrentConfig.LBS_ELO=""
    end

    -- ==================== MAIN LOOP ====================
    local lastShot = 0
    RunService.RenderStepped:Connect(function()
        -- Aimbot
        if CurrentConfig.Aimbot_Enabled and isAlive() then
            if fovCircle then
                fovCircle.Visible = CurrentConfig.Aimbot_ShowFOV
                fovCircle.Radius = CurrentConfig.Aimbot_Radius
                fovCircle.Color = CurrentConfig.Aimbot_FOVColor
                fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
            end
            local aim = CurrentConfig.Aimbot_Mode=="Always" or
                       (CurrentConfig.Aimbot_Mode=="Hold" and isMB(CurrentConfig.Aimbot_Key))
            if aim then
                local t = closestToCursor(CurrentConfig.Aimbot_Radius, CurrentConfig.Aimbot_Part, CurrentConfig.Aimbot_VisibleOnly)
                if t and t.Character then
                    local part = t.Character:FindFirstChild(CurrentConfig.Aimbot_Part)
                    if part then
                        local scr = Camera:WorldToScreenPoint(part.Position)
                        local delta = (Vector2.new(scr.X,scr.Y)-Vector2.new(Mouse.X,Mouse.Y))/CurrentConfig.Aimbot_Smoothness
                        mousemoverel(delta.X, delta.Y)
                    end
                end
            end
        elseif fovCircle then fovCircle.Visible = false end

        -- Silent aim target
        if CurrentConfig.Silent_Enabled then
            local t = closestToCursor(CurrentConfig.Silent_MaxDistance, CurrentConfig.Silent_Part, CurrentConfig.Silent_VisibleOnly)
            if t and math.random(1,100)<=CurrentConfig.Silent_HitChance then silentTarget=t else silentTarget=nil end
        else silentTarget=nil end

        -- Triggerbot
        if CurrentConfig.Trigger_Enabled and isAlive() and isMB(CurrentConfig.Trigger_Key) then
            local t = closestToCursor(CurrentConfig.Trigger_Distance,"Head",true)
            if t and t.Character and tick()-lastShot>=CurrentConfig.Trigger_Delay then
                if remoteFire then remoteFire:FireServer("MouseClick", t.Character.Head); lastShot=tick() end
            end
        end

        -- Ragebot
        ragebotUpdateTarget()
        ragebotAutoShoot()
        ragebotVoid()
        ragebotFly()
        ragebotNoClip()

        -- Desync
        updateDesync()

        -- Movement
        if isAlive() then
            local char = getChar()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                if CurrentConfig.Move_InfiniteJump and hum.FloorMaterial~=Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                if CurrentConfig.Move_Fly then
                    local dir=Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.new(0,1,0) end
                    hrp.Velocity = dir.Magnitude>0 and dir.Unit*CurrentConfig.Move_FlySpeed or Vector3.new()
                end
                if CurrentConfig.Move_SlideBoost and hum.MoveDirection.Magnitude>0 and hum.FloorMaterial~=Enum.Material.Air then
                    hrp.Velocity*=CurrentConfig.Move_SlideBoostMult
                end
                if CurrentConfig.Move_Velocity then hrp.Velocity=Vector3.new(CurrentConfig.Move_VelocitySpeed,0,0) end
            end
        end

        -- Third person camera
        if tpActive then
            local char = getChar()
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local offset = Camera.CFrame.LookVector * -CurrentConfig.ThirdPerson_Distance
                Camera.CameraSubject = root
                Camera.CFrame = CFrame.new(root.Position - offset, root.Position)
            end
        end

        updateChams()
        refreshSkins()
        spoofStats()
        spoofLeaderboard()

        -- ESP
        if CurrentConfig.ESP_Enabled then
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
                            esp.Box.Color=CurrentConfig.ESP_Color; esp.Box.Visible=CurrentConfig.ESP_Box
                        end
                        if esp.Health and esp.HealthOutline then
                            local pct = hum.Health/hum.MaxHealth
                            esp.HealthOutline.From=Vector2.new(x-5,y); esp.HealthOutline.To=Vector2.new(x-5,y+h)
                            esp.HealthOutline.Visible = CurrentConfig.ESP_HealthBar
                            esp.Health.From=Vector2.new(x-5,y+h); esp.Health.To=Vector2.new(x-5,y+h-h*pct)
                            esp.Health.Color=Color3.new(1-pct,pct,0); esp.Health.Visible=CurrentConfig.ESP_HealthBar
                        end
                        if CurrentConfig.ESP_Skeleton then
                            local conns = {
                                {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
                                {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
                                {"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
                                {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
                                {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
                                {"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                                {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
                            }
                            for i,pair in ipairs(conns) do
                                local p1=char:FindFirstChild(pair[1]); local p2=char:FindFirstChild(pair[2])
                                if p1 and p2 then
                                    if not esp.Skeleton[i] then
                                        esp.Skeleton[i] = safeDrawing("Line")
                                        if esp.Skeleton[i] then esp.Skeleton[i].Thickness=2; esp.Skeleton[i].Color=CurrentConfig.ESP_Color end
                                    end
                                    if esp.Skeleton[i] then
                                        local s1,_ = w2s(p1.Position); local s2,_ = w2s(p2.Position)
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
                            esp.Distance.Text=string.format("%.1f",dist)
                            esp.Distance.Position=Vector2.new(headPos.X,y+h+5); esp.Distance.Visible=true
                        end
                    else
                        for _,v in pairs(esp) do
                            if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end
                        end
                    end
                else
                    for _,v in pairs(esp) do
                        if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end
                    end
                end
            end
        else
            for _,esp in pairs(espCache) do
                for _,v in pairs(esp) do
                    if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end
                end
            end
        end
    end)

    -- ==================== UI TABS ====================
    local Tabs = {
        Combat   = Window:AddTab("Combat", "crosshair"),
        Visuals  = Window:AddTab("Visuals", "eye"),
        Ragebot  = Window:AddTab("Ragebot", "zap"),
        Desync   = Window:AddTab("Desync", "radio"),
        Skin     = Window:AddTab("Skin Changer", "shirt"),
        Movement = Window:AddTab("Movement", "footprints"),
        Anims    = Window:AddTab("Animations", "play"),
        HitSound = Window:AddTab("Hit Sounds", "music"),
        Spoofer  = Window:AddTab("Spoofer", "shield"),
        Settings = Window:AddTab("Settings", "settings"),
    }

    -- Combat / Aimbot
    local AimbotGroup = Tabs.Combat:AddLeftGroupbox("Aimbot", "crosshair")
    AimbotGroup:AddToggle("AimbotEnabled", {Text="Enable Aimbot", Default=CurrentConfig.Aimbot_Enabled, Callback=function(v) CurrentConfig.Aimbot_Enabled=v end})
    AimbotGroup:AddDropdown("AimbotMode", {Text="Mode", Values={"Hold","Toggle","Always"}, Default=CurrentConfig.Aimbot_Mode, Callback=function(v) CurrentConfig.Aimbot_Mode=v end})
    AimbotGroup:AddDropdown("AimbotPart", {Text="Target Part", Values={"Head","HumanoidRootPart","LeftLeg","RightLeg"}, Default=CurrentConfig.Aimbot_Part, Callback=function(v) CurrentConfig.Aimbot_Part=v end})
    AimbotGroup:AddSlider("AimbotSmoothness", {Text="Smoothness", Min=1,Max=20,Default=CurrentConfig.Aimbot_Smoothness, Rounding=1, Callback=function(v) CurrentConfig.Aimbot_Smoothness=v end})
    AimbotGroup:AddSlider("AimbotRadius", {Text="FOV Radius", Min=50,Max=500,Default=CurrentConfig.Aimbot_Radius, Rounding=0, Callback=function(v) CurrentConfig.Aimbot_Radius=v end})
    AimbotGroup:AddToggle("AimbotVisibleOnly", {Text="Visible Only", Default=CurrentConfig.Aimbot_VisibleOnly, Callback=function(v) CurrentConfig.Aimbot_VisibleOnly=v end})
    AimbotGroup:AddToggle("AimbotShowFOV", {Text="Show FOV Circle", Default=CurrentConfig.Aimbot_ShowFOV, Callback=function(v) CurrentConfig.Aimbot_ShowFOV=v end})
    AimbotGroup:AddColorPicker("AimbotFOVColor", {Default=CurrentConfig.Aimbot_FOVColor, Title="FOV Color", Callback=function(v) CurrentConfig.Aimbot_FOVColor=v end})
    AimbotGroup:AddKeybind("AimbotKey", {Text="Aimbot Key", Default="RightMouse", Callback=function(v) CurrentConfig.Aimbot_Key=v end})

    local SilentGroup = Tabs.Combat:AddRightGroupbox("Silent Aim", "eye")
    SilentGroup:AddToggle("SilentEnabled", {Text="Enable Silent Aim", Default=CurrentConfig.Silent_Enabled, Callback=function(v) CurrentConfig.Silent_Enabled=v end})
    SilentGroup:AddDropdown("SilentPart", {Text="Target Part", Values={"Head","HumanoidRootPart"}, Default=CurrentConfig.Silent_Part, Callback=function(v) CurrentConfig.Silent_Part=v end})
    SilentGroup:AddSlider("SilentHitChance", {Text="Hit Chance %", Min=0,Max=100,Default=CurrentConfig.Silent_HitChance, Rounding=0, Callback=function(v) CurrentConfig.Silent_HitChance=v end})
    SilentGroup:AddSlider("SilentManipulation", {Text="Manipulation (Y)", Min=-50,Max=50,Default=CurrentConfig.Silent_Manipulation, Rounding=1, Callback=function(v) CurrentConfig.Silent_Manipulation=v end})
    SilentGroup:AddToggle("SilentVisibleOnly", {Text="Visible Only", Default=CurrentConfig.Silent_VisibleOnly, Callback=function(v) CurrentConfig.Silent_VisibleOnly=v end})
    SilentGroup:AddSlider("SilentMaxDistance", {Text="Max Distance", Min=100,Max=1000,Default=CurrentConfig.Silent_MaxDistance, Rounding=0, Callback=function(v) CurrentConfig.Silent_MaxDistance=v end})
    SilentGroup:AddToggle("SilentDrawFOV", {Text="Draw Silent FOV", Default=CurrentConfig.Silent_DrawFOV, Callback=function(v) CurrentConfig.Silent_DrawFOV=v end})
    SilentGroup:AddSlider("SilentFOVRadius", {Text="Silent FOV", Min=50,Max=500,Default=CurrentConfig.Silent_FOVRadius, Rounding=0, Callback=function(v) CurrentConfig.Silent_FOVRadius=v end})

    local TriggerGroup = Tabs.Combat:AddLeftGroupbox("Triggerbot", "zap")
    TriggerGroup:AddToggle("TriggerEnabled", {Text="Enable Triggerbot", Default=CurrentConfig.Trigger_Enabled, Callback=function(v) CurrentConfig.Trigger_Enabled=v end})
    TriggerGroup:AddSlider("TriggerDelay", {Text="Delay (s)", Min=0,Max=1,Default=CurrentConfig.Trigger_Delay, Rounding=2, Callback=function(v) CurrentConfig.Trigger_Delay=v end})
    TriggerGroup:AddSlider("TriggerDistance", {Text="Max Distance", Min=100,Max=500,Default=CurrentConfig.Trigger_Distance, Rounding=0, Callback=function(v) CurrentConfig.Trigger_Distance=v end})
    TriggerGroup:AddKeybind("TriggerKey", {Text="Trigger Key", Default="RightMouse", Callback=function(v) CurrentConfig.Trigger_Key=v end})

    -- Visuals
    local ESPGroup = Tabs.Visuals:AddLeftGroupbox("ESP", "camera")
    ESPGroup:AddToggle("ESPEnabled", {Text="Enable ESP", Default=CurrentConfig.ESP_Enabled, Callback=function(v) CurrentConfig.ESP_Enabled=v end})
    ESPGroup:AddToggle("ESPBox", {Text="Box", Default=CurrentConfig.ESP_Box, Callback=function(v) CurrentConfig.ESP_Box=v end})
    ESPGroup:AddToggle("ESPHealthBar", {Text="Health Bar", Default=CurrentConfig.ESP_HealthBar, Callback=function(v) CurrentConfig.ESP_HealthBar=v end})
    ESPGroup:AddToggle("ESPSkeleton", {Text="Skeleton", Default=CurrentConfig.ESP_Skeleton, Callback=function(v) CurrentConfig.ESP_Skeleton=v end})
    ESPGroup:AddColorPicker("ESPColor", {Default=CurrentConfig.ESP_Color, Title="ESP Color", Callback=function(v) CurrentConfig.ESP_Color=v end})

    local ChamsGroup = Tabs.Visuals:AddRightGroupbox("Chams", "eye")
    ChamsGroup:AddToggle("ChamsEnabled", {Text="Enable Chams", Default=CurrentConfig.Chams_Enabled, Callback=function(v) CurrentConfig.Chams_Enabled=v end})
    ChamsGroup:AddDropdown("ChamsMaterial", {Text="Material", Values={"ForceField","Neon","Glass","Plastic"}, Default=CurrentConfig.Chams_Material, Callback=function(v) CurrentConfig.Chams_Material=v end})
    ChamsGroup:AddColorPicker("ChamsColor", {Default=CurrentConfig.Chams_Color, Title="Chams Color", Callback=function(v) CurrentConfig.Chams_Color=v end})

    local CrossGroup = Tabs.Visuals:AddLeftGroupbox("Crosshair", "plus")
    CrossGroup:AddToggle("CrossEnabled", {Text="Enable Crosshair", Default=CurrentConfig.Crosshair_Enabled, Callback=function(v) CurrentConfig.Crosshair_Enabled=v end})
    CrossGroup:AddSlider("CrossSize", {Text="Size", Min=5,Max=30,Default=CurrentConfig.Crosshair_Size, Rounding=0, Callback=function(v) CurrentConfig.Crosshair_Size=v end})
    CrossGroup:AddSlider("CrossThickness", {Text="Thickness", Min=1,Max=10,Default=CurrentConfig.Crosshair_Thickness, Rounding=0, Callback=function(v) CurrentConfig.Crosshair_Thickness=v end})
    CrossGroup:AddColorPicker("CrossColor", {Default=CurrentConfig.Crosshair_Color, Title="Color", Callback=function(v) CurrentConfig.Crosshair_Color=v end})
    CrossGroup:AddToggle("CrossDisableGame", {Text="Disable Game Crosshair", Default=CurrentConfig.Crosshair_DisableGame, Callback=function(v) CurrentConfig.Crosshair_DisableGame=v end})

    local TPGroup = Tabs.Visuals:AddRightGroupbox("Third Person", "user")
    TPGroup:AddKeybind("TPKey", {Text="Toggle Key", Default=CurrentConfig.ThirdPerson_Key, Callback=function(v) CurrentConfig.ThirdPerson_Key=v; tpKey=Enum.KeyCode[v] or Enum.KeyCode.V end})
    TPGroup:AddSlider("TPDistance", {Text="Distance", Min=5,Max=30,Default=CurrentConfig.ThirdPerson_Distance, Rounding=0, Callback=function(v) CurrentConfig.ThirdPerson_Distance=v end})

    -- Ragebot
    local RageGroup = Tabs.Ragebot:AddLeftGroupbox("Rage Options", "zap")
    RageGroup:AddToggle("RageEnabled", {Text="Enable Ragebot", Default=CurrentConfig.Rage_Enabled, Callback=function(v) CurrentConfig.Rage_Enabled=v end})
    RageGroup:AddToggle("RageAutoShoot", {Text="Auto Shoot", Default=CurrentConfig.Rage_AutoShoot, Callback=function(v) CurrentConfig.Rage_AutoShoot=v end})
    RageGroup:AddToggle("RageThroughWalls", {Text="Through Walls", Default=CurrentConfig.Rage_ThroughWalls, Callback=function(v) CurrentConfig.Rage_ThroughWalls=v end})
    RageGroup:AddSlider("RagePrediction", {Text="Prediction", Min=0,Max=0.5,Default=CurrentConfig.Rage_Prediction, Rounding=3, Callback=function(v) CurrentConfig.Rage_Prediction=v end})
    RageGroup:AddSlider("RageMaxShots", {Text="Max Shots/s", Min=1,Max=20,Default=CurrentConfig.Rage_MaxShotsPerSec, Rounding=0, Callback=function(v) CurrentConfig.Rage_MaxShotsPerSec=v end})
    RageGroup:AddToggle("RageVoidSpam", {Text="Void Spam", Default=CurrentConfig.Rage_VoidSpam, Callback=function(v) CurrentConfig.Rage_VoidSpam=v end})
    RageGroup:AddSlider("RageVoidHide", {Text="Hide Time", Min=0.1,Max=2,Default=CurrentConfig.Rage_VoidHide, Rounding=2, Callback=function(v) CurrentConfig.Rage_VoidHide=v end})
    RageGroup:AddSlider("RageVoidAttack", {Text="Attack Time", Min=0.05,Max=1,Default=CurrentConfig.Rage_VoidAttack, Rounding=2, Callback=function(v) CurrentConfig.Rage_VoidAttack=v end})
    RageGroup:AddToggle("RageFly", {Text="Fly", Default=CurrentConfig.Rage_Fly, Callback=function(v) CurrentConfig.Rage_Fly=v end})
    RageGroup:AddSlider("RageFlySpeed", {Text="Fly Speed", Min=10,Max=100,Default=CurrentConfig.Rage_FlySpeed, Rounding=0, Callback=function(v) CurrentConfig.Rage_FlySpeed=v end})
    RageGroup:AddToggle("RageNoClip", {Text="NoClip", Default=CurrentConfig.Rage_NoClip, Callback=function(v) CurrentConfig.Rage_NoClip=v end})

    -- Desync
    local DesyncGroup = Tabs.Desync:AddLeftGroupbox("Desync", "radio")
    DesyncGroup:AddToggle("DesyncEnabled", {Text="Enable Desync", Default=CurrentConfig.Desync_Enabled, Callback=function(v) CurrentConfig.Desync_Enabled=v end})
    DesyncGroup:AddSlider("DesyncDelay", {Text="Delay (s)", Min=0.1,Max=2,Default=CurrentConfig.Desync_Delay, Rounding=2, Callback=function(v) CurrentConfig.Desync_Delay=v end})
    -- Offset X,Y,Z
    DesyncGroup:AddSlider("DesyncOffsetX", {Text="Offset X", Min=-10,Max=10,Default=CurrentConfig.Desync_Offset.X, Rounding=1, Callback=function(v) CurrentConfig.Desync_Offset = Vector3.new(v, CurrentConfig.Desync_Offset.Y, CurrentConfig.Desync_Offset.Z) end})
    DesyncGroup:AddSlider("DesyncOffsetY", {Text="Offset Y", Min=-10,Max=10,Default=CurrentConfig.Desync_Offset.Y, Rounding=1, Callback=function(v) CurrentConfig.Desync_Offset = Vector3.new(CurrentConfig.Desync_Offset.X, v, CurrentConfig.Desync_Offset.Z) end})
    DesyncGroup:AddSlider("DesyncOffsetZ", {Text="Offset Z", Min=-10,Max=10,Default=CurrentConfig.Desync_Offset.Z, Rounding=1, Callback=function(v) CurrentConfig.Desync_Offset = Vector3.new(CurrentConfig.Desync_Offset.X, CurrentConfig.Desync_Offset.Y, v) end})

    -- Skin Changer
    local SkinEnableGroup = Tabs.Skin:AddLeftGroupbox("Enable", "shirt")
    SkinEnableGroup:AddToggle("SkinEnabled", {Text="Enable Skin Changer", Default=CurrentConfig.Skin_Enabled, Callback=function(v) CurrentConfig.Skin_Enabled=v end})

    local SkinGlobalGroup = Tabs.Skin:AddRightGroupbox("Global", "globe")
    SkinGlobalGroup:AddInput("GlobalSkinID", {Text="Skin ID", Default=CurrentConfig.Global_SkinID, Callback=function(v) CurrentConfig.Global_SkinID=v end})
    SkinGlobalGroup:AddInput("GlobalWrapID", {Text="Wrap ID", Default=CurrentConfig.Global_WrapID, Callback=function(v) CurrentConfig.Global_WrapID=v end})
    SkinGlobalGroup:AddInput("GlobalFinisherID", {Text="Finisher ID", Default=CurrentConfig.Global_FinisherID, Callback=function(v) CurrentConfig.Global_FinisherID=v end})
    SkinGlobalGroup:AddButton("ApplyGlobal", {Text="Apply Globally", Callback=refreshSkins})

    local SkinWeaponGroup = Tabs.Skin:AddLeftGroupbox("Per Weapon", "crosshair")
    local weaponDropdown
    local function updateWeaponDropdown()
        local weaps = getWeapons()
        local names = {}
        for _,w in ipairs(weaps) do table.insert(names, w.Name) end
        if weaponDropdown then
            weaponDropdown:Refresh(names, names[1] or "")
        else
            weaponDropdown = SkinWeaponGroup:AddDropdown("WeaponSelect", {Text="Select Weapon", Values=names, Default=names[1] or "", Callback=function() end})
        end
    end
    updateWeaponDropdown()
    SkinWeaponGroup:AddButton("RefreshWeapons", {Text="Refresh Weapons", Callback=updateWeaponDropdown})
    local weapSkinInput = SkinWeaponGroup:AddInput("WeapSkinID", {Text="Skin ID", Default="", Callback=function(v) end})
    local weapWrapInput = SkinWeaponGroup:AddInput("WeapWrapID", {Text="Wrap ID", Default="", Callback=function(v) end})
    SkinWeaponGroup:AddButton("ApplyWeapon", {Text="Apply to Selected", Callback=function()
        local n = weaponDropdown and weaponDropdown.Value
        if not n or n=="" then return end
        if not CurrentConfig.WeaponSkins[n] then CurrentConfig.WeaponSkins[n]={} end
        CurrentConfig.WeaponSkins[n].SkinID = weapSkinInput.Value
        CurrentConfig.WeaponSkins[n].WrapID = weapWrapInput.Value
        refreshSkins()
    end})
    SkinWeaponGroup:AddButton("ResetWeapon", {Text="Reset Selected", Callback=function()
        local n = weaponDropdown and weaponDropdown.Value
        if n and CurrentConfig.WeaponSkins[n] then CurrentConfig.WeaponSkins[n]=nil; refreshSkins() end
    end})

    -- Movement
    local MoveGroup = Tabs.Movement:AddLeftGroupbox("General", "footprints")
    MoveGroup:AddToggle("InfJump", {Text="Infinite Jump", Default=CurrentConfig.Move_InfiniteJump, Callback=function(v) CurrentConfig.Move_InfiniteJump=v end})
    MoveGroup:AddToggle("Fly", {Text="Fly", Default=CurrentConfig.Move_Fly, Callback=function(v) CurrentConfig.Move_Fly=v end})
    MoveGroup:AddSlider("FlySpeed", {Text="Fly Speed", Min=10,Max=100,Default=CurrentConfig.Move_FlySpeed, Rounding=0, Callback=function(v) CurrentConfig.Move_FlySpeed=v end})
    MoveGroup:AddToggle("SlideBoost", {Text="Slide Boost", Default=CurrentConfig.Move_SlideBoost, Callback=function(v) CurrentConfig.Move_SlideBoost=v end})
    MoveGroup:AddSlider("SlideBoostMult", {Text="Boost Multiplier", Min=1,Max=5,Default=CurrentConfig.Move_SlideBoostMult, Rounding=1, Callback=function(v) CurrentConfig.Move_SlideBoostMult=v end})
    MoveGroup:AddToggle("Velocity", {Text="Velocity", Default=CurrentConfig.Move_Velocity, Callback=function(v) CurrentConfig.Move_Velocity=v end})
    MoveGroup:AddSlider("VelocitySpeed", {Text="Velocity Speed", Min=1,Max=100,Default=CurrentConfig.Move_VelocitySpeed, Rounding=0, Callback=function(v) CurrentConfig.Move_VelocitySpeed=v end})

    -- Animations
    local AnimGroup = Tabs.Anims:AddLeftGroupbox("Custom Animation", "play")
    AnimGroup:AddToggle("AnimEnabled", {Text="Enable", Default=CurrentConfig.Anim_Enabled, Callback=function(v) CurrentConfig.Anim_Enabled=v end})
    AnimGroup:AddInput("AnimID", {Text="Animation ID", Default=CurrentConfig.Anim_ID, Callback=function(v) CurrentConfig.Anim_ID=v end})
    AnimGroup:AddSlider("AnimSpeed", {Text="Speed", Min=0.1,Max=5,Default=CurrentConfig.Anim_Speed, Rounding=1, Callback=function(v) CurrentConfig.Anim_Speed=v end})

    -- Hit Sounds
    local HitGroup = Tabs.HitSound:AddLeftGroupbox("Hit Sound Options", "music")
    HitGroup:AddToggle("HitEnabled", {Text="Enable", Default=CurrentConfig.HitSound_Enabled, Callback=function(v) CurrentConfig.HitSound_Enabled=v end})
    HitGroup:AddDropdown("HitSound", {Text="Sound", Values={"Bameware","Custom"}, Default=CurrentConfig.HitSound_Sound, Callback=function(v) CurrentConfig.HitSound_Sound=v end})
    HitGroup:AddDropdown("HitApply", {Text="Apply To", Values={"All","Enemies","Local"}, Default=CurrentConfig.HitSound_ApplyTo, Callback=function(v) CurrentConfig.HitSound_ApplyTo=v end})

    -- Spoofer
    local SpoofGroup = Tabs.Spoofer:AddLeftGroupbox("Stats Spoofer", "shield")
    SpoofGroup:AddInput("SpoofLevel", {Text="Level", Default=CurrentConfig.Spoof_Level, Callback=function(v) CurrentConfig.Spoof_Level=v end})
    SpoofGroup:AddInput("SpoofRank", {Text="Rank", Default=CurrentConfig.Spoof_Rank, Callback=function(v) CurrentConfig.Spoof_Rank=v end})
    SpoofGroup:AddInput("SpoofWinstreak", {Text="Winstreak", Default=CurrentConfig.Spoof_Winstreak, Callback=function(v) CurrentConfig.Spoof_Winstreak=v end})
    SpoofGroup:AddInput("SpoofWinrate", {Text="Winrate", Default=CurrentConfig.Spoof_Winrate, Callback=function(v) CurrentConfig.Spoof_Winrate=v end})
    SpoofGroup:AddInput("SpoofRankedStreak", {Text="Ranked Streak", Default=CurrentConfig.Spoof_RankedStreak, Callback=function(v) CurrentConfig.Spoof_RankedStreak=v end})
    SpoofGroup:AddInput("SpoofRankedWinrate", {Text="Ranked Winrate", Default=CurrentConfig.Spoof_RankedWinrate, Callback=function(v) CurrentConfig.Spoof_RankedWinrate=v end})

    local NameSpoofGroup = Tabs.Spoofer:AddRightGroupbox("Name Spoof", "user")
    NameSpoofGroup:AddToggle("NameSpoofEnabled", {Text="Enable Name Spoof", Default=CurrentConfig.NameSpoof_Enabled, Callback=function(v) CurrentConfig.NameSpoof_Enabled=v end})
    NameSpoofGroup:AddInput("NameSpoofText", {Text="Display Name", Default=CurrentConfig.NameSpoof_Text, Callback=function(v) CurrentConfig.NameSpoof_Text=v end})

    local LBGroup = Tabs.Spoofer:AddLeftGroupbox("Leaderboard Spoofer (client)", "trophy")
    LBGroup:AddToggle("LBEnabled", {Text="Enable", Default=CurrentConfig.LBS_Enabled, Callback=function(v) CurrentConfig.LBS_Enabled=v end})
    LBGroup:AddInput("LBWins", {Text="Wins", Default=CurrentConfig.LBS_Wins, Callback=function(v) CurrentConfig.LBS_Wins=v end})
    LBGroup:AddInput("LBWinstreak", {Text="Winstreak", Default=CurrentConfig.LBS_Winstreak, Callback=function(v) CurrentConfig.LBS_Winstreak=v end})
    LBGroup:AddInput("LBLevel", {Text="Level", Default=CurrentConfig.LBS_Level, Callback=function(v) CurrentConfig.LBS_Level=v end})
    LBGroup:AddInput("LBRank", {Text="Rank", Default=CurrentConfig.LBS_Rank, Callback=function(v) CurrentConfig.LBS_Rank=v end})
    LBGroup:AddInput("LBKD", {Text="K/D", Default=CurrentConfig.LBS_KD, Callback=function(v) CurrentConfig.LBS_KD=v end})
    LBGroup:AddInput("LBELO", {Text="Elo", Default=CurrentConfig.LBS_ELO, Callback=function(v) CurrentConfig.LBS_ELO=v end})
    LBGroup:AddButton("LBReset", {Text="Reset Leaderboard Spoofer", Callback=ResetLB})

    -- Settings
    local KeybindGroup = Tabs.Settings:AddLeftGroupbox("Keybinds", "settings")
    KeybindGroup:AddKeybind("ToggleUI", {Text="Toggle UI", Default="RightShift", Callback=function(v) Window:SetToggleKey(Enum.KeyCode[v]) end})

    local ConfigGroup = Tabs.Settings:AddRightGroupbox("Configurations", "folder")
    local cfgInput = ConfigGroup:AddInput("ConfigName", {Text="Config Name", Default=""})
    ConfigGroup:AddButton("SaveConfig", {Text="Save Config", Callback=function() saveCfg(cfgInput.Value) end})
    ConfigGroup:AddButton("LoadConfig", {Text="Load Config", Callback=function() loadCfg(cfgInput.Value) end})
    ConfigGroup:AddButton("DeleteConfig", {Text="Delete Config", Callback=function() delCfg(cfgInput.Value) end})
    local cfgList = listCfgs()
    local cfgDropdown = ConfigGroup:AddDropdown("ExistingConfigs", {Text="Existing", Values=cfgList, Default=cfgList[1] or "", Callback=function(v) cfgInput:SetValue(v) end})
    ConfigGroup:AddButton("RefreshConfigs", {Text="Refresh List", Callback=function() cfgDropdown:Refresh(listCfgs()) end})

    local ThemeGroup = Tabs.Settings:AddLeftGroupbox("Theme", "palette")
    ThemeGroup:AddDropdown("ThemeSelect", {Text="Select Theme", Values={"Sysnax","Dark","Light"}, Default="Sysnax", Callback=function(v)
        if v == "Sysnax" then
            Window:SetTheme({
                Background = Color3.fromRGB(25,25,30),
                Tab = Color3.fromRGB(35,35,40),
                Element = Color3.fromRGB(45,45,50),
                Accent = Color3.fromRGB(160,160,160),
                Text = Color3.fromRGB(230,230,230),
                TitleBar = Color3.fromRGB(30,30,35),
                Footer = Color3.fromRGB(60,60,65),
            })
        elseif v == "Dark" then
            Window:SetTheme("Dark")
        elseif v == "Light" then
            Window:SetTheme("Light")
        end
    end})

    -- Finalize
    Window:Toggle()  -- autoload (hidden)
    Window:Notify("🥳 Official Release  |  AC Bypassed  |  Desync Ready", 6)
end

pcall(main)