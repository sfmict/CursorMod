if GetLocale() ~= "esES" then
	return
end

local _, ns = ...
local L = ns.L

L["author"] = "Autor"
L["%s Configuration"] = "Configuración de %s"
L["Profile"] = "Perfil"
L["New profile"] = "Nuevo perfil"
L["Create"] = "Crear"
L["Copy current"] = "Copiar actual"
L["Set as default"] = "Establecer como predeterminado"
L["A profile with the same name exists."] = "Ya existe un perfil con el mismo nombre."
L["Are you sure you want to delete profile %s?"] = "¿Confirma que quiere borrar el perfil %s?"
L["Resize cursor"] = "Cambiar tamaño del cursor"
L["Autoscaling"] = "Escalado automático"
L["Scale"] = "Escala"
L["Opacity"] = "Opacidad"
L["Use class color"] = "Usar color de clase"
L["Show only in combat"] = "Mostrar solo en combate"
L["Show always"] = "Mostrar siempre"
L["Cursor freelook start delta"] = "Umbral de inicio de vista libre del cursor"
