-- GREENHUB FINAL (FULL FIXED)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI
local function getGui()
    if gethui then return gethui() end
    return CoreGui or player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "GreenHub"
gui.Parent = getGui()

--------------------------------------------------
-- LOGO (DİKDÖRTGEN + LED)
--------------------------------------------------

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(120,40)
openBtn.Position = UDim2.new(0,20,0,20)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Text = "GH"
openBtn.TextColor3 = Color3.fromRGB(0,255,0)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0

local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 1

-- Hover
openBtn.MouseEnter:Connect(function()
    openBtn.Text = "GREENHUB"
end)

openBtn.MouseLeave:Connect(function()
    openBtn.Text = "GH"
end)

--------------------------------------------------
-- DRAG
--------------------------------------------------

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

--------------------------------------------------
-- MAIN HUB
--------------------------------------------------

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,250)
main.Position = UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(15,25,15)
main.Visible = false
Instance.new("UICorner", main)

-- LED BORDER (İSTEDİĞİN GİBİ)
local border = Instance.new("UIStroke", main)
border.Color = Color3.fromRGB(144,255,144)
border.Thickness = 1.5

-- TITLE (KALIN)
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "GREENHUB"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,100)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

--------------------------------------------------
-- CONTAINER
--------------------------------------------------

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)

--------------------------------------------------
-- SPEED BUTTON
--------------------------------------------------

local speedOn = false

local speedBtn = Instance.new("TextButton", container)
speedBtn.Size = UDim2.new(1,0,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
speedBtn.Text = "Speed [OFF]"
speedBtn.TextColor3 = Color3.fromRGB(0,0,0)
speedBtn.Font = Enum.Font.GothamBold
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

--------------------------------------------------
-- MULTIPLIER SPEED (SERVER-LIKE SYSTEM)

local speedOn = false
local NORMAL_SPEED = 16
local SPEED_MULTIPLIER = 6 -- burayı artırabilirsin

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn

    if speedOn then
        speedBtn.Text = "Speed [ON]"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    else
        speedBtn.Text = "Speed [OFF]"
        speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)

        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = NORMAL_SPEED end
    end
end)

RunService.Heartbeat:Connect(function()
    if not speedOn then return end

    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- sürekli server gibi hız ver
    local targetSpeed = NORMAL_SPEED * SPEED_MULTIPLIER

    -- sadece düşükse artır (anti reset)
    if hum.WalkSpeed < targetSpeed then
        hum.WalkSpeed = targetSpeed
    end
end)
--------------------------------------------------
-- OPEN / CLOSE
--------------------------------------------------

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
