local config, UIParent, GetCursorPosition = CursorModConfig, UIParent, GetCursorPosition
config.cursorFrame = CreateFrame("FRAME", nil, UIParent)
config.cursorFrame:SetFrameStrata("TOOLTIP")
config.cursor = config.cursorFrame:CreateTexture(nil, "OVERLAY")
local cursor = config.cursor
cursor[1], cursor[2], cursor[3] = true, true, true


local function show(n)
	cursor[n] = false
	local x, y = GetCursorPosition()
	local scale = cursor.scale
	cursor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
	cursor:Show()
end


local function hide(n)
	if n == 3 then
		cursor[1] = true
		cursor[2] = true
		cursor[3] = true
	else
		cursor[n] = true
	end
	if cursor[1] and cursor[2] and cursor[3] then cursor:Hide() end
end


hooksecurefunc("CameraOrSelectOrMoveStart", function() show(1) end)
hooksecurefunc("CameraOrSelectOrMoveStop", function() hide(1) end)
hooksecurefunc("TurnOrActionStart", function() show(2) end)
hooksecurefunc("TurnOrActionStop", function() hide(2) end)
hooksecurefunc("MouselookStart", function() show(2) end)
hooksecurefunc("MouselookStop", function() hide(2) end)
hooksecurefunc("MoveAndSteerStart", function() show(3) end)
hooksecurefunc("MoveAndSteerStop", function() hide(3) end)
MovieFrame:HookScript("OnMovieFinished", function() hide(3) end)
