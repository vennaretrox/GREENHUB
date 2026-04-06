-- GREENHUB FULL UPGRADE

print("GREENHUB Loaded")

-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI PARENT
local function getGui()
    if gethui then return gethui() end
    return CoreGui or player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "GreenHub"
gui.Parent = getGui()

-- OPEN BUTTON (GH LOGO)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(60,60)
openBtn.Position = UDim2.new(0,20,0.5,-30)
openBtn.Text = "GH"
openBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBlack
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,250)
main.Position = UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(20,30,20)
Instance.new("UICorner", main)
main.Visible = false

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "GREEN HUB"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,100)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- BUTTON CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

-- BUTTON CREATOR
local function createButton(text, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1,0,0,35)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,60,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- SPEED TOGGLE
local speedOn = false
createButton("Speed [OFF]", function()
    speedOn = not speedOn
end)

-- SPEED LOOP
task.spawn(function()
    while true do
        task.wait(0.2)
        if speedOn then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 50
                end
            end
        end
    end
end)

-- DRAG SYSTEM
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
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

-- OPEN/CLOSE
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ANIM
main.Position = UDim2.new(0.5,-200,0.4,-125)
TweenService:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0.5,-200,0.5,-125)}):Play()
