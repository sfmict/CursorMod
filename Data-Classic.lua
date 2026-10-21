local config = CursorModConfig

local glow = {"Interface/AddOns/CursorMod/texture/classic-fx.png", .5, 1, 0, 1, 128, 128, -2.5, 1.75}
local outline = {"Interface/AddOns/CursorMod/texture/classic-fx.png", 0, .5, 0, 1, 128, 128, -.75, 1.75}

local customAtlases = {
	["talents-search-notonactionbar"] = {
		["file"] = "Interface/AddOns/CursorMod/texture/talents",
		["rightTexCoord"] = 0.36865234375,
		["topTexCoord"] = 0.8017578125,
		["leftTexCoord"] = 0.30712890625,
		["bottomTexCoord"] = 0.9248046875,
	},
	["talents-search-notonactionbarhidden"] = {
		["file"] = "Interface/AddOns/CursorMod/texture/talents",
		["rightTexCoord"] = 0.43212890625,
		["topTexCoord"] = 0.1708984375,
		["leftTexCoord"] = 0.37060546875,
		["bottomTexCoord"] = 0.2939453125,
	},
}

config.textures = {
	"Interface/AddOns/CursorMod/texture/point",
	"Interface/cursor/point",
	"Interface/cursor/unablepoint",
	"Interface/AddOns/CursorMod/texture/point-inverse",
	"Interface/AddOns/CursorMod/texture/point-ghostly",
	{"talents-search-notonactionbar", 84, 84, -2, 3},
	{"talents-search-notonactionbarhidden", 84, 84, -2, 3},
	{"Interface/cursor/point", 32, 32, 0, 0, glow, outline}
}


local getAtlasInfo = config.getAtlasInfo
function config.getAtlasInfo(name)
	return customAtlases[name] or getAtlasInfo(name)
end


function config:setTex(tex, rFrame, size, path, l,r,t,b,w,h,x,y)
	if l > 1 then
		w,h,x,y = l,r,t,b
		l,r,t,b = 0,1,0,1
	end
	tex:SetTexCoord(l,r,t,b)
	local atlasInfo = self.getAtlasInfo(path)
	if atlasInfo then
		if customAtlases[path] then
			tex:SetTexture(atlasInfo.file)
			tex:SetTexCoord(atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
		else
			tex:SetAtlas(path)
		end
	else
		tex:SetTexture(path)
	end
	tex:ClearAllPoints()
	tex:SetPoint("CENTER", rFrame, x,y)
	if w then
		tex:SetSize(w,h)
		tex:SetScale(size / 32)
	else
		tex:SetSize(size, size)
		tex:SetScale(1)
	end
end
