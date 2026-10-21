local config = CursorModConfig

local glow = {"Interface/AddOns/CursorMod/texture/camelot-fx.png", .5, 1, 0, 1, 64, 64, 0, 0}
local outline = {"Interface/AddOns/CursorMod/texture/camelot-fx.png", 0, .5, 0, 1, 64, 64, 0, 0}

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
	"Interface/AddOns/CursorMod/texture/point-inverse",
	"Interface/AddOns/CursorMod/texture/point-ghostly",
	{"talents-search-notonactionbar", 84, 84, -2, 3},
	{"talents-search-notonactionbarhidden", 84, 84, -2, 3},
	{
		{"Interface/cursor/UICursor2x", 261/512, 293/512, 67/256, 99/256, glow, outline},
		{"Interface/cursor/UICursor2x", 393/512, 441/512, 1/256, 49/256, glow, outline},
		{"Interface/cursor/UICursor2x", 261/512, 325/512, 1/256, 65/256, glow, outline},
		{"Interface/cursor/UICursor2x", 1/512, 97/512, 131/256, 227/256, glow, outline},
		{"Interface/cursor/UICursor2x", 1/512, 129/512, 1/256, 129/256, glow, outline},
	},
}