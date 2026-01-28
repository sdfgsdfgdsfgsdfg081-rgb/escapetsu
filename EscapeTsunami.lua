--==================== Marouf's Hub – Ultimate Panel All-in-One ====================--
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--==================== GUI ====================--
local gui = Instance.new("ScreenGui")
gui.Name = "MaroufsHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

--==================== LOGO ====================--
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.fromOffset(56,56)
logo.Position = UDim2.fromScale(0.05,0.5)
logo.Text = "M"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 26
logo.TextColor3 = Color3.fromRGB(255,255,255)
logo.BackgroundColor3 = Color3.fromRGB(25,25,25)
logo.BorderSizePixel = 0
logo.Active = true
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0,8)
local logoStroke = Instance.new("UIStroke", logo)
logoStroke.Color = Color3.fromRGB(255,255,255)
logoStroke.Thickness = 2
logoStroke.Transparency = 0.2

--==================== PANEL ====================--
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromOffset(460,480)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(30,30,35)
panel.BackgroundTransparency = 0.25
panel.Visible = false
panel.Active = true
panel.Draggable = true
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,18)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = Color3.fromRGB(200,40,40)
panelStroke.Thickness = 2
panelStroke.Transparency = 0.2

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "☢️ Marouf's Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220,220,220)

--==================== SCROLL ====================--
local scroll = Instance.new("ScrollingFrame", panel)
scroll.Position = UDim2.fromOffset(12,55)
scroll.Size = UDim2.new(1,-24,1,-67)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

--==================== SWITCH CREATOR ====================--
local function createSwitch(text)
	local holder = Instance.new("Frame", scroll)
	holder.Size = UDim2.new(1,0,0,40)
	holder.BackgroundColor3 = Color3.fromRGB(45,35,60)
	holder.BorderSizePixel = 0
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,12)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.new(0.7,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextColor3 = Color3.fromRGB(230,230,230)

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0.25,0,0.7,0)
	btn.Position = UDim2.new(0.72,0,0.15,0)
	btn.Text = "OFF"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(25,25,25)
	btn.BackgroundColor3 = Color3.fromRGB(200,200,200)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	return holder, btn
end

--==================== LOGIC VARIABLES ====================--
local ghostOn, superJumpOn, secretNukeOn, siteOn, tpSectionOn = false, false, false, false, false
local noclipConnection
local sitePanel
local tweening, selectedTPIndex = false, nil
local tpButtons = {}

--==================== GHOST MODE ====================--
local ghostHolder, ghostBtn = createSwitch("👻 GHOST MODE")
ghostBtn.MouseButton1Click:Connect(function()
	ghostOn = not ghostOn
	ghostBtn.Text = ghostOn and "ON" or "OFF"
	if ghostOn then
		if noclipConnection then noclipConnection:Disconnect() end
		noclipConnection = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				for _,v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end)
	else
		if noclipConnection then noclipConnection:Disconnect() noclipConnection=nil end
	end
end)

--==================== SUPER JUMP ====================--
local jumpHolder, jumpBtn = createSwitch("🦘 SUPER JUMP")
jumpBtn.MouseButton1Click:Connect(function()
	superJumpOn = not superJumpOn
	jumpBtn.Text = superJumpOn and "ON" or "OFF"
end)
UIS.JumpRequest:Connect(function()
	if superJumpOn then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hum = char:FindFirstChild("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
			local root = char.HumanoidRootPart
			root.Velocity = Vector3.new(root.Velocity.X,35,root.Velocity.Z)
		end
	end
end)

--==================== SECRET NUKE ====================--
local nukeHolder, nukeBtn = createSwitch("☢️ SECRET NUKE")
secretNukeOn = false
nukeBtn.MouseButton1Click:Connect(function()
	secretNukeOn = not secretNukeOn
	nukeBtn.Text = secretNukeOn and "ON" or "OFF"
end)
mouse.Button1Down:Connect(function()
	if secretNukeOn then
		local pos = mouse.Hit.Position
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
		end
	end
end)

--==================== SITE COORDINATES ====================--
local siteHolder, siteBtn = createSwitch("🌐 SITE COORDINATES")
siteBtn.MouseButton1Click:Connect(function()
	siteOn = not siteOn
	siteBtn.Text = siteOn and "ON" or "OFF"
	if siteOn then
		if not sitePanel then
			sitePanel = Instance.new("TextButton", panel)
			sitePanel.Size = UDim2.fromOffset(150,40)
			sitePanel.Position = UDim2.fromScale(0.6,0.1)
			sitePanel.BackgroundColor3 = Color3.fromRGB(50,50,50)
			sitePanel.TextColor3 = Color3.fromRGB(255,255,255)
			sitePanel.Font = Enum.Font.GothamBold
			sitePanel.TextScaled = true
			sitePanel.AutoButtonColor = false
			Instance.new("UICorner", sitePanel).CornerRadius = UDim.new(0,10)
			RunService.RenderStepped:Connect(function()
				if siteOn and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local p = player.Character.HumanoidRootPart.Position
					sitePanel.Text = string.format("X: %.1f Y: %.1f Z: %.1f", p.X, p.Y, p.Z)
				end
			end)
			sitePanel.MouseButton1Click:Connect(function()
				setclipboard(sitePanel.Text)
			end)
		end
		sitePanel.Visible = true
	else
		if sitePanel then sitePanel.Visible = false end
	end
end)

--==================== TP SECTION ====================--
local tpHolder, tpBtn = createSwitch("📍 TP Section")
local tpCoords = {
	Vector3.new(845.9,-1.9,48),
	Vector3.new(824.2,-1.9,136.2),
	Vector3.new(769.4,-1.9,319.7),
	Vector3.new(732.7,-1.9,648.5),
	Vector3.new(818.4,-1.9,1160.9),
	Vector3.new(759.4,-1.9,1745.8),
	Vector3.new(769.7,-1.9,2467.2),
	Vector3.new(768.3,-1.9,3450.7),
	Vector3.new(805.1,-1.9,4748.9),
	Vector3.new(791.6,3.6,-94.2)
}

local tpFrames = {}
tpBtn.MouseButton1Click:Connect(function()
	tpSectionOn = not tpSectionOn
	tpBtn.Text = tpSectionOn and "ON" or "OFF"

	for _,v in pairs(tpFrames) do
		v.Visible = tpSectionOn
	end

	if #tpFrames == 0 then
		for i,pos in ipairs(tpCoords) do
			local b = Instance.new("TextButton", scroll)
			b.Size = UDim2.new(0.15,0,0,30)
			b.Position = UDim2.new(0.05,0,0,(i-1)*35 + 200)
			b.Text = tostring(i)
			b.Font = Enum.Font.GothamBold
			b.TextSize = 14
			b.TextColor3 = Color3.new(1,1,1)
			b.BackgroundColor3 = Color3.fromRGB(50,50,80)
			b.BorderSizePixel = 0
			Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
			b.MouseButton1Click:Connect(function()
				selectedTPIndex=i
			end)
			table.insert(tpFrames,b)
		end

		local startBtn = Instance.new("TextButton", scroll)
		startBtn.Size = UDim2.new(0.35,0,0,35)
		startBtn.Position = UDim2.new(0.05,0,0,450)
		startBtn.Text = "Start Tween"
		startBtn.Font = Enum.Font.GothamBold
		startBtn.TextSize = 14
		startBtn.TextColor3 = Color3.new(1,1,1)
		startBtn.BackgroundColor3 = Color3.fromRGB(70,160,70)
		Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,10)

		local stopBtn = Instance.new("TextButton", scroll)
		stopBtn.Size = UDim2.new(0.35,0,0,35)
		stopBtn.Position = UDim2.new(0.55,0,0,450)
		stopBtn.Text = "Stop Tween"
		stopBtn.Font = Enum.Font.GothamBold
		stopBtn.TextSize = 14
		stopBtn.TextColor3 = Color3.new(1,1,1)
		stopBtn.BackgroundColor3 = Color3.fromRGB(160,70,70)
		Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,10)

		startBtn.MouseButton1Click:Connect(function()
			if selectedTPIndex then
				tweening = true
				spawn(function()
					while tweening do
						local pos = tpCoords[selectedTPIndex]
						if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
							player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
						end
						task.wait(0.01)
					end
				end)
			end
		end)
		stopBtn.MouseButton1Click:Connect(function()
			tweening=false
		end)
	end
end)

--==================== TOGGLE PANEL ====================--
logo.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)
