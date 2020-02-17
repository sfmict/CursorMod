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
		if type(self.config.autoScale) ~= "boolean" and not self.config.scale then
			self.config.autoScale = true
		end
		self.config.scale = self.config.scale or 1
		self.config.opacity = self.config.opacity or 1
		self.config.color = self.config.color or {1, 1, 1}

		self:setAutoScale()
		config:openConfig()
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


function config:setAutoScale()
	if self.config.autoScale then
		if not self.defuiscale then
			local useUiScale = GetCVar("useUiScale")
			SetCVar("useUiScale", 0)
			self.defuiscale = UIParent:GetEffectiveScale()
			SetCVar("useUiScale", useUiScale)

			hooksecurefunc("SetCVar", function(cmd)
				if cmd == "useUiScale" or cmd == "uiscale" or cmd == "gxMonitor" then
					self:setAutoScale()
				end
			end)
		end

		self.config.scale = self.defuiscale / UIParent:GetEffectiveScale()
		if self.scaleSlider then
			self.scaleSlider:SetValue(math.floor(self.config.scale * 100 + .5) / 100)
		end
	end

	self:setCursorSettings()
end


function config:setCursorSettings()
	self.cursor:SetTexture(self.textures[self.config.texPoint])
	self.cursor:SetSize(self.config.size, self.config.size)
	self.cursor:SetScale(self.config.scale)
	self.cursor:SetAlpha(self.config.opacity)
	self.cursor:SetVertexColor(unpack(self.config.color))

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
		self.cursorPreview:SetTexture(self.textures[self.config.texPoint])
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
	else
		InterfaceOptionsFrame_OpenToCategory(addon)
		if not InterfaceOptionsFrameAddOns:IsVisible() then
			InterfaceOptionsFrame_OpenToCategory(addon)
		end
	end
end


SLASH_CURSORMODCONFIG1 = "/cursormod"
SlashCmdList["CURSORMODCONFIG"] = function() config:openConfig() end