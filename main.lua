-- GREENHUB FINAL (REAL SPEED SYSTEM)

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

-- LOGO (dikdörtgen)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(120,50)
openBtn.Position = UDim2.new(0,20,0,20)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Text = "GH"
openBtn.TextColor3 = Color3.fromRGB(0,255,0)
openBtn.Font = Enum.Font.GothamSemibold
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0

-- LED border
local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 1.5

-- Hover text
openBtn.MouseEnter:Connect(function()
    openBtn.Text = "GREENHUB"
    TweenService:Create(openBtn, TweenInfo.new(0.15), {TextColor3=Color3.fromRGB(0,255,180)}):Play()
end)

openBtn.MouseLeave:Connect(function()
    openBtn.Text = "GH"
    TweenService:Create(openBtn, TweenInfo.new(0.15), {TextColor3=Color3.fromRGB(0,255,0)}):Play()
end)

-- DRAG
local dragging = false
local dragStart, startPos

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

-- MAIN HUB
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,250)
main.Position = UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(15,25,15)
Instance.new("UICorner", main)
main.Visible = false

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "GREEN HUB"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,100)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20

-- CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)

-- SPEED SYSTEM
local speedOn = false
local speedForce = nil

local speedBtn = Instance.new("TextButton", container)
speedBtn.Size = UDim2.new(1,0,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
speedBtn.Text = "Speed [OFF]"
speedBtn.TextColor3 = Color3.fromRGB(0,0,0)
speedBtn.Font = Enum.Font.GothamSemibold
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
    end
end)

-- SAFE SPEED (ANTI-DEATH + ANTI-RESET)

local speedOn = false

game:GetService("RunService").Heartbeat:Connect(function()
    if not speedOn then return end

    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or not root then return end

    -- sürekli küçük boost (farkedilmez)
    hum.WalkSpeed = 20

    -- ileri doğru hafif itme
    if hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 1.5)
    end
end)   
-- OPEN/CLOSE
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
