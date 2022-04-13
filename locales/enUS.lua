local _, L = ...

L["author"] = "Author"
L["%s Configuration"] = "%s Configuration"
L["Resize cursor"] = "Resize cursor"
L["Autoscaling"] = "Autoscaling"
L["Scale"] = "Scale"
L["Opacity"] = "Opacity"
L["Show only in combat"] = "Show only in combat"

setmetatable(L, {__index = function(self, key)
	self[key] = key or ""
	return key
end})