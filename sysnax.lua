-- Sysnax – Official Release (Multi‑game, all executors)
-- Zero freezes • Zero crashes • Right Shift to open

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========== GAME CHECK ==========
local supported = {
    Rivals = {17625359962, 15827677067, 18204519637},
    Arsenal = {286090429, 292439477, 258096465},
    HyperShot = {1110584932, 4618637946},
}
local currentGame = nil
for name, ids in pairs(supported) do
    for _, id in ipairs(ids) do
        if game.PlaceId == id then currentGame = name break end
    end
    if currentGame then break end
end
if not currentGame then
    game.StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Unsupported game.",Duration=5})
    return
end

-- ========== WINDUI ==========
local WindUI = nil
pcall(function()
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)
if not WindUI then LocalPlayer:Kick("UI load failed") return end

WindUI:AddTheme({
    Name="Sysnax", Accent=Color3.fromHex("#2a2a2e"), Background=Color3.fromHex("#121215"),
    AccentOutline=Color3.fromHex("#4a4a50"), Text=Color3.fromHex("#e0e0e0"),
    Placeholder=Color3.fromHex("#6a6a70"), Button=Color3.fromHex("#3a3a40"),
    Icon=Color3.fromHex("#9a9aa0"),
})
WindUI:SetTheme("Sysnax")

local Window = WindUI:CreateWindow({
    Title="Sysnax", Icon="rbxassetid://122198206955790", Folder="sysnax",
    Theme="Sysnax", Resizable=true, MinSize=Vector2.new(560,350),
    MaxSize=Vector2.new(850,560), Size=UDim2.fromOffset(680,520),
    ToggleKey=Enum.KeyCode.RightShift, HideSearchBar=true, ScrollBarEnabled=true,
})

-- ========== CONFIGS ==========
if not isfolder("sysnax") then makefolder("sysnax") end
if not isfolder("sysnax/configs") then makefolder("sysnax/configs") end
local CurrentConfig = {}
local function saveCfg(name)
    if name=="" then return end
    pcall(function()
        writefile("sysnax/configs/"..name..".json", HttpService:JSONEncode(CurrentConfig))
        WindUI:Notify({Title="Sysnax",Content=name.." saved.",Duration=3})
    end)
end
local function loadCfg(name)
    if name=="" or not isfile("sysnax/configs/"..name..".json") then return end
    local ok,data = pcall(function() return HttpService:JSONDecode(readfile("sysnax/configs/"..name..".json")) end)
    if ok and data then for k,v in pairs(data) do CurrentConfig[k]=v end
        WindUI:Notify({Title="Sysnax",Content=name.." loaded.",Duration=3}) end
end
local function delCfg(name)
    if name=="" or not isfile("sysnax/configs/"..name..".json") then return end
    delfile("sysnax/configs/"..name..".json")
    WindUI:Notify({Title="Sysnax",Content=name.." deleted.",Duration=3})
end
local function listCfgs()
    local t={}
    pcall(function() for _,f in ipairs(listfiles("sysnax/configs")) do
        local n=f:match("([^/]+)%.json$"); if n then table.insert(t,n) end end end)
    return t
end

-- ========== MOUSE BUTTONS ==========
local MouseBtns = {
    RightMouse=Enum.UserInputType.MouseButton2,
    LeftMouse=Enum.UserInputType.MouseButton1,
    MiddleMouse=Enum.UserInputType.MouseButton3,
}
pcall(function()
    local function addBtn(name, e1, e2)
        local ok,btn = pcall(function() return Enum.UserInputType[e1] end)
        if ok and btn then MouseBtns[name]=btn else
            ok,btn = pcall(function() return Enum.UserInputType[e2] end)
            if ok and btn then MouseBtns[name]=btn end
        end
    end
    addBtn("Mouse4","MouseButton4","Button4")
    addBtn("Mouse5","MouseButton5","Button5")
end)
local function isMB(name)
    local b = MouseBtns[name]
    return b and UserInputService:IsMouseButtonPressed(b)
end

-- ========== DEFAULTS ==========
CurrentConfig = {
    Aimbot_Enabled=false, Aimbot_Mode="Hold", Aimbot_Part="Head", Aimbot_Smoothness=5,
    Aimbot_Radius=200, Aimbot_VisibleOnly=true, Aimbot_ShowFOV=true,
    Aimbot_FOVColor=Color3.fromRGB(255,255,255), Aimbot_Key="RightMouse",
    Silent_Enabled=false, Silent_Part="Head", Silent_HitChance=100,
    Silent_Manipulation=0, Silent_VisibleOnly=true, Silent_MaxDistance=500,
    Trigger_Enabled=false, Trigger_Delay=0.1, Trigger_Distance=300, Trigger_Key="RightMouse",
    Rage_Enabled=false, Rage_AutoShoot=true, Rage_ThroughWalls=true, Rage_VoidSpam=false,
    Rage_Hide=0.15, Rage_Attack=0.05, Rage_Fly=false, Rage_FlySpeed=50, Rage_NoClip=false,
    ESP_Enabled=false, ESP_Box=true, ESP_HealthBar=true, ESP_Skeleton=false,
    ESP_Color=Color3.fromRGB(255,255,255),
    Chams_Enabled=false, Chams_Material="ForceField", Chams_Color=Color3.fromRGB(150,0,255),
    Crosshair_Enabled=false, Crosshair_Size=10, Crosshair_Thickness=2,
    Crosshair_Color=Color3.fromRGB(255,255,255), Crosshair_DisableGame=false,
    ThirdPerson_Enabled=false, ThirdPerson_Distance=15, ThirdPerson_Key="V",
    Skin_Enabled=false, Global_SkinID="", Global_WrapID="", Global_FinisherID="",
    WeaponSkins={},
    Move_InfiniteJump=false, Move_Fly=false, Move_FlySpeed=50,
    Move_SlideBoost=false, Move_SlideBoostMult=1, Move_Velocity=false, Move_VelocitySpeed=16,
    Anim_Enabled=false, Anim_ID="", Anim_Speed=1,
    HitSound_Enabled=false, HitSound_Sound="Bameware", HitSound_ApplyTo="All",
    Spoof_Level="", Spoof_Rank="", Spoof_Winstreak="", Spoof_Winrate="",
    Spoof_RankedStreak="", Spoof_RankedWinrate="",
    LBS_Enabled=false, LBS_Wins="", LBS_Winstreak="", LBS_Level="", LBS_Rank="",
    LBS_KD="", LBS_ELO="",
}

-- ========== HELPERS (NO YIELD) ==========
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

-- ========== FOV CIRCLE ==========
local fov
pcall(function()
    fov = Drawing.new("Circle")
    fov.Thickness=2; fov.NumSides=64; fov.Filled=false; fov.Transparency=1; fov.Visible=false
end)

-- ========== SILENT AIM (UE0‑style) ==========
local silentTarget = nil
local function safeHook()
    local mt = getrawmetatable and getrawmetatable(game)
    if not mt then
        -- fallback for some executors
        mt = debug and debug.getmetatable and debug.getmetatable(game)
    end
    if not mt or not mt.__namecall then return end
    local old = mt.__namecall
    local hooked = newcclosure and newcclosure(function(...)  -- executor may not support newcclosure; pcall inside
        local args = {...}
        local method = getnamecallmethod()
        if (method=="FireServer" or method=="InvokeServer") and type(args[1])=="string" then
            local rn = args[1]:lower()
            if rn:find("click") or rn:find("shoot") or rn:find("bullet") or rn:find("fire") then
                if CurrentConfig.Silent_Enabled and silentTarget and silentTarget.Character then
                    local part = silentTarget.Character:FindFirstChild(CurrentConfig.Silent_Part)
                    if part then
                        args[2] = part.Position + Vector3.new(0, CurrentConfig.Silent_Manipulation/100, 0)
                        if args[3] and type(args[3])=="userdata" then args[3] = part end
                    end
                end
            end
        end
        return old(unpack(args))
    end) or function(...) return old(...) end
    if setreadonly then setreadonly(mt, false) end
    mt.__namecall = hooked
    if setreadonly then setreadonly(mt, true) end
end
pcall(safeHook)  -- if it fails, silent aim simply won't work; no crash

-- ========== RAGEBOT (advanced) ==========
local function ragebotAutoShoot()
    if not CurrentConfig.Rage_Enabled or not isAlive() or not CurrentConfig.Rage_AutoShoot then return end
    local weaponSys = Workspace:FindFirstChild("WeaponSystem") or game.ReplicatedStorage:FindFirstChild("WeaponSystem")
    if not weaponSys then return end
    local ignoreVis = not CurrentConfig.Rage_ThroughWalls
    local target = closestToCursor(1000, "Head", ignoreVis)
    if target and target.Character then
        weaponSys:FireServer("MouseClick", target.Character.Head)
    end
end

local lastVoid=0, voidState=false
local function ragebotVoid()
    if not CurrentConfig.Rage_VoidSpam or not isAlive() then return end
    local char = getChar()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local now = tick()
    if not voidState then
        if now - lastVoid >= CurrentConfig.Rage_Hide then
            lastVoid = now
            hrp.CFrame = hrp.CFrame * CFrame.new(0,-15,0)
            voidState = true
        end
    else
        if now - lastVoid >= CurrentConfig.Rage_Attack then
            lastVoid = now
            hrp.CFrame = hrp.CFrame * CFrame.new(0,15,0)
            voidState = false
        end
    end
end

local function ragebotFly()
    if not CurrentConfig.Rage_Fly or not isAlive() then return end
    local char = getChar()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dir = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
    hrp.Velocity = dir.Magnitude>0 and dir.Unit*CurrentConfig.Rage_FlySpeed or Vector3.new()
end

local function ragebotNoClip()
    if not CurrentConfig.Rage_NoClip or not isAlive() then return end
    local char = getChar()
    for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end

-- ========== ESP ==========
local espCache={}
local function createESP(plr)
    local esp = {}
    pcall(function() esp.Box=Drawing.new("Square") end)
    pcall(function() esp.Health=Drawing.new("Line") end)
    pcall(function() esp.HealthOutline=Drawing.new("Line") end)
    pcall(function() esp.Name=Drawing.new("Text") end)
    pcall(function() esp.Distance=Drawing.new("Text") end)
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

-- ========== CHAMS ==========
local chamCache={}
local lastCham=0
local function updateChams()
    if CurrentConfig.Chams_Enabled then
        local now=tick()
        if now-lastCham<0.5 then return end
        lastCham=now
        for _,plr in ipairs(getPlayers()) do
            local char=plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _,p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        if not chamCache[p] then chamCache[p]={Material=p.Material,Color=p.Color} end
                        p.Material=Enum.Material[CurrentConfig.Chams_Material] or Enum.Material.ForceField
                        p.Color=CurrentConfig.Chams_Color
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

-- ========== SKIN CHANGER ==========
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

-- ========== THIRD PERSON ==========
local tpActive=false; local tpKey=Enum.KeyCode.V
local function setTP(active)
    tpActive=active
    if active then LocalPlayer.CameraMode=Enum.CameraMode.Classic else LocalPlayer.CameraMode=Enum.CameraMode.LockFirstPerson end
end
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode==tpKey then
        CurrentConfig.ThirdPerson_Enabled = not CurrentConfig.ThirdPerson_Enabled
        setTP(CurrentConfig.ThirdPerson_Enabled)
    end
end)

-- ========== SPOOFERS ==========
local lastSpoof=0
local function spoofStats()
    local now=tick()
    if now-lastSpoof<2 then return end
    lastSpoof=now
    local gui=LocalPlayer:FindFirstChild("PlayerGui")
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
end

local lastLBS=0
local function spoofLeaderboard()
    if not CurrentConfig.LBS_Enabled then return end
    local now=tick()
    if now-lastLBS<2 then return end
    lastLBS=now
    local gui=LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    local function findBoard()
        for _,scr in ipairs(gui:GetChildren()) do
            if scr:IsA("ScreenGui") then
                for _,obj in ipairs(scr:GetDescendants()) do
                    if obj:IsA("Frame") and (obj.Name:lower():find("leader") or obj.Name:lower():find("score")) then
                        return obj
                    end
                end
            end
        end
    end
    local board=findBoard()
    if not board then return end
    local name=LocalPlayer.Name
    for _,child in ipairs(board:GetDescendants()) do
        if (child:IsA("TextLabel") or child:IsA("TextButton")) and (child.Text==name or child.Text:find(name)) then
            local par=child.Parent
            if par then
                for _,el in ipairs(par:GetChildren()) do
                    if el:IsA("TextLabel") or el:IsA("TextButton") then
                        local txt=el.Text:lower()
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

-- ========== MAIN LOOP ==========
local lastShot=0
RunService.RenderStepped:Connect(function()
    -- AIMBOT
    if CurrentConfig.Aimbot_Enabled and isAlive() then
        if fov then
            fov.Visible=CurrentConfig.Aimbot_ShowFOV
            fov.Radius=CurrentConfig.Aimbot_Radius
            fov.Color=CurrentConfig.Aimbot_FOVColor
            fov.Position=Vector2.new(Mouse.X,Mouse.Y)
        end
        local aim = false
        if CurrentConfig.Aimbot_Mode=="Always" then aim=true
        elseif CurrentConfig.Aimbot_Mode=="Hold" then aim=isMB(CurrentConfig.Aimbot_Key) end
        if aim then
            local t=closestToCursor(CurrentConfig.Aimbot_Radius, CurrentConfig.Aimbot_Part, CurrentConfig.Aimbot_VisibleOnly)
            if t and t.Character then
                local part = t.Character:FindFirstChild(CurrentConfig.Aimbot_Part)
                if part then
                    local scr = Camera:WorldToScreenPoint(part.Position)
                    local delta = (Vector2.new(scr.X,scr.Y)-Vector2.new(Mouse.X,Mouse.Y))/CurrentConfig.Aimbot_Smoothness
                    mousemoverel(delta.X,delta.Y)
                end
            end
        end
    elseif fov then fov.Visible=false end

    -- SILENT AIM target selection
    if CurrentConfig.Silent_Enabled then
        local t=closestToCursor(CurrentConfig.Silent_MaxDistance, CurrentConfig.Silent_Part, CurrentConfig.Silent_VisibleOnly)
        if t and math.random(1,100)<=CurrentConfig.Silent_HitChance then silentTarget=t else silentTarget=nil end
    else silentTarget=nil end

    -- TRIGGERBOT
    if CurrentConfig.Trigger_Enabled and isAlive() and isMB(CurrentConfig.Trigger_Key) then
        local t=closestToCursor(CurrentConfig.Trigger_Distance,"Head",true)
        if t and t.Character and tick()-lastShot>=CurrentConfig.Trigger_Delay then
            local ws = Workspace:FindFirstChild("WeaponSystem") or game.ReplicatedStorage:FindFirstChild("WeaponSystem")
            if ws then ws:FireServer("MouseClick", t.Character.Head); lastShot=tick() end
        end
    end

    -- RAGEBOT
    ragebotAutoShoot()
    ragebotVoid()
    ragebotFly()
    ragebotNoClip()

    -- MOVEMENT
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

    -- THIRD PERSON CAMERA
    if tpActive then
        local char=getChar()
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root=char.HumanoidRootPart
            local offset=Camera.CFrame.LookVector*-CurrentConfig.ThirdPerson_Distance
            Camera.CameraSubject=root
            Camera.CFrame=CFrame.new(root.Position-offset, root.Position)
        end
    end

    updateChams()
    refreshSkins()
    spoofStats()
    spoofLeaderboard()

    -- ESP
    if CurrentConfig.ESP_Enabled then
        for plr,esp in pairs(espCache) do
            local char=plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hum=char.Humanoid; local root=char.HumanoidRootPart
                if hum.Health>0 then
                    local headPos,_=w2s((char:FindFirstChild("Head") or root).Position+Vector3.new(0,0.5,0))
                    local legPos,_=w2s((char:FindFirstChild("LeftFoot") or root).Position-Vector3.new(0,3,0))
                    local h=math.abs(headPos.Y-legPos.Y); local w=h/2
                    local x=headPos.X-w/2; local y=headPos.Y-h/2

                    if esp.Box then
                        esp.Box.Size=Vector2.new(w,h); esp.Box.Position=Vector2.new(x,y)
                        esp.Box.Color=CurrentConfig.ESP_Color; esp.Box.Visible=CurrentConfig.ESP_Box
                    end
                    if esp.Health and esp.HealthOutline then
                        local pct=hum.Health/hum.MaxHealth
                        esp.HealthOutline.From=Vector2.new(x-5,y); esp.HealthOutline.To=Vector2.new(x-5,y+h)
                        esp.HealthOutline.Visible=CurrentConfig.ESP_HealthBar
                        esp.Health.From=Vector2.new(x-5,y+h); esp.Health.To=Vector2.new(x-5,y+h-h*pct)
                        esp.Health.Color=Color3.new(1-pct,pct,0); esp.Health.Visible=CurrentConfig.ESP_HealthBar
                    end
                    if CurrentConfig.ESP_Skeleton and esp.Skeleton then
                        local conns={
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
                                    if Drawing then esp.Skeleton[i]=Drawing.new("Line") end
                                    if esp.Skeleton[i] then
                                        esp.Skeleton[i].Thickness=2; esp.Skeleton[i].Color=CurrentConfig.ESP_Color
                                    end
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
                        local dist=0
                        if getChar() and getChar():FindFirstChild("HumanoidRootPart") then
                            dist=(root.Position-getChar().HumanoidRootPart.Position).Magnitude
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

-- ==================== UI ====================
local Tabs = {
    Combat   = Window:Tab({Title="Combat", Icon="crosshair"}),
    Visuals  = Window:Tab({Title="Visuals", Icon="eye"}),
    Ragebot  = Window:Tab({Title="Ragebot", Icon="zap"}),
    Skin     = Window:Tab({Title="Skin Changer", Icon="shirt"}),
    Movement = Window:Tab({Title="Movement", Icon="footprints"}),
    Anims    = Window:Tab({Title="Animations", Icon="play"}),
    HitSound = Window:Tab({Title="Hit Sounds", Icon="music"}),
    Spoofer  = Window:Tab({Title="Spoofer", Icon="shield"}),
    Settings = Window:Tab({Title="Settings", Icon="settings"}),
}

-- Combat
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

-- Visuals
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
TPSec:Keybind({Title="Toggle Key", Value=CurrentConfig.ThirdPerson_Key, Callback=function(v) CurrentConfig.ThirdPerson_Key=v; tpKey=Enum.KeyCode[v] or Enum.KeyCode.V end})
TPSec:Slider({Title="Distance", Default=CurrentConfig.ThirdPerson_Distance, Step=1, Value={Min=5,Max=30,Default=CurrentConfig.ThirdPerson_Distance}, Callback=function(v) CurrentConfig.ThirdPerson_Distance=v end})

-- Ragebot
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

-- Skin Changer
local SkinEnableSec = Tabs.Skin:Section({Title="Enable"})
SkinEnableSec:Toggle({Title="Enable Skin Changer", Default=CurrentConfig.Skin_Enabled, Callback=function(v) CurrentConfig.Skin_Enabled=v end})
local GlobalSkinSec = Tabs.Skin:Section({Title="Global (apply to all)"})
GlobalSkinSec:Input({Title="Skin ID", Value=CurrentConfig.Global_SkinID, Callback=function(v) CurrentConfig.Global_SkinID=v end})
GlobalSkinSec:Input({Title="Wrap ID", Value=CurrentConfig.Global_WrapID, Callback=function(v) CurrentConfig.Global_WrapID=v end})
GlobalSkinSec:Input({Title="Finisher ID", Value=CurrentConfig.Global_FinisherID, Callback=function(v) CurrentConfig.Global_FinisherID=v end})
GlobalSkinSec:Button({Title="Apply Globally", Icon="check", Callback=refreshSkins})

local WeaponSkinSec = Tabs.Skin:Section({Title="Per‑Weapon (overrides global)"})
local weaponDropdown
local function updateWeaponDD()
    local weaps = getWeapons()
    local names = {}
    for _,w in ipairs(weaps) do table.insert(names, w.Name) end
    if weaponDropdown then weaponDropdown:Refresh(names, names[1] or "")
    else weaponDropdown = WeaponSkinSec:Dropdown({Title="Select Weapon", Values=names, Value=names[1] or "", Callback=function() end})
    end
end
updateWeaponDD()
WeaponSkinSec:Button({Title="Refresh Weapons", Icon="refresh-cw", Callback=updateWeaponDD})
local weapSkinInput = WeaponSkinSec:Input({Title="Skin ID", Placeholder="12345678", Callback=function(v) end})
local weapWrapInput = WeaponSkinSec:Input({Title="Wrap ID", Placeholder="87654321", Callback=function(v) end})
WeaponSkinSec:Button({Title="Apply to Selected", Icon="check", Callback=function()
    local n = weaponDropdown and weaponDropdown:GetValue()
    if not n or n=="" then return end
    if not CurrentConfig.WeaponSkins[n] then CurrentConfig.WeaponSkins[n]={} end
    CurrentConfig.WeaponSkins[n].SkinID = weapSkinInput:GetValue()
    CurrentConfig.WeaponSkins[n].WrapID = weapWrapInput:GetValue()
    refreshSkins()
end})
WeaponSkinSec:Button({Title="Reset Selected", Icon="trash", Callback=function()
    local n = weaponDropdown and weaponDropdown:GetValue()
    if n and CurrentConfig.WeaponSkins[n] then CurrentConfig.WeaponSkins[n]=nil; refreshSkins() end
end})

-- Movement
local MoveSec = Tabs.Movement:Section({Title="General"})
MoveSec:Toggle({Title="Infinite Jump", Default=CurrentConfig.Move_InfiniteJump, Callback=function(v) CurrentConfig.Move_InfiniteJump=v end})
MoveSec:Toggle({Title="Fly", Default=CurrentConfig.Move_Fly, Callback=function(v) CurrentConfig.Move_Fly=v end})
MoveSec:Slider({Title="Fly Speed", Step=1, Value={Min=10,Max=100,Default=CurrentConfig.Move_FlySpeed}, Callback=function(v) CurrentConfig.Move_FlySpeed=v end})
MoveSec:Toggle({Title="Slide Boost", Default=CurrentConfig.Move_SlideBoost, Callback=function(v) CurrentConfig.Move_SlideBoost=v end})
MoveSec:Slider({Title="Boost Multiplier", Step=0.1, Value={Min=1,Max=5,Default=CurrentConfig.Move_SlideBoostMult}, Callback=function(v) CurrentConfig.Move_SlideBoostMult=v end})
MoveSec:Toggle({Title="Velocity", Default=CurrentConfig.Move_Velocity, Callback=function(v) CurrentConfig.Move_Velocity=v end})
MoveSec:Slider({Title="Velocity Speed", Step=1, Value={Min=1,Max=100,Default=CurrentConfig.Move_VelocitySpeed}, Callback=function(v) CurrentConfig.Move_VelocitySpeed=v end})

-- Anims
local AnimSec = Tabs.Anims:Section({Title="Custom Animation"})
AnimSec:Toggle({Title="Enable", Default=CurrentConfig.Anim_Enabled, Callback=function(v) CurrentConfig.Anim_Enabled=v end})
AnimSec:Input({Title="Animation ID", Value=CurrentConfig.Anim_ID, Callback=function(v) CurrentConfig.Anim_ID=v end})
AnimSec:Slider({Title="Speed", Step=0.1, Value={Min=0.1,Max=5,Default=CurrentConfig.Anim_Speed}, Callback=function(v) CurrentConfig.Anim_Speed=v end})

-- Hit Sounds
local HitSec = Tabs.HitSound:Section({Title="Hit Sound Options"})
HitSec:Toggle({Title="Enable", Default=CurrentConfig.HitSound_Enabled, Callback=function(v) CurrentConfig.HitSound_Enabled=v end})
HitSec:Dropdown({Title="Sound", Values={"Bameware","Custom"}, Value=CurrentConfig.HitSound_Sound, Callback=function(v) CurrentConfig.HitSound_Sound=v end})
HitSec:Dropdown({Title="Apply To", Values={"All","Enemies","Local"}, Value=CurrentConfig.HitSound_ApplyTo, Callback=function(v) CurrentConfig.HitSound_ApplyTo=v end})

-- Spoofer
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
LBSec:Button({Title="Reset Leaderboard Spoofer", Icon="rotate-ccw", Callback=function()
    CurrentConfig.LBS_Enabled=false
    CurrentConfig.LBS_Wins=""; CurrentConfig.LBS_Winstreak=""; CurrentConfig.LBS_Level=""
    CurrentConfig.LBS_Rank=""; CurrentConfig.LBS_KD=""; CurrentConfig.LBS_ELO=""
end})

-- Settings
local KBSec = Tabs.Settings:Section({Title="Keybinds"})
KBSec:Keybind({Title="Toggle UI", Value="RightShift", Callback=function(v) Window:SetToggleKey(Enum.KeyCode[v]) end})

local CfgSec = Tabs.Settings:Section({Title="Configurations"})
local cfgInput = CfgSec:Input({Title="Config Name"})
CfgSec:Button({Title="Save Config", Icon="save", Callback=function() saveCfg(cfgInput:GetValue()) end})
CfgSec:Button({Title="Load Config", Icon="folder-open", Callback=function() loadCfg(cfgInput:GetValue()) end})
CfgSec:Button({Title="Delete Config", Icon="trash", Callback=function() delCfg(cfgInput:GetValue()) end})
local cfgList = listCfgs()
local cfgDD = CfgSec:Dropdown({Title="Existing Configs", Values=cfgList, Value=cfgList[1] or "", Callback=function(v) cfgInput:Set(v) end})
CfgSec:Button({Title="Refresh List", Icon="refresh-cw", Callback=function() cfgDD:Refresh(listCfgs()) end})

local ThemeSec = Tabs.Settings:Section({Title="Theme"})
ThemeSec:Dropdown({Title="Select Theme", Values={"Sysnax","Dark","Light"}, Value="Sysnax", Callback=function(v) WindUI:SetTheme(v) end})

-- Autoload: hide window immediately
pcall(function() Window:Toggle() end)

WindUI:Notify({Title="Sysnax", Content="🥳 Official Release", Duration=6})