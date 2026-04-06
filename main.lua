-- GREENHUB V6: GH Logo + LED + Speed 1000 + Speed Ring

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

-- OPEN BUTTON (Rectangular Logo)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(120,50) 
openBtn.Position = UDim2.new(0,20,0,20)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Text = "GH"
openBtn.TextColor3 = Color3.fromRGB(0,255,0)
openBtn.Font = Enum.Font.GothamSemibold
openBtn.TextScaled = true
openBtn.AutoButtonColor = false
openBtn.BorderSizePixel = 0
openBtn.TextStrokeTransparency = 0.7

-- LED halo
local halo = Instance.new("UIStroke", openBtn)
halo.Color = Color3.fromRGB(0,255,0)
halo.Thickness = 1.5
halo.Transparency = 0.2

-- SPEED RING
local ring = Instance.new("Frame", openBtn)
ring.Size = UDim2.new(1.4,0,1.4,0)
ring.Position = UDim2.new(-0.2,0,-0.2,0)
ring.BackgroundTransparency = 1
ring.BorderSizePixel = 0
ring.ClipsDescendants = false

local uiStroke = Instance.new("UIStroke", ring)
uiStroke.Color = Color3.fromRGB(0,255,0)
uiStroke.Thickness = 2
uiStroke.Transparency = 0.3

-- LED pulse + ring pulse
local pulseDir = 1
RunService.RenderStepped:Connect(function(dt)
    local t = halo.Transparency + dt*0.8*pulseDir
    if t > 0.5 then t=0.5 pulseDir=-1
    elseif t < 0.05 then t=0.05 pulseDir=1
    end
    halo.Transparency = t

    uiStroke.Transparency = halo.Transparency
    ring.Rotation = ring.Rotation + (player.Character and player.Character:FindFirstChildOfClass("Humanoid") and 1000 or 0)*dt*0.01
end)

-- Hover: yazı "GREENHUB"
openBtn.MouseEnter:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.15), {TextColor3=Color3.fromRGB(0,255,180)}):Play()
    openBtn.Text = "GREENHUB"
end)
openBtn.MouseLeave:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.15), {TextColor3=Color3.fromRGB(0,255,0)}):Play()
    openBtn.Text = "GH"
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
main.Size = UDim2.fromOffset(450,280)
main.Position = UDim2.new(0.5,-225,0.5,-140)
main.BackgroundColor3 = Color3.fromRGB(15,25,15)
Instance.new("UICorner", main)
main.Visible = false

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.Text = "GREEN HUB"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,100)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 24

-- BUTTON CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,60)
container.Size = UDim2.new(1,-20,1,-70)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,12)

-- SPEED TOGGLE
local speedOn = false
local speedBtn = Instance.new("TextButton", container)
speedBtn.Size = UDim2.new(1,0,0,45)
speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
speedBtn.Text = "Speed [OFF]"
speedBtn.TextColor3 = Color3.fromRGB(0,0,0)
speedBtn.Font = Enum.Font.GothamSemibold
speedBtn.TextSize = 22
Instance.new("UICorner", speedBtn)

-- hover effect
speedBtn.MouseEnter:Connect(function()
    TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(0,200,0)}):Play()
end)
speedBtn.MouseLeave:Connect(function()
    if speedOn then
        speedBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    else
        speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
    end
end)

-- toggle speed
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

-- SPEED LOOP 1000
task.spawn(function()
    while true do
        task.wait(0.05)
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = speedOn and 1000 or 16
            end
        end
    end
end)

-- OPEN/CLOSE HUB
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
