if GetLocale() ~= "zhTW" then
	return
end

local _, ns = ...
local L = ns.L

L["author"] = "作者"
L["%s Configuration"] = "%s 設定"
L["Profile"] = "設定檔"
L["New profile"] = "新設定檔"
L["Create"] = "建立"
L["Copy current"] = "複製當前的"
L["Set as default"] = "設定為預設"
L["A profile with the same name exists."] = "相同名稱的設定檔已存在。"
L["Are you sure you want to delete profile %s?"] = "你確定要刪除設定檔%s嗎？"
L["Resize cursor"] = "調整游標大小"
L["Autoscaling"] = "自動縮放"
L["Scale"] = "縮放"
L["Opacity"] = "不透明度"
L["Use class color"] = "使用職業顏色"
L["Show only in combat"] = "僅在戰鬥中顯示"
L["Show always"] = "總是顯示"
L["Cursor freelook start delta"] = "游標自由視角起始閾值"
