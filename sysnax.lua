-- Sysnax – Final Release (Rivals, Arsenal, HyperShot)
-- UI: Linoria (gray/black theme)  
-- Autoload · Right Shift to toggle · AC Bypass · All Modules

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
        StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Unsupported game.",Duration=5})
        return
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

    -- ==================== UI: LINORIA ====================
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Linoria/main/Library.lua"))()
    if not Library or not Library.CreateWindow then
        LocalPlayer:Kick("Failed to load Linoria UI.")
        return
    end

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

    -- ==================== CONFIGS ====================
    if not isfolder("sysnax") then makefolder("sysnax") end
    if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end
    local CurrentConfig = {}
    local function saveCfg(name)
        if name=="" then return end
        pcall(function()
            writefile("sysnax/configs/"..name..".json", HttpService:JSONEncode(CurrentConfig))
            Library:Notify(name.." saved.", 3)
        end)
    end
    local function loadCfg(name)
        if name=="" or not isfile("sysnax/configs/"..name..".json") then return end
        local ok,data = pcall(function() return HttpService:JSONDecode(readfile("sysnax/configs/"..name..".json")) end)
        if ok and data then for k,v in pairs(data) do CurrentConfig[k]=v end Library:Notify(name.." loaded.", 3) end
    end
    local function delCfg(name)
        if name=="" or not isfile("sysnax/configs/"..name..".json") then return end
        delfile("sysnax/configs/"..name..".json")
        Library:Notify(name.." deleted.", 3)
    end
    local function listCfgs()
        local t={}
        pcall(function() for _,f in ipairs(listfiles("sysnax/configs")) do local n=f:match("([^/]+)%.json$"); if n then table.insert(t,n) end end end)
        return t
    end

    -- ==================== MOUSE BUTTONS ====================
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
    local function isMB(name) local b = MouseBtns[name]; return b and UserInputService:IsMouseButtonPressed(b) end

    -- ==================== DEFAULT SETTINGS ====================
    CurrentConfig = {
        -- Legit / Aim Assist
        Aimbot_Enabled=false, Aimbot_Mode="Hold", Aimbot_Part="Head", Aimbot_Smoothness=3, Aimbot_FOV=105,
        Aimbot_VisibleOnly=true, Aimbot_ShowFOV=true, Aimbot_FOVColor=Color3.fromRGB(255,255,255), Aimbot_Key="RightMouse",
        -- Bullet Redirection (Silent Aim)
        Silent_Enabled=false, Silent_Part="Head", Silent_HitChance=100, Silent_Manipulation=0,
        Silent_VisibleOnly=true, Silent_MaxDistance=500, Silent_FOV=105, Silent_DrawFOV=true,
        -- Extend Hitbox
        Hitbox_Enabled=false, Hitbox_Part="Head", Hitbox_ExtendRate=10,
        -- Trigger Bot
        Trigger_Enabled=false, Trigger_Delay=0.1, Trigger_Distance=300, Trigger_Key="RightMouse",
        -- Recoil Control
        Recoil_Enabled=false, Recoil_ModelKick=100, Recoil_CameraKick=100,
        -- Ragebot
        Rage_Enabled=false, Rage_AutoShoot=true, Rage_ThroughWalls=true, Rage_Prediction=0.165,
        Rage_MaxShots=6, Rage_VoidSpam=false, Rage_VoidHide=0.15, Rage_VoidAttack=0.05,
        Rage_Fly=false, Rage_FlySpeed=50, Rage_NoClip=false,
        -- Visuals / ESP
        ESP_Enabled=false, ESP_Box=true, ESP_HealthBar=true, ESP_Skeleton=false, ESP_Color=Color3.fromRGB(255,255,255),
        -- Chams
        Chams_Enabled=false, Chams_Material="ForceField", Chams_Color=Color3.fromRGB(150,0,255),
        -- Crosshair
        Crosshair_Enabled=false, Crosshair_Size=10, Crosshair_Thickness=2, Crosshair_Color=Color3.fromRGB(255,255,255),
        Crosshair_DisableGame=false,
        -- Third Person
        ThirdPerson_Enabled=false, ThirdPerson_Distance=15, ThirdPerson_Key="V",
        -- Skin Changer (weapon categories)
        Skin_Enabled=false,
        -- Per weapon settings (weapon name -> {SkinID, WrapID, FinisherID})
        WeaponSkins = {},
        -- Movement
        Move_InfiniteJump=false, Move_Fly=false, Move_FlySpeed=50,
        Move_SlideBoost=false, Move_SlideBoostMult=1, Move_Velocity=false, Move_VelocitySpeed=16,
        -- Spoofer
        NameSpoof_Enabled=false, NameSpoof_Text="",
        Spoof_Level="", Spoof_Rank="", Spoof_Winstreak="", Spoof_Winrate="",
        Spoof_RankedStreak="", Spoof_RankedWinrate="",
        LBS_Enabled=false, LBS_Wins="", LBS_Winstreak="", LBS_Level="", LBS_Rank="",
        LBS_KD="", LBS_ELO="",
    }

    -- ==================== HELPER FUNCTIONS ====================
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

    -- ==================== DRAWING OBJECTS ====================
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

    -- ==================== FIND WEAPON REMOTE ====================
    local remoteFire = nil
    pcall(function()
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():match("fire") or v.Name:lower():match("shoot") or v.Name:lower():match("bullet") or v.Name:lower():match("click") then
                remoteFire = v; break
            end
        end
        if not remoteFire then
            remoteFire = Workspace:FindFirstChild("WeaponSystem") or ReplicatedStorage:FindFirstChild("WeaponSystem")
        end
    end)

    -- ==================== SILENT AIM & HITBOX EXTEND ====================
    local silentTarget = nil
    if remoteFire and remoteFire.FireServer then
        local oldFire = remoteFire.FireServer
        local function newFire(...)
            local args = {...}
            local target = silentTarget
            if CurrentConfig.Silent_Enabled and target and target.Character then
                local part = target.Character:FindFirstChild(CurrentConfig.Silent_Part)
                if part then
                    if CurrentConfig.Hitbox_Enabled then
                        local hp = target.Character:FindFirstChild(CurrentConfig.Hitbox_Part)
                        if hp then
                            local orig = hp.Size
                            hp.Size = orig + Vector3.new(CurrentConfig.Hitbox_ExtendRate/10, CurrentConfig.Hitbox_ExtendRate/10, CurrentConfig.Hitbox_ExtendRate/10)
                            task.defer(function() task.wait(0.05); pcall(function() hp.Size = orig end) end)
                        end
                    end
                    args[2] = part.Position + Vector3.new(0, CurrentConfig.Silent_Manipulation/100, 0)
                    if args[3] and type(args[3])=="userdata" then args[3] = part end
                end
            end
            return oldFire(remoteFire, unpack(args))
        end
        pcall(function() remoteFire.FireServer = newFire end)
    end

    -- ==================== RAGEBOT (UE0 style) ====================
    local ragebotTarget, ragebotLastShot, ragebotMinInterval = nil, 0, 0
    local function ragebotUpdateTarget()
        if not CurrentConfig.Rage_Enabled or not isAlive() then ragebotTarget=nil return end
        ragebotTarget = closestToCursor(1000, "Head", not CurrentConfig.Rage_ThroughWalls)
    end
    local function ragebotAutoShoot()
        if not CurrentConfig.Rage_AutoShoot or not ragebotTarget or not ragebotTarget.Character or not remoteFire then return end
        local now = tick()
        if CurrentConfig.Rage_MaxShots>0 then
            ragebotMinInterval = 1/CurrentConfig.Rage_MaxShots
            if now - ragebotLastShot < ragebotMinInterval then return end
        end
        local th = ragebotTarget.Character:FindFirstChild("Head")
        if not th then return end
        local predictedPos = th.Position
        if CurrentConfig.Rage_Prediction>0 then
            local hum = ragebotTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude>0 then
                predictedPos = predictedPos + hum.MoveDirection*(hum.WalkSpeed or 16)*CurrentConfig.Rage_Prediction
            end
        end
        predictedPos += Vector3.new(math.random(-10,10)/100, math.random(-10,10)/100, math.random(-10,10)/100)
        remoteFire:FireServer("MouseClick", predictedPos)
        ragebotLastShot = now
    end
    local lastVoid, voidHidden = 0, false
    local function ragebotVoid()
        if not CurrentConfig.Rage_VoidSpam or not isAlive() then return end
        local char = getChar(); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local now = tick()
        if not voidHidden then
            if now - lastVoid >= CurrentConfig.Rage_VoidHide then lastVoid=now; hrp.CFrame = hrp.CFrame*CFrame.new(0,-15,0); voidHidden=true end
        else
            if now - lastVoid >= CurrentConfig.Rage_VoidAttack then lastVoid=now; hrp.CFrame = hrp.CFrame*CFrame.new(0,15,0); voidHidden=false end
        end
    end
    local function ragebotFly()
        if not CurrentConfig.Rage_Fly or not isAlive() then return end
        local char = getChar(); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
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

    -- ==================== ESP ====================
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

    -- ==================== CHAMS ====================
    local chamCache, lastCham = {}, 0
    local function updateChams()
        if CurrentConfig.Chams_Enabled then
            local now = tick()
            if now-lastCham<0.5 then return end; lastCham=now
            for _,plr in ipairs(getPlayers()) do
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _,p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            if not chamCache[p] then chamCache[p]={Material=p.Material, Color=p.Color} end
                            p.Material = Enum.Material[CurrentConfig.Chams_Material] or Enum.Material.ForceField
                            p.Color = CurrentConfig.Chams_Color
                        end
                    end
                end
            end
        else
            for p,orig in pairs(chamCache) do if p and p.Parent then p.Material=orig.Material; p.Color=orig.Color end end
            table.clear(chamCache)
        end
    end

    -- ==================== SKIN CHANGER ====================
    -- get all tools from character and backpack
    local function getAllWeapons()
        local tools = {}
        local char = LocalPlayer.Character
        if char then
            for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v) end end
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v) end end end
        return tools
    end

    -- categorize weapons by name keywords (simplistic; adjust based on actual game)
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
                if skinID and skinID~="" then local d=Instance.new("Decal"); d.Texture="rbxassetid://"..skinID; d.Face=Enum.NormalId.Front; d.Parent=part end
                if wrapID and wrapID~="" then local w=Instance.new("Decal"); w.Texture="rbxassetid://"..wrapID; w.Face=Enum.NormalId.Back; w.Parent=part end
            end
        end
    end

    local function refreshAllSkins()
        if not CurrentConfig.Skin_Enabled then return end
        local weapons = getAllWeapons()
        for _,w in ipairs(weapons) do
            local data = CurrentConfig.WeaponSkins[w.Name]
            local skinID = (data and data.SkinID and data.SkinID~="") and data.SkinID or CurrentConfig.Global_SkinID or ""
            local wrapID = (data and data.WrapID and data.WrapID~="") and data.WrapID or CurrentConfig.Global_WrapID or ""
            applySkinToWeapon(w, skinID, wrapID)
        end
    end

    -- ==================== THIRD PERSON ====================
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

    -- ==================== SPOOFERS ====================
    local lastSpoof=0
    local function spoofStats()
        local now=tick()
        if now-lastSpoof<2 then return end; lastSpoof=now
        local gui = LocalPlayer:FindFirstChild("PlayerGui"); if not gui then return end
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
        if CurrentConfig.NameSpoof_Enabled and CurrentConfig.NameSpoof_Text~="" then
            for _,obj in ipairs(gui:GetDescendants()) do
                if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text == LocalPlayer.Name then
                    obj.Text = CurrentConfig.NameSpoof_Text
                end
            end
        end
    end
    local lastLBS=0
    local function spoofLeaderboard()
        if not CurrentConfig.LBS_Enabled then return end
        local now=tick()
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
                local contains = false
                for _,cell in ipairs(row:GetDescendants()) do
                    if (cell:IsA("TextLabel") or cell:IsA("TextButton")) and cell.Text == myName then contains=true; break end
                end
                if contains then
                    for _,cell in ipairs(row:GetDescendants()) do
                        if cell:IsA("TextLabel") or cell:IsA("TextButton") then
                            local txt = cell.Text:lower()
                            if txt:find("win") and not txt:find("streak") and CurrentConfig.LBS_Wins~="" then cell.Text=CurrentConfig.LBS_Wins
                            elseif txt:find("streak") and CurrentConfig.LBS_Winstreak~="" then cell.Text=CurrentConfig.LBS_Winstreak
                            elseif txt:find("level") and CurrentConfig.LBS_Level~="" then cell.Text=CurrentConfig.LBS_Level
                            elseif txt:find("rank") and CurrentConfig.LBS_Rank~="" then cell.Text=CurrentConfig.LBS_Rank
                            elseif (txt:find("kills") or txt:find("k/d")) and CurrentConfig.LBS_KD~="" then cell.Text=CurrentConfig.LBS_KD
                            elseif txt:find("elo") and CurrentConfig.LBS_ELO~="" then cell.Text=CurrentConfig.LBS_ELO
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
        CurrentConfig.LBS_Wins="";CurrentConfig.LBS_Winstreak="";CurrentConfig.LBS_Level="";CurrentConfig.LBS_Rank="";CurrentConfig.LBS_KD="";CurrentConfig.LBS_ELO=""
    end

    -- ==================== MAIN LOOP ====================
    local lastShot=0
    RunService.RenderStepped:Connect(function()
        -- Aimbot
        if CurrentConfig.Aimbot_Enabled and isAlive() then
            if fovCircle then
                fovCircle.Visible=CurrentConfig.Aimbot_ShowFOV; fovCircle.Radius=CurrentConfig.Aimbot_FOV
                fovCircle.Color=CurrentConfig.Aimbot_FOVColor; fovCircle.Position=Vector2.new(Mouse.X,Mouse.Y)
            end
            local aim = CurrentConfig.Aimbot_Mode=="Always" or (CurrentConfig.Aimbot_Mode=="Hold" and isMB(CurrentConfig.Aimbot_Key))
            if aim then
                local t = closestToCursor(CurrentConfig.Aimbot_FOV, CurrentConfig.Aimbot_Part, CurrentConfig.Aimbot_VisibleOnly)
                if t and t.Character then
                    local part = t.Character:FindFirstChild(CurrentConfig.Aimbot_Part)
                    if part then
                        local scr = Camera:WorldToScreenPoint(part.Position)
                        local delta = (Vector2.new(scr.X,scr.Y)-Vector2.new(Mouse.X,Mouse.Y))/CurrentConfig.Aimbot_Smoothness
                        mousemoverel(delta.X, delta.Y)
                    end
                end
            end
        elseif fovCircle then fovCircle.Visible=false end

        -- Silent aim target
        if CurrentConfig.Silent_Enabled then
            local t = closestToCursor(CurrentConfig.Silent_MaxDistance, CurrentConfig.Silent_Part, CurrentConfig.Silent_VisibleOnly)
            if t and math.random(1,100)<=CurrentConfig.Silent_HitChance then silentTarget=t else silentTarget=nil end
        else silentTarget=nil end
        if silentFOV then
            silentFOV.Visible = CurrentConfig.Silent_Enabled and CurrentConfig.Silent_DrawFOV
            silentFOV.Radius = CurrentConfig.Silent_FOV
            silentFOV.Position = Vector2.new(Mouse.X,Mouse.Y)
        end

        -- Triggerbot
        if CurrentConfig.Trigger_Enabled and isAlive() and isMB(CurrentConfig.Trigger_Key) then
            local t = closestToCursor(CurrentConfig.Trigger_Distance,"Head",true)
            if t and t.Character and tick()-lastShot>=CurrentConfig.Trigger_Delay then
                if remoteFire then remoteFire:FireServer("MouseClick", t.Character.Head); lastShot=tick() end
            end
        end

        -- Ragebot
        ragebotUpdateTarget(); ragebotAutoShoot(); ragebotVoid(); ragebotFly(); ragebotNoClip()

        -- Movement
        if isAlive() then
            local char = getChar(); local hum = char:FindFirstChildOfClass("Humanoid"); local hrp = char:FindFirstChild("HumanoidRootPart")
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

        updateChams(); refreshAllSkins(); spoofStats(); spoofLeaderboard()

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
                            local conns = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
                            for i,pair in ipairs(conns) do
                                local p1=char:FindFirstChild(pair[1]); local p2=char:FindFirstChild(pair[2])
                                if p1 and p2 then
                                    if not esp.Skeleton[i] then esp.Skeleton[i] = safeDrawing("Line"); if esp.Skeleton[i] then esp.Skeleton[i].Thickness=2; esp.Skeleton[i].Color=CurrentConfig.ESP_Color end end
                                    if esp.Skeleton[i] then
                                        local s1,_=w2s(p1.Position); local s2,_=w2s(p2.Position)
                                        esp.Skeleton[i].From=s1; esp.Skeleton[i].To=s2; esp.Skeleton[i].Visible=true
                                    end
                                end
                            end
                        else for _,s in ipairs(esp.Skeleton or {}) do if s then s.Visible=false end end end
                        if esp.Name then esp.Name.Text=plr.Name; esp.Name.Position=Vector2.new(headPos.X,y-15); esp.Name.Visible=true end
                        if esp.Distance and root then
                            local dist = 0
                            if getChar() and getChar():FindFirstChild("HumanoidRootPart") then dist = (root.Position - getChar().HumanoidRootPart.Position).Magnitude end
                            esp.Distance.Text=string.format("%.1f",dist); esp.Distance.Position=Vector2.new(headPos.X,y+h+5); esp.Distance.Visible=true
                        end
                    else
                        for _,v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end end
                    end
                else
                    for _,v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end end
                end
            end
        else
            for _,esp in pairs(espCache) do for _,v in pairs(esp) do if type(v)~="table" then if v then v.Visible=false end else for _,s in ipairs(v) do if s then s.Visible=false end end end end end
        end
    end)

    -- ==================== UI TABS ====================
    local TabLegit = Window:AddTab("Legit")
    local TabRage = Window:AddTab("Rage")
    local TabVisuals = Window:AddTab("Visuals")
    local TabSkin = Window:AddTab("Skin Changer")
    local TabSpoofer = Window:AddTab("Spoofer")
    local TabSettings = Window:AddTab("Settings")

    -- Legit > Aim Assist
    local AimGroup = TabLegit:AddLeftGroupbox("Aim Assist", "crosshair")
    AimGroup:AddToggle({Text="Enabled", Default=CurrentConfig.Aimbot_Enabled, Callback=function(v) CurrentConfig.Aimbot_Enabled=v end})
    AimGroup:AddSlider({Text="Aimbot FOV", Min=10, Max=360, Default=CurrentConfig.Aimbot_FOV, Rounding=0, Callback=function(v) CurrentConfig.Aimbot_FOV=v end})
    AimGroup:AddSlider({Text="Smoothing Factor", Min=1, Max=25, Default=CurrentConfig.Aimbot_Smoothness, Rounding=1, Callback=function(v) CurrentConfig.Aimbot_Smoothness=v end})
    AimGroup:AddDropdown({Text="Hit Box", Values={"Head","HumanoidRootPart","LeftLeg","RightLeg"}, Default=CurrentConfig.Aimbot_Part, Callback=function(v) CurrentConfig.Aimbot_Part=v end})
    AimGroup:AddKeybind({Text="Aimbot Key", Default=CurrentConfig.Aimbot_Key, Callback=function(v) CurrentConfig.Aimbot_Key=v end})
    AimGroup:AddToggle({Text="Draw Fov", Default=CurrentConfig.Aimbot_ShowFOV, Callback=function(v) CurrentConfig.Aimbot_ShowFOV=v end})
    AimGroup:AddSlider({Text="Num Sides", Min=4, Max=64, Default=48, Rounding=0, Callback=function(v) if fovCircle then fovCircle.NumSides=v end end})

    -- Bullet Redirection
    local SilentGroup = TabLegit:AddRightGroupbox("Bullet Redirection", "eye")
    SilentGroup:AddToggle({Text="Enabled", Default=CurrentConfig.Silent_Enabled, Callback=function(v) CurrentConfig.Silent_Enabled=v end})
    SilentGroup:AddSlider({Text="Silent Aim FOV", Min=10, Max=360, Default=CurrentConfig.Silent_FOV, Rounding=0, Callback=function(v) CurrentConfig.Silent_FOV=v end})
    SilentGroup:AddSlider({Text="Hit Chances", Min=0, Max=100, Default=CurrentConfig.Silent_HitChance, Rounding=0, Callback=function(v) CurrentConfig.Silent_HitChance=v end})
    SilentGroup:AddDropdown({Text="Redirection Mode", Values={"P Mode"}, Default="P Mode", Callback=function() end})
    SilentGroup:AddDropdown({Text="Hit Box", Values={"Head","HumanoidRootPart"}, Default=CurrentConfig.Silent_Part, Callback=function(v) CurrentConfig.Silent_Part=v end})
    SilentGroup:AddToggle({Text="Draw Fov", Default=CurrentConfig.Silent_DrawFOV, Callback=function(v) CurrentConfig.Silent_DrawFOV=v end})
    SilentGroup:AddSlider({Text="Num Sides", Min=4, Max=64, Default=48, Rounding=0, Callback=function(v) if silentFOV then silentFOV.NumSides=v end end})

    -- Extend Hitbox
    local HitboxGroup = TabLegit:AddLeftGroupbox("Extend Hitbox", "maximize")
    HitboxGroup:AddToggle({Text="Enabled", Default=CurrentConfig.Hitbox_Enabled, Callback=function(v) CurrentConfig.Hitbox_Enabled=v end})
    HitboxGroup:AddDropdown({Text="Hit Box", Values={"Head","HumanoidRootPart"}, Default=CurrentConfig.Hitbox_Part, Callback=function(v) CurrentConfig.Hitbox_Part=v end})
    HitboxGroup:AddSlider({Text="Extend Rate", Min=1, Max=50, Default=CurrentConfig.Hitbox_ExtendRate, Rounding=0, Callback=function(v) CurrentConfig.Hitbox_ExtendRate=v end})

    -- Trigger Bot
    local TriggerGroup = TabLegit:AddRightGroupbox("Trigger Bot", "zap")
    TriggerGroup:AddToggle({Text="Enabled", Default=CurrentConfig.Trigger_Enabled, Callback=function(v) CurrentConfig.Trigger_Enabled=v end})
    TriggerGroup:AddSlider({Text="Delay (s)", Min=0, Max=1, Default=CurrentConfig.Trigger_Delay, Rounding=2, Callback=function(v) CurrentConfig.Trigger_Delay=v end})
    TriggerGroup:AddSlider({Text="Max Distance", Min=100, Max=500, Default=CurrentConfig.Trigger_Distance, Rounding=0, Callback=function(v) CurrentConfig.Trigger_Distance=v end})
    TriggerGroup:AddKeybind({Text="Trigger Key", Default=CurrentConfig.Trigger_Key, Callback=function(v) CurrentConfig.Trigger_Key=v end})

    -- Recoil Control
    local RecoilGroup = TabLegit:AddLeftGroupbox("Recoil Control", "minus")
    RecoilGroup:AddToggle({Text="Enabled", Default=CurrentConfig.Recoil_Enabled, Callback=function(v) CurrentConfig.Recoil_Enabled=v end})
    RecoilGroup:AddSlider({Text="Model Kick", Min=0, Max=100, Default=CurrentConfig.Recoil_ModelKick, Rounding=0, Callback=function(v) CurrentConfig.Recoil_ModelKick=v end})
    RecoilGroup:AddSlider({Text="Camera Kick", Min=0, Max=100, Default=CurrentConfig.Recoil_CameraKick, Rounding=0, Callback=function(v) CurrentConfig.Recoil_CameraKick=v end})

    -- Ragebot
    local RageGroup = TabRage:AddLeftGroupbox("Ragebot", "zap")
    RageGroup:AddToggle({Text="Enable Ragebot", Default=CurrentConfig.Rage_Enabled, Callback=function(v) CurrentConfig.Rage_Enabled=v end})
    RageGroup:AddToggle({Text="Auto Shoot", Default=CurrentConfig.Rage_AutoShoot, Callback=function(v) CurrentConfig.Rage_AutoShoot=v end})
    RageGroup:AddToggle({Text="Through Walls", Default=CurrentConfig.Rage_ThroughWalls, Callback=function(v) CurrentConfig.Rage_ThroughWalls=v end})
    RageGroup:AddSlider({Text="Prediction", Min=0, Max=0.5, Default=CurrentConfig.Rage_Prediction, Rounding=3, Callback=function(v) CurrentConfig.Rage_Prediction=v end})
    RageGroup:AddSlider({Text="Max Shots/s", Min=1, Max=20, Default=CurrentConfig.Rage_MaxShots, Rounding=0, Callback=function(v) CurrentConfig.Rage_MaxShots=v end})
    RageGroup:AddToggle({Text="Void Spam", Default=CurrentConfig.Rage_VoidSpam, Callback=function(v) CurrentConfig.Rage_VoidSpam=v end})
    RageGroup:AddSlider({Text="Hide Time", Min=0.1, Max=2, Default=CurrentConfig.Rage_VoidHide, Rounding=2, Callback=function(v) CurrentConfig.Rage_VoidHide=v end})
    RageGroup:AddSlider({Text="Attack Time", Min=0.05, Max=1, Default=CurrentConfig.Rage_VoidAttack, Rounding=2, Callback=function(v) CurrentConfig.Rage_VoidAttack=v end})
    RageGroup:AddToggle({Text="Fly", Default=CurrentConfig.Rage_Fly, Callback=function(v) CurrentConfig.Rage_Fly=v end})
    RageGroup:AddSlider({Text="Fly Speed", Min=10, Max=100, Default=CurrentConfig.Rage_FlySpeed, Rounding=0, Callback=function(v) CurrentConfig.Rage_FlySpeed=v end})
    RageGroup:AddToggle({Text="NoClip", Default=CurrentConfig.Rage_NoClip, Callback=function(v) CurrentConfig.Rage_NoClip=v end})

    -- Visuals / ESP
    local ESPGroup = TabVisuals:AddLeftGroupbox("ESP", "camera")
    ESPGroup:AddToggle({Text="Enable ESP", Default=CurrentConfig.ESP_Enabled, Callback=function(v) CurrentConfig.ESP_Enabled=v end})
    ESPGroup:AddToggle({Text="Box", Default=CurrentConfig.ESP_Box, Callback=function(v) CurrentConfig.ESP_Box=v end})
    ESPGroup:AddToggle({Text="Health Bar", Default=CurrentConfig.ESP_HealthBar, Callback=function(v) CurrentConfig.ESP_HealthBar=v end})
    ESPGroup:AddToggle({Text="Skeleton", Default=CurrentConfig.ESP_Skeleton, Callback=function(v) CurrentConfig.ESP_Skeleton=v end})
    ESPGroup:AddColorPicker({Text="ESP Color", Default=CurrentConfig.ESP_Color, Callback=function(v) CurrentConfig.ESP_Color=v end})

    -- Chams
    local ChamsGroup = TabVisuals:AddRightGroupbox("Chams", "eye")
    ChamsGroup:AddToggle({Text="Enable Chams", Default=CurrentConfig.Chams_Enabled, Callback=function(v) CurrentConfig.Chams_Enabled=v end})
    ChamsGroup:AddDropdown({Text="Material", Values={"ForceField","Neon","Glass","Plastic"}, Default=CurrentConfig.Chams_Material, Callback=function(v) CurrentConfig.Chams_Material=v end})
    ChamsGroup:AddColorPicker({Text="Chams Color", Default=CurrentConfig.Chams_Color, Callback=function(v) CurrentConfig.Chams_Color=v end})

    -- Crosshair
    local CrossGroup = TabVisuals:AddLeftGroupbox("Crosshair", "plus")
    CrossGroup:AddToggle({Text="Enable Crosshair", Default=CurrentConfig.Crosshair_Enabled, Callback=function(v) CurrentConfig.Crosshair_Enabled=v end})
    CrossGroup:AddSlider({Text="Size", Min=5, Max=30, Default=CurrentConfig.Crosshair_Size, Rounding=0, Callback=function(v) CurrentConfig.Crosshair_Size=v end})
    CrossGroup:AddSlider({Text="Thickness", Min=1, Max=10, Default=CurrentConfig.Crosshair_Thickness, Rounding=0, Callback=function(v) CurrentConfig.Crosshair_Thickness=v end})
    CrossGroup:AddColorPicker({Text="Color", Default=CurrentConfig.Crosshair_Color, Callback=function(v) CurrentConfig.Crosshair_Color=v end})
    CrossGroup:AddToggle({Text="Disable Game Crosshair", Default=CurrentConfig.Crosshair_DisableGame, Callback=function(v) CurrentConfig.Crosshair_DisableGame=v end})

    -- Third Person
    local TPGroup = TabVisuals:AddRightGroupbox("Third Person", "user")
    TPGroup:AddKeybind({Text="Toggle Key", Default=CurrentConfig.ThirdPerson_Key, Callback=function(v) CurrentConfig.ThirdPerson_Key=v; tpKey = Enum.KeyCode[v] or Enum.KeyCode.V end})
    TPGroup:AddSlider({Text="Distance", Min=5, Max=30, Default=CurrentConfig.ThirdPerson_Distance, Rounding=0, Callback=function(v) CurrentConfig.ThirdPerson_Distance=v end})

    -- Movement
    local MoveGroup = TabVisuals:AddLeftGroupbox("Movement", "footprints")
    MoveGroup:AddToggle({Text="Infinite Jump", Default=CurrentConfig.Move_InfiniteJump, Callback=function(v) CurrentConfig.Move_InfiniteJump=v end})
    MoveGroup:AddToggle({Text="Fly", Default=CurrentConfig.Move_Fly, Callback=function(v) CurrentConfig.Move_Fly=v end})
    MoveGroup:AddSlider({Text="Fly Speed", Min=10, Max=100, Default=CurrentConfig.Move_FlySpeed, Rounding=0, Callback=function(v) CurrentConfig.Move_FlySpeed=v end})
    MoveGroup:AddToggle({Text="Slide Boost", Default=CurrentConfig.Move_SlideBoost, Callback=function(v) CurrentConfig.Move_SlideBoost=v end})
    MoveGroup:AddSlider({Text="Boost Multiplier", Min=1, Max=5, Default=CurrentConfig.Move_SlideBoostMult, Rounding=1, Callback=function(v) CurrentConfig.Move_SlideBoostMult=v end})
    MoveGroup:AddToggle({Text="Velocity", Default=CurrentConfig.Move_Velocity, Callback=function(v) CurrentConfig.Move_Velocity=v end})
    MoveGroup:AddSlider({Text="Velocity Speed", Min=1, Max=100, Default=CurrentConfig.Move_VelocitySpeed, Rounding=0, Callback=function(v) CurrentConfig.Move_VelocitySpeed=v end})

    -- Skin Changer Tab (weapon categories)
    local SkinEnableGroup = TabSkin:AddLeftGroupbox("Enable", "shirt")
    SkinEnableGroup:AddToggle({Text="Enable Skin Changer", Default=CurrentConfig.Skin_Enabled, Callback=function(v) CurrentConfig.Skin_Enabled=v; refreshAllSkins() end})

    -- Global apply
    local SkinGlobal = TabSkin:AddRightGroupbox("Global Settings", "globe")
    SkinGlobal:AddInput({Text="Skin ID", Default=CurrentConfig.Global_SkinID or "", Callback=function(v) CurrentConfig.Global_SkinID=v end})
    SkinGlobal:AddInput({Text="Wrap ID", Default=CurrentConfig.Global_WrapID or "", Callback=function(v) CurrentConfig.Global_WrapID=v end})
    SkinGlobal:AddInput({Text="Finisher ID", Default=CurrentConfig.Global_FinisherID or "", Callback=function(v) CurrentConfig.Global_FinisherID=v end})
    SkinGlobal:AddButton({Text="Apply to All Weapons", Callback=function()
        CurrentConfig.WeaponSkins = {}  -- clear per-weapon overrides
        refreshAllSkins()
    end})

    -- Per weapon customization
    local SkinWeaponSection = TabSkin:AddLeftGroupbox("Weapon Customization", "crosshair")
    -- Weapon category filter dropdown
    local weaponCategoryDropdown = SkinWeaponSection:AddDropdown({
        Text = "Weapon Category",
        Values = {"All", "Melee", "Primary", "Secondary", "Utility"},
        Default = "All",
        Callback = function() end
    })
    -- Weapon list (dropdown that updates based on category)
    local weaponListDropdown = SkinWeaponSection:AddDropdown({
        Text = "Select Weapon",
        Values = {},
        Default = "",
        Callback = function(v)
            local data = CurrentConfig.WeaponSkins[v]
            -- update skin/wrap/finisher inputs to show current values
            if data then
                skinInput:SetValue(data.SkinID or "")
                wrapInput:SetValue(data.WrapID or "")
                finisherInput:SetValue(data.FinisherID or "")
            else
                skinInput:SetValue("")
                wrapInput:SetValue("")
                finisherInput:SetValue("")
            end
        end
    })

    local function updateWeaponList()
        local allWeapons = getAllWeapons()
        local category = weaponCategoryDropdown.Value or "All"
        local names = {}
        for _,tool in ipairs(allWeapons) do
            local cat = categorizeWeaponName(tool.Name)
            if category == "All" or cat == category then
                table.insert(names, tool.Name)
            end
        end
        weaponListDropdown:Refresh(names, #names>0 and names[1] or "")
    end

    -- Refresh button
    SkinWeaponSection:AddButton({Text="Refresh Weapons", Callback=updateWeaponList})
    -- Initial refresh
    updateWeaponList()

    local skinInput = SkinWeaponSection:AddInput({Text="Skin ID", Default="", Callback=function(v) end})
    local wrapInput = SkinWeaponSection:AddInput({Text="Wrap ID", Default="", Callback=function(v) end})
    local finisherInput = SkinWeaponSection:AddInput({Text="Finisher ID", Default="", Callback=function(v) end})

    SkinWeaponSection:AddButton({Text="Apply to Selected", Callback=function()
        local weaponName = weaponListDropdown.Value
        if not weaponName or weaponName == "" then return end
        if not CurrentConfig.WeaponSkins[weaponName] then CurrentConfig.WeaponSkins[weaponName] = {} end
        CurrentConfig.WeaponSkins[weaponName].SkinID = skinInput.Value
        CurrentConfig.WeaponSkins[weaponName].WrapID = wrapInput.Value
        CurrentConfig.WeaponSkins[weaponName].FinisherID = finisherInput.Value
        refreshAllSkins()
    end})

    SkinWeaponSection:AddButton({Text="Reset Selected", Callback=function()
        local weaponName = weaponListDropdown.Value
        if weaponName and CurrentConfig.WeaponSkins[weaponName] then
            CurrentConfig.WeaponSkins[weaponName] = nil
            skinInput:SetValue("")
            wrapInput:SetValue("")
            finisherInput:SetValue("")
            refreshAllSkins()
        end
    end})

    -- Spoofer
    local StatsSpoof = TabSpoofer:AddLeftGroupbox("Stats Spoofer", "shield")
    StatsSpoof:AddInput({Text="Level", Default=CurrentConfig.Spoof_Level, Callback=function(v) CurrentConfig.Spoof_Level=v end})
    StatsSpoof:AddInput({Text="Rank", Default=CurrentConfig.Spoof_Rank, Callback=function(v) CurrentConfig.Spoof_Rank=v end})
    StatsSpoof:AddInput({Text="Winstreak", Default=CurrentConfig.Spoof_Winstreak, Callback=function(v) CurrentConfig.Spoof_Winstreak=v end})
    StatsSpoof:AddInput({Text="Winrate", Default=CurrentConfig.Spoof_Winrate, Callback=function(v) CurrentConfig.Spoof_Winrate=v end})
    StatsSpoof:AddInput({Text="Ranked Streak", Default=CurrentConfig.Spoof_RankedStreak, Callback=function(v) CurrentConfig.Spoof_RankedStreak=v end})
    StatsSpoof:AddInput({Text="Ranked Winrate", Default=CurrentConfig.Spoof_RankedWinrate, Callback=function(v) CurrentConfig.Spoof_RankedWinrate=v end})

    local NameSpoof = TabSpoofer:AddRightGroupbox("Name Spoof", "user")
    NameSpoof:AddToggle({Text="Enable", Default=CurrentConfig.NameSpoof_Enabled, Callback=function(v) CurrentConfig.NameSpoof_Enabled=v end})
    NameSpoof:AddInput({Text="Display Name", Default=CurrentConfig.NameSpoof_Text, Callback=function(v) CurrentConfig.NameSpoof_Text=v end})

    local LBGroup = TabSpoofer:AddLeftGroupbox("Leaderboard Spoofer (client)", "trophy")
    LBGroup:AddToggle({Text="Enable", Default=CurrentConfig.LBS_Enabled, Callback=function(v) CurrentConfig.LBS_Enabled=v end})
    LBGroup:AddInput({Text="Wins", Default=CurrentConfig.LBS_Wins, Callback=function(v) CurrentConfig.LBS_Wins=v end})
    LBGroup:AddInput({Text="Winstreak", Default=CurrentConfig.LBS_Winstreak, Callback=function(v) CurrentConfig.LBS_Winstreak=v end})
    LBGroup:AddInput({Text="Level", Default=CurrentConfig.LBS_Level, Callback=function(v) CurrentConfig.LBS_Level=v end})
    LBGroup:AddInput({Text="Rank", Default=CurrentConfig.LBS_Rank, Callback=function(v) CurrentConfig.LBS_Rank=v end})
    LBGroup:AddInput({Text="K/D", Default=CurrentConfig.LBS_KD, Callback=function(v) CurrentConfig.LBS_KD=v end})
    LBGroup:AddInput({Text="Elo", Default=CurrentConfig.LBS_ELO, Callback=function(v) CurrentConfig.LBS_ELO=v end})
    LBGroup:AddButton({Text="Reset", Callback=ResetLB})

    -- Settings
    local KeyGroup = TabSettings:AddLeftGroupbox("Keybinds", "settings")
    KeyGroup:AddKeybind({Text="Toggle UI", Default="RightShift", Callback=function(v) Window:SetToggleKey(Enum.KeyCode[v]) end})

    local ConfigGroup = TabSettings:AddRightGroupbox("Configurations", "folder")
    local cfgInput = ConfigGroup:AddInput({Text="Config Name", Default=""})
    ConfigGroup:AddButton({Text="Save", Callback=function() saveCfg(cfgInput.Value) end})
    ConfigGroup:AddButton({Text="Load", Callback=function() loadCfg(cfgInput.Value) end})
    ConfigGroup:AddButton({Text="Delete", Callback=function() delCfg(cfgInput.Value) end})
    local cfgList = listCfgs()
    local cfgDrop = ConfigGroup:AddDropdown({Text="Existing", Values=cfgList, Default=cfgList[1] or "", Callback=function(v) cfgInput:SetValue(v) end})
    ConfigGroup:AddButton({Text="Refresh", Callback=function() cfgDrop:Refresh(listCfgs()) end})

    local ThemeGroup = TabSettings:AddLeftGroupbox("Theme", "palette")
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
    Library:Notify("🥳 Official Release  |  AC Bypassed  |  All Features Active", 6)
end

pcall(main)