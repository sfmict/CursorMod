local cursor, f = UIParent:CreateTexture(nil, "OVERLAY"), 0
UIParent.cursorTexture = cursor
cursor:SetTexture("Interface/AddOns/CursorMod/texture/point.blp")


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