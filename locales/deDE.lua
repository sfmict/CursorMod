if GetLocale() ~= "deDE" then
	return
end

local _, L = ...

L["author"] = "Autor"
L["%s Configuration"] = "%s Konfiguration"
L["Profile"] = "Profil"
L["New profile"] = "Neues Profil"
L["Create"] = "Erstellen"
L["Copy current"] = "Kopie der aktuellen"
L["Set as default"] = "Als Standard festlegen"
L["A profile with the same name exists."] = "Es existiert ein Profil mit demselben Namen."
L["Are you sure you want to delete profile %s?"] = "Bist Du dir sicher, dass Du das Profil %s löschen möchten?"
-- L["Resize cursor"] = ""
-- L["Autoscaling"] = ""
-- L["Scale"] = ""
-- L["Opacity"] = ""
-- L["Use class color"] = ""
-- L["Show only in combat"] = ""