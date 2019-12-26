local addon, L = ...
local config = CreateFrame("FRAME", "CursorModConfig", InterfaceOptionsFramePanelContainer)
config.name = addon


config:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	end
end)
config:RegisterEvent("ADDON_LOADED")


function config:ADDON_LOADED(addonName)
	if addonName == addon then
		self:UnregisterEvent("ADDON_LOADED")

		CursorModDB = CursorModDB or {}
		self.globalDB = CursorModDB
		self.globalDB.config = self.globalDB.config or {}
		self.config = self.globalDB.config
		self.config.size = self.config.size or 32
		self.config.scale = self.config.scale or 1
		self.config.opacity = self.config.opacity or 1
		self.config.color = self.config.color or {1, 1, 1}
		self.cursor = UIParent.cursorTexture

		self:setCursorSettings()
	end
end


config:SetScript("OnShow", function(self)
	-- ADDON INFO
	local info = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	info:SetPoint("TOPRIGHT", -16, 16)
	info:SetTextColor(.5, .5, .5, 1)
	info:SetText(format("%s %s: %s", GetAddOnMetadata(addon, "Version"), L["author"], GetAddOnMetadata(addon, "Author")))

	-- TITLE
	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(format(L["%s Configuration"], addon))

	-- PREVIEW BACKGROUND
	local previewBg = self:CreateTexture(nil, "BACKGROUND")
	previewBg:SetTexture("Interface/ChatFrame/ChatFrameBackground")
	previewBg:SetVertexColor(.1, .1, .1, .5)
	previewBg:SetSize(128, 128)
	previewBg:SetPoint("TOPLEFT", 16, -70)

	-- PREVIEW CURSOR
	local cursorPreview = self:CreateTexture(nil, "ARTWORK")
	self.cursorPreview = cursorPreview
	cursorPreview:SetTexture("Interface/AddOns/CursorMod/texture/point.blp")
	cursorPreview:SetPoint("CENTER", previewBg)

	-- SIZE COMBOBOX
	local sizeCombobox = CreateFrame("FRAME", "CursorModSize", self, "UIDropDownMenuTemplate")
	sizeCombobox:SetPoint("TOPLEFT", previewBg, "TOPRIGHT", 10, 7)

	UIDropDownMenu_Initialize(sizeCombobox, function(self, level, menuList)
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

	-- SIZE
	local scaleSlider = CreateFrame("SLIDER", nil, self, "OptionsSliderTemplate")
	scaleSlider:SetSize(400, 17)
	scaleSlider:SetPoint("TOPLEFT", sizeCombobox, "BOTTOMLEFT", 20, -15)
	scaleSlider:SetMinMaxValues(.1, 2)
	scaleSlider.Low:Hide()
	scaleSlider.High:Hide()
	scaleSlider.Text:SetFontObject("GameFontNormalSmall")
	scaleSlider.Text:SetText(L["Scale"])
	scaleSlider.label = scaleSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	scaleSlider.label:SetPoint("LEFT", scaleSlider, "RIGHT", 2, 1)
	scaleSlider:SetValue(self.config.opacity)
	scaleSlider.label:SetText(self.config.opacity)
	scaleSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value * 100 + .05) / 100
		config.config.scale = value
		config:setCursorSettings()
		self.label:SetText(value)
		self:SetValue(value)
	end)

	-- OPACITY
	local opacitySlider = CreateFrame("SLIDER", nil, self, "OptionsSliderTemplate")
	opacitySlider:SetSize(400, 17)
	opacitySlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -15)
	opacitySlider:SetMinMaxValues(.1, 1)
	opacitySlider.Low:Hide()
	opacitySlider.High:Hide()
	opacitySlider.Text:SetFontObject("GameFontNormalSmall")
	opacitySlider.Text:SetText(L["Opacity"])
	opacitySlider.label = opacitySlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	opacitySlider.label:SetPoint("LEFT", opacitySlider, "RIGHT", 2, 1)
	opacitySlider:SetValue(self.config.scale)
	opacitySlider.label:SetText(self.config.scale)
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
		local r, g, b = colorTex:GetVertexColor()
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


function config:setCursorSettings()
	self.cursor:SetSize(self.config.size, self.config.size)
	self.cursor:SetScale(self.config.scale)
	self.cursor:SetAlpha(self.config.opacity)
	self.cursor:SetVertexColor(unpack(self.config.color))

	if self.cursorPreview then
		self.cursorPreview:SetSize(self.config.size, self.config.size)
		self.cursorPreview:SetScale(self.config.scale)
		self.cursorPreview:SetAlpha(self.config.opacity)
		self.cursorPreview:SetVertexColor(unpack(self.config.color))
	end
end


-- ADD CATEGORY
InterfaceOptions_AddCategory(config)


-- OPEN CONFIG
function config:openConfig()
	if InterfaceOptionsFrameAddOns:IsVisible() and self:IsVisible() then
		InterfaceOptionsFrame:Hide()
		self:cancel()
	else
		InterfaceOptionsFrame_OpenToCategory(addon)
		if not InterfaceOptionsFrameAddOns:IsVisible() then
			InterfaceOptionsFrame_OpenToCategory(addon)
		end
	end
end


SLASH_CURSORMODCONFIG1 = "/cursormod"
SlashCmdList["CURSORMODCONFIG"] = function() config:openConfig() end