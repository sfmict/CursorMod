local _, L = ...

L["author"] = "Author"
L["%s Configuration"] = "%s Configuration"
L["Scale"] = "Scale"
L["Opacity"] = "Opacity"

setmetatable(L, {__index = function(self, key)
	self[key] = key or ""
	return key
end})