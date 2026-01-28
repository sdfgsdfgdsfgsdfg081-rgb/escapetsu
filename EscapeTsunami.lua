--==================== Marouf's Hub ====================--
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--==================== GUI ====================--
local gui = Instance.new("ScreenGui")
gui.Name = "MaroufsHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

--==================== LOGO (SQUARE + WHITE GLOW) ====================--
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.fromOffset(56,56)
logo.Position = UDim2.fromScale(0.05,0.5)
logo.Text = "M"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 26
logo.TextColor3 = Color3.new(1,1,1)
logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
logo.BorderSizePixel = 0
logo.Active = true
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0,8)
local logoStroke = Instance.new("UIStroke", logo)
logoStroke.Color = Color3.fromRGB(255,255,255)
logoStroke.Thickness = 2
logoStroke.Transparency = 0.15

--==================== PANEL (GLASS + RED GLOW) ====================--
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromOffset(430,370)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(15,15,15)
panel.BackgroundTransparency = 0.3
panel.Visible = false
panel.Active = true
panel.Draggable = true
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,18)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = Color3.fromRGB(200,40,40)
panelStroke.Thickness = 2
panelStroke.Transparency = 0.1

--==================== TITLE ====================--
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundColor3 = Color3.fromRGB(140,30,30)
title.BackgroundTransparency = 0.2
title.Text = "☢️ Marouf's Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0,18)

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
	holder.BackgroundColor3 = Color3.fromRGB(70,50,120)
	holder.BorderSizePixel = 0
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,12)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.new(0.7,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextColor3 = Color3.fromRGB(255,255,255)

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0.25,0,0.7,0)
	btn.Position = UDim2.new(0.72,0,0.15,0)
	btn.Text = "OFF"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(25,25,25)
	btn.BackgroundColor3 = Color3.fromRGB(240,240,240)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	return btn
end

--==================== SUPER JUMP ====================--
local superJump = false
local sjBtn = createSwitch("🦘 Super Jump")
sjBtn.MouseButton1Click:Connect(function()
	superJump = not superJump
	sjBtn.Text = superJump and "ON" or "OFF"
end)

UIS.JumpRequest:Connect(function()
	if superJump and player.Character then
		local hum = player.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.RootPart then
			hum.RootPart.Velocity += Vector3.new(0,10,0) -- weaker super jump
		end
	end
end)

--==================== SECRET NUKE TP ====================--
local secret = false
local nukeBtn = createSwitch("☢️ Secret Nuke TP")
nukeBtn.MouseButton1Click:Connect(function()
	secret = not secret
	nukeBtn.Text = secret and "ON" or "OFF"
end)
mouse.Button1Down:Connect(function()
	if secret and mouse.Hit and player.Character then
		player.Character:MoveTo(mouse.Hit.Position + Vector3.new(0,3,0))
	end
end)

--==================== SAFE TP FUNCTION (STRONG) ====================--
local function safeTP(pos)
	if not player.Character then return end
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	local hum = player.Character:FindFirstChildOfClass("Humanoid")
	if hrp and hum then
		hum.PlatformStand = true
		hrp.Anchored = true
		hrp.CFrame = CFrame.new(pos)
		task.wait(0.05)
		hrp.Anchored = false
		hum.PlatformStand = false
	end
end

--==================== CREATE TP BUTTON WITH GLOW ====================--
local function createTP(text,pos)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1,0,0,36)
	b.Text = text
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(90,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

	local stroke = Instance.new("UIStroke", b)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 1
	stroke.Transparency = 0.6

	b.MouseButton1Click:Connect(function()
		safeTP(pos)
		-- Glowy Pulse Animation
		local tween = TweenService:Create(stroke,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,true),{Transparency=0})
		tween:Play()
		tween.Completed:Connect(function()
			stroke.Transparency = 0.6
		end)
	end)
end

--==================== ALL TPS ====================--
local coords = {
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
local names = {"TP 1","TP 2","TP 3","TP 4","TP 5","TP 6","TP 7","TP 8","⭐ SPECIAL TP","TP (Spawn - Beta)"}
for i,v in ipairs(coords) do createTP(names[i],v) end

--==================== SITE COORDINATES ====================--
local siteCoords = false
local siteBtn = createSwitch("🌐 Site Coordinates")
local sitePanel
siteBtn.MouseButton1Click:Connect(function()
	siteCoords = not siteCoords
	siteBtn.Text = siteCoords and "ON" or "OFF"
	if siteCoords then
		sitePanel = Instance.new("Frame", gui)
		sitePanel.Size = UDim2.fromOffset(180,60)
		sitePanel.Position = UDim2.fromScale(0.8,0.7)
		sitePanel.AnchorPoint = Vector2.new(0.5,0.5)
		sitePanel.BackgroundColor3 = Color3.fromRGB(90,200,240)
		sitePanel.BackgroundTransparency = 0.2
		sitePanel.Active = true
		sitePanel.Draggable = true
		Instance.new("UICorner", sitePanel).CornerRadius = UDim.new(0,12)

		local label = Instance.new("TextButton", sitePanel)
		label.Size = UDim2.fromScale(1,1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextColor3 = Color3.new(1,1,1)

		label.MouseButton1Click:Connect(function()
			if label.Text ~= "" then
				setclipboard(label.Text)
			end
		end)

		RunService.RenderStepped:Connect(function()
			if sitePanel then
				local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
				if pos then
					label.Text = string.format("X: %.1f Y: %.1f Z: %.1f", pos.X,pos.Y,pos.Z)
				end
			end
		end)
	else
		if sitePanel then sitePanel:Destroy() end
	end
end)

--==================== TOGGLE PANEL ====================--
logo.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)
