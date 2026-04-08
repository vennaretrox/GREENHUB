-- GREENHUB GOD STABLE FINAL (NO BUG)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local function getGui()
    if gethui then return gethui() end
    return CoreGui or player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Parent = getGui()

--------------------------------------------------
-- LOGO (ANİMASYON + DRAG)
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

-- glow animasyon
task.spawn(function()
    while true do
        TweenService:Create(btn,TweenInfo.new(1),{TextColor3=Color3.fromRGB(0,180,0)}):Play()
        task.wait(1)
        TweenService:Create(btn,TweenInfo.new(1),{TextColor3=Color3.fromRGB(0,255,0)}):Play()
        task.wait(1)
    end
end)

-- drag
local dragging,dragStart,startPos

btn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
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
-- MAIN (ANİMASYON)
--------------------------------------------------
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,320)
main.Position = UDim2.new(0.5,-200,0.5,-200)
main.BackgroundColor3 = Color3.fromRGB(15,25,15)
main.Visible = false
main.BackgroundTransparency = 1

Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0,255,0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "GREENHUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(0,255,100)
title.BackgroundTransparency = 1

local cont = Instance.new("Frame", main)
cont.Position = UDim2.new(0,10,0,50)
cont.Size = UDim2.new(1,-20,1,-60)
cont.BackgroundTransparency = 1
Instance.new("UIListLayout", cont).Padding = UDim.new(0,10)

--------------------------------------------------
-- SPEED V2 (EN STABİL)
--------------------------------------------------
local speed=false
local NORMAL=16
local BOOST=3
local TP=0.5

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
    local r=c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end

    if h.MoveDirection.Magnitude>0 then
        h.WalkSpeed = NORMAL + BOOST
        r.CFrame = r.CFrame + (h.MoveDirection * TP)
    else
        h.WalkSpeed = NORMAL
    end
end)

--------------------------------------------------
-- DASH (E TUŞU)
--------------------------------------------------
local lastDash=0
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.E then
        if tick()-lastDash<1 then return end
        lastDash=tick()

        local c=player.Character
        if not c then return end

        local r=c:FindFirstChild("HumanoidRootPart")
        local h=c:FindFirstChildOfClass("Humanoid")

        if r and h then
            r.CFrame = r.CFrame + (h.MoveDirection * 16)
        end
    end
end)

--------------------------------------------------
-- BASE TP (KESİN FIX)
--------------------------------------------------
local basePos=nil

player.CharacterAdded:Connect(function(char)
    local root=char:WaitForChild("HumanoidRootPart")
    task.wait(1)
    basePos=root.CFrame
end)

RunService.Heartbeat:Connect(function()
    local c=player.Character
    if not c or not basePos then return end

    local tool=c:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("brain") then
        c.HumanoidRootPart.CFrame = basePos
        task.wait(1.5)
    end
end)

--------------------------------------------------
-- SAFE TP (BUTON)
--------------------------------------------------
local tpBtn=Instance.new("TextButton",cont)
tpBtn.Size=UDim2.new(1,0,0,40)
tpBtn.Text="Safe TP"
Instance.new("UICorner",tpBtn)

tpBtn.MouseButton1Click:Connect(function()
    local c=player.Character
    if not c then return end

    local r=c:FindFirstChild("HumanoidRootPart")
    if r then
        r.CFrame = r.CFrame + Vector3.new(0,0,-60)
    end
end)

--------------------------------------------------
-- MENU ANİMASYON
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible

    if main.Visible then
        main.Position = UDim2.new(0.5,-200,0.5,-250)
        main.BackgroundTransparency = 1

        TweenService:Create(main,TweenInfo.new(0.3),{
            Position = UDim2.new(0.5,-200,0.5,-160),
            BackgroundTransparency = 0
        }):Play()
    end
end)
