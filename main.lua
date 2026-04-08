-- GREENHUB ULTRA FIXED

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)

--------------------------------------------------
-- MAIN UI
--------------------------------------------------
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(300,260)
main.Position = UDim2.new(0.5,-150,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Visible = true

local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0,8)

--------------------------------------------------
-- SPEED (ULTRA FIX)
--------------------------------------------------
local speed = false
local currentSpeed = 16

local speedBtn = Instance.new("TextButton", main)
speedBtn.Size = UDim2.new(1,0,0,40)
speedBtn.Text = "Speed [OFF]"

speedBtn.MouseButton1Click:Connect(function()
    speed = not speed
    speedBtn.Text = speed and "Speed [ON]" or "Speed [OFF]"
end)

RunService.RenderStepped:Connect(function()
    local c = player.Character
    if not c then return end

    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end

    if speed then
        if currentSpeed ~= 22 then
            currentSpeed = 22
            h.WalkSpeed = currentSpeed
        end

        if h.MoveDirection.Magnitude > 0 then
            r.CFrame = r.CFrame + (h.MoveDirection * 0.35)
        end
    else
        if currentSpeed ~= 16 then
            currentSpeed = 16
            h.WalkSpeed = 16
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
-- TP SYSTEM (ULTRA FIX + TOGGLE)
--------------------------------------------------
local tpOn = false
local basePart = nil
local lastTP = 0

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(1,0,0,40)
tpBtn.Text = "Auto TP [OFF]"

tpBtn.MouseButton1Click:Connect(function()
    tpOn = not tpOn
    tpBtn.Text = tpOn and "Auto TP [ON]" or "Auto TP [OFF]"
end)

-- base bulma (DAHA STABİL)
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
        if tick() - lastTP < 2 then return end -- anti spam
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
