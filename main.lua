-- GREENHUB ULTRA FINAL
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI parent
local function getGui()
    if gethui then return gethui() end
    return CoreGui or player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "GreenHub"
gui.Parent = getGui()

--------------------------------------------------
-- LOGO (DİKDÖRTGEN + LED + ANİMASYON)
--------------------------------------------------
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(120,40)
openBtn.Position = UDim2.new(0,20,0,20)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Text = "GH"
openBtn.TextColor3 = Color3.fromRGB(0,255,0)
openBtn.Font = Enum.Font.Gotham
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0

local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 1.5

-- Logo animation (dark green ↔ normal green)
RunService.Heartbeat:Connect(function()
    local t = tick() % 2
    if t < 1 then
        openBtn.TextColor3 = Color3.fromRGB(0,180,0)
    else
        openBtn.TextColor3 = Color3.fromRGB(0,255,0)
    end
end)

-- Hover effect
openBtn.MouseEnter:Connect(function() openBtn.Text = "GREENHUB" end)
openBtn.MouseLeave:Connect(function() openBtn.Text = "GH" end)

-- Drag
local dragging, dragStart, startPos = false, nil, nil
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = openBtn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        openBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--------------------------------------------------
-- MAIN HUB (LED + TITLE)
--------------------------------------------------
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,250)
main.Position = UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(15,25,15)
main.Visible = false
Instance.new("UICorner", main)

local border = Instance.new("UIStroke", main)
border.Color = Color3.fromRGB(0,255,0)
border.Thickness = 2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "GREENHUB"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,100)
title.Font = Enum.Font.Gotham
title.TextSize = 22

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)

--------------------------------------------------
-- SPEED BUTTON (GİZLİ SPEED)
--------------------------------------------------
local speedOn = false
local NORMAL_SPEED = 16
local TARGET_SPEED = 50
local currentSpeed = NORMAL_SPEED

local speedBtn = Instance.new("TextButton", container)
speedBtn.Size = UDim2.new(1,0,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
speedBtn.Text = "Speed [OFF]"
speedBtn.TextColor3 = Color3.fromRGB(0,0,0)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 20
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        speedBtn.Text = "Speed [ON]"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    else
        speedBtn.Text = "Speed [OFF]"
        speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
        currentSpeed = NORMAL_SPEED
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = NORMAL_SPEED end
    end
end)

-- Gizli speed sistemi (smooth, anti-reset)
RunService.Heartbeat:Connect(function()
    if not speedOn then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Smooth hız artışı
    if currentSpeed < TARGET_SPEED then
        currentSpeed = currentSpeed + 1
    end
    hum.WalkSpeed = currentSpeed

    -- Hafif ileri ışınlama
    if hum.MoveDirection.Magnitude > 0.1 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 0.5)
    end
end)

--------------------------------------------------
-- OPEN/CLOSE HUB
--------------------------------------------------
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
