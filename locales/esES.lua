if GetLocale() ~= "esES" then
	return
end

local _, L = ...

L["author"] = "Autor"
L["%s Configuration"] = "Configuración de %s"
L["Profile"] = "Perfil"
L["New profile"] = "Nuevo perfil"
L["Create"] = "Crear"
L["Copy current"] = "Copiar actual"
L["Set as default"] = "Establecer predeterminado"
L["A profile with the same name exists."] = "Ya existe un perfil con el mismo nombre."
L["Are you sure you want to delete profile %s?"] = "¿Confirma que quiere borrar el perfil %s?"
-- L["Resize cursor"] = ""
-- L["Autoscaling"] = ""
-- L["Scale"] = ""
-- L["Opacity"] = ""
-- L["Use class color"] = ""
-- L["Show only in combat"] = ""