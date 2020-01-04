local config, UIParent, GetCursorPosition, f = CursorModConfig, UIParent, GetCursorPosition, 0
config.cursorFrame = CreateFrame("FRAME", nil, UIParent)
config.cursorFrame:SetFrameStrata("TOOLTIP")
config.cursor = config.cursorFrame:CreateTexture(nil, "OVERLAY")
local cursor = config.cursor


local function show()
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale() * cursor:GetScale()

	cursor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
	cursor:Show()
	f = f + 1
end


local function hide(force)
	f = f - 1
	if f < 0 or force then f = 0 end
	if f == 0 then cursor:Hide() end
end


hooksecurefunc("TurnOrActionStart", show)
hooksecurefunc("TurnOrActionStop", hide)
hooksecurefunc("CameraOrSelectOrMoveStart", show)
hooksecurefunc("CameraOrSelectOrMoveStop", hide)
hooksecurefunc("MoveAndSteerStart", show)
hooksecurefunc("MoveAndSteerStop", function() hide(1) end)
MovieFrame:HookScript("OnMovieFinished", function() hide(1) end)