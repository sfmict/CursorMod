local config = CursorModConfig

local glow = {"Interface/AddOns/CursorMod/texture/midnight-fx.png", .5, 1, 0, 1, 64, 64, -1.75, 1.75}
local outline = {"Interface/AddOns/CursorMod/texture/midnight-fx.png", 0, .5, 0, 1, 64, 64, -1.75, 1.75}

config.textures = {
	"Interface/AddOns/CursorMod/texture/point",
	{
		{"Interface/cursor/UICursor2x", 261/512, 293/512, 67/256, 99/256},
		{"Interface/cursor/UICursor2x", 393/512, 441/512, 1/256, 49/256},
		{"Interface/cursor/UICursor2x", 261/512, 325/512, 1/256, 65/256},
		{"Interface/cursor/UICursor2x", 1/512, 97/512, 131/256, 227/256},
		{"Interface/cursor/UICursor2x", 1/512, 129/512, 1/256, 129/256},
	},
	{
		{"Interface/cursor/UICursor2x", 261/512, 293/512, 101/256, 133/256},
		{"Interface/cursor/UICursor2x", 443/512, 491/512, 1/256, 49/256},
		{"Interface/cursor/UICursor2x", 327/512, 391/512, 1/256, 65/256},
		{"Interface/cursor/UICursor2x", 131/512, 227/512, 131/256, 227/256},
		{"Interface/cursor/UICursor2x", 131/512, 259/512, 1/256, 129/256},
	},
	-- "Interface/cursor/unablepoint",
	"Interface/AddOns/CursorMod/texture/point-inverse",
	"Interface/AddOns/CursorMod/texture/point-ghostly",
	{"talents-search-notonactionbar", 84, 84, -2, 3},
	{"talents-search-notonactionbarhidden", 84, 84, -2, 3},
	{"Interface/AddOns/CursorMod/texture/midnight-glow.png", 64, 64, -1.75, 1.75},
	"Interface/AddOns/CursorMod/texture/midnight-inverse.png",
	{"Interface/AddOns/CursorMod/texture/midnight-inverse-glow.png", 64, 64, -1.75, 1.75},
	{
		{"Interface/cursor/UICursor2x", 261/512, 293/512, 67/256, 99/256, glow, outline},
		{"Interface/cursor/UICursor2x", 393/512, 441/512, 1/256, 49/256, glow, outline},
		{"Interface/cursor/UICursor2x", 261/512, 325/512, 1/256, 65/256, glow, outline},
		{"Interface/cursor/UICursor2x", 1/512, 97/512, 131/256, 227/256, glow, outline},
		{"Interface/cursor/UICursor2x", 1/512, 129/512, 1/256, 129/256, glow, outline},
	},
	{"Interface/AddOns/CursorMod/texture/midnight-inverse.png", 32, 32, 0, 0, glow, outline},
}
