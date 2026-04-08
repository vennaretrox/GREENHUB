-- GREENHUB GOD MODE (ULTRA OP FINAL)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local function getGui()
    if gethui then return gethui() end
    return CoreGui or player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Parent = getGui()

--------------------------------------------------
-- LOGO + DRAG
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(120,40)
btn.Position = UDim2.new(0,20,0,20)
btn.Text = "GH"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(0,255,0)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true

Instance.new("UIStroke", btn).Color = Color3.fromRGB(0,255,0)

local dragging,dragStart,startPos

btn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=i.Position
        startPos=btn.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-dragStart
        btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=false
    end
end)

--------------------------------------------------
-- MAIN
--------------------------------------------------
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,380)
main.Position = UDim2.new(0.5,-200,0.5,-190)
main.BackgroundColor3 = Color3.fromRGB(15,25,15)
main.Visible=false
Instance.new("UICorner", main)

Instance.new("UIStroke", main).Color = Color3.fromRGB(0,255,0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text="GREENHUB"
title.Font=Enum.Font.GothamBold
title.TextSize=26
title.TextColor3=Color3.fromRGB(0,255,100)
title.BackgroundTransparency=1

local cont = Instance.new("Frame", main)
cont.Position=UDim2.new(0,10,0,50)
cont.Size=UDim2.new(1,-20,1,-60)
cont.BackgroundTransparency=1
Instance.new("UIListLayout", cont).Padding=UDim.new(0,10)

--------------------------------------------------
-- SMART SPEED
--------------------------------------------------
local speed=false
local baseSpeed=16
local maxBoost=9
local cur=16

local sbtn=Instance.new("TextButton",cont)
sbtn.Size=UDim2.new(1,0,0,40)
sbtn.Text="Speed [OFF]"
Instance.new("UICorner",sbtn)

sbtn.MouseButton1Click:Connect(function()
    speed=not speed
    sbtn.Text=speed and "Speed [ON]" or "Speed [OFF]"
end)

RunService.RenderStepped:Connect(function()
    if not speed then return end
    local c=player.Character
    if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid")
    if not h then return end

    if h.MoveDirection.Magnitude>0 then
        cur=math.min(cur+0.5,baseSpeed+maxBoost)
    else
        cur=math.max(cur-1,baseSpeed)
    end

    h.WalkSpeed=cur
end)

--------------------------------------------------
-- DASH (COOLDOWN)
--------------------------------------------------
local lastDash=0
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.Q then
        if tick()-lastDash<1 then return end
        lastDash=tick()

        local c=player.Character
        if not c then return end
        local r=c:FindFirstChild("HumanoidRootPart")
        local h=c:FindFirstChildOfClass("Humanoid")

        if r and h then
            r.CFrame=r.CFrame+(h.MoveDirection*20)
        end
    end
end)

--------------------------------------------------
-- AUTO BASE TP (GERÇEK)
--------------------------------------------------
local spawnPos

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    local root=char:WaitForChild("HumanoidRootPart")
    spawnPos=root.CFrame
end)

RunService.Heartbeat:Connect(function()
    local c=player.Character
    if not c or not spawnPos then return end

    local tool=c:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("brain") then
        c.HumanoidRootPart.CFrame=spawnPos
    end
end)

--------------------------------------------------
-- SMART TP (İSİM / EN YAKIN)
--------------------------------------------------
local tpOn=false

local tpbtn=Instance.new("TextButton",cont)
tpbtn.Size=UDim2.new(1,0,0,40)
tpbtn.Text="TP [OFF]"
Instance.new("UICorner",tpbtn)

local box=Instance.new("TextBox",cont)
box.Size=UDim2.new(1,0,0,35)
box.PlaceholderText="isim boş = en yakın"
Instance.new("UICorner",box)

tpbtn.MouseButton1Click:Connect(function()
    tpOn=not tpOn
    tpbtn.Text=tpOn and "TP [ON]" or "TP [OFF]"
end)

box.FocusLost:Connect(function(enter)
    if not enter or not tpOn then return end

    local my=player.Character
    if not my then return end

    local closest,dist=nil,math.huge

    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d=(plr.Character.HumanoidRootPart.Position - my.HumanoidRootPart.Position).Magnitude

            if box.Text=="" then
                if d<dist then
                    dist=d
                    closest=plr
                end
            elseif plr.Name:lower():find(box.Text:lower()) then
                closest=plr
                break
            end
        end
    end

    if closest then
        my.HumanoidRootPart.CFrame=
            closest.Character.HumanoidRootPart.CFrame+Vector3.new(0,0,3)
    end
end)

--------------------------------------------------
-- AUTO STEAL (YAKINDA)
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local c=player.Character
    if not c then return end

    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("brain") then
            local handle=v:FindFirstChild("Handle")
            if handle and (handle.Position - c.HumanoidRootPart.Position).Magnitude < 10 then
                firetouchinterest(c.HumanoidRootPart, handle, 0)
                firetouchinterest(c.HumanoidRootPart, handle, 1)
            end
        end
    end
end)

--------------------------------------------------
-- OPEN
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    main.Visible=not main.Visible
end)
