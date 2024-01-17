local _, L = ...

L["author"] = "Author"
L["%s Configuration"] = "%s Configuration"
L["Profile"] = "Profile"
L["New profile"] = "New profile"
L["Create"] = "Create"
L["Copy current"] = "Copy current"
L["Set as default"] = "Set as default"
L["A profile with the same name exists."] = "A profile with the same name exists."
L["Are you sure you want to delete profile %s?"] = "Are you sure you want to delete profile %s?"
L["Resize cursor"] = "Resize cursor"
L["Autoscaling"] = "Autoscaling"
L["Scale"] = "Scale"
L["Opacity"] = "Opacity"
L["Show only in combat"] = "Show only in combat"

setmetatable(L, {__index = function(self, key)
	self[key] = key or ""
	return key
end})