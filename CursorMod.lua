local config, UIParent, GetCursorPosition = CursorModConfig, UIParent, GetCursorPosition
local cursorFrame = CreateFrame("FRAME", nil, UIParent)
config.cursorFrame = cursorFrame
cursorFrame:SetFrameStrata("TOOLTIP")
cursorFrame.glow = cursorFrame:CreateTexture(nil, "BORDER")
cursorFrame.outline = cursorFrame:CreateTexture(nil, "ARTWORK")
cursorFrame.cursor = cursorFrame:CreateTexture(nil, "OVERLAY")
cursorFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT")
cursorFrame:Hide()
cursorFrame[1], cursorFrame[2] = true, true


cursorFrame:SetScript("OnShow", function(self)
	local x, y = GetCursorPosition()
	local scale = self.scale
	self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
end)


function cursorFrame:show(n)
	self[n] = false
	if self[3] or self[1] and self[2] and not config.pConfig.showAlways then return end
	self:Show()
end


function cursorFrame:hide(n)
	self[n] = true
	if self[1] and self[2] or self[3] then self:Hide() end
end


function cursorFrame:PLAYER_STARTED_LOOKING() self:show(1) end
function cursorFrame:PLAYER_STARTED_TURNING() self:show(2) end
function cursorFrame:PLAYER_STOPPED_LOOKING() self:hide(1) end
function cursorFrame:PLAYER_STOPPED_TURNING() self:hide(2) end
function cursorFrame:PLAYER_REGEN_DISABLED() self:show(3) end
function cursorFrame:PLAYER_REGEN_ENABLED() self:hide(3) end
cursorFrame:SetScript("OnEvent", function(self, event) self[event](self) end)