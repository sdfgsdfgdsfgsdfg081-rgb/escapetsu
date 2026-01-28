--// MQ Hub – Steal + TP Hub ☢️
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") -- for simulating E
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MQHub"
gui.ResetOnSpawn = false

-- ===== LOGO (MQ) =====
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.fromOffset(70,70)
logo.Position = UDim2.fromScale(0.05,0.5)
logo.AnchorPoint = Vector2.new(0.5,0.5)
logo.BackgroundColor3 = Color3.fromRGB(30,30,30)
logo.BackgroundTransparency = 0.5
logo.Text = "MQ"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 28
logo.TextColor3 = Color3.fromRGB(170,0,170)
logo.BorderSizePixel = 0
logo.Active = true
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0,14)
local logoGlow = Instance.new("UIStroke", logo)
logoGlow.Thickness = 4
logoGlow.Color = Color3.fromRGB(100,0,100)
logoGlow.Transparency = 0.3
logoGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ===== MAIN PANEL =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(480,400)
frame.Position = UDim2.fromScale(0.5,0.5)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- ===== TOP BAR =====
local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1,0,0,50)
top.BackgroundColor3 = Color3.fromRGB(50,10,80)
top.BackgroundTransparency = 0.3
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "☢️ MQ Hub"
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(200,50,200)
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(100,0,100)
title.TextScaled = true

-- ===== SCROLL =====
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.fromOffset(12,60)
scroll.Size = UDim2.new(1,-24,1,-72)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,10)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- ===== SWITCH CREATOR =====
local function createSwitch(text)
	local sw = Instance.new("Frame", scroll)
	sw.Size = UDim2.new(1,0,0,32)
	sw.BackgroundTransparency = 1

	local lbl = Instance.new("TextLabel", sw)
	lbl.Size = UDim2.new(0.7,0,1,0)
	lbl.Position = UDim2.new(0,0,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(255,255,255)
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local switch = Instance.new("Frame", sw)
	switch.Size = UDim2.new(0.25,0,0.6,0)
	switch.Position = UDim2.new(0.75,0,0.2,0)
	switch.BackgroundColor3 = Color3.fromRGB(170,0,0)
	switch.BorderSizePixel = 0
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", switch)
	knob.Size = UDim2.new(0.5,0,1,0)
	knob.Position = UDim2.new(0,0,0,0)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = false
	switch.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			knob:TweenPosition(state and UDim2.new(0.5,0,0,0) or UDim2.new(0,0,0,0),"Out","Quad",0.15,true)
			switch.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
		end
	end)

	return sw, function() return state end, switch
end

-- ===== SWITCHES =====
local tpSwitch, tpState = createSwitch("🛠️ TP Section")
local autoGrabSwitch, autoGrabState, autoSwitchFrame = createSwitch("🤲 Auto Grab")
local siteSwitch, siteState = createSwitch("🌐 Site Coordinates")

-- ===== AUTO GRAB / STEAL PANEL =====
local stealPanel
local stealing = false
local stealLoop
autoGrabSwitch.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if stealPanel then
			stealPanel:Destroy()
			stealPanel = nil
			stealing = false
			if stealLoop then stealLoop:Disconnect() end
		elseif autoGrabState() then
			-- CREATE STEAL PANEL
			stealPanel = Instance.new("Frame", gui)
			stealPanel.Size = UDim2.fromOffset(180,60)
			stealPanel.Position = UDim2.fromScale(0.75,0.6)
			stealPanel.AnchorPoint = Vector2.new(0.5,0.5)
			stealPanel.Active = true
			stealPanel.Draggable = true
			stealPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
			stealPanel.BackgroundTransparency = 0.3
			Instance.new("UICorner", stealPanel).CornerRadius = UDim.new(0,12)

			local stealBtn = Instance.new("TextButton", stealPanel)
			stealBtn.Size = UDim2.fromScale(1,1)
			stealBtn.BackgroundTransparency = 1
			stealBtn.Text = "Steal"
			stealBtn.Font = Enum.Font.GothamBold
			stealBtn.TextColor3 = Color3.fromRGB(255,255,255)
			stealBtn.TextScaled = true

			local active = false
			stealBtn.MouseButton1Click:Connect(function()
				active = not active
				stealBtn.BackgroundColor3 = active and Color3.fromRGB(0,170,0) or Color3.fromRGB(30,30,30)
				stealing = active
			end)

			-- Steal Loop
			stealLoop = RunService.RenderStepped:Connect(function()
				if stealing and autoGrabState() then
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						for _,obj in pairs(workspace:GetDescendants()) do
							if obj:IsA("Tool") and obj:FindFirstChild("Handle") and (obj.Handle.Position - char.HumanoidRootPart.Position).Magnitude < 8 then
								-- HOLD E for grabbing
								if obj.Parent ~= char then
									VirtualUser:Button1Down(Vector2.new())
									task.wait(0.01)
									obj.Parent = char
									VirtualUser:Button1Up(Vector2.new())
								end
							end
						end
					end
				end
			end)
		end
	end
end)

-- ===== SITE COORDINATES =====
local sitePanel
siteSwitch.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if sitePanel then sitePanel:Destroy() end
		if siteState() then
			sitePanel = Instance.new("Frame", gui)
			sitePanel.Size = UDim2.fromOffset(180,50)
			sitePanel.Position = UDim2.fromScale(0.75,0.2)
			sitePanel.Active = true
			sitePanel.Draggable = true
			sitePanel.BackgroundColor3 = Color3.fromRGB(50,50,50)
			sitePanel.BackgroundTransparency = 0.3
			Instance.new("UICorner", sitePanel).CornerRadius = UDim.new(0,12)

			local lbl = Instance.new("TextButton", sitePanel)
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.Font = Enum.Font.GothamBold
			lbl.TextColor3 = Color3.fromRGB(255,255,255)
			lbl.TextScaled = true
			lbl.MouseButton1Click:Connect(function() setclipboard(lbl.Text) end)

			RunService.RenderStepped:Connect(function()
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					lbl.Text = string.format("X: %.1f Y: %.1f Z: %.1f",
						char.HumanoidRootPart.Position.X,
						char.HumanoidRootPart.Position.Y,
						char.HumanoidRootPart.Position.Z)
				end
			end)
		end
	end
end)

-- ===== TP SECTION =====
local tpPanel
local tpCoords = {
	Vector3.new(845.9, -1.9, 48),
	Vector3.new(824.2, -1.9, 136.2),
	Vector3.new(769.4, -1.9, 319.7),
	Vector3.new(732.7, -1.9, 648.5),
	Vector3.new(818.4, -1.9, 1160.9),
	Vector3.new(759.4, -1.9, 1745.8),
	Vector3.new(769.7, -1.9, 2467.2),
	Vector3.new(768.3, -1.9, 3450.7),
	Vector3.new(805.1,-1.9,4748.9),
	Vector3.new(791.6,3.6,-94.2)
}

tpSwitch.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if tpPanel then
			tpPanel:Destroy()
			tpPanel = nil
		elseif tpState() then
			tpPanel = Instance.new("Frame", gui)
			tpPanel.Size = UDim2.fromOffset(220,300)
			tpPanel.Position = UDim2.fromScale(0.8,0.5)
			tpPanel.AnchorPoint = Vector2.new(0.5,0.5)
			tpPanel.Active = true
			tpPanel.Draggable = true
			tpPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
			tpPanel.BackgroundTransparency = 0.3
			Instance.new("UICorner", tpPanel).CornerRadius = UDim.new(0,14)

			local layout = Instance.new("UIListLayout", tpPanel)
			layout.Padding = UDim.new(0,6)

			local selected = nil
			for i,pos in ipairs(tpCoords) do
				local b = Instance.new("TextButton", tpPanel)
				b.Size = UDim2.new(1,0,0,30)
				b.BackgroundColor3 = Color3.fromRGB(50,50,50)
				b.TextColor3 = Color3.fromRGB(255,255,255)
				b.Text = "TP "..i
				b.Font = Enum.Font.GothamBold
				b.TextScaled = true
				b.MouseButton1Click:Connect(function()
					selected = pos
				end)
				Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
			end

			local startBtn = Instance.new("TextButton", tpPanel)
			startBtn.Position = UDim2.new(0,0,1,-60)
			startBtn.Size = UDim2.new(0.5,-5,0,30)
			startBtn.Text = "Start Tween"
			startBtn.Font = Enum.Font.GothamBold
			startBtn.TextColor3 = Color3.fromRGB(255,255,255)
			startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
			Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,10)

			local stopBtn = Instance.new("TextButton", tpPanel)
			stopBtn.Position = UDim2.new(0.5,5,1,-60)
			stopBtn.Size = UDim2.new(0.5,-5,0,30)
			stopBtn.Text = "Stop Tween"
			stopBtn.Font = Enum.Font.GothamBold
			stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
			stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
			Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,10)

			local tweening = false
			local delayTime = 0.0008
			startBtn.MouseButton1Click:Connect(function()
				tweening = true
				spawn(function()
					while tweening and selected do
						local char = player.Character
						if char and char:FindFirstChild("HumanoidRootPart") then
							char.HumanoidRootPart.CFrame = CFrame.new(selected)
						end
						task.wait(delayTime)
					end
				end)
			end)
			stopBtn.MouseButton1Click:Connect(function()
				tweening = false
			end)
		end
	end
end)

-- ===== TOGGLE MAIN PANEL =====
logo.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
