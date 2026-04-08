-- GREENHUB PERFECT FINAL + LEGIT SPEED

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
-- LOGO (AYNI)
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
        TweenService:Create(stroke,TweenInfo.new(0.8),{
            Transparency = 0.2
        }):Play()
        task.wait(0.8)

        TweenService:Create(btn,TweenInfo.new(0.8),{
            TextColor3 = Color3.fromRGB(0,255,0)
        }):Play()
        TweenService:Create(stroke,TweenInfo.new(0.8),{
            Transparency = 0
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
-- AUTO TP TOGGLE (MENÜ)
--------------------------------------------------
local tpToggleBtn = Instance.new("TextButton", cont)
tpToggleBtn.Size = UDim2.new(1,0,0,40)
tpToggleBtn.Text = "Auto TP [ON]"
Instance.new("UICorner", tpToggleBtn)

tpToggleBtn.MouseButton1Click:Connect(function()
    tpOn = not tpOn
    tpToggleBtn.Text = tpOn and "Auto TP [ON]" or "Auto TP [OFF]"
end)

--------------------------------------------------
-- BASE SELECT (TEXTBOX)
--------------------------------------------------
local baseBox = Instance.new("TextBox", cont)
baseBox.Size = UDim2.new(1,0,0,40)
baseBox.PlaceholderText = "Base adı yaz (cash adı)"
baseBox.Text = ""
Instance.new("UICorner", baseBox)

baseBox.FocusLost:Connect(function()
    local text = baseBox.Text:lower()

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:lower():find(text) then
            basePart = v
            baseBox.Text = "Seçildi!"
            task.wait(1)
            baseBox.Text = ""
            break
        end
    end
end)

--------------------------------------------------
-- AUTO STEAL (YAKIN BRAIN)
--------------------------------------------------
local stealOn = false

local stealBtn = Instance.new("TextButton", cont)
stealBtn.Size = UDim2.new(1,0,0,40)
stealBtn.Text = "Auto Steal [OFF]"
Instance.new("UICorner", stealBtn)

stealBtn.MouseButton1Click:Connect(function()
    stealOn = not stealOn
    stealBtn.Text = stealOn and "Auto Steal [ON]" or "Auto Steal [OFF]"
end)

RunService.Heartbeat:Connect(function()
    if not stealOn then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v.Name:lower():find("brain") then
            if v:FindFirstChild("Handle") then
                local dist = (v.Handle.Position - root.Position).Magnitude
                if dist < 15 then
                    firetouchinterest(root, v.Handle, 0)
                    firetouchinterest(root, v.Handle, 1)
                end
            end
        end
    end
end)

--------------------------------------------------
-- PANIC BUTTON (HERŞEYİ KAPAT)
--------------------------------------------------
local panicBtn = Instance.new("TextButton", cont)
panicBtn.Size = UDim2.new(1,0,0,40)
panicBtn.Text = "PANIC (KAPAT)"
panicBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
Instance.new("UICorner", panicBtn)

panicBtn.MouseButton1Click:Connect(function()
    legitOn = false
    speedBtn.Text = "Legit Speed [OFF]"

    tpOn = false
    tpToggleBtn.Text = "Auto TP [OFF]"

    stealOn = false
    stealBtn.Text = "Auto Steal [OFF]"
end)

--------------------------------------------------
-- LEGIT SPEED (SENİN KODUN FIXLENMİŞ HALİ)
--------------------------------------------------
local legitOn = false
local NORMAL_SPEED = 16
local ADD_SPEED = 6

local speedBtn = Instance.new("TextButton", cont)
speedBtn.Size = UDim2.new(1,0,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)
speedBtn.Text = "Legit Speed [OFF]"
speedBtn.TextColor3 = Color3.fromRGB(0,0,0)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 20
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
    legitOn = not legitOn
    if legitOn then
        speedBtn.Text = "Legit Speed [ON]"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    else
        speedBtn.Text = "Legit Speed [OFF]"
        speedBtn.BackgroundColor3 = Color3.fromRGB(144,238,144)

        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = NORMAL_SPEED end
    end
end)

RunService.Heartbeat:Connect(function()
    if not legitOn then return end

    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local target = NORMAL_SPEED + ADD_SPEED

    if hum.MoveDirection.Magnitude > 0.1 then
        hum.WalkSpeed = math.min(hum.WalkSpeed + 0.5, target)
    else
        if hum.WalkSpeed > NORMAL_SPEED then
            hum.WalkSpeed = math.max(hum.WalkSpeed - 1, NORMAL_SPEED)
        end
    end
end)

--------------------------------------------------
-- DASH (GERİ ÇEKME YOK)
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
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(99999,0,99999)
                bv.Velocity = root.CFrame.LookVector * 70
                bv.Parent = root
                game.Debris:AddItem(bv,0.25)
            end
        end

        task.wait(1.2)
        canDash = true
    end
end)

--------------------------------------------------
-- TP (AYNI SİSTEM)
--------------------------------------------------
local basePart = nil
local tpOn = true
local lastTP = 0

task.spawn(function()
    while true do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name:lower():find("cash") then
                basePart = v
            end
        end
        task.wait(3)
    end
end)

RunService.Heartbeat:Connect(function()
    if not tpOn then return end

    local c = player.Character
    if not c or not basePart then return end

    local tool = c:FindFirstChildOfClass("Tool")

    if tool and tool.Name:lower():find("brain") then
        if tick() - lastTP < 2 then return end
        lastTP = tick()

        task.spawn(function()
            task.wait(1.5)
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame =
                    basePart.CFrame + Vector3.new(0,3,0)
            end
        end)
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
