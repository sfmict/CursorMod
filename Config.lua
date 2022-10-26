local addon, L = ...
local config = CreateFrame("FRAME", "CursorModConfig")
config:Hide()


config.textures = {
	"Interface/AddOns/CursorMod/texture/point",
	{
		{"Interface/cursor/UICursor2x", 261/512, 293/512, 67/256, 99/256},
		{"Interface/cursor/UICursor2x", 393/512, 441/512, 1/256, 49/256},
		{"Interface/cursor/UICursor2x", 261/512, 325/512, 1/256, 65/256},
		{"Interface/cursor/UICursor2x", 1/512, 97/512, 131/256, 227/256},
		{"Interface/cursor/UICursor2x", 1/512, 129/512, 1/256, 129/256},
	},
	{
		{"Interface/cursor/UICursor2x", 261/512, 293/512, 101/256, 133/256},
		{"Interface/cursor/UICursor2x", 443/512, 491/512, 1/256, 49/256},
		{"Interface/cursor/UICursor2x", 327/512, 391/512, 1/256, 65/256},
		{"Interface/cursor/UICursor2x", 131/512, 227/512, 131/256, 227/256},
		{"Interface/cursor/UICursor2x", 131/512, 259/512, 1/256, 129/256},
	},
	-- "Interface/cursor/unablepoint",
	"Interface/AddOns/CursorMod/texture/point-inverse",
	"Interface/AddOns/CursorMod/texture/point-ghostly",
}


config:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
config:RegisterEvent("ADDON_LOADED")
config:RegisterEvent("PLAYER_LOGIN")


function config:ADDON_LOADED(addonName)
	if addonName == addon then
		self:UnregisterEvent("ADDON_LOADED")
		self.ADDON_LOADED = nil

		CursorModDB = CursorModDB or {}
		self.globalDB = CursorModDB
		self.globalDB.config = self.globalDB.config or {}
		self.config = self.globalDB.config
		self.config.texPoint = self.config.texPoint or 1
		if self.config.size == nil then
			local cursorSizePreferred = tonumber(GetCVar("cursorSizePreferred"))
			if cursorSizePreferred == -1 then cursorSizePreferred = 0 end
			self.config.size = cursorSizePreferred
		end
		if type(self.config.autoScale) ~= "boolean" then
			self.config.autoScale = true
		end
		self.config.scale = self.config.scale or 1
		self.config.opacity = self.config.opacity or 1
		self.config.color = self.config.color or {1, 1, 1}

		self.sizes = {[0] = 32, 48, 64, 96, 128}
		hooksecurefunc(UIParent, "SetScale", function() self:setAutoScale() end)
		self:RegisterEvent("UI_SCALE_CHANGED")
		self:setAutoScale()
		self:setCombatTracking()

		self.cursorFrame:RegisterEvent("PLAYER_STARTED_LOOKING")
		self.cursorFrame:RegisterEvent("PLAYER_STARTED_TURNING")
		self.cursorFrame:RegisterEvent("PLAYER_STOPPED_LOOKING")
		self.cursorFrame:RegisterEvent("PLAYER_STOPPED_TURNING")
	end
end


config:SetScript("OnShow", function(self)
	self:SetScript("OnShow", function(self)
		self:SetPoint("TOPLEFT", -12, 8)
	end)
	self:SetPoint("TOPLEFT", -12, 8)

	-- ADDON INFO
	local info = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	info:SetPoint("TOPLEFT", 40, 20)
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
	local function createTextureButton(id, texPath, left, right, top, bottom)
		local btn = CreateFrame("BUTTON", nil, self, "CursorModTextureSelectTemplate")

		if id == 1 then
			btn:SetPoint("BOTTOMLEFT", previewBg, "TOPLEFT", 0, 20)
		else
			btn:SetPoint("LEFT", self.textureBtn[id - 1], "RIGHT")
		end

		btn.id = id
		btn.icon:SetTexture(texPath)
		btn.icon:SetTexCoord(left, right, top, bottom)
		btn:SetScript("OnClick", textureBtnClick)
		tinsert(self.textureBtn, btn)
	end

	for i, texPath in ipairs(self.textures) do
		if type(texPath) == "table" then
			createTextureButton(i, unpack(texPath[1]))
		else
			createTextureButton(i, texPath, 0, 1, 0, 1)
		end
	end

	self.textureBtn[self.config.texPoint].check:Show()

	-- SIZE COMBOBOX
	local sizeCombobox = CreateFrame("FRAME", "CursorModSize", self, "UIDropDownMenuTemplate")
	sizeCombobox:SetPoint("TOPLEFT", previewBg, "TOPRIGHT", 10, 6)

	UIDropDownMenu_Initialize(sizeCombobox, function(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for i = 0, #config.sizes do
			local size = config.sizes[i]
			info.checked = nil
			info.text = size.."x"..size
			info.value = i
			info.func = function(self)
				config.config.size = self.value
				config:setCursorSettings()
				UIDropDownMenu_SetSelectedValue(sizeCombobox, self.value)
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	UIDropDownMenu_SetSelectedValue(sizeCombobox, self.config.size)
	local size = self.sizes[self.config.size]
	UIDropDownMenu_SetText(sizeCombobox, size.."x"..size)

	-- CHANGE CURSOR SIZE
	local changeCursorSize = CreateFrame("CheckButton", nil, self, "CursorModCheckButtonTemplate")
	changeCursorSize:SetPoint("LEFT", sizeCombobox, "RIGHT", 120, 2)
	changeCursorSize.Text:SetText(L["Resize cursor"])
	changeCursorSize:SetChecked(self.config.changeCursorSize)
	changeCursorSize:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		config.config.changeCursorSize = checked
		config:setCursorSettings()
	end)

	-- SCALE
	local scaleSlider = CreateFrame("FRAME", nil, self, "CursorModSliderTemplate")
	self.scaleSlider = scaleSlider
	scaleSlider:SetPoint("TOPLEFT", sizeCombobox, "BOTTOMLEFT", 20, -15)
	local value = math.floor(self.config.scale * 100 + .5) / 100
	local options = Settings.CreateSliderOptions(.1, 2, .01)
	scaleSlider:Init(value, options.minValue, options.maxValue, options.steps, options.formatters)
	scaleSlider.text:SetText(L["Scale"])
	scaleSlider.RightText:SetText(value)
	scaleSlider.RightText:Show()
	scaleSlider.OnSliderValueChanged = function(self, value)
		value = math.floor(value * 100 + .5) / 100
		config.config.scale = value
		config:setCursorSettings()
		self.RightText:SetText(value)
	end
	scaleSlider:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, scaleSlider.OnSliderValueChanged, scaleSlider)
	scaleSlider:SetEnabled_(not self.config.autoScale)

	-- AUTO SCALE
	local autoScaleCheckbox = CreateFrame("CheckButton", nil, self, "CursorModCheckButtonArtTemplate")
	autoScaleCheckbox:SetPoint("RIGHT", scaleSlider, "LEFT", 0, 0)
	autoScaleCheckbox.tooltipOwnerPoint = "ANCHOR_TOP"
	autoScaleCheckbox.tooltipText = L["Autoscaling"]
	autoScaleCheckbox:SetChecked(self.config.autoScale)
	autoScaleCheckbox:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		scaleSlider:SetEnabled_(not checked)
		config.config.autoScale = checked
		config:setAutoScale()
	end)

	-- OPACITY
	local opacitySlider = CreateFrame("SLIDER", nil, self, "CursorModSliderTemplate")
	opacitySlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -15)
	local options = Settings.CreateSliderOptions(.1, 1, .1)
	opacitySlider:Init(self.config.opacity, options.minValue, options.maxValue, options.steps, options.formatters)
	opacitySlider.text:SetText(L["Opacity"])
	opacitySlider.RightText:SetText(self.config.opacity)
	opacitySlider.RightText:Show()
	opacitySlider.OnSliderValueChanged = function(self, value)
		value = math.floor(value * 10 + .5) / 10
		config.config.opacity = value
		config:setCursorSettings()
		self.RightText:SetText(value)
	end
	opacitySlider:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, opacitySlider.OnSliderValueChanged, opacitySlider)

	-- COLOR
	local colorBtn =  CreateFrame("BUTTON", nil, self)
	colorBtn:SetSize(30, 30)
	colorBtn:SetPoint("TOPLEFT", opacitySlider, "BOTTOMLEFT", -3, -15)
	colorBtn:SetNormalTexture("Interface/ChatFrame/ChatFrameColorSwatch")
	local colorTex = colorBtn:GetNormalTexture()
	colorTex:SetVertexColor(unpack(self.config.color))

	colorBtn.swatchFunc = function()
		colorTex:SetVertexColor(ColorPickerFrame:GetColorRGB())
		config.config.color = {ColorPickerFrame:GetColorRGB()}
		config:setCursorSettings()
	end
	colorBtn.cancelFunc = function(color)
		config.config.color = {color.r, color.g, color.b}
		colorTex:SetVertexColor(color.r, color.g, color.b)
		config:setCursorSettings()
	end
	colorBtn:SetScript("OnClick", function(btn)
		btn.r, btn.g, btn.b = unpack(config.config.color)
		OpenColorPicker(btn)
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

	-- SHOW ONLY IN COMBAT
	local showOnlyInCombat = CreateFrame("CheckButton", nil, self, "CursorModCheckButtonTemplate")
	showOnlyInCombat:SetPoint("TOPLEFT", previewBg, "BOTTOMLEFT", 0, -15)
	showOnlyInCombat.Text:SetText(L["Show only in combat"])
	showOnlyInCombat:SetChecked(self.config.showOnlyInCombat)
	showOnlyInCombat:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		config.config.showOnlyInCombat = checked
		config:setCombatTracking()
	end)

	-- SET SETTINGS
	self:setCursorSettings()
end)


function config:setAutoScale()
	if self.config.autoScale then
		local width
		if GetCVarBool("gxMaximize") then
			width = C_VideoOptions.GetGameWindowSizes(GetCVar("gxMonitor"), true)[1].x
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


function config:setCombatTracking()
	if self.config.showOnlyInCombat then
		self.cursorFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		self.cursorFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.cursor[3] = not InCombatLockdown()
	else
		self.cursorFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self.cursorFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self.cursor[3] = false
	end
end


function config:setCursorSettings()
	local size = self.sizes[self.config.size]
	local scale = self.autoScale or self.config.scale

	local textures, left, right, top, bottom = self.textures[self.config.texPoint]
	if type(textures) == "table" then
		textures, left, right, top, bottom = unpack(textures[self.config.size + 1])
	else
		textures, left, right, top, bottom = textures, 0, 1, 0, 1
	end

	self.cursor:SetTexture(textures)
	self.cursor:SetTexCoord(left, right, top, bottom)
	self.cursor:SetSize(size, size)
	self.cursor:SetScale(scale)
	self.cursor:SetAlpha(self.config.opacity)
	self.cursor:SetVertexColor(unpack(self.config.color))
	self.cursor.scale = scale * UIParent:GetScale()

	local cursorSizePreferred = tonumber(GetCVar("cursorSizePreferred"))
	if self.config.changeCursorSize then
		if cursorSizePreferred ~= self.config.size then
			SetCVar("cursorSizePreferred", self.config.size)
		end
	elseif cursorSizePreferred ~= -1 then
		SetCVar("cursorSizePreferred", -1)
	end

	if self.cursorPreview then
		if size * scale > 128 then
			scale = 128 / size
		end
		self.cursorPreview:SetTexture(textures)
		self.cursorPreview:SetTexCoord(left, right, top, bottom)
		self.cursorPreview:SetSize(size, size)
		self.cursorPreview:SetScale(scale)
		self.cursorPreview:SetAlpha(self.config.opacity)
		self.cursorPreview:SetVertexColor(unpack(self.config.color))
	end

	if self.ldbButton then
		self.ldbButton.icon = textures
		self.ldbButton.iconCoords = {left, right - (right - left) * .1, top, bottom - (bottom - top) * .1}
	end
end


-- ADD CATEGORY
local category, layout = Settings.RegisterCanvasLayoutCategory(config, addon)
category.ID = addon
-- layout:AddAnchorPoint("TOPLEFT", -12, 8)
-- layout:AddAnchorPoint("BOTTOMRIGHT", 0, 0)
Settings.RegisterAddOnCategory(category)


-- OPEN CONFIG
function config:openConfig()
	if SettingsPanel:IsVisible() and self:IsVisible() then
		HideUIPanel(SettingsPanel)
	else
		Settings.OpenToCategory(addon, true)
	end
end


SLASH_CURSORMODCONFIG1 = "/cursormod"
SlashCmdList["CURSORMODCONFIG"] = function() config:openConfig() end


-- ADD BUTTON TO DATABROKER
function config:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
	local ldb = LibStub and LibStub("LibDataBroker-1.1", true)
	if ldb then
		local r, g, b = unpack(self.config.color)
		local r2, g2, b2 = 1, 1, 1

		local textures, left, right, top, bottom = self.textures[self.config.texPoint]
		if type(textures) == "table" then
			textures, left, right, top, bottom = unpack(textures[self.config.size + 1])
		else
			textures, left, right, top, bottom = textures, 0, 1, 0, 1
		end

		self.ldbButton = ldb:NewDataObject("CursorMod", {
			type = "launcher",
			text = "CursorMod",
			icon = textures,
			iconCoords = {left, right - (right - left) * .1, top, bottom - (bottom - top) * .1},
			iconR = r,
			iconG = g,
			iconB = b,
			OnTooltipShow = function(tooltip)
				tooltip:SetText(("%s (|cffff7f3f%s|r)"):format(addon, GetAddOnMetadata(addon, "Version")))
			end,
			OnClick = function() self:openConfig() end,
			OnEnter = function()
				self.cursorFrame:SetScript("OnUpdate", function(_, elaps)
					elaps = elaps / 2
					if r > 1 then r2 = -1
					elseif r < 0 then r2 = 1 end
					r = r + r2 * (elaps - elaps / random(3))
					if g > 1 then g2 = -1
					elseif g < 0 then g2 = 1 end
					g = g + g2 * elaps
					if b > 1 then b2 = -1
					elseif b < 0 then b2 = 1 end
					b = b + b2 * (elaps + elaps / random(3))
					self.ldbButton.iconR = r
					self.ldbButton.iconG = g
					self.ldbButton.iconB = b
				end)
			end,
			OnLeave = function()
				self.cursorFrame:SetScript("OnUpdate", nil)
			end,
		})
	end
end