-- Ultimate Super Panel v15 – With Nuke Icon Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateSuperPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== SMALL NUKE LOGO =====
local nukeIcon = Instance.new("TextButton")
nukeIcon.Size = UDim2.fromOffset(50,50)
nukeIcon.Position = UDim2.fromScale(0.9,0.1)
nukeIcon.BackgroundColor3 = Color3.fromRGB(255,60,60)
nukeIcon.Text = "☢"
nukeIcon.TextScaled = true
nukeIcon.Font = Enum.Font.GothamBold
nukeIcon.TextColor3 = Color3.fromRGB(0,0,0)
nukeIcon.Parent = gui
nukeIcon.Active = true
nukeIcon.Draggable = true
Instance.new("UICorner", nukeIcon).CornerRadius = UDim.new(0,10)

-- ===== MAIN PANEL =====
local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(0.22,0.55)
frame.Position = UDim2.fromScale(0.38,0.2)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1,0.1)
title.Position = UDim2.fromScale(0,0)
title.BackgroundTransparency = 1
title.Text = "ULTIMATE PANEL"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = frame

-- ===== SCROLLING FRAME =====
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.fromScale(1,0.9)
scroll.Position = UDim2.fromScale(0,0.1)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local uiLayout = Instance.new("UIListLayout")
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0,4)
uiLayout.Parent = scroll

local function updateCanvas()
	scroll.CanvasSize = UDim2.new(0,0,0,uiLayout.AbsoluteContentSize.Y + 10)
end

-- ===== SWITCH CREATOR =====
local function createSwitch(parent,text)
	local switch = Instance.new("Frame")
	switch.Size = UDim2.fromScale(0.9,0.065)
	switch.BackgroundColor3 = Color3.fromRGB(170,0,0)
	switch.BorderSizePixel = 0
	switch.Parent = parent
	Instance.new("UICorner", switch).CornerRadius = UDim.new(0,12)

	local knob = Instance.new("TextButton")
	knob.Size = UDim2.fromScale(0.45,1)
	knob.Position = UDim2.fromScale(0,0)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.Text = ""
	knob.BorderSizePixel = 0
	knob.Parent = switch
	Instance.new("UICorner", knob).CornerRadius = UDim.new(0,12)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1,1)
	label.Position = UDim2.fromScale(0,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.TextScaled = true
	label.Parent = switch

	return switch, knob
end

-- ===== SWITCHES =====
local ghostSwitch, ghostKnob = createSwitch(scroll,"GHOST MODE")
local jumpSwitch, jumpKnob = createSwitch(scroll,"INF JUMP")
local secretNukeSwitch, secretNukeKnob = createSwitch(scroll,"SECRET NUKE")
local aSwitch, aKnob = createSwitch(scroll,"A PANEL")

-- ===== TP BUTTON CREATOR =====
local function createTPButton(parent,text,position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.9,0.055)
	btn.BackgroundColor3 = Color3.fromRGB(0,0,255)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	btn.MouseButton1Click:Connect(function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(position)
		end
	end)
	return btn
end

-- TP Buttons 1-8 + Special
local tpCoords = {
	Vector3.new(845.9, -1.9, 48.0),
	Vector3.new(824.2, -1.9, 136.2),
	Vector3.new(769.4, -1.9, 319.7),
	Vector3.new(732.7, -1.9, 648.5),
	Vector3.new(818.4, -1.9, 1160.9),
	Vector3.new(759.4, -1.9, 1745.8),
	Vector3.new(769.7, -1.9, 2467.2),
	Vector3.new(768.3, -1.9, 3450.7)
}

for i,pos in ipairs(tpCoords) do
	createTPButton(scroll,"TP "..i,pos)
end
createTPButton(scroll,"TP SPECIAL",Vector3.new(805.1,-1.9,4748.9))
updateCanvas()

-- ===== LOGIC VARIABLES =====
local ghostOn = false
local jumpOn = false
local secretNukeOn = false
local aPanelOn = false
local noclipConnection
local aPanel
local aTextButton

-- GHOST MODE
local function setNoclip(state)
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			local char = player.Character
			if not char then return end
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	end
end

ghostKnob.MouseButton1Click:Connect(function()
	if not ghostOn then
		ghostKnob:TweenPosition(UDim2.new(0.55,0,0,0),"Out","Quad",0.15,true)
		ghostSwitch.BackgroundColor3 = Color3.fromRGB(0,170,0)
		ghostOn = true
		setNoclip(true)
	else
		ghostKnob:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.15,true)
		ghostSwitch.BackgroundColor3 = Color3.fromRGB(170,0,0)
		ghostOn = false
		setNoclip(false)
	end
end)

-- INF JUMP
jumpKnob.MouseButton1Click:Connect(function()
	if not jumpOn then
		jumpKnob:TweenPosition(UDim2.new(0.55,0,0,0),"Out","Quad",0.15,true)
		jumpSwitch.BackgroundColor3 = Color3.fromRGB(0,170,0)
		jumpOn = true
	else
		jumpKnob:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.15,true)
		jumpSwitch.BackgroundColor3 = Color3.fromRGB(170,0,0)
		jumpOn = false
	end
end)

UserInputService.JumpRequest:Connect(function()
	if jumpOn then
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
			local hum = char.Humanoid
			local root = char.HumanoidRootPart
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			root.Velocity = Vector3.new(root.Velocity.X,50,root.Velocity.Z)
		end
	end
end)

-- SECRET NUKE LOGIC
secretNukeKnob.MouseButton1Click:Connect(function()
	if not secretNukeOn then
		secretNukeKnob:TweenPosition(UDim2.new(0.55,0,0,0),"Out","Quad",0.15,true)
		secretNukeSwitch.BackgroundColor3 = Color3.fromRGB(0,170,0)
		secretNukeOn = true
	else
		secretNukeKnob:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.15,true)
		secretNukeSwitch.BackgroundColor3 = Color3.fromRGB(170,0,0)
		secretNukeOn = false
	end
end)

mouse.Button1Down:Connect(function()
	if secretNukeOn then
		local targetPos = mouse.Hit.Position
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0,3,0))
		end
	end
end)

-- ===== A PANEL LOGIC =====
aKnob.MouseButton1Click:Connect(function()
	if not aPanelOn then
		aKnob:TweenPosition(UDim2.new(0.55,0,0,0),"Out","Quad",0.15,true)
		aSwitch.BackgroundColor3 = Color3.fromRGB(0,170,0)
		aPanelOn = true
		aPanel = Instance.new("Frame",gui)
		aPanel.Size = UDim2.fromOffset(200,100)
		aPanel.Position = UDim2.fromScale(0.5,0.5)
		aPanel.AnchorPoint = Vector2.new(0.5,0.5)
		aPanel.BackgroundColor3 = Color3.fromRGB(220,220,220)
		aPanel.Active = true
		aPanel.Draggable = true
		Instance.new("UICorner", aPanel).CornerRadius = UDim.new(0,10)
		aTextButton = Instance.new("TextButton",aPanel)
		aTextButton.Size = UDim2.fromScale(1,1)
		aTextButton.BackgroundTransparency = 1
		aTextButton.TextScaled = true
		aTextButton.Font = Enum.Font.GothamBold
		aTextButton.TextColor3 = Color3.fromRGB(0,0,0)
		RunService.RenderStepped:Connect(function()
			if aPanelOn and aTextButton then
				local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
				if pos then
					aTextButton.Text = string.format("X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
				end
			end
		end)
		aTextButton.MouseButton1Click:Connect(function()
			if aTextButton.Text then
				setclipboard(aTextButton.Text)
			end
		end)
	else
		aKnob:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.15,true)
		aSwitch.BackgroundColor3 = Color3.fromRGB(170,0,0)
		aPanelOn = false
		if aPanel then aPanel:Destroy() end
	end
end)

-- ===== NUKE ICON TOGGLE PANEL =====
nukeIcon.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- REAPPLY GHOST ON RESPAWN
player.CharacterAdded:Connect(function()
	if ghostOn then
		task.wait(0.2)
		local char = player.Character
		if char then
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end
end)
