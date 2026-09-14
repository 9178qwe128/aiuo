-- ============================================================
-- 小黑鱼 UI · 圣奥里专属 · 完整版 A7
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local BRAND_NAME = "小黑鱼"
local CURRENT_PLACE_ID = game.PlaceId
local SAINT_PLACE_ID = 104841616983113
local buildDefaultUI
local buildSaintUI

local CONFIG = {
    WINDOW_SIZE = UDim2.new(0, 620, 0, 420),
    SIDEBAR_WIDTH = 150,
    MINIMIZED_SIZE = UDim2.new(0, 200, 0, 40),
    HEADER_HEIGHT = 40,
    GLASS_TRANSPARENCY = 0.35,
    GLASS_COLOR = Color3.fromRGB(20, 20, 30),
    ACCENT_COLOR = Color3.fromRGB(120, 80, 255),
    TWEEN_TIME = 0.25,
    NORMAL_RADIUS = UDim.new(0, 12),
    PILL_RADIUS = UDim.new(1, 0),
}
local PHONE_POS_X = 0.85
local PHONE_POS_Y = 0.35

local Log = {
    lines = {}, label = nil, maxLines = 200,
    colors = {
        green=Color3.fromRGB(120,255,160), red=Color3.fromRGB(255,100,100),
        yellow=Color3.fromRGB(255,220,100), blue=Color3.fromRGB(120,180,255),
        gray=Color3.fromRGB(160,160,180), white=Color3.fromRGB(230,230,240),
    },
}
function Log.setLabel(lbl) Log.label = lbl; Log.refresh() end
function Log.refresh()
    if not Log.label then return end
    Log.label.Text = table.concat(Log.lines, "\n")
    local p = Log.label.Parent
    if p and p:IsA("ScrollingFrame") then
        p.CanvasPosition = Vector2.new(0, math.max(0, Log.label.AbsoluteSize.Y - p.AbsoluteSize.Y + 20))
    end
end
function Log.add(text, colorName)
    local c = Log.colors[colorName or "white"] or Log.colors.white
    local hex = string.format("#%02X%02X%02X", math.floor(c.R*255+.5), math.floor(c.G*255+.5), math.floor(c.B*255+.5))
    local ts = os.date("%H:%M:%S")
    table.insert(Log.lines, string.format("[%s] <font color=\"%s\">%s</font>", ts, hex, text))
    if #Log.lines > Log.maxLines then table.remove(Log.lines, 1) end
    Log.refresh()
end
function Log.clear() Log.lines = {}; Log.refresh() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XiaoHeiYuUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local uiScale = Instance.new("UIScale")
uiScale.Parent = screenGui
local function updateScale()
    local vp = workspace.CurrentCamera.ViewportSize
    uiScale.Scale = math.clamp(vp.X / 1280, 0.7, 1.4)
end
updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local authOverlay = Instance.new("Frame")
authOverlay.Size = UDim2.new(1, 0, 1, 0)
authOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
authOverlay.BackgroundTransparency = 0.4
authOverlay.BorderSizePixel = 0
authOverlay.ZIndex = 500
authOverlay.Parent = screenGui

local authCard = Instance.new("Frame")
authCard.Size = UDim2.new(0, 340, 0, 240)
authCard.Position = UDim2.new(0.5, 0, 0.5, 0)
authCard.AnchorPoint = Vector2.new(0.5, 0.5)
authCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
authCard.BackgroundTransparency = 0.05
authCard.BorderSizePixel = 0
authCard.ZIndex = 501
authCard.Parent = authOverlay
Instance.new("UICorner", authCard).CornerRadius = UDim.new(0, 14)

local authStroke = Instance.new("UIStroke")
authStroke.Color = Color3.fromRGB(120, 80, 255)
authStroke.Thickness = 1.5
authStroke.Transparency = 0.4
authStroke.Parent = authCard

local authTitle = Instance.new("TextLabel")
authTitle.Size = UDim2.new(1, 0, 0, 40)
authTitle.Position = UDim2.new(0, 0, 0, 20)
authTitle.BackgroundTransparency = 1
authTitle.Text = "🐟 " .. BRAND_NAME .. " · 卡密验证"
authTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
authTitle.TextSize = 18
authTitle.Font = Enum.Font.GothamBold
authTitle.ZIndex = 502
authTitle.Parent = authCard

local authSub = Instance.new("TextLabel")
authSub.Size = UDim2.new(1, 0, 0, 20)
authSub.Position = UDim2.new(0, 0, 0, 60)
authSub.BackgroundTransparency = 1
authSub.Text = "公益版 · 随便输都能进"
authSub.TextColor3 = Color3.fromRGB(160, 255, 180)
authSub.TextSize = 12
authSub.Font = Enum.Font.Gotham
authSub.ZIndex = 502
authSub.Parent = authCard

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 42)
keyBox.Position = UDim2.new(0.5, 0, 0, 92)
keyBox.AnchorPoint = Vector2.new(0.5, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
keyBox.BackgroundTransparency = 0.1
keyBox.BorderSizePixel = 0
keyBox.Text = ""
keyBox.PlaceholderText = "输入任意内容（或留空）"
keyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 14
keyBox.Font = Enum.Font.GothamMedium
keyBox.ClearTextOnFocus = false
keyBox.ZIndex = 502
keyBox.Parent = authCard
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)

local authStatus = Instance.new("TextLabel")
authStatus.Size = UDim2.new(1, -40, 0, 20)
authStatus.Position = UDim2.new(0, 20, 0, 144)
authStatus.BackgroundTransparency = 1
authStatus.Text = "公益版无需卡密，直接进入"
authStatus.TextColor3 = Color3.fromRGB(120, 255, 160)
authStatus.TextSize = 12
authStatus.Font = Enum.Font.GothamMedium
authStatus.TextXAlignment = Enum.TextXAlignment.Center
authStatus.ZIndex = 502
authStatus.Parent = authCard

local authBtn = Instance.new("TextButton")
authBtn.Size = UDim2.new(1, -40, 0, 42)
authBtn.Position = UDim2.new(0.5, 0, 1, -60)
authBtn.AnchorPoint = Vector2.new(0.5, 0)
authBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
authBtn.BorderSizePixel = 0
authBtn.Text = "进入"
authBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
authBtn.TextSize = 14
authBtn.Font = Enum.Font.GothamBold
authBtn.AutoButtonColor = false
authBtn.ZIndex = 502
authBtn.Parent = authCard
Instance.new("UICorner", authBtn).CornerRadius = UDim.new(0, 8)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = CONFIG.WINDOW_SIZE
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = CONFIG.NORMAL_RADIUS

local glassBg = Instance.new("ImageLabel")
glassBg.Size = UDim2.new(1, 0, 1, 0)
glassBg.BackgroundTransparency = CONFIG.GLASS_TRANSPARENCY
glassBg.BackgroundColor3 = CONFIG.GLASS_COLOR
glassBg.BorderSizePixel = 0
glassBg.Image = ""
glassBg.ZIndex = 1
glassBg.Parent = mainFrame
local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = CONFIG.NORMAL_RADIUS
glassCorner.Parent = glassBg

local glassStroke = Instance.new("UIStroke")
glassStroke.Color = Color3.fromRGB(255, 255, 255)
glassStroke.Transparency = 0.85
glassStroke.Thickness = 1
glassStroke.Parent = glassBg

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, CONFIG.HEADER_HEIGHT)
header.BackgroundTransparency = 1
header.ZIndex = 5
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = CONFIG.NORMAL_RADIUS
headerCorner.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -130, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = BRAND_NAME
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 6
titleLabel.Parent = header

local noticeBtn = Instance.new("TextButton")
noticeBtn.Size = UDim2.new(0, 30, 0, 30)
noticeBtn.Position = UDim2.new(1, -118, 0, 5)
noticeBtn.BackgroundTransparency = 1
noticeBtn.Text = "🔔"
noticeBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
noticeBtn.TextSize = 16
noticeBtn.Font = Enum.Font.GothamBold
noticeBtn.ZIndex = 6
noticeBtn.Parent = header

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.ZIndex = 6
minimizeBtn.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -72, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 6
closeBtn.Parent = header

local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, CONFIG.SIDEBAR_WIDTH, 1, -CONFIG.HEADER_HEIGHT)
sidebar.Position = UDim2.new(0, 0, 0, CONFIG.HEADER_HEIGHT)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 3
sidebar.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
sidebar.ScrollBarImageTransparency = 0.6
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
sidebar.ZIndex = 4
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 4)
sidebarPadding.PaddingBottom = UDim.new(0, 4)
sidebarPadding.PaddingLeft = UDim.new(0, 6)
sidebarPadding.PaddingRight = UDim.new(0, 6)
sidebarPadding.Parent = sidebar

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 1, 1, -CONFIG.HEADER_HEIGHT - 16)
sidebarDivider.Position = UDim2.new(0, CONFIG.SIDEBAR_WIDTH - 1, 0, CONFIG.HEADER_HEIGHT + 8)
sidebarDivider.BackgroundTransparency = 0.7
sidebarDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sidebarDivider.BorderSizePixel = 0
sidebarDivider.ZIndex = 5
sidebarDivider.Parent = mainFrame

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -CONFIG.SIDEBAR_WIDTH, 1, -CONFIG.HEADER_HEIGHT)
contentArea.Position = UDim2.new(0, CONFIG.SIDEBAR_WIDTH, 0, CONFIG.HEADER_HEIGHT)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 4
contentArea.Parent = mainFrame

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, -16, 1, -16)
contentScroll.Position = UDim2.new(0, 8, 0, 8)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 3
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
contentScroll.ScrollBarImageTransparency = 0.6
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.ZIndex = 5
contentScroll.Parent = contentArea

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 4)
contentPadding.PaddingBottom = UDim.new(0, 4)
contentPadding.PaddingLeft = UDim.new(0, 4)
contentPadding.PaddingRight = UDim.new(0, 4)
contentPadding.Parent = contentScroll

local noticePanel = Instance.new("Frame")
noticePanel.Size = UDim2.new(1, -32, 0, 200)
noticePanel.Position = UDim2.new(0.5, 0, 0.5, 0)
noticePanel.AnchorPoint = Vector2.new(0.5, 0.5)
noticePanel.BackgroundTransparency = 0.1
noticePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
noticePanel.BorderSizePixel = 0
noticePanel.Visible = false
noticePanel.ZIndex = 100
noticePanel.Parent = mainFrame
Instance.new("UICorner", noticePanel).CornerRadius = UDim.new(0, 10)

local noticeTitle = Instance.new("TextLabel")
noticeTitle.Size = UDim2.new(1, -50, 0, 30)
noticeTitle.Position = UDim2.new(0, 14, 0, 10)
noticeTitle.BackgroundTransparency = 1
noticeTitle.Text = "📢 " .. BRAND_NAME .. " 公告"
noticeTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
noticeTitle.TextSize = 15
noticeTitle.Font = Enum.Font.GothamBold
noticeTitle.TextXAlignment = Enum.TextXAlignment.Left
noticeTitle.ZIndex = 101
noticeTitle.Parent = noticePanel

local noticeContent = Instance.new("TextLabel")
noticeContent.Size = UDim2.new(1, -28, 1, -58)
noticeContent.Position = UDim2.new(0, 14, 0, 44)
noticeContent.BackgroundTransparency = 1
noticeContent.Text = ""
noticeContent.TextColor3 = Color3.fromRGB(210, 210, 220)
noticeContent.TextSize = 13
noticeContent.Font = Enum.Font.Gotham
noticeContent.TextXAlignment = Enum.TextXAlignment.Left
noticeContent.TextYAlignment = Enum.TextYAlignment.Top
noticeContent.TextWrapped = true
noticeContent.ZIndex = 101
noticeContent.Parent = noticePanel

local noticeClose = Instance.new("TextButton")
noticeClose.Size = UDim2.new(0, 30, 0, 30)
noticeClose.Position = UDim2.new(1, -35, 0, 8)
noticeClose.BackgroundTransparency = 1
noticeClose.Text = "×"
noticeClose.TextColor3 = Color3.fromRGB(200, 100, 100)
noticeClose.TextSize = 18
noticeClose.Font = Enum.Font.GothamBold
noticeClose.ZIndex = 101
noticeClose.Parent = noticePanel

noticeClose.Activated:Connect(function() noticePanel.Visible = false end)
noticeBtn.Activated:Connect(function() noticePanel.Visible = not noticePanel.Visible end)

local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        mainFrame.ZIndex = 100
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging or not dragStart then return end
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = (input.Position - dragStart) / uiScale.Scale
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragStart = nil
        mainFrame.ZIndex = 1
    end
end)

local isMinimized = false
local TWEEN_INFO = TweenInfo.new(CONFIG.TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        sidebar.Visible = false
        sidebarDivider.Visible = false
        contentArea.Visible = false
        closeBtn.Visible = false
        noticeBtn.Visible = false
        minimizeBtn.Text = "+"
        minimizeBtn.TextSize = 20
        minimizeBtn.Position = UDim2.new(1, -36, 0, 5)
        TweenService:Create(mainFrame, TWEEN_INFO, { Size = CONFIG.MINIMIZED_SIZE }):Play()
        TweenService:Create(glassCorner, TWEEN_INFO, { CornerRadius = CONFIG.PILL_RADIUS }):Play()
        TweenService:Create(headerCorner, TWEEN_INFO, { CornerRadius = CONFIG.PILL_RADIUS }):Play()
    else
        TweenService:Create(mainFrame, TWEEN_INFO, { Size = CONFIG.WINDOW_SIZE }):Play()
        TweenService:Create(glassCorner, TWEEN_INFO, { CornerRadius = CONFIG.NORMAL_RADIUS }):Play()
        TweenService:Create(headerCorner, TWEEN_INFO, { CornerRadius = CONFIG.NORMAL_RADIUS }):Play()
        minimizeBtn.Text = "—"
        minimizeBtn.TextSize = 18
        minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
        task.delay(CONFIG.TWEEN_TIME * 0.6, function()
            if not isMinimized then
                sidebar.Visible = true
                sidebarDivider.Visible = true
                contentArea.Visible = true
                closeBtn.Visible = true
                noticeBtn.Visible = true
            end
        end)
    end
end
minimizeBtn.Activated:Connect(toggleMinimize)
closeBtn.Activated:Connect(function() screenGui.Enabled = false end)

local tabs = {}
local activeTab = nil

local function createTab(tabName, iconText)
    local tabData = { name = tabName }
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.ZIndex = 6
    tabButton.LayoutOrder = #tabs + 1
    tabButton.Parent = sidebar
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

    local btnIcon = Instance.new("TextLabel")
    btnIcon.Name = "Icon"
    btnIcon.Size = UDim2.new(0, 30, 1, 0)
    btnIcon.Position = UDim2.new(0, 4, 0, 0)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Text = iconText or "●"
    btnIcon.TextColor3 = Color3.fromRGB(180, 180, 200)
    btnIcon.TextSize = 16
    btnIcon.Font = Enum.Font.Gotham
    btnIcon.ZIndex = 7
    btnIcon.Parent = tabButton

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Name = "Label"
    btnLabel.Size = UDim2.new(1, -40, 1, 0)
    btnLabel.Position = UDim2.new(0, 38, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = tabName
    btnLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    btnLabel.TextSize = 13
    btnLabel.Font = Enum.Font.GothamMedium
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.ZIndex = 7
    btnLabel.Parent = tabButton

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 20)
    indicator.Position = UDim2.new(0, 0, 0.5, -10)
    indicator.BackgroundColor3 = CONFIG.ACCENT_COLOR
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 8
    indicator.Parent = tabButton
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = tabName .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.ZIndex = 5
    contentFrame.Parent = contentScroll

    local innerLayout = Instance.new("UIListLayout")
    innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    innerLayout.Padding = UDim.new(0, 8)
    innerLayout.Parent = contentFrame

    tabData.contentFrame = contentFrame
    tabData.button = tabButton
    tabData.indicator = indicator
    tabData.icon = btnIcon
    tabData.label = btnLabel

    tabButton.Activated:Connect(function()
        if activeTab == tabData then return end
        if activeTab then
            activeTab.contentFrame.Visible = false
            activeTab.indicator.Visible = false
            activeTab.button.BackgroundTransparency = 1
            activeTab.icon.TextColor3 = Color3.fromRGB(180, 180, 200)
            activeTab.label.TextColor3 = Color3.fromRGB(200, 200, 210)
        end
        activeTab = tabData
        contentFrame.Visible = true
        indicator.Visible = true
        tabButton.BackgroundTransparency = 0.85
        tabButton.BackgroundColor3 = CONFIG.ACCENT_COLOR
        btnIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(tabs, tabData)
    if #tabs == 1 then
        activeTab = tabData
        contentFrame.Visible = true
        indicator.Visible = true
        tabButton.BackgroundTransparency = 0.85
        tabButton.BackgroundColor3 = CONFIG.ACCENT_COLOR
        btnIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    return tabData
end

local function resolveParent(target)
    if target and target.contentFrame then return target.contentFrame end
    return target
end

local function addSection(target, sectionTitle)
    local parent = resolveParent(target)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 32)
    section.BackgroundTransparency = 1
    section.ZIndex = 5
    section.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = sectionTitle
    lbl.TextColor3 = Color3.fromRGB(140, 140, 160)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = section
end

local function addButton(target, btnText, callback)
    local parent = resolveParent(target)
    local btn = Instance.new("TextButton")
    btn.Name = btnText
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundTransparency = 0.8
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = btnText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = btn

    btn.Activated:Connect(function()
        if callback then callback(btn, lbl) end
    end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.65 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.8 }):Play()
    end)
    return btn, lbl
end

local function addToggle(target, btnText, defaultState, onChanged, logName)
    local state = defaultState or false
    local btn, lbl = addButton(target, btnText, function(_, label)
        state = not state
        label.Text = btnText .. (state and "   ● 开" or "   ○ 关")
        label.TextColor3 = state and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(220, 220, 230)
        if onChanged then onChanged(state) end
        Log.add((state and "✓ 开启: " or "○ 关闭: ") .. (logName or btnText),
            state and "green" or "yellow")
    end)
    lbl.Text = btnText .. (state and "   ● 开" or "   ○ 关")
    lbl.TextColor3 = state and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(220, 220, 230)
    return btn, lbl
end

local activeSliderDrag = nil
local function addSlider(target, labelText, minVal, maxVal, defaultVal, onChange)
    local parent = resolveParent(target)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundTransparency = 1
    container.ZIndex = 5
    container.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText .. "   " .. tostring(defaultVal)
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -12, 0, 6)
    track.Position = UDim2.new(0, 6, 0, 34)
    track.BackgroundTransparency = 0.55
    track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    track.BorderSizePixel = 0
    track.ZIndex = 5
    track.Parent = container
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = CONFIG.ACCENT_COLOR
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 7
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hitArea = Instance.new("TextButton")
    hitArea.Size = UDim2.new(1, 0, 0, 30)
    hitArea.Position = UDim2.new(0, 0, 0.5, -15)
    hitArea.BackgroundTransparency = 1
    hitArea.Text = ""
    hitArea.ZIndex = 8
    hitArea.Parent = track

    local function setFromX(xPos)
        local rel = math.clamp((xPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        lbl.Text = labelText .. "   " .. tostring(val)
        if onChange then onChange(val) end
    end

    local initRel = (defaultVal - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(initRel, 0, 1, 0)
    knob.Position = UDim2.new(initRel, 0, 0.5, 0)

    hitArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            activeSliderDrag = setFromX
            setFromX(input.Position.X)
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if not activeSliderDrag then return end
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        activeSliderDrag(input.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        activeSliderDrag = nil
    end
end)

local function clearAllTabs()
    for _, c in ipairs(sidebar:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, c in ipairs(contentScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    tabs = {}
    activeTab = nil
end

local function getHRP()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getCurrentVehicle()
    local char = player.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local seat = humanoid.SeatPart
    if not seat then return nil end
    return seat:FindFirstAncestorOfClass("Model"), seat
end

local function forEachVehiclePart(vehicle, fn)
    if not vehicle then return end
    for _, d in ipairs(vehicle:GetDescendants()) do
        if d:IsA("BasePart") then fn(d) end
    end
end

local function firePrompt(prompt)
    if not prompt then return end
    pcall(function() fireproximityprompt(prompt) end)
end

local function teleportTo(pos)
    local hrp = getHRP()
    if not hrp then return false end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    return true
end

-- ============================================================
-- 🛡 防封 A6 模块
-- ============================================================
local AntiBan
do
    local AB = {}
    AB.CONFIG = {
        SMOOTH_STEP_MAX_DIST = 25,
        SMOOTH_DELAY_MIN = 0.02,
        SMOOTH_DELAY_MAX = 0.05,
        FAKE_MOVE_INTERVAL = 3.5,
        FAKE_MOVE_DURATION = 0.4,
        SPEED_LIMIT = 60,
        TELEPORT_COOLDOWN = 1.2,
        SPEED_WATCH_INTERVAL = 1.0,
        SPEED_MAX_ALLOWED = 200,
        HEARTBEAT_JITTER_MIN = 0.05,
        HEARTBEAT_JITTER_MAX = 0.25,
        SANITIZE_RAY_DEPTH = 40,
    }
    AB.stats = {
        teleportCount = 0, teleportBlocked = 0, lastTeleportTime = 0,
        speedWarnCount = 0, kickWarnCount = 0,
    }

    local _getHRP = function()
        local char = player.Character
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function _zeroVelocity(hrp)
        if not hrp then return end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    local function sanitizePos(targetPos)
        if not targetPos then return nil end
        local hrp = _getHRP()
        if not hrp then return targetPos end
        if targetPos.X ~= targetPos.X or targetPos.Y ~= targetPos.Y or targetPos.Z ~= targetPos.Z then
            return nil
        end
        if math.abs(targetPos.X) > 100000 or math.abs(targetPos.Y) > 100000 or math.abs(targetPos.Z) > 100000 then
            return nil
        end
        local origin = targetPos + Vector3.new(0, AB.CONFIG.SANITIZE_RAY_DEPTH / 2, 0)
        local dir = Vector3.new(0, -AB.CONFIG.SANITIZE_RAY_DEPTH, 0)
        local ray = Ray.new(origin, dir)
        local hitPart, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, { hrp.Parent })
        if hitPart and hitPos then
            return Vector3.new(targetPos.X, hitPos.Y + 4, targetPos.Z)
        end
        if targetPos.Y < -50 then return nil end
        return targetPos
    end

    local function canTeleport()
        local now = tick()
        if now - AB.stats.lastTeleportTime < AB.CONFIG.TELEPORT_COOLDOWN then
            AB.stats.teleportBlocked = AB.stats.teleportBlocked + 1
            return false
        end
        return true
    end

    local teleportQueue = {}
    local queueRunning = false
    local function enqueueTeleport(fn)
        table.insert(teleportQueue, fn)
        if queueRunning then return end
        queueRunning = true
        task.spawn(function()
            while #teleportQueue > 0 do
                local job = table.remove(teleportQueue, 1)
                if job then pcall(job) end
                task.wait(AB.CONFIG.TELEPORT_COOLDOWN)
            end
            queueRunning = false
        end)
    end

    function AB.smoothTeleport(targetPos, steps)
        if not canTeleport() then return false end
        local clean = sanitizePos(targetPos)
        if not clean then
            AB.stats.teleportBlocked = AB.stats.teleportBlocked + 1
            Log.add("🛡 [防封] 落点非法，已拦截", "yellow")
            return false
        end
        targetPos = clean
        local hrp = _getHRP()
        if not hrp then return false end
        local start = hrp.Position
        local totalDist = (start - targetPos).Magnitude
        if totalDist < 5 then
            hrp.CFrame = CFrame.new(targetPos)
            if AB.CONFIG.SPEED_LIMIT > 0 then _zeroVelocity(hrp) end
            AB.stats.teleportCount = AB.stats.teleportCount + 1
            AB.stats.lastTeleportTime = tick()
            return true
        end
        local segCount = math.clamp(math.ceil(totalDist / AB.CONFIG.SMOOTH_STEP_MAX_DIST), 1, 30)
        local curPos = start
        for s = 1, segCount do
            local t = s / segCount
            local eased = t * t * (3 - 2 * t)
            local jitter = Vector3.new((math.random() - 0.5) * 2.5, 0, (math.random() - 0.5) * 2.5)
            local segTarget = start:Lerp(targetPos, eased) + jitter
            local segDist = (curPos - segTarget).Magnitude
            local subSteps = math.clamp(math.floor(segDist / 6), 2, 6)
            for i = 1, subSteps do
                local tt = i / subSteps
                local ei = tt * tt * (3 - 2 * tt)
                hrp.CFrame = CFrame.new(curPos:Lerp(segTarget, ei))
                local delay = AB.CONFIG.SMOOTH_DELAY_MIN
                    + math.random() * (AB.CONFIG.SMOOTH_DELAY_MAX - AB.CONFIG.SMOOTH_DELAY_MIN)
                task.wait(delay)
            end
            curPos = segTarget
        end
        hrp.CFrame = CFrame.new(targetPos)
        if AB.CONFIG.SPEED_LIMIT > 0 then _zeroVelocity(hrp) end
        AB.stats.teleportCount = AB.stats.teleportCount + 1
        AB.stats.lastTeleportTime = tick()
        return true
    end

    function AB.hardTeleport(targetPos)
        if not canTeleport() then return false end
        local clean = sanitizePos(targetPos)
        if not clean then
            AB.stats.teleportBlocked = AB.stats.teleportBlocked + 1
            Log.add("🛡 [防封] 落点非法，已拦截", "yellow")
            return false
        end
        local hrp = _getHRP()
        if not hrp then return false end
        hrp.CFrame = CFrame.new(clean)
        _zeroVelocity(hrp)
        AB.stats.teleportCount = AB.stats.teleportCount + 1
        AB.stats.lastTeleportTime = tick()
        return true
    end

    function AB.queueTeleport(targetPos, mode)
        enqueueTeleport(function()
            if mode == "hard" then AB.hardTeleport(targetPos) else AB.smoothTeleport(targetPos) end
        end)
    end

    local fakeMoveRunning = false
    local fakeMoveThread = nil
    function AB.setFakeMovement(on)
        fakeMoveRunning = on
        if fakeMoveThread then task.cancel(fakeMoveThread); fakeMoveThread = nil end
        if not on then return end
        fakeMoveThread = task.spawn(function()
            while fakeMoveRunning do
                task.wait(AB.CONFIG.FAKE_MOVE_INTERVAL + math.random() * 2)
                local hrp = _getHRP()
                if hrp and hrp.Parent then
                    local humanoid = hrp.Parent:FindFirstChildOfClass("Humanoid")
                    if humanoid and not humanoid.SeatPart then
                        local fwd = (math.random() - 0.5) * 2
                        local side = (math.random() - 0.5) * 2
                        pcall(function() humanoid:Move(Vector3.new(side, 0, fwd), true) end)
                        task.wait(AB.CONFIG.FAKE_MOVE_DURATION)
                        pcall(function() humanoid:Move(Vector3.zero, false) end)
                    end
                end
            end
        end)
    end

    local kickWatchOn = false
    function AB.setKickWatch(on)
        kickWatchOn = on
        if not on then return end
        if AB._kickConn then pcall(function() AB._kickConn:Disconnect() end) end
        AB._kickConn = player.CharacterRemoving:Connect(function()
            if kickWatchOn then
                AB.stats.kickWarnCount = AB.stats.kickWarnCount + 1
                Log.add("🛡 [防封] 检测到角色移除，可能被踢/重载", "yellow")
            end
        end)
    end

    local scanRunning = false
    local scanThread = nil
    local DETECT_KEYWORDS = {
        "anticheat","anti-cheat","detect","ban","kick","exploit","hack","cheat",
        "反作弊","检测","封禁","踢出"
    }
    function AB.setDetectionScan(on)
        scanRunning = on
        if scanThread then task.cancel(scanThread); scanThread = nil end
        if not on then return end
        scanThread = task.spawn(function()
            while scanRunning do
                task.wait(5)
                local found = {}
                for _, obj in ipairs(game:GetDescendants()) do
                    if obj:IsA("LocalScript") or obj:IsA("Script") then
                        local n = obj.Name:lower()
                        for _, kw in ipairs(DETECT_KEYWORDS) do
                            if n:find(kw, 1, true) then
                                table.insert(found, obj:GetFullName())
                                break
                            end
                        end
                    end
                end
                if #found > 0 then
                    Log.add("🛡 [防封] 发现 " .. #found .. " 个可疑检测脚本", "yellow")
                    if #found <= 3 then
                        for _, n in ipairs(found) do
                            Log.add("  · " .. n, "gray")
                        end
                    end
                end
            end
        end)
    end

    local speedWatchRunning = false
    local speedWatchThread = nil
    function AB.setSpeedWatch(on)
        speedWatchRunning = on
        if speedWatchThread then task.cancel(speedWatchThread); speedWatchThread = nil end
        if not on then return end
        speedWatchThread = task.spawn(function()
            while speedWatchRunning do
                task.wait(AB.CONFIG.SPEED_WATCH_INTERVAL)
                local hrp = _getHRP()
                if hrp then
                    local v = hrp.AssemblyLinearVelocity.Magnitude
                    if v > AB.CONFIG.SPEED_MAX_ALLOWED then
                        AB.stats.speedWarnCount = AB.stats.speedWarnCount + 1
                        pcall(function()
                            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity.Unit * AB.CONFIG.SPEED_MAX_ALLOWED
                        end)
                        Log.add(string.format("🛡 [防封] 速度异常 %.0f，已降速", v), "yellow")
                    end
                end
            end
        end)
    end

    function AB.startHeartbeatJitter()
        task.spawn(function()
            while true do
                task.wait(AB.CONFIG.HEARTBEAT_JITTER_MIN
                    + math.random() * (AB.CONFIG.HEARTBEAT_JITTER_MAX - AB.CONFIG.HEARTBEAT_JITTER_MIN))
            end
        end)
    end

    AB.getConfig = function()
        return {
            SMOOTH_STEP_MAX_DIST = AB.CONFIG.SMOOTH_STEP_MAX_DIST,
            SMOOTH_DELAY_MIN = AB.CONFIG.SMOOTH_DELAY_MIN,
            SMOOTH_DELAY_MAX = AB.CONFIG.SMOOTH_DELAY_MAX,
            FAKE_MOVE_INTERVAL = AB.CONFIG.FAKE_MOVE_INTERVAL,
            SPEED_LIMIT = AB.CONFIG.SPEED_LIMIT,
            TELEPORT_COOLDOWN = AB.CONFIG.TELEPORT_COOLDOWN,
            SPEED_MAX_ALLOWED = AB.CONFIG.SPEED_MAX_ALLOWED,
            HEARTBEAT_JITTER_MIN = AB.CONFIG.HEARTBEAT_JITTER_MIN,
            HEARTBEAT_JITTER_MAX = AB.CONFIG.HEARTBEAT_JITTER_MAX,
        }
    end

    AB.getStats = function()
        return {
            teleportCount = AB.stats.teleportCount,
            teleportBlocked = AB.stats.teleportBlocked,
            speedWarnCount = AB.stats.speedWarnCount,
            kickWarnCount = AB.stats.kickWarnCount,
        }
    end

    AntiBan = AB
    _G.XiaoHeiYuAntiBan = AB
    print("[小黑鱼] 防封模块 A6 已加载")
end

-- ============================================================
-- [第 1/5 条结束] 下一段：传送 + 事件 + 生存 + 刷钱 + 破解 + 弹药 + 碰撞箱 + 旋转 + 防抓拍 + 交通 + 车辆
-- ============================================================
-- ============================================================
-- [续接第 1/5 条]
-- ============================================================

-- ============================================================
-- 🌀 传送模块
-- ============================================================
local Teleport
do
    local TP = {}
    TP.LOW_PROFILE = true
    TP.AGGRESSIVE_MODE = false
    TP.ZERO_VELOCITY_AFTER = true
    TP.TARGET_CACHE_TIME = 0.8
    TP.LOW_PROFILE_STOP_DIST = 15

    local function _zeroVel(hrp)
        if not hrp then return end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    local function dismountVehicle()
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart then
            humanoid.Sit = false
            task.wait(0.15 + math.random() * 0.1)
        end
    end

    local function builtinSmoothTeleport(targetPos, steps)
        local hrp = getHRP()
        if not hrp then return false end
        local origin = targetPos + Vector3.new(0, 8, 0)
        local ray = Ray.new(origin, Vector3.new(0, -20, 0))
        local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, { hrp.Parent })
        if hitPart then
            local ok, pos = pcall(function() return hitPart.Position end)
            if ok and pos then
                targetPos = Vector3.new(targetPos.X, pos.Y + 4, targetPos.Z)
            end
        end
        local dist = (hrp.Position - targetPos).Magnitude
        if dist < 15 then
            hrp.CFrame = CFrame.new(targetPos)
            return true
        end
        steps = steps or math.clamp(math.floor(dist / 8), 4, 10)
        local start = hrp.Position
        for i = 1, steps do
            local t = i / steps
            local eased = t * t * (3 - 2 * t)
            hrp.CFrame = CFrame.new(start:Lerp(targetPos, eased))
            task.wait(0.015 + math.random() * 0.01)
        end
        return true
    end

    local function hardTeleport(targetPos)
        local hrp = getHRP()
        if not hrp then return false end
        hrp.CFrame = CFrame.new(targetPos)
        _zeroVel(hrp)
        return true
    end

    local smoothTeleport = builtinSmoothTeleport
    if _G.XiaoHeiYuAntiBan and type(_G.XiaoHeiYuAntiBan.smoothTeleport) == "function" then
        smoothTeleport = _G.XiaoHeiYuAntiBan.smoothTeleport
    end

    local targetCache = { pos = nil, time = 0 }

    local function getTargetFromClientContent()
        local now = tick()
        if targetCache.pos and now - targetCache.time < TP.TARGET_CACHE_TIME then
            return targetCache.pos
        end
        local folder = workspace:FindFirstChild("Gameplay")
        if folder then folder = folder:FindFirstChild("Entities") end
        if folder then folder = folder:FindFirstChild("ClientContent") end
        if not folder then return nil end
        for _, d in ipairs(folder:GetChildren()) do
            if d:IsA("BasePart") then
                local pos = d.Position + Vector3.new(0, 3, 0)
                targetCache.pos = pos
                targetCache.time = now
                return pos
            end
        end
        return nil
    end

    local function getTargetFromMarkers()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Highlight") and obj.Enabled then
                local parent = obj.Parent
                if parent and parent:IsA("Model") then
                    local primary = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
                    if primary then return primary.Position end
                elseif parent and parent:IsA("BasePart") then
                    return parent.Position
                end
            elseif obj:IsA("SelectionBox") and obj.Visible then
                if obj.Parent and obj.Parent:IsA("BasePart") then
                    return obj.Parent.Position
                end
            end
        end
        return nil
    end

    local function getTargetPosition()
        return getTargetFromClientContent() or getTargetFromMarkers()
    end

    local function clearTargetCache()
        targetCache.pos = nil
        targetCache.time = 0
    end

    local function teleportForJob(targetPos)
        if not targetPos then return false end
        local char = player.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        dismountVehicle()
        local jittered = targetPos + Vector3.new(
            (math.random() - 0.5) * 4, 0, (math.random() - 0.5) * 4)
        local ok = smoothTeleport(jittered)
        task.wait(0.05 + math.random() * 0.05)
        if TP.ZERO_VELOCITY_AFTER then _zeroVel(hrp) end
        return ok
    end

    local function teleportToPosition(pos, mode)
        if not pos then return false end
        if mode == "hard" then return hardTeleport(pos) end
        return smoothTeleport(pos)
    end

    local function teleportToPlayer(targetName)
        local target = Players:FindFirstChild(targetName)
        if not target or not target.Character then
            Log.add("✗ 找不到玩家: " .. tostring(targetName), "red")
            return false
        end
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            Log.add("✗ 目标玩家无 HRP", "red")
            return false
        end
        local offset = Vector3.new((math.random() - 0.5) * 6, 0, (math.random() - 0.5) * 6)
        return teleportForJob(hrp.Position + offset)
    end

    local function teleportToMouse()
        local camera = workspace.CurrentCamera
        local mouse = player:GetMouse()
        if not camera or not mouse then return false end
        local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { player.Character }
        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, params)
        if not result then
            Log.add("✗ 鼠标前方无落点", "red")
            return false
        end
        return teleportForJob(result.Position + Vector3.new(0, 3, 0))
    end

    local function teleportOutOfVehicle()
        local vehicle, seat = getCurrentVehicle()
        if not vehicle or not seat then
            Log.add("○ 未在载具内", "yellow")
            return false
        end
        local seatPos = seat.Position
        local offset = Vector3.new(math.random(-6, 6), 4, math.random(-6, 6))
        dismountVehicle()
        task.wait(0.1)
        return smoothTeleport(seatPos + offset)
    end

    TP.teleportForJob = teleportForJob
    TP.smoothTeleport = smoothTeleport
    TP.hardTeleport = hardTeleport
    TP.teleportToPosition = teleportToPosition
    TP.getTargetPosition = getTargetPosition
    TP.getTargetFromClientContent = getTargetFromClientContent
    TP.getTargetFromMarkers = getTargetFromMarkers
    TP.clearTargetCache = clearTargetCache
    TP.teleportToPlayer = teleportToPlayer
    TP.teleportToMouse = teleportToMouse
    TP.teleportOutOfVehicle = teleportOutOfVehicle
    TP.getHRP = getHRP
    TP.getCurrentVehicle = getCurrentVehicle
    TP.forEachVehiclePart = forEachVehiclePart
    TP.dismountVehicle = dismountVehicle
    TP.zeroVelocity = _zeroVel
    TP.Log = Log
    TP.getConfig = function()
        return {
            LOW_PROFILE = TP.LOW_PROFILE,
            AGGRESSIVE_MODE = TP.AGGRESSIVE_MODE,
            ZERO_VELOCITY_AFTER = TP.ZERO_VELOCITY_AFTER,
            TARGET_CACHE_TIME = TP.TARGET_CACHE_TIME,
            LOW_PROFILE_STOP_DIST = TP.LOW_PROFILE_STOP_DIST,
        }
    end

    Teleport = TP
    _G.XiaoHeiYuTeleport = TP
    Log.add("🌀 传送模块已集成（魔改版）", "blue")
end

-- ============================================================
-- 事件监听
-- ============================================================
local lastHealth = nil
local healthWatchConn = nil
local function watchHumanoidForEvents(humanoid)
    if healthWatchConn then healthWatchConn:Disconnect() end
    lastHealth = humanoid.Health
    healthWatchConn = humanoid.HealthChanged:Connect(function(newHealth)
        if lastHealth and newHealth < lastHealth then
            local dmg = lastHealth - newHealth
            if dmg >= 1 then
                Log.add(string.format("⚔ 受到攻击 -%.0f HP  (剩余 %.0f)", dmg, newHealth), "green")
            end
        end
        if newHealth <= 0 and lastHealth and lastHealth > 0 then
            Log.add("💀 角色死亡", "red")
        end
        lastHealth = newHealth
    end)
end
local function onCharacterAdded(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        watchHumanoidForEvents(humanoid)
        Log.add("✓ 角色已加载: " .. player.Name, "blue")
    end
end
if player.Character then task.spawn(onCharacterAdded, player.Character) end
player.CharacterAdded:Connect(onCharacterAdded)

Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        Log.add("❗ 你被移出服务器（被踢 / 断线 / 疑似封禁）", "red")
    else
        Log.add("· 玩家离开: " .. plr.Name, "gray")
    end
end)
Players.PlayerAdded:Connect(function(plr)
    Log.add("· 玩家加入: " .. plr.Name, "gray")
end)

-- ============================================================
-- 生存
-- ============================================================
local HEALTH_KEYWORDS = {"health", "hp", "life", "lives", "vitality", "生命", "血量", "血条"}
local STAMINA_KEYWORDS = {"stamina", "energy", "sprint", "endurance", "体力", "精力", "耐力"}
local FOOD_KEYWORDS = {"food", "hunger", "thirst", "hungry", "thirsty", "eat", "drink", "satiety", "食物", "饥饿", "口渴", "饱食"}

local function forEachPlayerValue(fn)
    local containers = {player, player.Character, player:FindFirstChild("PlayerGui"), player:FindFirstChild("Backpack"), player:FindFirstChild("PlayerScripts")}
    for _, container in ipairs(containers) do
        if container then
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("NumberValue") or d:IsA("IntValue") then fn(d) end
            end
        end
    end
end

local function startValueLock(flag, keywords, fixedValue, name)
    if flag.thread then task.cancel(flag.thread); flag.thread = nil end
    if not flag.on then return end
    flag.thread = task.spawn(function()
        while flag.on do
            forEachPlayerValue(function(d)
                local n = d.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw, 1, true) then
                        pcall(function()
                            if d:IsA("NumberValue") then d.Value = fixedValue
                            elseif d:IsA("IntValue") then d.Value = math.floor(fixedValue) end
                        end)
                        break
                    end
                end
            end)
            if name == "health" then
                local char = player.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function()
                            humanoid.MaxHealth = math.max(humanoid.MaxHealth, 99999)
                            humanoid.Health = humanoid.MaxHealth
                        end)
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

local healthFlag = {on=false,thread=nil}
local staminaFlag = {on=false,thread=nil}
local foodFlag = {on=false,thread=nil}
local function setInfiniteHealth(on) healthFlag.on = on; startValueLock(healthFlag, HEALTH_KEYWORDS, 99999, "health") end
local function setInfiniteStamina(on) staminaFlag.on = on; startValueLock(staminaFlag, STAMINA_KEYWORDS, 99999, "stamina") end
local function setInfiniteFood(on) foodFlag.on = on; startValueLock(foodFlag, FOOD_KEYWORDS, 100, "food") end

-- ============================================================
-- 💰 刷钱模块
-- ============================================================
local function clickAt(x, y)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
end

local function clickPhoneUI()
    local vp = workspace.CurrentCamera.ViewportSize
    local px = vp.X * PHONE_POS_X
    local py = vp.Y * PHONE_POS_Y
    clickAt(px, py)
end

local ACCEPT_KEYWORDS = {
    taxi = {"start shift", "accept", "take order", "接单", "接任务", "开始轮班", "taxi shift", "出租车"},
    bus  = {"start route", "drive route", "bus route", "开始路线", "驾驶路线", "start bus", "公交"},
    delivery = {"delivery", "package", "送快递", "派送", "快递", "start delivery"},
}

local function tryClickAcceptButton(jobType)
    local keywords = ACCEPT_KEYWORDS[jobType]
    if not keywords then return false end
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return false end
    for _, gui in ipairs(pg:GetDescendants()) do
        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible and not gui:IsDescendantOf(screenGui) then
            local txt = ""
            if gui:IsA("TextButton") then txt = gui.Text
            else
                local tl = gui:FindFirstChildWhichIsA("TextLabel", true)
                if tl then txt = tl.Text end
            end
            local lower = txt:lower()
            for _, kw in ipairs(keywords) do
                if lower:find(kw, 1, true) then
                    pcall(function() gui:Activate() end)
                    return true, txt
                end
            end
        end
    end
    return false
end

local function doAccept(jobType)
    local ok, txt = tryClickAcceptButton(jobType)
    if ok then return true, "按钮: " .. txt end
    clickPhoneUI()
    task.wait(0.3)
    local vp = workspace.CurrentCamera.ViewportSize
    local px = vp.X * PHONE_POS_X
    local py = vp.Y * PHONE_POS_Y
    for i = 1, 3 do
        clickAt(px, py + i * 80)
        task.wait(0.3)
    end
    return true, "坐标点击"
end

local function getTargetFromClientContent()
    local folder = workspace:FindFirstChild("Gameplay")
    if not folder then return nil end
    folder = folder:FindFirstChild("Entities")
    if not folder then return nil end
    folder = folder:FindFirstChild("ClientContent")
    if not folder then return nil end
    for _, d in ipairs(folder:GetDescendants()) do
        if d:IsA("BasePart") then
            return d.Position + Vector3.new(0, 3, 0)
        end
    end
    return nil
end

local function getTargetFromMarkers()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") and obj.Enabled then
            local parent = obj.Parent
            if parent and parent:IsA("Model") then
                local primary = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
                if primary then return primary.Position end
            elseif parent and parent:IsA("BasePart") then
                return parent.Position
            end
        elseif obj:IsA("SelectionBox") and obj.Visible then
            if obj.Parent and obj.Parent:IsA("BasePart") then
                return obj.Parent.Position
            end
        end
    end
    return nil
end

local function getTargetPosition()
    return getTargetFromClientContent() or getTargetFromMarkers()
end

local function teleportForJob(targetPos)
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.15)
    end
    hrp.CFrame = CFrame.new(targetPos)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    return true
end

local jobRunning = {
    taxi = { value = false },
    bus  = { value = false },
    delivery = { value = false },
}
local jobThreads = { taxi = nil, bus = nil, delivery = nil }
local jobCounts = { taxi = 0, bus = 0, delivery = 0 }
local jobNames = { taxi = "出租车", bus = "公交车", delivery = "快递" }

local function runJobLoop(jobType)
    local running = jobRunning[jobType]
    while running.value do
        Log.add("📱 " .. jobNames[jobType] .. " 尝试接单...", "blue")
        local ok, method = doAccept(jobType)
        jobCounts[jobType] = jobCounts[jobType] + 1
        Log.add(string.format("✓ %s 接单 #%d (方式: %s)", jobNames[jobType], jobCounts[jobType], method or "?"), "green")

        local targetPos = nil
        for attempt = 1, 15 do
            if not running.value then return end
            task.wait(0.4)
            targetPos = getTargetPosition()
            if targetPos then break end
        end

        if not targetPos then
            Log.add("· 未找到目标位置，稍后重试", "yellow")
            task.wait(2)
            continue
        end

        Log.add("→ 第 1 次传送到目标", "blue")
        teleportForJob(targetPos)
        task.wait(2.5)

        if not running.value then return end
        local targetPos2 = getTargetPosition()
        if targetPos2 then
            Log.add("→ 第 2 次传送到目标", "blue")
            teleportForJob(targetPos2)
        end

        Log.add("✅ " .. jobNames[jobType] .. " 订单完成", "green")
        task.wait(2)
    end
end

local function setJobRunning(jobType, on)
    jobRunning[jobType].value = on
    if jobThreads[jobType] then
        task.cancel(jobThreads[jobType])
        jobThreads[jobType] = nil
    end
    if not on then return end
    jobThreads[jobType] = task.spawn(function()
        runJobLoop(jobType)
    end)
end

local function setTaxiAutoFarm(on) setJobRunning("taxi", on) end
local function setBusAutoFarm(on) setJobRunning("bus", on) end
local function setDeliveryAutoFarm(on) setJobRunning("delivery", on) end

-- ============================================================
-- ATM 破解
-- ============================================================
local atmCrackRunning = false
local atmCrackThread = nil
local function getGuiText(gui)
    if gui:IsA("TextButton") or gui:IsA("TextLabel") then return gui.Text end
    local tl = gui:FindFirstChildWhichIsA("TextLabel", true)
    if tl then return tl.Text end
    return ""
end
local function isCodeLike(txt)
    if not txt or #txt < 2 or #txt > 4 then return false end
    return txt:match("^%u%u%u?%u?$") ~= nil
end
local function findCodeButtons()
    local buttons = {}
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return buttons end
    for _, gui in ipairs(pg:GetDescendants()) do
        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible and not gui:IsDescendantOf(screenGui) then
            local txt = getGuiText(gui)
            if isCodeLike(txt) then table.insert(buttons, {btn=gui, code=txt}) end
        end
    end
    return buttons
end
local function findTargetCodes()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, gui in ipairs(pg:GetDescendants()) do
        if gui:IsA("TextLabel") and gui.Visible and not gui:IsDescendantOf(screenGui) then
            local t = gui.Text
            if t then
                local codes = {}
                for code in t:gmatch("%u%u%u?%u?") do
                    if #code >= 2 and #code <= 4 then table.insert(codes, code) end
                end
                if #codes >= 2 and #codes <= 4 then return codes end
            end
        end
    end
    return nil
end
local function autoCrackOnce()
    local buttons = findCodeButtons()
    if #buttons == 0 then return false end
    local targets = findTargetCodes()
    if not targets then
        for _, data in ipairs(buttons) do
            pcall(function() data.btn:Activate() end)
            task.wait(0.06)
        end
        return true
    end
    local clicked = 0
    for _, tgt in ipairs(targets) do
        for _, data in ipairs(buttons) do
            if data.code == tgt then
                pcall(function() data.btn:Activate() end)
                clicked = clicked + 1
                task.wait(0.08)
                break
            end
        end
    end
    return clicked > 0
end
local function setAutoCrackATM(on)
    atmCrackRunning = on
    if atmCrackThread then task.cancel(atmCrackThread); atmCrackThread = nil end
    if not on then return end
    atmCrackThread = task.spawn(function()
        while atmCrackRunning do
            local ok = autoCrackOnce()
            task.wait(ok and 0.15 or 0.5)
        end
    end)
end

-- ============================================================
-- 无限弹药
-- ============================================================
local saintConnections = {}
local function setInfiniteAmmo(on)
    for _, conn in ipairs(saintConnections) do pcall(function() conn:Disconnect() end) end
    saintConnections = {}
    if not on then return end
    local TARGET = 999
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    local function processTool(tool)
        if not tool:IsA("Tool") then return end
        local wl = tool:FindFirstChild("_TeamWhitelisted")
        if wl then wl:Destroy() end
        local cfg = tool:FindFirstChild("Config")
        if not cfg then return end
        local ammo = cfg:FindFirstChild("Ammo")
        if ammo and ammo:IsA("ValueBase") then ammo.Value = TARGET end
    end
    for _, item in ipairs(backpack:GetChildren()) do processTool(item) end
    table.insert(saintConnections, backpack.ChildAdded:Connect(function(child)
        task.wait(0.1); processTool(child)
    end))
    table.insert(saintConnections, RunService.Heartbeat:Connect(function()
        for _, tool in ipairs(backpack:GetChildren()) do
            local cfg = tool:FindFirstChild("Config")
            if cfg then
                local ammo = cfg:FindFirstChild("Ammo")
                if ammo and ammo:IsA("ValueBase") and ammo.Value ~= TARGET then ammo.Value = TARGET end
            end
        end
    end))
end

-- ============================================================
-- 大碰撞箱
-- ============================================================
local bigHitboxEnabled = false
local bigHitboxData = {}
local function enlargeHead(character)
    local head = character:FindFirstChild("Head")
    if not head or bigHitboxData[head] then return end
    bigHitboxData[head] = {Size=head.Size, Transparency=head.Transparency, CanCollide=head.CanCollide}
    head.Size = Vector3.new(4, 4, 4)
    head.Transparency = 0.4
    head.CanCollide = false
end
local function restoreHead(head)
    local d = bigHitboxData[head]
    if d then
        head.Size = d.Size
        head.Transparency = d.Transparency
        head.CanCollide = d.CanCollide
        bigHitboxData[head] = nil
    end
end
local function setBigHitbox(on)
    bigHitboxEnabled = on
    if on then
        if player.Character then enlargeHead(player.Character) end
    else
        for head in pairs(bigHitboxData) do restoreHead(head) end
    end
end
local function watchCharacterForHitbox(char)
    char:WaitForChild("Head", 5)
    if bigHitboxEnabled then enlargeHead(char) end
end
if player.Character then task.spawn(watchCharacterForHitbox, player.Character) end
player.CharacterAdded:Connect(function(char)
    bigHitboxData = {}
    watchCharacterForHitbox(char)
end)

-- ============================================================
-- 疯狂旋转
-- ============================================================
local spinRunning = false
local spinSpeed = 720
local spinConnection = nil
local originalAutoRotate = nil
local function setSpin(on)
    spinRunning = on
    if on then
        if spinConnection then spinConnection:Disconnect() end
        spinConnection = RunService.Heartbeat:Connect(function(dt)
            if not spinRunning then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if originalAutoRotate == nil then originalAutoRotate = humanoid.AutoRotate end
                humanoid.AutoRotate = false
            end
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed * dt), 0)
        end)
    else
        if spinConnection then spinConnection:Disconnect(); spinConnection = nil end
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and originalAutoRotate ~= nil then humanoid.AutoRotate = originalAutoRotate end
        end
        originalAutoRotate = nil
    end
end
local function setSpinSpeed(v) spinSpeed = v end

-- ============================================================
-- 防抓拍
-- ============================================================
local antiCameraRunning = false
local antiCameraThread = nil
local ANTI_CAMERA_RADIUS = 60
local CAMERA_KEYWORDS = {"camera","traffic","photo","capture","snap","violation","ticket","redlight","stopline","checkpoint","抓拍","摄像头","闯红灯","违规","拍照","电子眼"}
local function isTrafficCameraPart(part)
    if not part:IsA("BasePart") then return false end
    local n = part.Name:lower()
    for _, kw in ipairs(CAMERA_KEYWORDS) do
        if n:find(kw, 1, true) then return true end
    end
    return false
end
local function setAntiCamera(on)
    antiCameraRunning = on
    if antiCameraThread then task.cancel(antiCameraThread); antiCameraThread = nil end
    if not on then return end
    antiCameraThread = task.spawn(function()
        while antiCameraRunning do
            local hrp = getHRP()
            if hrp then
                local ok, parts = pcall(function() return workspace:GetPartBoundsInRadius(hrp.Position, ANTI_CAMERA_RADIUS) end)
                if ok and parts then
                    for _, part in ipairs(parts) do
                        if isTrafficCameraPart(part) then
                            pcall(function()
                                part.CanTouch = false
                                part.CanQuery = false
                                part.CanCollide = false
                            end)
                        end
                    end
                end
            end
            task.wait(0.15)
        end
    end)
end

-- ============================================================
-- 交通三合一
-- ============================================================
local antiFineRunning = false
local antiFineThread = nil
local ANTI_FINE_RADIUS = 120

local FINE_KEYWORDS = {"police","cop","officer","fine","ticket","penalty","punishment","violation","arrest","wanted","bounty","citation","report","damage","crash","hit","collision","impact","destroy","detain","suspect","pursuit","chase","crime","警察","警官","罚单","处罚","罚款","违规","违法","通缉","扣分","扣钱","损坏","撞击","碰撞","事故","贴条","抓人","逮捕","追捕"}

local WANTED_KEYWORDS = {
    "wanted","bounty","star","stars","heat","crime","criminal","suspect",
    "arrest","detain","pursuit","chase","police","cop","officer","swat",
    "ranger","patrol","alert","alarm","report","citation","warrant",
    "通缉","悬赏","星","热度","犯罪","嫌犯","嫌疑","逮捕","抓捕","拘留",
    "追捕","追击","报警","警报","警官","警察","巡警","特警"
}

local TRIGGER_KEYWORDS = {
    "trigger","sensor","trap","hitbox","alert","detect","detector",
    "collision","hitdetect","damage","impact","crashbox",
    "触发","感应","感应器","检测","检测器","碰撞","碰撞箱","陷阱"
}

local DISMISS_KEYWORDS = {"cancel","close","dismiss","ok","accept","pay","confirm","关闭","取消","确认","支付","接受","知道了","好的"}

local function isFineRelated(part)
    if not part:IsA("BasePart") then return false end
    local n = part.Name:lower()
    for _, kw in ipairs(FINE_KEYWORDS) do if n:find(kw, 1, true) then return true end end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            local at = (child.ActionText or ""):lower()
            local ot = (child.ObjectText or ""):lower()
            for _, kw in ipairs(FINE_KEYWORDS) do
                if at:find(kw, 1, true) or ot:find(kw, 1, true) then return true end
            end
        end
    end
    return false
end

local function isWantedRelated(part)
    if not part:IsA("BasePart") then return false end
    local n = part.Name:lower()
    for _, kw in ipairs(WANTED_KEYWORDS) do if n:find(kw, 1, true) then return true end end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            local at = (child.ActionText or ""):lower()
            local ot = (child.ObjectText or ""):lower()
            for _, kw in ipairs(WANTED_KEYWORDS) do
                if at:find(kw, 1, true) or ot:find(kw, 1, true) then return true end
            end
        end
    end
    return false
end

local function isTriggerPart(part)
    if not part:IsA("BasePart") then return false end
    local n = part.Name:lower()
    for _, kw in ipairs(TRIGGER_KEYWORDS) do if n:find(kw, 1, true) then return true end end
    return false
end

local function dismissFineUI()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return end
    for _, gui in ipairs(pg:GetDescendants()) do
        if gui:IsA("TextButton") and gui.Visible and not gui:IsDescendantOf(screenGui) then
            local txt = gui.Text:lower()
            local ancestor = gui.Parent
            local isFinePanel = false
            for _ = 1, 5 do
                if not ancestor then break end
                local an = ancestor.Name:lower()
                for _, kw in ipairs(FINE_KEYWORDS) do
                    if an:find(kw, 1, true) then isFinePanel = true; break end
                end
                if isFinePanel then break end
                ancestor = ancestor.Parent
            end
            if isFinePanel then
                for _, kw in ipairs(DISMISS_KEYWORDS) do
                    if txt:find(kw, 1, true) then
                        pcall(function() gui:Activate() end)
                        break
                    end
                end
            end
        end
    end
end

local function dismissWantedUI()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return end
    for _, gui in ipairs(pg:GetDescendants()) do
        if gui:IsA("TextButton") and gui.Visible and not gui:IsDescendantOf(screenGui) then
            local txt = gui.Text:lower()
            local ancestor = gui.Parent
            local isWantedPanel = false
            for _ = 1, 6 do
                if not ancestor then break end
                local an = ancestor.Name:lower()
                for _, kw in ipairs(WANTED_KEYWORDS) do
                    if an:find(kw, 1, true) then isWantedPanel = true; break end
                end
                if isWantedPanel then break end
                ancestor = ancestor.Parent
            end
            if isWantedPanel then
                for _, kw in ipairs(DISMISS_KEYWORDS) do
                    if txt:find(kw, 1, true) then
                        pcall(function() gui:Activate() end)
                        break
                    end
                end
            end
        end
    end
end

local function restoreFines()
    local containers = {player:FindFirstChild("PlayerGui"), player:FindFirstChild("Backpack"), player.Character, player}
    for _, container in ipairs(containers) do
        if container then
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("NumberValue") or d:IsA("IntValue") then
                    local n = d.Name:lower()
                    for _, kw in ipairs({"fine","penalty","point","score","money","cash","credit","罚","分","钱"}) do
                        if n:find(kw, 1, true) then
                            local lastMax = d:GetAttribute("XiaoHeiYuLastMax") or d.Value
                            if d.Value > lastMax then
                                d:SetAttribute("XiaoHeiYuLastMax", d.Value)
                            elseif d.Value < lastMax then
                                d.Value = lastMax
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end

local WANTED_VALUE_KWS = {
    "wanted","bounty","star","stars","heat","crime","criminal","suspect",
    "arrest","warrant","wantedlevel","wantedlevelvalue","notoriety",
    "通缉","悬赏","星","热度","犯罪","嫌犯","嫌疑","逮捕"
}
local function lockWantedValues()
    local containers = {
        player, player.Character, player:FindFirstChild("PlayerGui"),
        player:FindFirstChild("Backpack"), player:FindFirstChild("PlayerScripts")
    }
    for _, container in ipairs(containers) do
        if container then
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("NumberValue") or d:IsA("IntValue") then
                    local n = d.Name:lower()
                    for _, kw in ipairs(WANTED_VALUE_KWS) do
                        if n:find(kw, 1, true) then
                            pcall(function()
                                if d.Value ~= 0 then d.Value = 0 end
                            end)
                            break
                        end
                    end
                end
            end
            for _, d in ipairs(container:GetDescendants()) do
                for _, attr in ipairs(d:GetAttributes()) do
                    local an = attr:lower()
                    for _, kw in ipairs(WANTED_VALUE_KWS) do
                        if an:find(kw, 1, true) then
                            pcall(function() d:SetAttribute(attr, 0) end)
                            break
                        end
                    end
                end
            end
        end
    end
end

local function disableTriggers()
    local hrp = getHRP()
    if not hrp then return end
    local ok, parts = pcall(function()
        return workspace:GetPartBoundsInRadius(hrp.Position, ANTI_FINE_RADIUS)
    end)
    if not ok or not parts then return end
    for _, part in ipairs(parts) do
        if isTriggerPart(part) then
            pcall(function()
                part.CanTouch = false
                part.CanQuery = false
                part.CanCollide = false
                part.Transparency = math.max(part.Transparency, 0.95)
            end)
            for _, d in ipairs(part:GetDescendants()) do
                if d:IsA("ProximityPrompt") then pcall(function() d.Enabled = false end) end
                if d:IsA("TouchTransmitter") then pcall(function() d:Destroy() end) end
            end
        end
    end
end

local function disableWantedModels()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= player.Character then
            local n = obj.Name:lower()
            local hit = false
            for _, kw in ipairs(WANTED_KEYWORDS) do
                if n:find(kw, 1, true) then hit = true; break end
            end
            for _, kw in ipairs(FINE_KEYWORDS) do
                if n:find(kw, 1, true) then hit = true; break end
            end
            if hit then
                for _, d in ipairs(obj:GetDescendants()) do
                    if d:IsA("BasePart") then
                        pcall(function()
                            d.CanTouch = false
                            d.CanQuery = false
                        end)
                    elseif d:IsA("ProximityPrompt") then
                        pcall(function() d.Enabled = false end)
                    end
                end
            end
        end
    end
end

local function setAntiFine(on)
    antiFineRunning = on
    if antiFineThread then task.cancel(antiFineThread); antiFineThread = nil end
    if not on then return end
    antiFineThread = task.spawn(function()
        while antiFineRunning do
            local hrp = getHRP()
            if hrp then
                local ok, parts = pcall(function()
                    return workspace:GetPartBoundsInRadius(hrp.Position, ANTI_FINE_RADIUS)
                end)
                if ok and parts then
                    for _, part in ipairs(parts) do
                        if isFineRelated(part) or isWantedRelated(part) then
                            pcall(function()
                                part.CanTouch = false
                                part.CanQuery = false
                                part.CanCollide = false
                            end)
                            for _, d in ipairs(part:GetDescendants()) do
                                if d:IsA("ProximityPrompt") then pcall(function() d.Enabled = false end) end
                                if d:IsA("TouchTransmitter") then pcall(function() d:Destroy() end) end
                            end
                        end
                    end
                end
                pcall(disableWantedModels)
                pcall(disableTriggers)
            end
            pcall(dismissFineUI)
            pcall(dismissWantedUI)
            pcall(restoreFines)
            pcall(lockWantedValues)
            task.wait(0.15)
        end
    end)
end

-- ============================================================
-- 车辆
-- ============================================================
local vehicleSpeedBoost = false
local vehicleSpeedThread = nil
local vehicleSpeedMultiplier = 2
local originalVehicleData = {}
local function setVehicleSpeedBoost(on)
    vehicleSpeedBoost = on
    if vehicleSpeedThread then task.cancel(vehicleSpeedThread); vehicleSpeedThread = nil end
    if not on then
        for obj, data in pairs(originalVehicleData) do
            if obj.Parent and data.prop then pcall(function() obj[data.prop] = data.value end) end
        end
        originalVehicleData = {}
        return
    end
    vehicleSpeedThread = task.spawn(function()
        while vehicleSpeedBoost do
            local vehicle = getCurrentVehicle()
            if vehicle then
                forEachVehiclePart(vehicle, function(part)
                    if part:IsA("VehicleSeat") then
                        if not originalVehicleData[part] then
                            originalVehicleData[part] = {prop="MaxSpeed", value=part.MaxSpeed}
                        end
                        pcall(function()
                            part.MaxSpeed = 200 * vehicleSpeedMultiplier
                            part.Torque = math.huge
                        end)
                    end
                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA("BodyVelocity") or child:IsA("LinearVelocity") then
                            if not originalVehicleData[child] then
                                originalVehicleData[child] = {prop="MaxForce", value=child.MaxForce}
                            end
                            pcall(function()
                                if child:IsA("BodyVelocity") then
                                    child.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                elseif child:IsA("LinearVelocity") then
                                    child.MaxForce = math.huge
                                end
                            end)
                        end
                    end
                end)
            end
            task.wait(0.5)
        end
    end)
end
local function setVehicleSpeedMultiplier(v) vehicleSpeedMultiplier = v end

local vehicleBrakeThread = nil
local vehicleBrakeOn = false
local function setVehicleFastBrake(on)
    vehicleBrakeOn = on
    if vehicleBrakeThread then task.cancel(vehicleBrakeThread); vehicleBrakeThread = nil end
    if not on then return end
    vehicleBrakeThread = task.spawn(function()
        while vehicleBrakeOn do
            local vehicle = getCurrentVehicle()
            if vehicle then
                forEachVehiclePart(vehicle, function(part)
                    if part:IsA("VehicleSeat") then pcall(function() part.Torque = math.huge end) end
                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA("BodyAngularVelocity") then
                            pcall(function() child.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) end)
                        end
                    end
                end)
            end
            task.wait(0.3)
        end
    end)
end

local vehicleFuelThread = nil
local vehicleFuelOn = false
local FUEL_KEYWORDS = {"fuel","gas","petrol","gasoline","燃油","汽油"}
local function setVehicleInfiniteFuel(on)
    vehicleFuelOn = on
    if vehicleFuelThread then task.cancel(vehicleFuelThread); vehicleFuelThread = nil end
    if not on then return end
    vehicleFuelThread = task.spawn(function()
        while vehicleFuelOn do
            local vehicle = getCurrentVehicle()
            if vehicle then
                for _, d in ipairs(vehicle:GetDescendants()) do
                    if d:IsA("NumberValue") or d:IsA("IntValue") then
                        local n = d.Name:lower()
                        for _, kw in ipairs(FUEL_KEYWORDS) do
                            if n:find(kw, 1, true) then d.Value = 100; break end
                        end
                    end
                end
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, d in ipairs(pg:GetDescendants()) do
                        if d:IsA("NumberValue") or d:IsA("IntValue") then
                            local n = d.Name:lower()
                            for _, kw in ipairs(FUEL_KEYWORDS) do
                                if n:find(kw, 1, true) then d.Value = 100; break end
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local vehicleDurabilityThread = nil
local vehicleDurabilityOn = false
local DURABILITY_KEYWORDS = {"durability","health","hp","integrity","condition","damage","耐久","血量","损伤"}
local function setVehicleInfiniteDurability(on)
    vehicleDurabilityOn = on
    if vehicleDurabilityThread then task.cancel(vehicleDurabilityThread); vehicleDurabilityThread = nil end
    if not on then return end
    vehicleDurabilityThread = task.spawn(function()
        while vehicleDurabilityOn do
            local vehicle = getCurrentVehicle()
            if vehicle then
                for _, d in ipairs(vehicle:GetDescendants()) do
                    if d:IsA("NumberValue") or d:IsA("IntValue") then
                        local n = d.Name:lower()
                        for _, kw in ipairs(DURABILITY_KEYWORDS) do
                            if n:find(kw, 1, true) then d.Value = 999999; break end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local vehicleNoCollideOn = false
local vehicleNoCollideThread = nil
local noCollideSaved = {}
local function setVehicleNoCollide(on)
    vehicleNoCollideOn = on
    if vehicleNoCollideThread then task.cancel(vehicleNoCollideThread); vehicleNoCollideThread = nil end
    if not on then
        for part, collide in pairs(noCollideSaved) do
            if part.Parent then pcall(function() part.CanCollide = collide end) end
        end
        noCollideSaved = {}
        return
    end
    vehicleNoCollideThread = task.spawn(function()
        while vehicleNoCollideOn do
            local vehicle = getCurrentVehicle()
            if vehicle then
                forEachVehiclePart(vehicle, function(part)
                    if noCollideSaved[part] == nil then noCollideSaved[part] = part.CanCollide end
                    pcall(function() part.CanCollide = false end)
                end)
            end
            task.wait(0.3)
        end
    end)
end

local vehicleStableOn = false
local vehicleStableThread = nil
local stableSaved = {}
local function setVehicleStable(on)
    vehicleStableOn = on
    if vehicleStableThread then task.cancel(vehicleStableThread); vehicleStableThread = nil end
    if not on then
        for part, data in pairs(stableSaved) do
            if part.Parent then pcall(function() part.CustomPhysicalProperties = data end) end
        end
        stableSaved = {}
        return
    end
    vehicleStableThread = task.spawn(function()
        while vehicleStableOn do
            local vehicle = getCurrentVehicle()
            if vehicle then
                forEachVehiclePart(vehicle, function(part)
                    if stableSaved[part] == nil then stableSaved[part] = part.CustomPhysicalProperties end
                    pcall(function()
                        part.CustomPhysicalProperties = PhysicalProperties.new(
                            math.max(part:GetMass() / math.max(part.Size.Magnitude, 1), 0.7),
                            3.0, 0.0, 100, 100
                        )
                    end)
                end)
            end
            task.wait(0.5)
        end
    end)
end

local vehicleInstantStopOn = false
local vehicleInstantStopThread = nil
local function setVehicleInstantStop(on)
    vehicleInstantStopOn = on
    if vehicleInstantStopThread then task.cancel(vehicleInstantStopThread); vehicleInstantStopThread = nil end
    if not on then return end
    vehicleInstantStopThread = task.spawn(function()
        while vehicleInstantStopOn do
            local vehicle = getCurrentVehicle()
            if vehicle then
                forEachVehiclePart(vehicle, function(part)
                    if not part.Anchored then
                        pcall(function()
                            part.AssemblyLinearVelocity = Vector3.zero
                            part.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end)
            end
            task.wait()
        end
    end)
end

-- ============================================================
-- [第 2/5 条结束] 下一段：停止所有 + 初始化 + 默认界面 + 圣奥里界面 + 卡密逻辑
-- ============================================================
-- ============================================================
-- [续接第 2/5 条]
-- ============================================================

-- ============================================================
-- 停止所有
-- ============================================================
local function stopAllSaintFeatures()
    setInfiniteAmmo(false)
    setBigHitbox(false)
    setSpin(false)
    setAutoCrackATM(false)
    setAntiCamera(false)
    setAntiFine(false)
    setTaxiAutoFarm(false)
    setBusAutoFarm(false)
    setDeliveryAutoFarm(false)
    setInfiniteHealth(false)
    setInfiniteStamina(false)
    setInfiniteFood(false)
    setVehicleSpeedBoost(false)
    setVehicleFastBrake(false)
    setVehicleInfiniteFuel(false)
    setVehicleInfiniteDurability(false)
    setVehicleNoCollide(false)
    setVehicleStable(false)
    setVehicleInstantStop(false)
    for head in pairs(bigHitboxData) do restoreHead(head) end
    Log.add("○ 已关闭所有功能", "yellow")
end

-- ============================================================
-- 初始化
-- ============================================================
local initSteps = {
    {name = "UI 加载",      desc = "检查小黑鱼界面是否完整"},
    {name = "角色绑定",     desc = "检查角色、Humanoid、HumanoidRootPart"},
    {name = "背包与工具",   desc = "检查 Backpack 和已装备工具"},
    {name = "座位与车辆",   desc = "检查当前是否在座位上"},
    {name = "远程事件扫描", desc = "扫描 ReplicatedStorage 里的 Remote"},
    {name = "重置所有开关", desc = "关闭之前残留的所有功能"},
}
local initRunning = false

local function runInitCheck(index)
    if index == 1 then
        local ok = screenGui and screenGui.Parent == playerGui and mainFrame and mainFrame.Parent == screenGui
        return ok, ok and "界面正常" or "界面异常"
    elseif index == 2 then
        local char = player.Character
        if not char then return false, "没有角色" end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not humanoid then return false, "没有 Humanoid" end
        if not hrp then return false, "没有 RootPart" end
        return true, string.format("HP %.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
    elseif index == 3 then
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return false, "没有背包" end
        local count = 0
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then count = count + 1 end
        end
        return true, count .. " 个工具"
    elseif index == 4 then
        local vehicle, seat = getCurrentVehicle()
        if seat then return true, "已在座位: " .. (vehicle and vehicle.Name or "未知") end
        return true, "未在车内"
    elseif index == 5 then
        local count = 0
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then count = count + 1 end
        end
        return true, count .. " 个 Remote"
    elseif index == 6 then
        stopAllSaintFeatures()
        return true, "所有开关已重置"
    end
    return false, "未知步骤"
end

local function runInitAll(onProgress, onDone)
    if initRunning then return end
    initRunning = true
    task.spawn(function()
        for i, step in ipairs(initSteps) do
            local ok, msg = runInitCheck(i)
            if onProgress then onProgress(i, ok, msg) end
            task.wait(0.4)
        end
        initRunning = false
        if onDone then onDone() end
    end)
end

-- ============================================================
-- 默认界面
-- ============================================================
local DEFAULT_NOTICE = "欢迎使用 " .. BRAND_NAME .. "\n\n请到【服务器】页选择服务器脚本。"

buildDefaultUI = function()
    clearAllTabs()
    titleLabel.Text = BRAND_NAME
    noticeContent.Text = DEFAULT_NOTICE
    Log.setLabel(nil)

    local tabNotice  = createTab("公告",   "📢")
    local tabServer  = createTab("服务器", "🌐")
    local tabTeleport= createTab("传送",   "🌀")
    local tabGeneral = createTab("通用",   "⚙")

    do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 160)
        card.BackgroundTransparency = 0.75
        card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        card.ZIndex = 5
        card.Parent = tabNotice.contentFrame
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local ct = Instance.new("TextLabel")
        ct.Size = UDim2.new(1, -24, 1, -24)
        ct.Position = UDim2.new(0, 12, 0, 12)
        ct.BackgroundTransparency = 1
        ct.Text = DEFAULT_NOTICE
        ct.TextColor3 = Color3.fromRGB(220, 220, 230)
        ct.TextSize = 13
        ct.Font = Enum.Font.Gotham
        ct.TextXAlignment = Enum.TextXAlignment.Left
        ct.TextYAlignment = Enum.TextYAlignment.Top
        ct.TextWrapped = true
        ct.ZIndex = 6
        ct.Parent = card
    end

    do
        addSection(tabServer, "热门服务器")
        local btn, btnLabel = addButton(tabServer, "", nil)
        btn.BackgroundTransparency = 0.75
        btnLabel.Visible = false

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 36, 1, 0)
        icon.Position = UDim2.new(0, 8, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "★"
        icon.TextColor3 = CONFIG.ACCENT_COLOR
        icon.TextSize = 20
        icon.Font = Enum.Font.GothamBold
        icon.ZIndex = 7
        icon.Parent = btn

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, -100, 0, 20)
        nl.Position = UDim2.new(0, 50, 0, 8)
        nl.BackgroundTransparency = 1
        nl.Text = "圣奥里"
        nl.TextColor3 = Color3.fromRGB(240, 240, 250)
        nl.TextSize = 14
        nl.Font = Enum.Font.GothamBold
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.ZIndex = 7
        nl.Parent = btn

        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1, -100, 0, 16)
        dl.Position = UDim2.new(0, 50, 0, 28)
        dl.BackgroundTransparency = 1
        dl.Text = "全部圣奥里专属功能"
        dl.TextColor3 = Color3.fromRGB(160, 160, 180)
        dl.TextSize = 11
        dl.Font = Enum.Font.Gotham
        dl.TextXAlignment = Enum.TextXAlignment.Left
        dl.ZIndex = 7
        dl.Parent = btn

        if CURRENT_PLACE_ID == SAINT_PLACE_ID then
            local badge = Instance.new("TextLabel")
            badge.Size = UDim2.new(0, 40, 0, 16)
            badge.Position = UDim2.new(1, -68, 0, 6)
            badge.BackgroundTransparency = 0.2
            badge.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
            badge.Text = "当前"
            badge.TextColor3 = Color3.fromRGB(20, 30, 20)
            badge.TextSize = 10
            badge.Font = Enum.Font.GothamBold
            badge.ZIndex = 8
            badge.Parent = btn
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
        end

        btn.Activated:Connect(function()
            if buildSaintUI then buildSaintUI() end
        end)
    end

    do
        addSection(tabTeleport, "模式")
        addToggle(tabTeleport, "低暴露模式", true, function(on)
            if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.LOW_PROFILE = on end
        end, "低暴露模式")
        addToggle(tabTeleport, "激进模式", false, function(on)
            if _G.XiaoHeiYuTeleport then
                _G.XiaoHeiYuTeleport.AGGRESSIVE_MODE = on
                _G.XiaoHeiYuTeleport.LOW_PROFILE = not on
            end
        end, "激进模式")
        addToggle(tabTeleport, "传送后清零速度", true, function(on)
            if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.ZERO_VELOCITY_AFTER = on end
        end, "清零速度")

        addSection(tabTeleport, "任务传送")
        addButton(tabTeleport, "传送到目标位置", function()
            local tp = _G.XiaoHeiYuTeleport
            if not tp then return end
            local pos = tp.getTargetPosition()
            if pos then
                tp.teleportForJob(pos)
                Log.add("→ 已传送到目标", "blue")
            else
                Log.add("✗ 未找到目标", "red")
            end
        end)
        addButton(tabTeleport, "传送到目标（硬传）", function()
            local tp = _G.XiaoHeiYuTeleport
            if not tp then return end
            local pos = tp.getTargetPosition()
            if pos then
                tp.hardTeleport(pos)
                Log.add("⚡ 已硬传到目标", "yellow")
            else
                Log.add("✗ 未找到目标", "red")
            end
        end)
        addButton(tabTeleport, "清空目标缓存", function()
            if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.clearTargetCache() end
            Log.add("🧹 目标缓存已清空", "gray")
        end)

        addSection(tabTeleport, "玩家传送")
        do
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 34)
            box.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
            box.BackgroundTransparency = 0.1
            box.BorderSizePixel = 0
            box.Text = ""
            box.PlaceholderText = "输入玩家名后按回车"
            box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.TextSize = 13
            box.Font = Enum.Font.GothamMedium
            box.ClearTextOnFocus = false
            box.ZIndex = 5
            box.Parent = tabTeleport.contentFrame
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function(enter)
                if enter and box.Text ~= "" and _G.XiaoHeiYuTeleport then
                    _G.XiaoHeiYuTeleport.teleportToPlayer(box.Text)
                    box.Text = ""
                end
            end)
        end
        addButton(tabTeleport, "传送到最近玩家", function()
            local tp = _G.XiaoHeiYuTeleport
            if not tp then return end
            local myHRP = tp.getHRP()
            if not myHRP then return end
            local best, bestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local h = p.Character:FindFirstChild("HumanoidRootPart")
                    if h then
                        local d = (h.Position - myHRP.Position).Magnitude
                        if d < bestDist then bestDist = d; best = p end
                    end
                end
            end
            if best then
                tp.teleportToPlayer(best.Name)
                Log.add("→ 传送至 " .. best.Name, "blue")
            else
                Log.add("✗ 附近无其他玩家", "red")
            end
        end)

        addSection(tabTeleport, "载具传送")
        addButton(tabTeleport, "从载具中下车", function()
            if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.teleportOutOfVehicle() end
        end)
        addButton(tabTeleport, "传送到当前载具旁", function()
            local vehicle, _ = getCurrentVehicle()
            if not vehicle then
                Log.add("○ 未在载具内", "yellow")
                return
            end
            local part = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
            if part and _G.XiaoHeiYuTeleport then
                _G.XiaoHeiYuTeleport.teleportForJob(part.Position + Vector3.new(0, 5, 0))
                Log.add("→ 已传送到载具旁", "blue")
            end
        end)

        addSection(tabTeleport, "鼠标传送")
        addButton(tabTeleport, "传送到鼠标指向位置", function()
            if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.teleportToMouse() end
        end)

        addSection(tabTeleport, "坐标传送")
        do
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 34)
            box.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
            box.BackgroundTransparency = 0.1
            box.BorderSizePixel = 0
            box.Text = ""
            box.PlaceholderText = "输入 X,Y,Z 后按回车（例: 100,5,200）"
            box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.TextSize = 13
            box.Font = Enum.Font.GothamMedium
            box.ClearTextOnFocus = false
            box.ZIndex = 5
            box.Parent = tabTeleport.contentFrame
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function(enter)
                if enter and box.Text ~= "" then
                    local x, y, z = box.Text:match("([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)")
                    if x and y and z and _G.XiaoHeiYuTeleport then
                        _G.XiaoHeiYuTeleport.teleportForJob(Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
                        Log.add("→ 已传送到坐标 " .. box.Text, "blue")
                    else
                        Log.add("✗ 坐标格式错误", "red")
                    end
                    box.Text = ""
                end
            end)
        end
        addButton(tabTeleport, "传送到 0,50,0", function()
            if _G.XiaoHeiYuTeleport then
                _G.XiaoHeiYuTeleport.teleportForJob(Vector3.new(0, 50, 0))
            end
        end)

        addSection(tabTeleport, "🛡 防封 A6")
        addToggle(tabTeleport, "假移动", false, function(on)
            if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setFakeMovement(on) end
        end, "假移动")
        addToggle(tabTeleport, "反踢监控", false, function(on)
            if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setKickWatch(on) end
        end, "反踢监控")
        addToggle(tabTeleport, "反检测扫描", false, function(on)
            if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setDetectionScan(on) end
        end, "反检测扫描")
        addToggle(tabTeleport, "速度异常监控", false, function(on)
            if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setSpeedWatch(on) end
        end, "速度监控")
    end

    do
        addSection(tabGeneral, "通用工具")
        addButton(tabGeneral, "重置角色", function()
            if player.Character then player.Character:BreakJoints() end
        end)
        addButton(tabGeneral, "显示 " .. BRAND_NAME .. " 公告", function()
            noticePanel.Visible = true
        end)
    end
end

-- ============================================================
-- 圣奥里界面
-- ============================================================
local SAINT_NOTICE = "欢迎使用 " .. BRAND_NAME .. " · 圣奥里\n\n"
    .. "• 初始化：6 道检查\n"
    .. "• 日志：实时记录事件\n"
    .. "• 刷钱：出租车 / 公交车 / 快递 / 外卖 / 拖车 / 警车 / 垃圾车 / 消防车 / 公交检查\n"
    .. "• 传送：魔改版（防封模块自动接管 smoothTeleport）\n"
    .. "• 交通：防罚单三合一（防罚单 + 防通缉 + 防抓捕）\n"
    .. "• 防封：A6 + A7 增强检测\n"
    .. "• DLC：ESP / 车辆飞行 / 子弹 / 更多刷钱职业\n"

buildSaintUI = function()
    clearAllTabs()
    titleLabel.Text = BRAND_NAME .. " · 圣奥里"
    noticeContent.Text = SAINT_NOTICE

    local tabInit     = createTab("初始化", "🚀")
    local tabLog      = createTab("日志",   "📋")
    local tabBattle   = createTab("战斗",   "⚔")
    local tabSurvival = createTab("生存",   "❤")
    local tabHack     = createTab("破解",   "💻")
    local tabMoney    = createTab("刷钱",   "💰")
    local tabTraffic  = createTab("交通",   "🚦")
    local tabVehicle  = createTab("车辆",   "🚗")
    local tabFun      = createTab("娱乐",   "🎮")
    local tabTeleport = createTab("传送",   "🌀")
    local tabDLC      = createTab("DLC",    "🎁")
    local tabDetect   = createTab("检测",   "🛡")
    local tabSaint    = createTab("圣奥里", "★")
    local tabNotice   = createTab("公告",   "📢")
    local tabGeneral  = createTab("通用",   "⚙")

    -- 初始化
    addSection(tabInit, "一键初始化")
    local initBtn, initLbl = addButton(tabInit, "▶ 开始初始化（6 道检查）", nil)

    local lightsRow = Instance.new("Frame")
    lightsRow.Size = UDim2.new(1, 0, 0, 60)
    lightsRow.BackgroundTransparency = 1
    lightsRow.ZIndex = 5
    lightsRow.Parent = tabInit.contentFrame

    local lightsLayout = Instance.new("UIListLayout")
    lightsLayout.FillDirection = Enum.FillDirection.Horizontal
    lightsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    lightsLayout.Padding = UDim.new(0, 6)
    lightsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    lightsLayout.Parent = lightsRow

    local lights = {}
    for i = 1, 6 do
        local lightFrame = Instance.new("Frame")
        lightFrame.Size = UDim2.new(0, 42, 0, 50)
        lightFrame.BackgroundTransparency = 1
        lightFrame.LayoutOrder = i
        lightFrame.ZIndex = 5
        lightFrame.Parent = lightsRow

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 28, 0, 28)
        dot.Position = UDim2.new(0.5, -14, 0, 0)
        dot.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        dot.BorderSizePixel = 0
        dot.ZIndex = 6
        dot.Parent = lightFrame
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local numLbl = Instance.new("TextLabel")
        numLbl.Size = UDim2.new(1, 0, 0, 20)
        numLbl.Position = UDim2.new(0, 0, 0, 30)
        numLbl.BackgroundTransparency = 1
        numLbl.Text = "第 " .. i .. " 道"
        numLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
        numLbl.TextSize = 10
        numLbl.Font = Enum.Font.GothamMedium
        numLbl.ZIndex = 6
        numLbl.Parent = lightFrame

        lights[i] = {dot = dot, label = numLbl}
    end

    local initLogFrame = Instance.new("Frame")
    initLogFrame.Size = UDim2.new(1, 0, 0, 130)
    initLogFrame.BackgroundTransparency = 0.75
    initLogFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    initLogFrame.ZIndex = 5
    initLogFrame.Parent = tabInit.contentFrame
    Instance.new("UICorner", initLogFrame).CornerRadius = UDim.new(0, 8)

    local initLogText = Instance.new("TextLabel")
    initLogText.Size = UDim2.new(1, -20, 1, -20)
    initLogText.Position = UDim2.new(0, 10, 0, 10)
    initLogText.BackgroundTransparency = 1
    initLogText.Text = "点击上方按钮开始 6 道检查"
    initLogText.TextColor3 = Color3.fromRGB(180, 200, 220)
    initLogText.TextSize = 11
    initLogText.Font = Enum.Font.Code
    initLogText.TextXAlignment = Enum.TextXAlignment.Left
    initLogText.TextYAlignment = Enum.TextYAlignment.Top
    initLogText.TextWrapped = true
    initLogText.ZIndex = 6
    initLogText.Parent = initLogFrame

    local initLogLines = {}
    local function addInitLog(line)
        table.insert(initLogLines, line)
        if #initLogLines > 6 then table.remove(initLogLines, 1) end
        initLogText.Text = table.concat(initLogLines, "\n")
    end

    initBtn.Activated:Connect(function()
        if initRunning then
            addInitLog("⚠ 正在初始化")
            return
        end
        for i = 1, 6 do lights[i].dot.BackgroundColor3 = Color3.fromRGB(80, 80, 90) end
        initLogLines = {}
        initLogText.Text = ""
        addInitLog("▶ 开始初始化...")
        initLbl.Text = "运行中..."

        runInitAll(
            function(i, ok, msg)
                lights[i].dot.BackgroundColor3 = ok and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(255, 120, 120)
                addInitLog(string.format("[%d] %s %s — %s", i, ok and "✓" or "✗", initSteps[i].name, msg))
            end,
            function()
                addInitLog("▶ 初始化完成")
                initLbl.Text = "▶ 开始初始化（6 道检查）"
            end
        )
    end)

    -- 日志
    addSection(tabLog, "实时日志")
    local logScroll = Instance.new("ScrollingFrame")
    logScroll.Size = UDim2.new(1, 0, 0, 280)
    logScroll.BackgroundTransparency = 0.75
    logScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    logScroll.BorderSizePixel = 0
    logScroll.ScrollBarThickness = 4
    logScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    logScroll.ScrollBarImageTransparency = 0.5
    logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logScroll.ZIndex = 5
    logScroll.Parent = tabLog.contentFrame
    Instance.new("UICorner", logScroll).CornerRadius = UDim.new(0, 8)

    local logInner = Instance.new("TextLabel")
    logInner.Size = UDim2.new(1, -20, 0, 0)
    logInner.Position = UDim2.new(0, 10, 0, 8)
    logInner.BackgroundTransparency = 1
    logInner.Text = "等待事件..."
    logInner.TextColor3 = Color3.fromRGB(220, 220, 230)
    logInner.TextSize = 12
    logInner.Font = Enum.Font.Code
    logInner.TextXAlignment = Enum.TextXAlignment.Left
    logInner.TextYAlignment = Enum.TextYAlignment.Top
    logInner.TextWrapped = true
    logInner.RichText = true
    logInner.AutomaticSize = Enum.AutomaticSize.Y
    logInner.ZIndex = 6
    logInner.Parent = logScroll

    Log.setLabel(logInner)
    Log.add("小黑鱼 · 圣奥里 已启动", "blue")

    addSection(tabLog, "操作")
    addButton(tabLog, "清空日志", function()
        Log.clear()
        Log.add("日志已清空", "gray")
    end)

    -- 战斗
    addSection(tabBattle, "战斗辅助")
    addToggle(tabBattle, "无限弹药", false, setInfiniteAmmo, "无限弹药")
    addToggle(tabBattle, "大碰撞箱", false, setBigHitbox, "大碰撞箱")

    -- 生存
    addSection(tabSurvival, "生命")
    addToggle(tabSurvival, "无限生命", false, setInfiniteHealth, "无限生命")
    addSection(tabSurvival, "体力与食物")
    addToggle(tabSurvival, "无限体力", false, setInfiniteStamina, "无限体力")
    addToggle(tabSurvival, "无限食物", false, setInfiniteFood, "无限食物")

    -- 破解
    addSection(tabHack, "ATM 黑客")
    addToggle(tabHack, "自动破解", false, setAutoCrackATM, "ATM自动破解")

    -- 刷钱
    addSection(tabMoney, "自动接单 · 刷钱")
    addToggle(tabMoney, "出租车自动接单", false, setTaxiAutoFarm, "出租车刷钱")
    addToggle(tabMoney, "公交车自动接单", false, setBusAutoFarm, "公交车刷钱")
    addToggle(tabMoney, "送快递自动接单", false, setDeliveryAutoFarm, "快递刷钱")

    addSection(tabMoney, "手动操作")
    addButton(tabMoney, "手动接一次出租车", function()
        local ok, txt = tryClickAcceptButton("taxi")
        Log.add(ok and ("✓ 点到按钮: " .. txt) or "✗ 未找到出租车接单按钮", ok and "green" or "red")
    end)
    addButton(tabMoney, "手动接一次公交车", function()
        local ok, txt = tryClickAcceptButton("bus")
        Log.add(ok and ("✓ 点到按钮: " .. txt) or "✗ 未找到公交车接单按钮", ok and "green" or "red")
    end)
    addButton(tabMoney, "手动接一次快递", function()
        local ok, txt = tryClickAcceptButton("delivery")
        Log.add(ok and ("✓ 点到按钮: " .. txt) or "✗ 未找到快递接单按钮", ok and "green" or "red")
    end)
    addButton(tabMoney, "测试手机坐标点击", function()
        clickPhoneUI()
        Log.add("📱 已模拟点击手机图标位置", "blue")
    end)
    addButton(tabMoney, "传送到目标位置", function()
        local pos = getTargetPosition()
        if pos then
            teleportForJob(pos)
            Log.add("→ 已传送到目标", "blue")
        else
            Log.add("✗ 未找到目标", "red")
        end
    end)

    -- 交通
    addSection(tabTraffic, "交通辅助（激进版 · 慎用）")
    addToggle(tabTraffic, "防抓拍", false, setAntiCamera, "防抓拍")
    addToggle(tabTraffic, "防罚单 + 防通缉 + 防抓捕", false, setAntiFine, "三合一防护")

    addSection(tabTraffic, "🛡 隐蔽版（推荐 · 用这个不封号）")
    addButton(tabTraffic, "✅ 开启隐蔽防抓拍", function()
        if _G.XiaoHeiYuStealth then
            _G.XiaoHeiYuStealth.setAntiCameraV2(true)
        else
            Log.add("✗ 隐蔽引擎未加载", "red")
        end
    end)
    addButton(tabTraffic, "✅ 开启隐蔽三合一", function()
        if _G.XiaoHeiYuStealth then
            _G.XiaoHeiYuStealth.setAntiFineV2(true)
        else
            Log.add("✗ 隐蔽引擎未加载", "red")
        end
    end)
    addButton(tabTraffic, "❌ 关闭隐蔽模式", function()
        if _G.XiaoHeiYuStealth then
            _G.XiaoHeiYuStealth.disableAll()
        end
    end)

    -- 车辆
    addSection(tabVehicle, "车辆常规")
    addToggle(tabVehicle, "刹车更快", false, setVehicleFastBrake, "刹车更快")
    addToggle(tabVehicle, "车辆速度提升", false, setVehicleSpeedBoost, "车辆速度")
    addSlider(tabVehicle, "速度倍数", 1, 10, vehicleSpeedMultiplier, setVehicleSpeedMultiplier)
    addSection(tabVehicle, "车辆状态")
    addToggle(tabVehicle, "无限燃油", false, setVehicleInfiniteFuel, "无限燃油")
    addToggle(tabVehicle, "无限耐久", false, setVehicleInfiniteDurability, "无限耐久")
    addSection(tabVehicle, "车辆进阶")
    addToggle(tabVehicle, "无碰撞（穿墙穿车）", false, setVehicleNoCollide, "无碰撞")
    addToggle(tabVehicle, "稳定不翻车", false, setVehicleStable, "稳定不翻车")
    addToggle(tabVehicle, "瞬间停止（每帧清速度）", false, setVehicleInstantStop, "瞬间停止")

    -- 娱乐
    addSection(tabFun, "人物特效")
    addToggle(tabFun, "疯狂旋转", false, setSpin, "疯狂旋转")
    addSlider(tabFun, "旋转速度 (度/秒)", 30, 3600, spinSpeed, setSpinSpeed)

    -- 传送
    addSection(tabTeleport, "模式")
    addToggle(tabTeleport, "低暴露模式", true, function(on)
        if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.LOW_PROFILE = on end
    end, "低暴露模式")
    addToggle(tabTeleport, "激进模式", false, function(on)
        if _G.XiaoHeiYuTeleport then
            _G.XiaoHeiYuTeleport.AGGRESSIVE_MODE = on
            _G.XiaoHeiYuTeleport.LOW_PROFILE = not on
        end
    end, "激进模式")
    addToggle(tabTeleport, "传送后清零速度", true, function(on)
        if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.ZERO_VELOCITY_AFTER = on end
    end, "清零速度")

    addSection(tabTeleport, "任务传送")
    addButton(tabTeleport, "传送到目标位置", function()
        local tp = _G.XiaoHeiYuTeleport
        if not tp then return end
        local pos = tp.getTargetPosition()
        if pos then
            tp.teleportForJob(pos)
            Log.add("→ 已传送到目标", "blue")
        else
            Log.add("✗ 未找到目标", "red")
        end
    end)
    addButton(tabTeleport, "传送到目标（硬传）", function()
        local tp = _G.XiaoHeiYuTeleport
        if not tp then return end
        local pos = tp.getTargetPosition()
        if pos then
            tp.hardTeleport(pos)
            Log.add("⚡ 已硬传到目标", "yellow")
        else
            Log.add("✗ 未找到目标", "red")
        end
    end)
    addButton(tabTeleport, "清空目标缓存", function()
        if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.clearTargetCache() end
        Log.add("🧹 目标缓存已清空", "gray")
    end)

    addSection(tabTeleport, "玩家传送")
    do
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, 34)
        box.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
        box.BackgroundTransparency = 0.1
        box.BorderSizePixel = 0
        box.Text = ""
        box.PlaceholderText = "输入玩家名后按回车"
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.TextSize = 13
        box.Font = Enum.Font.GothamMedium
        box.ClearTextOnFocus = false
        box.ZIndex = 5
        box.Parent = tabTeleport.contentFrame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        box.FocusLost:Connect(function(enter)
            if enter and box.Text ~= "" and _G.XiaoHeiYuTeleport then
                _G.XiaoHeiYuTeleport.teleportToPlayer(box.Text)
                box.Text = ""
            end
        end)
    end
    addButton(tabTeleport, "传送到最近玩家", function()
        local tp = _G.XiaoHeiYuTeleport
        if not tp then return end
        local myHRP = tp.getHRP()
        if not myHRP then return end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local h = p.Character:FindFirstChild("HumanoidRootPart")
                if h then
                    local d = (h.Position - myHRP.Position).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
        if best then
            tp.teleportToPlayer(best.Name)
            Log.add("→ 传送至 " .. best.Name, "blue")
        else
            Log.add("✗ 附近无其他玩家", "red")
        end
    end)

    addSection(tabTeleport, "载具传送")
    addButton(tabTeleport, "从载具中下车（传送出车外）", function()
        if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.teleportOutOfVehicle() end
    end)
    addButton(tabTeleport, "传送到当前载具旁", function()
        local vehicle, _ = getCurrentVehicle()
        if not vehicle then
            Log.add("○ 未在载具内", "yellow")
            return
        end
        local part = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
        if part and _G.XiaoHeiYuTeleport then
            _G.XiaoHeiYuTeleport.teleportForJob(part.Position + Vector3.new(0, 5, 0))
            Log.add("→ 已传送到载具旁", "blue")
        end
    end)

    addSection(tabTeleport, "鼠标传送")
    addButton(tabTeleport, "传送到鼠标指向位置", function()
        if _G.XiaoHeiYuTeleport then _G.XiaoHeiYuTeleport.teleportToMouse() end
    end)

    addSection(tabTeleport, "坐标传送")
    do
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, 34)
        box.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
        box.BackgroundTransparency = 0.1
        box.BorderSizePixel = 0
        box.Text = ""
        box.PlaceholderText = "输入 X,Y,Z 后按回车"
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.TextSize = 13
        box.Font = Enum.Font.GothamMedium
        box.ClearTextOnFocus = false
        box.ZIndex = 5
        box.Parent = tabTeleport.contentFrame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        box.FocusLost:Connect(function(enter)
            if enter and box.Text ~= "" then
                local x, y, z = box.Text:match("([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)")
                if x and y and z and _G.XiaoHeiYuTeleport then
                    _G.XiaoHeiYuTeleport.teleportForJob(Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
                    Log.add("→ 已传送到坐标 " .. box.Text, "blue")
                else
                    Log.add("✗ 坐标格式错误", "red")
                end
                box.Text = ""
            end
        end)
    end
    addButton(tabTeleport, "传送到 0,50,0", function()
        if _G.XiaoHeiYuTeleport then
            _G.XiaoHeiYuTeleport.teleportForJob(Vector3.new(0, 50, 0))
        end
    end)

    addSection(tabTeleport, "🛡 防封（A6 + A7）")
    addToggle(tabTeleport, "假移动", false, function(on)
        if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setFakeMovement(on) end
    end, "假移动")
    addToggle(tabTeleport, "反踢监控", false, function(on)
        if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setKickWatch(on) end
    end, "反踢监控")
    addToggle(tabTeleport, "反检测扫描", false, function(on)
        if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setDetectionScan(on) end
    end, "反检测扫描")
    addToggle(tabTeleport, "速度异常监控", false, function(on)
        if _G.XiaoHeiYuAntiBan then _G.XiaoHeiYuAntiBan.setSpeedWatch(on) end
    end, "速度监控")
    addButton(tabTeleport, "查看防封配置", function()
        local ab = _G.XiaoHeiYuAntiBan
        if not ab then
            Log.add("✗ 防封模块未加载", "red")
            return
        end
        local cfg = ab.getConfig()
        Log.add("🛡 防封 A6 配置:", "blue")
        Log.add("  · 每段最大距离: " .. cfg.SMOOTH_STEP_MAX_DIST, "gray")
        Log.add("  · 每步延迟: " .. cfg.SMOOTH_DELAY_MIN .. " ~ " .. cfg.SMOOTH_DELAY_MAX, "gray")
        Log.add("  · 假移动间隔: " .. cfg.FAKE_MOVE_INTERVAL .. " 秒", "gray")
        Log.add("  · 速度限制: " .. cfg.SPEED_LIMIT, "gray")
        Log.add("  · 传送冷却: " .. cfg.TELEPORT_COOLDOWN .. " 秒", "gray")
        Log.add("  · 速度监控阈值: " .. cfg.SPEED_MAX_ALLOWED, "gray")
    end)
    addButton(tabTeleport, "查看防封统计", function()
        local ab = _G.XiaoHeiYuAntiBan
        if not ab or not ab.getStats then return end
        local s = ab.getStats()
        Log.add("🛡 防封 A6 运行时统计:", "blue")
        Log.add("  · 成功传送: " .. s.teleportCount .. " 次", "green")
        Log.add("  · 被拦截: " .. s.teleportBlocked .. " 次", "yellow")
        Log.add("  · 速度异常: " .. s.speedWarnCount .. " 次", "yellow")
        Log.add("  · 角色移除: " .. s.kickWarnCount .. " 次", "red")
    end)

    -- DLC tab
    addSection(tabDLC, "🎯 ESP 透视")
    addToggle(tabDLC, "启用 ESP", false, function(on)
        if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setEnabled(on) end
    end, "ESP")
    addToggle(tabDLC, "显示玩家", true, function(on)
        if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setShowPlayers(on) end
    end, "ESP玩家")
    addToggle(tabDLC, "显示车辆", true, function(on)
        if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setShowVehicles(on) end
    end, "ESP车辆")
    addToggle(tabDLC, "显示 NPC", false, function(on)
        if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setShowNPCs(on) end
    end, "ESP NPC")

    addSection(tabDLC, "🚗 车辆飞行跳跃")
    addToggle(tabDLC, "车辆飞行", false, function(on)
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.setFlyEnabled(on) end
    end, "车辆飞行")
    addSlider(tabDLC, "飞行速度", 1, 50, 8, function(v)
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.CONFIG.flySpeed = v end
    end)
    addToggle(tabDLC, "车辆跳跃（空格）", false, function(on)
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.setJumpEnabled(on) end
    end, "车辆跳跃")
    addSlider(tabDLC, "跳跃力度", 50, 500, 120, function(v)
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.CONFIG.jumpPower = v end
    end)
    addToggle(tabDLC, "无重力", false, function(on)
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.setNoGravity(on) end
    end, "无重力")

    addSection(tabDLC, "🔫 子弹")
    addToggle(tabDLC, "子弹追踪", false, function(on)
        if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.setTrackEnabled(on) end
    end, "子弹追踪")
    addSlider(tabDLC, "追踪范围", 50, 2000, 500, function(v)
        if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.CONFIG.trackRange = v end
    end)
    addToggle(tabDLC, "穿墙", false, function(on)
        if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.setPierceEnabled(on) end
    end, "穿墙")
    addToggle(tabDLC, "无后坐力", false, function(on)
        if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.setNoRecoil(on) end
    end, "无后坐力")

    addSection(tabDLC, "💰 更多刷钱职业")
    addToggle(tabDLC, "外卖", false, function(on)
        if _G.XiaoHeiYuJobs then _G.XiaoHeiYuJobs.setJob("food", on) end
    end, "外卖")
    addToggle(tabDLC, "拖车", false, function(on)
        if _G.XiaoHeiYuJobs then _G.XiaoHeiYuJobs.setJob("tow", on) end
    end, "拖车")
    addToggle(tabDLC, "警车", false, function(on)
        if _G.XiaoHeiYuJobs then _G.XiaoHeiYuJobs.setJob("police", on) end
    end, "警车")
    addToggle(tabDLC, "垃圾车", false, function(on)
        if _G.XiaoHeiYuJobs then _G.XiaoHeiYuJobs.setJob("garbage", on) end
    end, "垃圾车")
    addToggle(tabDLC, "消防车", false, function(on)
        if _G.XiaoHeiYuJobs then _G.XiaoHeiYuJobs.setJob("firetruck", on) end
    end, "消防车")
    addToggle(tabDLC, "公交检查", false, function(on)
        if _G.XiaoHeiYuJobs then _G.XiaoHeiYuJobs.setJob("bus_check", on) end
    end, "公交检查")

    addSection(tabDLC, "操作")
    addButton(tabDLC, "❌ 全部 DLC 关闭", function()
        if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setEnabled(false) end
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.stopAll() end
        if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.stopAll() end
        if _G.XiaoHeiYuJobs then
            for _, k in ipairs(_G.XiaoHeiYuJobs.getActive()) do
                _G.XiaoHeiYuJobs.setJob(k, false)
            end
        end
        Log.add("○ DLC 全部关闭", "yellow")
    end)

    -- 检测 tab
    addSection(tabDetect, "🛡 A7 检测开关")
    addToggle(tabDetect, "Kick / 断线检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectKick = on end
    end, "Kick检测")
    addToggle(tabDetect, "Remote 调用检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectRemote = on end
    end, "Remote检测")
    addToggle(tabDetect, "反作弊脚本检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectScript = on end
    end, "脚本检测")
    addToggle(tabDetect, "速度异常检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectSpeed = on end
    end, "速度检测")
    addToggle(tabDetect, "传送异常检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectTeleport = on end
    end, "传送检测")
    addToggle(tabDetect, "血量异常检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectHealth = on end
    end, "血量检测")
    addToggle(tabDetect, "被标记检测", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.detectMarked = on end
    end, "标记检测")
    addToggle(tabDetect, "紧急熔断（自动关功能）", true, function(on)
        if _G.XiaoHeiYuGuard then _G.XiaoHeiYuGuard.CONFIG.autoEmergencyStop = on end
    end, "紧急熔断")

    addSection(tabDetect, "操作")
    addButton(tabDetect, "📊 查看检测统计", function()
        local G = _G.XiaoHeiYuGuard
        if not G then
            Log.add("✗ A7 检测模块未加载", "red")
            return
        end
        local s = G.getStats()
        Log.add("🛡 A7 检测统计:", "blue")
        Log.add("  · 被踢: " .. s.kickCount, "gray")
        Log.add("  · 可疑Remote: " .. s.remoteSuspicious, "yellow")
        Log.add("  · 可疑脚本: " .. s.scriptSuspicious, "yellow")
        Log.add("  · 速度异常: " .. s.speedWarn, "yellow")
        Log.add("  · 传送异常: " .. s.teleportWarn, "yellow")
        Log.add("  · 血量异常: " .. s.healthWarn, "yellow")
        Log.add("  · 被标记: " .. s.markedWarn, "red")
    end)
    addButton(tabDetect, "🚨 手动紧急熔断", function()
        local G = _G.XiaoHeiYuGuard
        if G and G.emergencyStop then
            G.emergencyStop("手动触发")
            Log.add("🚨 已手动熔断", "red")
        end
    end)
    addButton(tabDetect, "🧹 清空检测日志", function()
        if _G.XiaoHeiYuGuard then
            _G.XiaoHeiYuGuard.events = {}
            Log.add("🧹 检测日志已清空", "gray")
        end
    end)

    -- 圣奥里
    addSection(tabSaint, "圣奥里专属")
    addButton(tabSaint, "查看公告", function() noticePanel.Visible = true end)
    addButton(tabSaint, "关闭所有功能", function() stopAllSaintFeatures() end)
    addButton(tabSaint, "← 返回主界面", function()
        stopAllSaintFeatures()
        if buildDefaultUI then buildDefaultUI() end
    end)

    -- 公告
    do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 300)
        card.BackgroundTransparency = 0.75
        card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        card.ZIndex = 5
        card.Parent = tabNotice.contentFrame
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local ct = Instance.new("TextLabel")
        ct.Size = UDim2.new(1, -24, 1, -24)
        ct.Position = UDim2.new(0, 12, 0, 12)
        ct.BackgroundTransparency = 1
        ct.Text = SAINT_NOTICE
        ct.TextColor3 = Color3.fromRGB(220, 220, 230)
        ct.TextSize = 13
        ct.Font = Enum.Font.Gotham
        ct.TextXAlignment = Enum.TextXAlignment.Left
        ct.TextYAlignment = Enum.TextYAlignment.Top
        ct.TextWrapped = true
        ct.ZIndex = 6
        ct.Parent = card
    end

    -- 通用
    addSection(tabGeneral, "通用工具")
    addButton(tabGeneral, "重置角色", function()
        if player.Character then player.Character:BreakJoints() end
    end)
    addButton(tabGeneral, "显示 " .. BRAND_NAME .. " 公告", function()
        noticePanel.Visible = true
    end)
end

-- ============================================================
-- 卡密逻辑
-- ============================================================
local function unlockUI()
    TweenService:Create(authOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(authCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
    task.wait(0.45)
    authOverlay.Visible = false
    mainFrame.Visible = true
    buildDefaultUI()
    Log.add("🎫 卡密验证通过（公益版）", "green")
    if CURRENT_PLACE_ID == SAINT_PLACE_ID then
        task.wait(1)
        noticePanel.Visible = true
    end
end
_G.__xhy_unlock = unlockUI

local function tryAuth()
    authStatus.TextColor3 = Color3.fromRGB(120, 255, 160)
    authStatus.Text = "✓ 验证通过，进入中..."
    task.wait(0.3)
    unlockUI()
end

authBtn.Activated:Connect(tryAuth)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryAuth() end
end)

authBtn.MouseEnter:Connect(function()
    TweenService:Create(authBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(140, 100, 255) }):Play()
end)
authBtn.MouseLeave:Connect(function()
    TweenService:Create(authBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(120, 80, 255) }):Play()
end)

-- ============================================================
-- 启动时自动启用防封基础项
-- ============================================================
if _G.XiaoHeiYuAntiBan then
    pcall(function() _G.XiaoHeiYuAntiBan.startHeartbeatJitter() end)
end

-- ============================================================
-- [第 3/5 条结束] 下一段：隐蔽引擎 + 左侧面板 + ESP + 飞行 + 子弹 + 更多刷钱职业
-- ============================================================
-- ============================================================
-- [续接第 3/5 条 · 第 4A/5 条]
-- ============================================================

-- ============================================================
-- 🛡 防封 A6 · 隐蔽引擎
-- 接口：_G.XiaoHeiYuStealth
-- ============================================================
do
    local S = {}
    S.CONFIG = {
        silent = true,
        randomIntervalMin = 0.6,
        randomIntervalMax = 1.8,
        batchSize = 4,
        actionCooldownMin = 0.05,
        actionCooldownMax = 0.15,
        radius = 40,
        quietLogWindow = 3,
    }

    local lastLogTime = {}
    local function silentLog(text, color)
        if not S.CONFIG.silent then
            Log.add(text, color or "gray")
            return
        end
        local key = tostring(text):sub(1, 20)
        local now = tick()
        if not lastLogTime[key] or now - lastLogTime[key] > S.CONFIG.quietLogWindow then
            lastLogTime[key] = now
            Log.add(text, color or "gray")
        end
    end
    S.log = silentLog

    function S.waitRandom()
        task.wait(S.CONFIG.randomIntervalMin
            + math.random() * (S.CONFIG.randomIntervalMax - S.CONFIG.randomIntervalMin))
    end

    function S.neutralize(part)
        if not part or not part.Parent then return end
        pcall(function()
            if part.CanTouch then part.CanTouch = false end
            if part.CanQuery then part.CanQuery = false end
        end)
        task.wait(S.CONFIG.actionCooldownMin
            + math.random() * (S.CONFIG.actionCooldownMax - S.CONFIG.actionCooldownMin))
    end

    function S.scan(radius, filterFn)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end
        local r = radius or S.CONFIG.radius
        local ok, parts = pcall(function()
            return workspace:GetPartBoundsInRadius(hrp.Position, r)
        end)
        if not ok or not parts then return 0 end
        local count = 0
        for _, part in ipairs(parts) do
            if count >= S.CONFIG.batchSize then break end
            if filterFn and filterFn(part) then
                S.neutralize(part)
                count = count + 1
            end
        end
        return count
    end

    _G.XiaoHeiYuStealth = S
    print("[小黑鱼 A6] 隐蔽引擎已加载")
end

-- ============ 隐蔽版防抓拍 / 交通三合一 ============
do
    local S = _G.XiaoHeiYuStealth

    local CAMERA_KEYWORDS = {"camera","traffic","photo","capture","snap","redlight","stopline","checkpoint","抓拍","摄像头","闯红灯","拍照","电子眼"}
    local WANTED_KEYWORDS = {"wanted","bounty","heat","crime","criminal","suspect","arrest","detain","pursuit","warrant","通缉","悬赏","热度","犯罪","嫌犯","逮捕","抓捕","追捕"}
    local FINE_KEYWORDS   = {"police","cop","officer","fine","ticket","penalty","violation","警察","警官","罚单","处罚","罚款","违规","违法"}

    local runningCamera = false
    function S.setAntiCameraV2(on)
        runningCamera = on
        if not on then return end
        task.spawn(function()
            while runningCamera do
                S.scan(40, function(part)
                    if not part:IsA("BasePart") then return false end
                    local n = part.Name:lower()
                    for _, kw in ipairs(CAMERA_KEYWORDS) do
                        if n:find(kw, 1, true) then return true end
                    end
                    return false
                end)
                S.waitRandom()
            end
        end)
        S.log("🛡 隐蔽防抓拍已开启", "green")
    end

    local runningFine = false
    function S.setAntiFineV2(on)
        runningFine = on
        if not on then return end
        task.spawn(function()
            while runningFine do
                S.scan(40, function(part)
                    if not part:IsA("BasePart") then return false end
                    local n = part.Name:lower()
                    for _, kw in ipairs(WANTED_KEYWORDS) do
                        if n:find(kw, 1, true) then return true end
                    end
                    for _, kw in ipairs(FINE_KEYWORDS) do
                        if n:find(kw, 1, true) then return true end
                    end
                    return false
                end)
                S.waitRandom()
            end
        end)
        S.log("🛡 隐蔽三合一已开启", "green")
    end

    S.enableAll = function()
        S.setAntiCameraV2(true)
        S.setAntiFineV2(true)
        S.log("🛡 隐蔽模式已全部开启", "green")
    end

    S.disableAll = function()
        runningCamera = false
        runningFine = false
        S.log("○ 隐蔽模式已关闭", "yellow")
    end

    S.setSilent = function(on)
        S.CONFIG.silent = on
    end
end

-- ============ 左侧悬浮控制台 ============
do
    local S = _G.XiaoHeiYuStealth
    local pg = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "XiaoHeiYu_StealthPanel"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = pg

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 200, 0, 190)
    panel.Position = UDim2.new(0, 20, 0.5, -95)
    panel.BackgroundColor3 = Color3.fromRGB(22, 26, 34)
    panel.BackgroundTransparency = 0.05
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Draggable = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 255, 160)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    stroke.Parent = panel

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🛡 隐蔽引擎 A6"
    title.TextColor3 = Color3.fromRGB(120, 255, 160)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.Parent = panel

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -16, 1, -40)
    btnContainer.Position = UDim2.new(0, 8, 0, 34)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = panel
    Instance.new("UIListLayout", btnContainer).Padding = UDim.new(0, 6)

    local function makeBtn(text, cb, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = color or Color3.fromRGB(40, 44, 58)
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(230, 230, 240)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = true
        btn.Parent = btnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.Activated:Connect(cb)
        return btn
    end

    makeBtn("✅ 一键开启隐蔽模式", function()
        S.enableAll()
    end, Color3.fromRGB(60, 100, 70))

    makeBtn("❌ 关闭隐蔽模式", function()
        S.disableAll()
    end, Color3.fromRGB(100, 60, 60))

    local silentBtn
    silentBtn = makeBtn("🔇 安静模式: 开", function()
        S.setSilent(not S.CONFIG.silent)
        silentBtn.Text = "🔇 安静模式: " .. (S.CONFIG.silent and "开" or "关")
    end, Color3.fromRGB(50, 60, 80))

    makeBtn("📊 查看状态", function()
        print("[小黑鱼 A6] 隐蔽引擎状态:")
        print("  · silent:", S.CONFIG.silent)
        print("  · 扫描间隔:", S.CONFIG.randomIntervalMin, "~", S.CONFIG.randomIntervalMax)
        print("  · 半径:", S.CONFIG.radius)
        print("  · 每批数量:", S.CONFIG.batchSize)
    end)

    Log.add("🛡 隐蔽引擎 A6 已加载，左侧面板可用", "green")
end

-- ============================================================
-- 🎯 DLC-1 · ESP 透视模块
-- 接口：_G.XiaoHeiYuESP
-- ============================================================
do
    local E = {}
    E.CONFIG = {
        enabled = false,
        showPlayers = true,
        showVehicles = true,
        showNPCs = false,
        showBox = true,
        showName = true,
        showDistance = true,
        showHealth = true,
        showLine = false,
        maxDistance = 1000,
        playerColor = Color3.fromRGB(120, 255, 160),
        vehicleColor = Color3.fromRGB(120, 180, 255),
        npcColor = Color3.fromRGB(255, 160, 120),
        textSize = 13,
        refreshInterval = 0.1,
    }

    local espFolder = nil
    local espObjects = {}
    local runThread = nil
    local running = false

    local function makeGui()
        if espFolder and espFolder.Parent then return espFolder end
        local coreGui = game:GetService("CoreGui")
        espFolder = Instance.new("Folder")
        espFolder.Name = "XiaoHeiYu_ESP"
        pcall(function() espFolder.Parent = coreGui end)
        if not espFolder.Parent then espFolder.Parent = player:WaitForChild("PlayerGui") end
        return espFolder
    end

    local function createESPFor(model, color)
        if espObjects[model] then return espObjects[model] end
        local data = {}

        if E.CONFIG.showBox then
            local box = Instance.new("SelectionBox")
            box.Name = "XHY_Box"
            box.Adornee = model
            box.Color3 = color
            box.LineThickness = 0.05
            box.SurfaceTransparency = 1
            box.Parent = makeGui()
            data.box = box
        end

        if E.CONFIG.showName or E.CONFIG.showDistance or E.CONFIG.showHealth then
            local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "XHY_Billboard"
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 200, 0, 60)
                billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = makeGui()

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size = UDim2.new(1, 0, 0, 20)
                nameLbl.Position = UDim2.new(0, 0, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = ""
                nameLbl.TextColor3 = color
                nameLbl.TextSize = E.CONFIG.textSize
                nameLbl.Font = Enum.Font.GothamBold
                nameLbl.TextStrokeTransparency = 0.3
                nameLbl.Parent = billboard

                local infoLbl = Instance.new("TextLabel")
                infoLbl.Size = UDim2.new(1, 0, 0, 18)
                infoLbl.Position = UDim2.new(0, 0, 0, 20)
                infoLbl.BackgroundTransparency = 1
                infoLbl.Text = ""
                infoLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
                infoLbl.TextSize = E.CONFIG.textSize - 1
                infoLbl.Font = Enum.Font.Gotham
                infoLbl.TextStrokeTransparency = 0.5
                infoLbl.Parent = billboard

                local healthBar = Instance.new("Frame")
                healthBar.Size = UDim2.new(0.8, 0, 0, 5)
                healthBar.Position = UDim2.new(0.1, 0, 0, 42)
                healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                healthBar.BorderSizePixel = 0
                healthBar.Parent = billboard
                Instance.new("UICorner", healthBar).CornerRadius = UDim.new(1, 0)

                local healthFill = Instance.new("Frame")
                healthFill.Name = "Fill"
                healthFill.Size = UDim2.new(1, 0, 1, 0)
                healthFill.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
                healthFill.BorderSizePixel = 0
                healthFill.Parent = healthBar
                Instance.new("UICorner", healthFill).CornerRadius = UDim.new(1, 0)

                data.billboard = billboard
                data.nameLbl = nameLbl
                data.infoLbl = infoLbl
                data.healthBar = healthBar
                data.healthFill = healthFill
            end
        end

        if E.CONFIG.showLine then
            local line = Instance.new("LineHandleAdornment")
            line.Name = "XHY_Line"
            line.Adornee = model:FindFirstChildWhichIsA("BasePart")
            line.Color3 = color
            line.Thickness = 2
            line.Length = 0
            line.AlwaysOnTop = true
            line.Parent = makeGui()
            data.line = line
        end

        espObjects[model] = data
        return data
    end

    local function destroyESP(model)
        local data = espObjects[model]
        if not data then return end
        for k, v in pairs(data) do
            if v and v.Destroy then pcall(function() v:Destroy() end) end
        end
        espObjects[model] = nil
    end

    local function clearAll()
        for model, _ in pairs(espObjects) do
            destroyESP(model)
        end
        espObjects = {}
        if espFolder then pcall(function() espFolder:Destroy() end) end
        espFolder = nil
    end

    local function collectTargets()
        local list = {}
        if E.CONFIG.showPlayers then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    table.insert(list, {model = p.Character, type = "player", name = p.Name, color = E.CONFIG.playerColor})
                end
            end
        end
        if E.CONFIG.showVehicles then
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") then
                    local hasSeat = obj:FindFirstChildWhichIsA("VehicleSeat", true)
                    if hasSeat then
                        table.insert(list, {model = obj, type = "vehicle", name = obj.Name, color = E.CONFIG.vehicleColor})
                    end
                end
            end
        end
        if E.CONFIG.showNPCs then
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") then
                    local humanoid = obj:FindFirstChildOfClass("Humanoid")
                    local isPlayerChar = false
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Character == obj then isPlayerChar = true; break end
                    end
                    if humanoid and not isPlayerChar then
                        table.insert(list, {model = obj, type = "npc", name = obj.Name, color = E.CONFIG.npcColor})
                    end
                end
            end
        end
        return list
    end

    local function updateESP()
        local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myPos = myHRP.Position

        local targets = collectTargets()
        local currentSet = {}

        for _, target in ipairs(targets) do
            local model = target.model
            currentSet[model] = true
            local data = createESPFor(model, target.color)

            local pos
            local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if primary then pos = primary.Position end

            if pos then
                local dist = (pos - myPos).Magnitude
                if dist > E.CONFIG.maxDistance then
                    if data.billboard then data.billboard.Enabled = false end
                    if data.box then data.box.Visible = false end
                else
                    if data.billboard then
                        data.billboard.Enabled = true
                        if data.nameLbl and E.CONFIG.showName then
                            data.nameLbl.Text = target.name
                        end
                        if data.infoLbl then
                            local parts = {}
                            if E.CONFIG.showDistance then
                                table.insert(parts, string.format("%.0fm", dist))
                            end
                            local humanoid = model:FindFirstChildOfClass("Humanoid")
                            if E.CONFIG.showHealth and humanoid then
                                table.insert(parts, string.format("%.0f/%.0f", humanoid.Health, humanoid.MaxHealth))
                            end
                            data.infoLbl.Text = table.concat(parts, "  ")
                        end
                        if data.healthFill then
                            local humanoid = model:FindFirstChildOfClass("Humanoid")
                            if humanoid and humanoid.MaxHealth > 0 then
                                local ratio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                                data.healthFill.Size = UDim2.new(ratio, 0, 1, 0)
                                if ratio > 0.6 then
                                    data.healthFill.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
                                elseif ratio > 0.3 then
                                    data.healthFill.BackgroundColor3 = Color3.fromRGB(255, 220, 100)
                                else
                                    data.healthFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                                end
                            end
                        end
                    end
                    if data.box then data.box.Visible = true end
                end
            end
        end

        for model, _ in pairs(espObjects) do
            if not currentSet[model] or not model.Parent then
                destroyESP(model)
            end
        end
    end

    function E.setEnabled(on)
        E.CONFIG.enabled = on
        if on then
            if running then return end
            running = true
            runThread = task.spawn(function()
                while running do
                    pcall(updateESP)
                    task.wait(E.CONFIG.refreshInterval)
                end
            end)
        else
            running = false
            if runThread then task.cancel(runThread); runThread = nil end
            clearAll()
        end
    end

    function E.setShowPlayers(on) E.CONFIG.showPlayers = on end
    function E.setShowVehicles(on) E.CONFIG.showVehicles = on end
    function E.setShowNPCs(on) E.CONFIG.showNPCs = on end
    function E.setShowBox(on) E.CONFIG.showBox = on; clearAll() end
    function E.setShowName(on) E.CONFIG.showName = on; clearAll() end
    function E.setShowDistance(on) E.CONFIG.showDistance = on; clearAll() end
    function E.setShowHealth(on) E.CONFIG.showHealth = on; clearAll() end

    function E.getConfig()
        return {
            enabled = E.CONFIG.enabled,
            showPlayers = E.CONFIG.showPlayers,
            showVehicles = E.CONFIG.showVehicles,
            showNPCs = E.CONFIG.showNPCs,
            showBox = E.CONFIG.showBox,
            showName = E.CONFIG.showName,
            showDistance = E.CONFIG.showDistance,
            showHealth = E.CONFIG.showHealth,
            maxDistance = E.CONFIG.maxDistance,
        }
    end

    E.clearAll = clearAll
    _G.XiaoHeiYuESP = E
    print("[小黑鱼 DLC] ESP 透视模块已加载")
end

-- ============================================================
-- 🚗 DLC-2 · 车辆飞行跳跃模块
-- 接口：_G.XiaoHeiYuFly
-- ============================================================
do
    local F = {}
    F.CONFIG = {
        flyEnabled = false,
        flySpeed = 8,
        flyHeight = 200,
        jumpEnabled = false,
        jumpPower = 120,
        noGravity = false,
    }

    local flyThread = nil
    local running = false
    local jumpConn = nil

    local function getVehicleModel()
        local char = player.Character
        if not char then return nil end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or not humanoid.SeatPart then return nil end
        return humanoid.SeatPart:FindFirstAncestorOfClass("Model")
    end

    local function flyLoop()
        while running do
            if F.CONFIG.flyEnabled then
                local veh = getVehicleModel()
                if veh then
                    for _, part in ipairs(veh:GetDescendants()) do
                        if part:IsA("BasePart") and not part.Anchored then
                            local isSeat = part:IsA("VehicleSeat")
                            local isRoot = part.Name:lower():find("root") ~= nil
                            if isSeat or isRoot then
                                pcall(function()
                                    part.AssemblyLinearVelocity = Vector3.new(
                                        part.AssemblyLinearVelocity.X,
                                        F.CONFIG.flySpeed,
                                        part.AssemblyLinearVelocity.Z
                                    )
                                end)
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end

    function F.setFlyEnabled(on)
        F.CONFIG.flyEnabled = on
        if on and not running then
            running = true
            flyThread = task.spawn(flyLoop)
        end
        if not on then
            if not F.CONFIG.jumpEnabled and not F.CONFIG.noGravity then
                running = false
                if flyThread then task.cancel(flyThread); flyThread = nil end
            end
        end
    end

    function F.setJumpEnabled(on)
        F.CONFIG.jumpEnabled = on
        if not on then
            if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
            return
        end
        if jumpConn then return end
        jumpConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local veh = getVehicleModel()
                if veh then
                    for _, part in ipairs(veh:GetDescendants()) do
                        if part:IsA("BasePart") and not part.Anchored then
                            if part:IsA("VehicleSeat") then
                                pcall(function()
                                    part.AssemblyLinearVelocity = part.AssemblyLinearVelocity
                                        + Vector3.new(0, F.CONFIG.jumpPower, 0)
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end

    function F.setNoGravity(on)
        F.CONFIG.noGravity = on
        local veh = getVehicleModel()
        if veh then
            for _, part in ipairs(veh:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored then
                    pcall(function()
                        part.GravityScale = on and 0 or 1
                    end)
                end
            end
        end
    end

    function F.stopAll()
        F.setFlyEnabled(false)
        F.setJumpEnabled(false)
        F.setNoGravity(false)
    end

    F.getConfig = function()
        return {
            flyEnabled = F.CONFIG.flyEnabled,
            flySpeed = F.CONFIG.flySpeed,
            jumpEnabled = F.CONFIG.jumpEnabled,
            jumpPower = F.CONFIG.jumpPower,
            noGravity = F.CONFIG.noGravity,
        }
    end

    _G.XiaoHeiYuFly = F
    print("[小黑鱼 DLC] 车辆飞行跳跃模块已加载")
end

-- ============================================================
-- 🔫 DLC-3 · 子弹模块（追踪 + 穿墙 + 无后坐力）
-- 接口：_G.XiaoHeiYuBullet
-- ============================================================
do
    local B = {}
    B.CONFIG = {
        trackEnabled = false,
        pierceEnabled = false,
        noRecoilEnabled = false,
        trackRange = 500,
    }

    local trackThread = nil
    local running = false

    local function getNearestPlayer()
        local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil end
        local myPos = myHRP.Position
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local d = (head.Position - myPos).Magnitude
                    if d < bestDist and d <= B.CONFIG.trackRange then
                        bestDist = d
                        best = head
                    end
                end
            end
        end
        return best
    end

    local function trackLoop()
        while running do
            if B.CONFIG.trackEnabled then
                local target = getNearestPlayer()
                local myChar = player.Character
                if target and myChar then
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        local dir = (target.Position - myHRP.Position).Unit
                        for _, obj in ipairs(workspace:GetChildren()) do
                            if obj:IsA("BasePart") then
                                local n = obj.Name:lower()
                                if n:find("bullet") or n:find("projectile") or n:find("弹") then
                                    pcall(function()
                                        obj.AssemblyLinearVelocity = dir * obj.AssemblyLinearVelocity.Magnitude
                                    end)
                                end
                            end
                        end
                        for _, container in ipairs(workspace:GetDescendants()) do
                            if container:IsA("Model") then
                                local n = container.Name:lower()
                                if n:find("bullet") or n:find("projectile") then
                                    for _, d in ipairs(container:GetDescendants()) do
                                        if d:IsA("BasePart") then
                                            pcall(function()
                                                d.AssemblyLinearVelocity = dir * d.AssemblyLinearVelocity.Magnitude
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end

    function B.setTrackEnabled(on)
        B.CONFIG.trackEnabled = on
        if on and not running then
            running = true
            trackThread = task.spawn(trackLoop)
        end
        if not on then
            if not B.CONFIG.pierceEnabled then
                running = false
                if trackThread then task.cancel(trackThread); trackThread = nil end
            end
        end
    end

    local pierceConn = nil
    local savedCollide = {}

    function B.setPierceEnabled(on)
        B.CONFIG.pierceEnabled = on
        if on then
            if pierceConn then return end
            pierceConn = RunService.Heartbeat:Connect(function()
                local myChar = player.Character
                if not myChar then return end
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("wall") then
                        if savedCollide[obj] == nil then
                            savedCollide[obj] = obj.CanCollide
                        end
                        pcall(function() obj.CanCollide = false end)
                    end
                end
            end)
        else
            if pierceConn then pierceConn:Disconnect(); pierceConn = nil end
            for part, val in pairs(savedCollide) do
                if part.Parent then pcall(function() part.CanCollide = val end) end
            end
            savedCollide = {}
        end
    end

    function B.setNoRecoil(on)
        B.CONFIG.noRecoilEnabled = on
        local camera = workspace.CurrentCamera
        if not camera then return end
        if on then
            pcall(function()
                camera.CameraType = Enum.CameraType.Custom
            end)
            if B._recoilConn then B._recoilConn:Disconnect() end
            B._recoilConn = RunService.RenderStepped:Connect(function()
                if not B.CONFIG.noRecoilEnabled then return end
                local char = player.Character
                if not char then return end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if camera.CameraType ~= Enum.CameraType.Custom then
                        camera.CameraType = Enum.CameraType.Custom
                    end
                end
            end)
        else
            if B._recoilConn then B._recoilConn:Disconnect(); B._recoilConn = nil end
        end
    end

    function B.stopAll()
        B.setTrackEnabled(false)
        B.setPierceEnabled(false)
        B.setNoRecoil(false)
    end

    B.getConfig = function()
        return {
            trackEnabled = B.CONFIG.trackEnabled,
            pierceEnabled = B.CONFIG.pierceEnabled,
            noRecoilEnabled = B.CONFIG.noRecoilEnabled,
            trackRange = B.CONFIG.trackRange,
        }
    end

    _G.XiaoHeiYuBullet = B
    print("[小黑鱼 DLC] 子弹模块已加载")
end

-- ============================================================
-- [第 4A/5 条结束] 下一段：更多刷钱职业 + DLC 面板 + A7 检测 + A7 检测面板 + 完成
-- ============================================================
-- ============================================================
-- [续接第 4A/5 条 · 第 4B/5 条]
-- ============================================================

-- ============================================================
-- 💰 DLC-4 · 更多刷钱职业
-- 接口：_G.XiaoHeiYuJobs
-- ============================================================
do
    local J = {}
    J.JOB_KEYWORDS = {
        food      = {"外卖", "food delivery", "food", "delivery food", "送餐", "送外卖"},
        tow       = {"拖车", "tow", "tow truck", "拖走", "清障"},
        police    = {"警车", "police", "cop", "巡逻", "出警", "patrol"},
        garbage   = {"垃圾", "garbage", "trash", "环卫", "收垃圾"},
        firetruck = {"消防", "fire", "firetruck", "灭火", "救火"},
        bus_check = {"公交检查", "bus check", "查票", "检票", "bus inspector"},
    }
    J.JOB_NAMES = {
        food = "外卖", tow = "拖车", police = "警车",
        garbage = "垃圾车", firetruck = "消防车", bus_check = "公交检查",
    }

    local runningJobs = {}
    local jobThreads = {}

    local function tryClickJobButton(jobType)
        local keywords = J.JOB_KEYWORDS[jobType]
        if not keywords then return false end
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return false end
        for _, gui in ipairs(pg:GetDescendants()) do
            if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible and not gui:IsDescendantOf(screenGui) then
                local txt = ""
                if gui:IsA("TextButton") then txt = gui.Text
                else
                    local tl = gui:FindFirstChildWhichIsA("TextLabel", true)
                    if tl then txt = tl.Text end
                end
                local lower = txt:lower()
                for _, kw in ipairs(keywords) do
                    if lower:find(kw:lower(), 1, true) then
                        pcall(function() gui:Activate() end)
                        return true, txt
                    end
                end
            end
        end
        return false
    end

    local function runJob(jobType)
        while runningJobs[jobType] do
            Log.add("📱 " .. (J.JOB_NAMES[jobType] or jobType) .. " 尝试接单...", "blue")
            local ok, txt = tryClickJobButton(jobType)
            if ok then
                Log.add("✓ " .. (J.JOB_NAMES[jobType] or jobType) .. " 接单成功: " .. txt, "green")
            else
                local vp = workspace.CurrentCamera.ViewportSize
                VirtualInputManager:SendMouseButtonEvent(vp.X * PHONE_POS_X, vp.Y * PHONE_POS_Y, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(vp.X * PHONE_POS_X, vp.Y * PHONE_POS_Y, 0, false, game, 0)
                Log.add("· " .. (J.JOB_NAMES[jobType] or jobType) .. " 未找到按钮，已尝试点击手机", "yellow")
            end

            local targetPos = nil
            for i = 1, 15 do
                if not runningJobs[jobType] then return end
                task.wait(0.4)
                if _G.XiaoHeiYuTeleport then
                    targetPos = _G.XiaoHeiYuTeleport.getTargetPosition()
                    if targetPos then break end
                end
            end

            if targetPos and _G.XiaoHeiYuTeleport then
                _G.XiaoHeiYuTeleport.teleportForJob(targetPos)
                task.wait(2.5)
                local targetPos2 = _G.XiaoHeiYuTeleport.getTargetPosition()
                if targetPos2 then
                    _G.XiaoHeiYuTeleport.teleportForJob(targetPos2)
                end
                Log.add("✅ " .. (J.JOB_NAMES[jobType] or jobType) .. " 订单完成", "green")
            else
                Log.add("· " .. (J.JOB_NAMES[jobType] or jobType) .. " 未找到目标", "yellow")
            end
            task.wait(2)
        end
    end

    function J.setJob(jobType, on)
        if not J.JOB_KEYWORDS[jobType] then return end
        runningJobs[jobType] = on
        if jobThreads[jobType] then
            task.cancel(jobThreads[jobType])
            jobThreads[jobType] = nil
        end
        if on then
            jobThreads[jobType] = task.spawn(function()
                runJob(jobType)
            end)
        end
    end

    J.getActive = function()
        local list = {}
        for k, v in pairs(runningJobs) do
            if v then table.insert(list, k) end
        end
        return list
    end

    _G.XiaoHeiYuJobs = J
    print("[小黑鱼 DLC] 更多刷钱职业模块已加载")
end

-- ============================================================
-- 🎛 DLC 悬浮控制台（右侧）
-- ============================================================
do
    local gui = Instance.new("ScreenGui")
    gui.Name = "XiaoHeiYu_DLC_Panel"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 220, 0, 440)
    panel.Position = UDim2.new(1, -240, 0.5, -220)
    panel.BackgroundColor3 = Color3.fromRGB(22, 26, 34)
    panel.BackgroundTransparency = 0.05
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Draggable = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 80, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    stroke.Parent = panel

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🎁 DLC 控制台"
    title.TextColor3 = Color3.fromRGB(180, 150, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.Parent = panel

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -16, 1, -40)
    list.Position = UDim2.new(0, 8, 0, 34)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.Parent = panel
    Instance.new("UIListLayout", list).Padding = UDim.new(0, 6)

    local function mkBtn(text, cb, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 30)
        b.BackgroundColor3 = color or Color3.fromRGB(40, 44, 58)
        b.BackgroundTransparency = 0.15
        b.Text = text
        b.TextColor3 = Color3.fromRGB(230, 230, 240)
        b.TextSize = 11
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = true
        b.Parent = list
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.Activated:Connect(cb)
        return b
    end

    mkBtn("🎯 ESP: 关", function(self)
        local on = not _G.XiaoHeiYuESP.CONFIG.enabled
        _G.XiaoHeiYuESP.setEnabled(on)
        self.Text = "🎯 ESP: " .. (on and "开" or "关")
    end, Color3.fromRGB(60, 80, 100))
    mkBtn("🎯 ESP 仅玩家", function()
        _G.XiaoHeiYuESP.setShowVehicles(false)
        _G.XiaoHeiYuESP.setShowNPCs(false)
        _G.XiaoHeiYuESP.setShowPlayers(true)
        _G.XiaoHeiYuESP.setEnabled(true)
    end)
    mkBtn("🚗 车辆飞行: 关", function(self)
        local on = not _G.XiaoHeiYuFly.CONFIG.flyEnabled
        _G.XiaoHeiYuFly.setFlyEnabled(on)
        self.Text = "🚗 车辆飞行: " .. (on and "开" or "关")
    end, Color3.fromRGB(60, 100, 70))
    mkBtn("🚗 车辆跳跃: 关", function(self)
        local on = not _G.XiaoHeiYuFly.CONFIG.jumpEnabled
        _G.XiaoHeiYuFly.setJumpEnabled(on)
        self.Text = "🚗 车辆跳跃: " .. (on and "开" or "关")
    end, Color3.fromRGB(60, 100, 70))
    mkBtn("🔫 子弹追踪: 关", function(self)
        local on = not _G.XiaoHeiYuBullet.CONFIG.trackEnabled
        _G.XiaoHeiYuBullet.setTrackEnabled(on)
        self.Text = "🔫 子弹追踪: " .. (on and "开" or "关")
    end, Color3.fromRGB(100, 60, 60))
    mkBtn("🔫 穿墙: 关", function(self)
        local on = not _G.XiaoHeiYuBullet.CONFIG.pierceEnabled
        _G.XiaoHeiYuBullet.setPierceEnabled(on)
        self.Text = "🔫 穿墙: " .. (on and "开" or "关")
    end, Color3.fromRGB(100, 60, 60))
    mkBtn("💰 外卖", function()
        local a = _G.XiaoHeiYuJobs.getActive()
        _G.XiaoHeiYuJobs.setJob("food", not (table.find(a, "food") ~= nil))
    end, Color3.fromRGB(100, 80, 50))
    mkBtn("💰 拖车", function()
        local a = _G.XiaoHeiYuJobs.getActive()
        _G.XiaoHeiYuJobs.setJob("tow", not (table.find(a, "tow") ~= nil))
    end, Color3.fromRGB(100, 80, 50))
    mkBtn("💰 警车", function()
        local a = _G.XiaoHeiYuJobs.getActive()
        _G.XiaoHeiYuJobs.setJob("police", not (table.find(a, "police") ~= nil))
    end, Color3.fromRGB(100, 80, 50))
    mkBtn("💰 垃圾车", function()
        local a = _G.XiaoHeiYuJobs.getActive()
        _G.XiaoHeiYuJobs.setJob("garbage", not (table.find(a, "garbage") ~= nil))
    end, Color3.fromRGB(100, 80, 50))
    mkBtn("💰 消防车", function()
        local a = _G.XiaoHeiYuJobs.getActive()
        _G.XiaoHeiYuJobs.setJob("firetruck", not (table.find(a, "firetruck") ~= nil))
    end, Color3.fromRGB(100, 80, 50))
    mkBtn("💰 公交检查", function()
        local a = _G.XiaoHeiYuJobs.getActive()
        _G.XiaoHeiYuJobs.setJob("bus_check", not (table.find(a, "bus_check") ~= nil))
    end, Color3.fromRGB(100, 80, 50))
    mkBtn("❌ 全部 DLC 关闭", function()
        if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setEnabled(false) end
        if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.stopAll() end
        if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.stopAll() end
        if _G.XiaoHeiYuJobs then
            for _, k in ipairs(_G.XiaoHeiYuJobs.getActive()) do
                _G.XiaoHeiYuJobs.setJob(k, false)
            end
        end
        Log.add("○ DLC 全部关闭", "yellow")
    end, Color3.fromRGB(120, 60, 60))

    Log.add("🎁 DLC 控制台已加载（右侧面板）", "blue")
end

-- ============================================================
-- 🛡 防封 A7 · 增强检测模块
-- 接口：_G.XiaoHeiYuGuard
-- ============================================================
do
    local G = {}
    G.CONFIG = {
        detectKick = true, detectRemote = true, detectScript = true,
        detectSpeed = true, detectTeleport = true, detectHealth = true, detectMarked = true,
        speedThreshold = 250, teleportDistThreshold = 500,
        teleportFreqThreshold = 5, healthDropThreshold = 80,
        autoEmergencyStop = true, emergencyCooldown = 3,
        showPanel = true, maxLogs = 30,
    }
    G.events = {}
    G.lastEmergency = 0
    G.stats = {kickCount=0, remoteSuspicious=0, scriptSuspicious=0, speedWarn=0, teleportWarn=0, healthWarn=0, markedWarn=0}
    G.teleportHistory = {}

    local function pushEvent(text, level)
        table.insert(G.events, 1, {time=os.date("%H:%M:%S"), text=text, level=level or "gray"})
        if #G.events > G.CONFIG.maxLogs then table.remove(G.events) end
        if _G.__xhy_a7_refresh then pcall(_G.__xhy_a7_refresh) end
    end
    G.pushEvent = pushEvent

    local function emergencyStop(reason)
        if not G.CONFIG.autoEmergencyStop then return end
        local now = tick()
        if now - G.lastEmergency < G.CONFIG.emergencyCooldown then return end
        G.lastEmergency = now
        pushEvent("🚨 紧急熔断: " .. reason, "red")
        pcall(function()
            if _G.XiaoHeiYuESP then _G.XiaoHeiYuESP.setEnabled(false) end
            if _G.XiaoHeiYuFly then _G.XiaoHeiYuFly.stopAll() end
            if _G.XiaoHeiYuBullet then _G.XiaoHeiYuBullet.stopAll() end
            if _G.XiaoHeiYuJobs then
                for _, k in ipairs(_G.XiaoHeiYuJobs.getActive()) do
                    _G.XiaoHeiYuJobs.setJob(k, false)
                end
            end
            if _G.XiaoHeiYuTeleport then
                _G.XiaoHeiYuTeleport.LOW_PROFILE = true
                _G.XiaoHeiYuTeleport.AGGRESSIVE_MODE = false
            end
            if _G.XiaoHeiYuStealth then _G.XiaoHeiYuStealth.disableAll() end
        end)
        pushEvent("○ 已自动关闭所有功能", "yellow")
    end
    G.emergencyStop = emergencyStop

    -- 1. Kick / 断线
    if G.CONFIG.detectKick then
        pcall(function()
            player.CharacterRemoving:Connect(function()
                G.stats.kickCount = G.stats.kickCount + 1
                pushEvent("🔔 角色移除（可能被踢/重载）", "yellow")
            end)
        end)
        pcall(function()
            Players.PlayerRemoving:Connect(function(p)
                if p == player then pushEvent("🔔 检测到你被移出服务器", "red") end
            end)
        end)
    end

    -- 2. Remote 检测
    if G.CONFIG.detectRemote then
        local SUSP = {"kick","ban","detect","anticheat","anti_cheat","verify","check",
            "watch","report","flag","suspicious","检测","封禁","踢出","举报","标记"}
        task.spawn(function()
            local rs = ReplicatedStorage
            local seen = {}
            local function check(obj)
                if seen[obj] then return end
                seen[obj] = true
                local n = obj.Name:lower()
                for _, kw in ipairs(SUSP) do
                    if n:find(kw, 1, true) then
                        G.stats.remoteSuspicious = G.stats.remoteSuspicious + 1
                        pushEvent("📡 可疑 Remote: " .. obj.Name, "yellow")
                        break
                    end
                end
            end
            for _, obj in ipairs(rs:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then check(obj) end
            end
            rs.DescendantAdded:Connect(function(obj)
                task.wait(0.1)
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then check(obj) end
            end)
        end)
    end

    -- 3. 反作弊脚本检测
    if G.CONFIG.detectScript then
        local SK = {"anticheat","anti-cheat","anti_cheat","detector","watchdog",
            "monitor","guard","protect","反作弊","检测","监控","守卫"}
        task.spawn(function()
            local seen = {}
            local function scan()
                for _, obj in ipairs(game:GetDescendants()) do
                    if (obj:IsA("LocalScript") or obj:IsA("Script")) and not seen[obj] then
                        seen[obj] = true
                        local n = obj.Name:lower()
                        for _, kw in ipairs(SK) do
                            if n:find(kw, 1, true) then
                                G.stats.scriptSuspicious = G.stats.scriptSuspicious + 1
                                pushEvent("🕵 可疑脚本: " .. obj:GetFullName(), "yellow")
                                break
                            end
                        end
                    end
                end
            end
            scan()
            while true do
                task.wait(5)
                scan()
            end
        end)
    end

    -- 4. 速度检测
    if G.CONFIG.detectSpeed then
        task.spawn(function()
            while true do
                task.wait(0.5)
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local v = hrp.AssemblyLinearVelocity.Magnitude
                    if v > G.CONFIG.speedThreshold then
                        G.stats.speedWarn = G.stats.speedWarn + 1
                        pushEvent(string.format("🚗 速度异常: %.0f", v), "yellow")
                        if v > G.CONFIG.speedThreshold * 2 then
                            emergencyStop("速度异常过大")
                        end
                    end
                end
            end
        end)
    end

    -- 5. 传送检测
    if G.CONFIG.detectTeleport then
        task.spawn(function()
            local lastPos = nil
            while true do
                task.wait(0.5)
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if lastPos then
                        local d = (hrp.Position - lastPos).Magnitude
                        if d > G.CONFIG.teleportDistThreshold then
                            G.stats.teleportWarn = G.stats.teleportWarn + 1
                            local now = tick()
                            table.insert(G.teleportHistory, now)
                            while #G.teleportHistory > 0 and now - G.teleportHistory[1] > 5 do
                                table.remove(G.teleportHistory, 1)
                            end
                            pushEvent(string.format("🌀 传送距离: %.0f", d), "yellow")
                            if #G.teleportHistory >= G.CONFIG.teleportFreqThreshold then
                                emergencyStop("传送过于频繁")
                            end
                        end
                    end
                    lastPos = hrp.Position
                end
            end
        end)
    end

    -- 6. 血量检测
    if G.CONFIG.detectHealth then
        local function watch()
            local char = player.Character
            if not char then return end
            local h = char:FindFirstChildOfClass("Humanoid")
            if not h then return end
            local last = h.Health
            h.HealthChanged:Connect(function(nh)
                if nh < last and (last - nh) >= G.CONFIG.healthDropThreshold then
                    G.stats.healthWarn = G.stats.healthWarn + 1
                    pushEvent(string.format("💥 大量掉血: -%.0f", last - nh), "yellow")
                end
                last = nh
            end)
        end
        if player.Character then task.spawn(watch) end
        player.CharacterAdded:Connect(function() task.spawn(watch) end)
    end

    -- 7. 标记检测
    if G.CONFIG.detectMarked then
        local MK = {"wanted","bounty","heat","crime","suspect","arrest","marked",
            "flagged","suspicious","通缉","悬赏","热度","犯罪","嫌犯","标记","嫌疑"}
        task.spawn(function()
            while true do
                task.wait(2)
                local containers = {
                    player, player.Character, player:FindFirstChild("PlayerGui"),
                    player:FindFirstChild("Backpack"), player:FindFirstChild("PlayerScripts")
                }
                for _, container in ipairs(containers) do
                    if container then
                        for _, obj in ipairs(container:GetDescendants()) do
                            for _, attr in ipairs(obj:GetAttributes()) do
                                local an = attr:lower()
                                for _, kw in ipairs(MK) do
                                    if an:find(kw, 1, true) then
                                        local val = obj:GetAttribute(attr)
                                        if type(val) == "number" and val > 0 then
                                            G.stats.markedWarn = G.stats.markedWarn + 1
                                            pushEvent("⚠ 被标记: " .. obj.Name .. "." .. attr .. " = " .. tostring(val), "red")
                                            pcall(function() obj:SetAttribute(attr, 0) end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    G.getStats = function()
        return {
            kickCount = G.stats.kickCount,
            remoteSuspicious = G.stats.remoteSuspicious,
            scriptSuspicious = G.stats.scriptSuspicious,
            speedWarn = G.stats.speedWarn,
            teleportWarn = G.stats.teleportWarn,
            healthWarn = G.stats.healthWarn,
            markedWarn = G.stats.markedWarn,
        }
    end
    G.getEvents = function() return G.events end

    _G.XiaoHeiYuGuard = G
    print("[小黑鱼 A7] 增强检测模块已加载，_G.XiaoHeiYuGuard")
end

-- ============================================================
-- 🛡 A7 检测面板（左下角）
-- ============================================================
do
    local G = _G.XiaoHeiYuGuard
    if not G then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "XiaoHeiYu_GuardPanel"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 260, 0, 320)
    panel.Position = UDim2.new(0, 20, 1, -340)
    panel.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    panel.BackgroundTransparency = 0.05
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Draggable = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 200, 100)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    stroke.Parent = panel

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🛡 A7 检测面板"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.Parent = panel

    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, -16, 0, 80)
    statsLabel.Position = UDim2.new(0, 8, 0, 32)
    statsLabel.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
    statsLabel.BackgroundTransparency = 0.3
    statsLabel.BorderSizePixel = 0
    statsLabel.Text = ""
    statsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    statsLabel.TextSize = 11
    statsLabel.Font = Enum.Font.Code
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.TextYAlignment = Enum.TextYAlignment.Top
    statsLabel.Parent = panel
    Instance.new("UICorner", statsLabel).CornerRadius = UDim.new(0, 6)

    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, -16, 0, 140)
    logLabel.Position = UDim2.new(0, 8, 0, 118)
    logLabel.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
    logLabel.BackgroundTransparency = 0.3
    logLabel.BorderSizePixel = 0
    logLabel.Text = ""
    logLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    logLabel.TextSize = 10
    logLabel.Font = Enum.Font.Code
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.TextYAlignment = Enum.TextYAlignment.Top
    logLabel.TextWrapped = true
    logLabel.Parent = panel
    Instance.new("UICorner", logLabel).CornerRadius = UDim.new(0, 6)

    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, -16, 0, 40)
    btnRow.Position = UDim2.new(0, 8, 1, -48)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = panel

    local function refresh()
        local s = G.getStats()
        statsLabel.Text = string.format(
            "🛡 实时统计\n" ..
            "  · 被踢: %d\n" ..
            "  · 可疑Remote: %d\n" ..
            "  · 可疑脚本: %d\n" ..
            "  · 速度异常: %d\n" ..
            "  · 传送异常: %d\n" ..
            "  · 血量异常: %d\n" ..
            "  · 被标记: %d",
            s.kickCount, s.remoteSuspicious, s.scriptSuspicious,
            s.speedWarn, s.teleportWarn, s.healthWarn, s.markedWarn)

        local lines = {}
        for i = 1, math.min(8, #G.events) do
            local e = G.events[i]
            table.insert(lines, string.format("[%s] %s", e.time, e.text))
        end
        if #lines == 0 then lines = {"等待事件..."} end
        logLabel.Text = table.concat(lines, "\n")
    end
    _G.__xhy_a7_refresh = refresh
    refresh()

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0.5, -3, 1, 0)
    clearBtn.Position = UDim2.new(0, 0, 0, 0)
    clearBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 100)
    clearBtn.BackgroundTransparency = 0.2
    clearBtn.Text = "🧹 清空日志"
    clearBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
    clearBtn.TextSize = 11
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = btnRow
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)
    clearBtn.Activated:Connect(function()
        G.events = {}
        refresh()
    end)

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0.5, -3, 1, 0)
    stopBtn.Position = UDim2.new(0.5, 3, 0, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
    stopBtn.BackgroundTransparency = 0.2
    stopBtn.Text = "🚨 手动熔断"
    stopBtn.TextColor3 = Color3.fromRGB(255, 230, 230)
    stopBtn.TextSize = 11
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.Parent = btnRow
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)
    stopBtn.Activated:Connect(function()
        G.CONFIG.autoEmergencyStop = true
        G.emergencyStop("手动触发")
        refresh()
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            pcall(refresh)
        end
    end)

    Log.add("🛡 A7 检测面板已加载（左下角）", "green")
end

-- ============================================================
-- ✅ 完整版 A7 全部加载完成
-- ============================================================
Log.add("🎉 小黑鱼 A6+A7 全部加载完成", "green")
print("[小黑鱼] 完整版 A7 已全部加载")
print("  · _G.XiaoHeiYuAntiBan  - 防封 A6")
print("  · _G.XiaoHeiYuTeleport  - 传送")
print("  · _G.XiaoHeiYuStealth   - 隐蔽引擎")
print("  · _G.XiaoHeiYuESP       - ESP")
print("  · _G.XiaoHeiYuFly       - 车辆飞行跳跃")
print("  · _G.XiaoHeiYuBullet    - 子弹")
print("  · _G.XiaoHeiYuJobs      - 更多刷钱职业")
print("  · _G.XiaoHeiYuGuard     - 防封 A7 增强检测")