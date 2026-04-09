-- GREENHUB ULTRA FIXED

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
-- LOGO
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(120,40)
btn.Position = UDim2.new(0,20,0,20)
btn.Text = "GH"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(0,255,0)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true

local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 2

task.spawn(function()
    while true do
        TweenService:Create(btn,TweenInfo.new(0.8),{
            TextColor3 = Color3.fromRGB(0,180,0)
        }):Play()
        task.wait(0.8)
        TweenService:Create(btn,TweenInfo.new(0.8),{
            TextColor3 = Color3.fromRGB(0,255,0)
        }):Play()
        task.wait(0.8)
    end
end)

-- DRAG
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
-- MAIN
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
-- PLAYER TP
--------------------------------------------------
local playerBox = Instance.new("TextBox", cont)
playerBox.Size = UDim2.new(1,0,0,40)
playerBox.PlaceholderText = "Oyuncu adı yaz (TP)"
Instance.new("UICorner", playerBox)

playerBox.FocusLost:Connect(function()
    local text = playerBox.Text:lower()

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr.Name:lower():find(text) then
            local my = player.Character
            local trg = plr.Character

            if my and trg then
                local r1 = my:FindFirstChild("HumanoidRootPart")
                local r2 = trg:FindFirstChild("HumanoidRootPart")

                if r1 and r2 then
                    r1.CFrame = r2.CFrame + Vector3.new(0,3,0)
                end
            end
            break
        end
    end
end)

--------------------------------------------------
-- LEGIT SPEED
--------------------------------------------------
local legitOn = false
local NORMAL = 16
local ADD = 7

local speedBtn = Instance.new("TextButton", cont)
speedBtn.Size = UDim2.new(1,0,0,40)
speedBtn.Text = "Legit Speed [OFF]"
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
    legitOn = not legitOn
    speedBtn.Text = legitOn and "Legit Speed [ON]" or "Legit Speed [OFF]"
end)

RunService.Heartbeat:Connect(function()
    if not legitOn then return end

    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local target = NORMAL + ADD

    if hum.MoveDirection.Magnitude > 0.1 then
        hum.WalkSpeed = math.min(hum.WalkSpeed + 0.5, target)
    else
        hum.WalkSpeed = math.max(hum.WalkSpeed - 1, NORMAL)
    end
end)

--------------------------------------------------
-- DASH
--------------------------------------------------
local canDash = true

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.E and canDash then
        canDash = false

        local c = player.Character
        if c then
            local root = c:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame + (root.CFrame.LookVector * 25)
            end
        end

        task.wait(1.2)
        canDash = true
    end
end)

--------------------------------------------------
-- BASE SAVE + R TP
--------------------------------------------------
local basePos = nil

player.CharacterAdded:Connect(function(char)
    local root = char:WaitForChild("HumanoidRootPart")
    task.wait(1)
    basePos = root.CFrame
end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.R then
        local char = player.Character
        if char and basePos then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = basePos
            end
        end
    end
end)

--------------------------------------------------
-- MENU
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
