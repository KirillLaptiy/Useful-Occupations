---@class UsefulOccupations.Trait
---@field type string
---@field name string
---@field cost integer
---@field desc string
---@field xpBoosts UsefulOccupations.XpBoost[]
---@field freeRecipes string[]

---@class UsefulOccupations.Traits
---@field NightVision UsefulOccupations.Trait
---@field Illiterate UsefulOccupations.Trait
---@field Herbalist UsefulOccupations.Trait

---@type UsefulOccupations.Traits
local Traits = {
	NightVision = {
		type = "NightVision",
		name = getText("UI_trait_NightVision"),
		cost = 2,
		desc = getText("UI_trait_NightVisionDesc"),
		xpBoosts = {},
		freeRecipes = {},
	},
	Illiterate = {
		type = "Illiterate",
		name = getText("UI_trait_Illiterate"),
		cost = -8,
		desc = getText("UI_trait_IlliterateDesc"),
		xpBoosts = {},
		freeRecipes = {},
	},
	Herbalist = {
		type = "Herbalist",
		name = getText("UI_trait_Herbalist"),
		cost = 4,
		desc = getText("UI_trait_HerbalistDesc"),
		xpBoosts = {
			{ perk = Perks.PlantScavenging, level = 1 },
		},
		freeRecipes = {
			"Herbalist",
			"MakePlantainPoultice",
			"MakeComfreyPoultice",
			"MakeWildGarlicPoultice",
			"Black Sage Growing Season",
			"Broadleaf Plantain Growing Season",
			"Comfrey Growing Season",
			"Common Mallow Growing Season",
			"Wild Garlic Growing Season",
		},
	},
}

return Traits
