-- GREENHUB MAIN

print("GREENHUB Loaded")

-- GUI BASE
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local function getGui()
    if gethui then return gethui() end
    return CoreGui or player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "GreenHub"
gui.Parent = getGui()

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(400,250)
main.Position = UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(20,30,20)
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "GREEN HUB"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,100)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- BUTTON SYSTEM
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

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

-- FEATURES
createButton("Speed", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = 50 end
end)

createButton("Normal", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = 16 end
end)

-- ANIM
main.Position = UDim2.new(0.5,-200,0.4,-125)
TweenService:Create(main, TweenInfo.new(0.3), {
    Position = UDim2.new(0.5,-200,0.5,-125)
}):Play()
