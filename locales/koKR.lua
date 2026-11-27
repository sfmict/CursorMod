if GetLocale() ~= "koKR" then
	return
end

local _, ns = ...
local L = ns.L

L["author"] = "제작자"
L["%s Configuration"] = "%s 설정"
L["Profile"] = "프로필"
L["New profile"] = "새 프로필"
L["Create"] = "생성"
L["Copy current"] = "현재 복사"
L["Set as default"] = "기본으로 설정"
L["A profile with the same name exists."] = "같은 이름의 프로필이 존재합니다."
L["Are you sure you want to delete profile %s?"] = "프로필 %s을 삭제하시겠습니까?"
L["Resize cursor"] = "커서 크기 변경"
L["Autoscaling"] = "자동 크기 조절"
L["Scale"] = "크기 비율"
L["Opacity"] = "불투명도"
L["Use class color"] = "직업 색상 사용"
L["Show only in combat"] = "전투 중에만 표시"
L["Show always"] = "항상 표시"
L["Cursor freelook start delta"] = "커서 자유 시점 시작 임계값"
