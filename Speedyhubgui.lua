https://github.com/speedy-codestv/Speedy-roblox-universal-script-- Speedy Hub Admin GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = "Speedy Hub Admin"
ScreenGui.ResetOnSpawn = false

-- Key input frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyFrame.Active = true
KeyFrame.Draggable = true -- draggable
KeyFrame.Parent = ScreenGui

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0.3, 0)
KeyBox.Position = UDim2.new(0.1, 0, 0.2, 0)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
KeyBox.Parent = KeyFrame

local ConfirmBtn = Instance.new("TextButton")
ConfirmBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
ConfirmBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
ConfirmBtn.Text = "Confirm"
ConfirmBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
ConfirmBtn.TextColor3 = Color3.new(1,1,1)
ConfirmBtn.Parent = KeyFrame

-- Admin frame
local AdminFrame = Instance.new("Frame")
AdminFrame.Size = UDim2.new(0, 300, 0, 300)
AdminFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
AdminFrame.BackgroundColor3 = Color3.fromRGB(30,30,60)
AdminFrame.Visible = false
AdminFrame.Active = true
AdminFrame.Draggable = true -- draggable
AdminFrame.Parent = ScreenGui

-- Button helper
local function makeButton(name, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0.12, 0)
	btn.Position = UDim2.new(0.1, 0, yPos, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(100,100,120)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = AdminFrame
	return btn
end

-- Buttons
local FlyBtn = makeButton("Fly", 0.1)
local NoclipBtn = makeButton("Noclip", 0.25)
local SwordBtn = makeButton("Sword", 0.4)

-- Fly speed input
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.8, 0, 0.12, 0)
SpeedBox.Position = UDim2.new(0.1, 0, 0.55, 0)
SpeedBox.Text = "Fly Speed: 50"
SpeedBox.BackgroundColor3 = Color3.fromRGB(120,120,140)
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.ClearTextOnFocus = true
SpeedBox.Parent = AdminFrame

-- Key check
ConfirmBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == "Speedyhubunlocked" then
		KeyFrame.Visible = false
		AdminFrame.Visible = true
	else
		KeyBox.Text = "Wrong Key!"
	end
end)

--// Fly System
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

local function startFly()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bodyGyro.P = 9e4
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0,0,0)
	bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bodyVelocity.Parent = hrp

	flying = true

	RunService.RenderStepped:Connect(function()
		if flying then
			local camCF = workspace.CurrentCamera.CFrame
			local moveVec = Vector3.new(0,0,0)

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveVec = moveVec + camCF.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveVec = moveVec - camCF.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveVec = moveVec - camCF.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveVec = moveVec + camCF.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveVec = moveVec + Vector3.new(0,1,0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveVec = moveVec - Vector3.new(0,1,0)
			end

			bodyVelocity.Velocity = moveVec * flySpeed
			bodyGyro.CFrame = camCF
		end
	end)
end

local function stopFly()
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	flying = false
end

FlyBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		FlyBtn.Text = "Fly"
	else
		startFly()
		FlyBtn.Text = "Stop Fly"
	end
end)

-- Update speed from box
SpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(SpeedBox.Text)
		if val then
			flySpeed = val
			SpeedBox.Text = "Fly Speed: " .. flySpeed
		else
			SpeedBox.Text = "Invalid"
		end
	end
end)

--// Noclip
local noclip = false
NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipBtn.Text = noclip and "Stop Noclip" or "Noclip"
end)

RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

--// Sword giver
local function makeSword()
	local sword = Instance.new("Tool")
	sword.RequiresHandle = true
	sword.Name = "AdminSword"

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1,4,1)
	handle.Color = Color3.fromRGB(200,200,200)
	handle.Parent = sword

	local dmg = 30
	sword.Activated:Connect(function()
		local char = player.Character
		if not char then return end
		local ray = Ray.new(handle.Position, char.PrimaryPart.CFrame.LookVector * 5)
		local hit, pos = workspace:FindPartOnRay(ray, char)
		if hit and hit.Parent:FindFirstChildOfClass("Humanoid") then
			hit.Parent:FindFirstChildOfClass("Humanoid"):TakeDamage(dmg)
		end
	end)

	return sword
end

SwordBtn.MouseButton1Click:Connect(function()
	local backpack = player:WaitForChild("Backpack")
	if not backpack:FindFirstChild("AdminSword") then
		local sword = makeSword()
		sword.Parent = backpack
	end
end)
