if GetLocale() ~= "frFR" then
	return
end

local _, ns = ...
local L = ns.L

L["author"] = "Auteur"
L["%s Configuration"] = "%s Configuration"
L["Profile"] = "Profil"
L["New profile"] = "Nouveau profil"
L["Create"] = "Créer"
L["Copy current"] = "Copier l'actuel"
L["Set as default"] = "Définir par défaut"
L["A profile with the same name exists."] = "Un profil portant le même nom existe."
L["Are you sure you want to delete profile %s?"] = "Êtes-vous sûr de vouloir supprimer le profil %s ?"
L["Resize cursor"] = "Redimensionner le curseur"
L["Autoscaling"] = "Mise à l'échelle automatique"
L["Scale"] = "Échelle"
L["Opacity"] = "Opacité"
L["Use class color"] = "Utiliser la couleur de classe"
L["Show only in combat"] = "Afficher uniquement en combat"
L["Show always"] = "Toujours afficher"
L["Cursor freelook start delta"] = "Seuil de démarrage de la vue libre du curseur"
