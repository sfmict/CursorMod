local config, UIParent, GetCursorPosition = CursorModConfig, UIParent, GetCursorPosition
config.cursorFrame = CreateFrame("FRAME", nil, UIParent)
local cursorFrame = config.cursorFrame
cursorFrame:SetFrameStrata("TOOLTIP")
config.cursor = cursorFrame:CreateTexture(nil, "OVERLAY")
local cursor = config.cursor
cursor[1], cursor[2] = true, true


local function show(n)
	cursor[n] = false
	if cursor[3] then return end
	local x, y = GetCursorPosition()
	local scale = cursor.scale
	cursor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
	cursor:Show()
end


local function hide(n)
	cursor[n] = true
	if cursor[1] and cursor[2] or cursor[3] then cursor:Hide() end
end


function cursorFrame:PLAYER_STARTED_LOOKING() show(1) end
function cursorFrame:PLAYER_STARTED_TURNING() show(2) end
function cursorFrame:PLAYER_STOPPED_LOOKING() hide(1) end
function cursorFrame:PLAYER_STOPPED_TURNING() hide(2) end
function cursorFrame:PLAYER_REGEN_DISABLED() show(3) end
function cursorFrame:PLAYER_REGEN_ENABLED() hide(3) end
cursorFrame:SetScript("OnEvent", function(self, event) self[event](self) end)