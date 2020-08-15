local addon, L = ...
local config = CreateFrame("FRAME", "CursorModConfig", InterfaceOptionsFramePanelContainer)
config.name = addon


config.textures = {
	"Interface/AddOns/CursorMod/texture/point",
	"Interface/cursor/point",
	"Interface/cursor/unablepoint",
	"Interface/AddOns/CursorMod/texture/point-inverse",
	"Interface/AddOns/CursorMod/texture/point-ghostly",
}


config:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
config:RegisterEvent("ADDON_LOADED")
config:RegisterEvent("PLAYER_LOGIN")


function config:ADDON_LOADED(addonName)
	if addonName == addon then
		self:UnregisterEvent("ADDON_LOADED")

		CursorModDB = CursorModDB or {}
		self.globalDB = CursorModDB
		self.globalDB.config = self.globalDB.config or {}
		self.config = self.globalDB.config
		self.config.texPoint = self.config.texPoint or 1
		if not self.config.size then
			local cursorSizePreferred = GetCVar("cursorSizePreferred")
			if cursorSizePreferred == "2" then
				self.config.size = 64
			elseif cursorSizePreferred == "1" then
				self.config.size = 48
			else
				self.config.size = 32
			end
		end
		if type(self.config.autoScale) ~= "boolean" then
			self.config.autoScale = true
		end
		self.config.scale = self.config.scale or 1
		self.config.opacity = self.config.opacity or 1
		self.config.color = self.config.color or {1, 1, 1}

		hooksecurefunc(UIParent, "SetScale", function() self:setAutoScale() end)
		self:RegisterEvent("UI_SCALE_CHANGED")
		self:setAutoScale()
	end
end


config:SetScript("OnShow", function(self)
	-- ADDON INFO
	local info = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	info:SetPoint("TOPRIGHT", -16, 16)
	info:SetTextColor(.5, .5, .5, 1)
	info:SetJustifyH("RIGHT")
	info:SetText(("%s %s: %s"):format(GetAddOnMetadata(addon, "Version"), L["author"], GetAddOnMetadata(addon, "Author")))

	-- TITLE
	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetJustifyH("LEFT")
	title:SetText(L["%s Configuration"]:format(addon))

	-- PREVIEW BACKGROUND
	local previewBg = self:CreateTexture(nil, "BACKGROUND")
	previewBg:SetTexture("Interface/ChatFrame/ChatFrameBackground")
	previewBg:SetVertexColor(.1, .1, .1, .5)
	previewBg:SetSize(128, 128)
	previewBg:SetPoint("TOPLEFT", 16, -110)

	-- PREVIEW CURSOR
	local cursorPreview = self:CreateTexture(nil, "ARTWORK")
	self.cursorPreview = cursorPreview
	cursorPreview:SetPoint("CENTER", previewBg)

	-- TEXTURE SELECT
	local function textureBtnClick(btn)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self.textureBtn[self.config.texPoint].check:Hide()
		btn.check:Show()
		self.config.texPoint = btn.id
		self:setCursorSettings()
	end

	self.textureBtn = {}
	local function createTextureButton(texPath, id)
		local btn = CreateFrame("BUTTON", nil, self, "CursorModTextureSelectTemplate")

		if id == 1 then
			btn:SetPoint("BOTTOMLEFT", previewBg, "TOPLEFT", 0, 20)
		else
			btn:SetPoint("LEFT", self.textureBtn[id - 1], "RIGHT")
		end

		btn.id = id
		btn.icon:SetTexture(texPath)
		btn:SetScript("OnClick", textureBtnClick)
		tinsert(self.textureBtn, btn)
	end

	for i, texPath in ipairs(self.textures) do
		createTextureButton(texPath, i)
	end

	self.textureBtn[self.config.texPoint].check:Show()

	-- SIZE COMBOBOX
	local sizeCombobox = CreateFrame("FRAME", "CursorModSize", self, "UIDropDownMenuTemplate")
	sizeCombobox:SetPoint("TOPLEFT", previewBg, "TOPRIGHT", 10, 6)

	UIDropDownMenu_Initialize(sizeCombobox, function(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for _, size in ipairs({32, 48, 64}) do
			info.checked = nil
			info.text = size.."x"..size
			info.value = size
			info.func = function(self)
				config.config.size = self.value
				config:setCursorSettings()
				UIDropDownMenu_SetSelectedValue(sizeCombobox, self.value)
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	UIDropDownMenu_SetSelectedValue(sizeCombobox, self.config.size)
	UIDropDownMenu_SetText(sizeCombobox, self.config.size.."x"..self.config.size)

	-- CHANGE CURSOR SIZE
	local changeCursorSize = CreateFrame("CheckButton", nil, self, "CursorModCheckButtonTemplate")
	changeCursorSize:SetPoint("LEFT", sizeCombobox, "RIGHT", 120, 1)
	changeCursorSize.Text:SetText(L["Resize cursor"])
	changeCursorSize:SetChecked(self.config.changeCursorSize)
	changeCursorSize:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		config.config.changeCursorSize = checked
		config:setCursorSettings()
	end)

	-- SCALE
	local scaleSlider = CreateFrame("SLIDER", nil, self, "CursorModSliderTemplate")
	self.scaleSlider = scaleSlider
	scaleSlider:SetPoint("TOPLEFT", sizeCombobox, "BOTTOMLEFT", 20, -15)
	scaleSlider:SetMinMaxValues(.1, 2)
	scaleSlider.text:SetText(L["Scale"])
	local scale = math.floor(self.config.scale * 100 + .5) / 100
	scaleSlider:SetValue(scale)
	scaleSlider.label:SetText(scale)
	scaleSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value * 100 + .5) / 100
		config.config.scale = value
		config:setCursorSettings()
		self.label:SetText(value)
		self:SetValue(value)
	end)
	scaleSlider:SetEnabled(not self.config.autoScale)

	-- AUTO SCALE
	local autoScaleCheckbox = CreateFrame("CheckButton", nil, self, "OptionsBaseCheckButtonTemplate")
	autoScaleCheckbox:SetPoint("RIGHT", scaleSlider, "LEFT", 0, 0)
	autoScaleCheckbox.tooltipOwnerPoint = "ANCHOR_TOP"
	autoScaleCheckbox.tooltipText = L["Autoscaling"]
	autoScaleCheckbox:SetChecked(self.config.autoScale)
	autoScaleCheckbox:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		scaleSlider:SetEnabled(not checked)
		config.config.autoScale = checked
		config:setAutoScale()
	end)

	-- OPACITY
	local opacitySlider = CreateFrame("SLIDER", nil, self, "CursorModSliderTemplate")
	opacitySlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -15)
	opacitySlider:SetMinMaxValues(.1, 1)
	opacitySlider.text:SetText(L["Opacity"])
	opacitySlider:SetValue(self.config.opacity)
	opacitySlider.label:SetText(self.config.opacity)
	opacitySlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value * 10 + .5) / 10
		config.config.opacity = value
		config:setCursorSettings()
		self.label:SetText(value)
		self:SetValue(value)
	end)

	-- COLOR
	local colorBtn =  CreateFrame("BUTTON", nil, self)
	colorBtn:SetSize(30, 30)
	colorBtn:SetPoint("TOPLEFT", opacitySlider, "BOTTOMLEFT", -3, -15)
	colorBtn:SetNormalTexture("Interface/ChatFrame/ChatFrameColorSwatch")
	local colorTex = colorBtn:GetNormalTexture()
	colorTex:SetVertexColor(unpack(self.config.color))
	local function updateColor()
		colorTex:SetVertexColor(ColorPickerFrame:GetColorRGB())
		config.config.color = {ColorPickerFrame:GetColorRGB()}
		config:setCursorSettings()
	end
	local function cancelColor(previousColor)
		colorTex:SetVertexColor(unpack(previousColor))
		config.config.color = previousColor
		config:setCursorSettings()
	end
	colorBtn:SetScript("OnClick", function()
		local r, g, b = unpack(config.config.color)
		ColorPickerFrame.previousValues = {r, g, b}
		ColorPickerFrame.func = updateColor
		ColorPickerFrame.cancelFunc = cancelColor
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Show()
	end)

	local btnResetColor = CreateFrame("BUTTON", nil, self, "UIPanelButtonTemplate")
	btnResetColor:SetSize(60, 22)
	btnResetColor:SetPoint("LEFT", colorBtn, "RIGHT", 3, 0)
	btnResetColor:SetText(RESET)
	btnResetColor:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		colorTex:SetVertexColor(1, 1, 1)
		config.config.color = {1, 1, 1}
		config:setCursorSettings()
	end)

	-- SET SETTINGS
	self:setCursorSettings()

	-- RESET ONSHOW
	self:SetScript("OnShow", nil)
end)


local function DecodeResolution(valueString)
	local xIndex = strfind(valueString, "x")
	local width = strsub(valueString, 1, xIndex - 1)
	local height = strsub(valueString, xIndex + 1, strlen(valueString))
	local widthIndex = strfind(height, " ")
	if widthIndex ~= nil then
		height = strsub(height, 0, widthIndex - 1)
	end
	return tonumber(width), tonumber(height)
end


function config:setAutoScale()
	if self.config.autoScale then
		local width
		if GetCVarBool("gxMaximize") then
			local _, resolution = GetScreenResolutions(GetCVar("gxMonitor") + 1, true)
			width = DecodeResolution(resolution)
		else
			width = GetPhysicalScreenSize()
		end
		self.autoScale = WorldFrame:GetWidth() / width / UIParent:GetScale()
	else
		self.autoScale = nil
	end

	self:setCursorSettings()
end
config.UI_SCALE_CHANGED = config.setAutoScale


function config:setCursorSettings()
	local scale = self.autoScale or self.config.scale
	self.cursor:SetTexture(self.textures[self.config.texPoint])
	self.cursor:SetSize(self.config.size, self.config.size)
	self.cursor:SetScale(scale)
	self.cursor:SetAlpha(self.config.opacity)
	self.cursor:SetVertexColor(unpack(self.config.color))
	self.cursor.scale = scale * UIParent:GetScale()

	if self.config.changeCursorSize then
		if self.config.size == 64 then
			SetCVar("cursorSizePreferred", 2)
		elseif self.config.size == 48 then
			SetCVar("cursorSizePreferred", 1)
		else
			SetCVar("cursorSizePreferred", 0)
		end
	end

	if self.cursorPreview then
		if scale > 2 then scale = 2 end
		self.cursorPreview:SetTexture(self.textures[self.config.texPoint])
		self.cursorPreview:SetSize(self.config.size, self.config.size)
		self.cursorPreview:SetScale(scale)
		self.cursorPreview:SetAlpha(self.config.opacity)
		self.cursorPreview:SetVertexColor(unpack(self.config.color))
	end

	if self.ldbButton then
		self.ldbButton.icon = self.textures[self.config.texPoint]
	end
end


-- ADD CATEGORY
InterfaceOptions_AddCategory(config)


-- OPEN CONFIG
function config:openConfig()
	if InterfaceOptionsFrameAddOns:IsVisible() and self:IsVisible() then
		InterfaceOptionsFrame:Hide()
	else
		InterfaceOptionsFrame_OpenToCategory(addon)
		if not InterfaceOptionsFrameAddOns:IsVisible() then
			InterfaceOptionsFrame_OpenToCategory(addon)
		end
	end
end


SLASH_CURSORMODCONFIG1 = "/cursormod"
SlashCmdList["CURSORMODCONFIG"] = function() config:openConfig() end


-- ADD BUTTON TO DATABROKER
function config:PLAYER_LOGIN()
	if LibStub then
		local ldb = LibStub("LibDataBroker-1.1", true)
		if ldb then
			local r, g, b = unpack(config.config.color)
			local r2, g2, b2 = 1, 1, 1
			config.ldbButton = ldb:NewDataObject("CursorMod", {
				type = "launcher",
				text = "CursorMod",
				icon = config.textures[config.config.texPoint],
				iconCoords = {0, .9, 0, .9},
				iconR = r,
				iconG = g,
				iconB = b,
				OnTooltipShow = function(tooltip)
					tooltip:SetText(("%s (|cffff7f3f%s|r)"):format(addon, GetAddOnMetadata(addon, "Version")))
				end,
				OnClick = function() config:openConfig() end,
				OnEnter = function()
					config.cursorFrame:SetScript("OnUpdate", function(_, elaps)
						elaps = elaps / 2
						if r > 1 then r2 = -1 end
						if r < 0 then r2 = 1 end
						r = r + r2 * (elaps - elaps / random(3))
						if g > 1 then g2 = -1 end
						if g < 0 then g2 = 1 end
						g = g + g2 * elaps
						if b > 1 then b2 = -1 end
						if b < 0 then b2 = 1 end
						b = b + b2 * (elaps + elaps / random(3))
						config.ldbButton.iconR = r
						config.ldbButton.iconG = g
						config.ldbButton.iconB = b
					end)
				end,
				OnLeave = function()
					config.cursorFrame:SetScript("OnUpdate", nil)
				end,
			})
		end
	end
end