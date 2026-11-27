if GetLocale() ~= "deDE" then
	return
end

local _, ns = ...
local L = ns.L

L["author"] = "Autor"
L["%s Configuration"] = "%s Konfiguration"
L["Profile"] = "Profil"
L["New profile"] = "Neues Profil"
L["Create"] = "Erstellen"
L["Copy current"] = "Aktuelles kopieren"
L["Set as default"] = "Als Standard festlegen"
L["A profile with the same name exists."] = "Es existiert ein Profil mit demselben Namen."
L["Are you sure you want to delete profile %s?"] = "Bist du dir sicher, dass du das Profil %s löschen möchtest?"
L["Resize cursor"] = "Cursorgröße ändern"
L["Autoscaling"] = "Automatische Skalierung"
L["Scale"] = "Skalierung"
L["Opacity"] = "Deckkraft"
L["Use class color"] = "Klassenfarbe verwenden"
L["Show only in combat"] = "Nur im Kampf anzeigen"
L["Show always"] = "Immer anzeigen"
L["Cursor freelook start delta"] = "Startschwelle für Cursor-Freelook"
