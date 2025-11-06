---@class UsefulOccupations.Trait
---@field type string
---@field name string
---@field cost integer
---@field desc string
---@field xpBoosts UsefulOccupations.XpBoost[]
---@field freeRecipes string[]

----@class UsefulOccupations.Traits
----@field NightVision UsefulOccupations.Trait
----@field Illiterate UsefulOccupations.Trait
----@field Herbalist UsefulOccupations.Trait

---@class UsefulOccupations.Traits
local Traits = {
	---@class Traits.NightVision
	NightVision = {
		type = "NightVision",
		name = getText("UI_trait_NightVision"),
		cost = 2,
		desc = getText("UI_trait_NightVisionDesc"),
		---@class Traits.NightVision.xpBoosts
		xpBoosts = {},
		---@class Traits.NightVision.freeRecipes
		freeRecipes = {},
	},

	---@class Traits.Illiterate
	Illiterate = {
		type = "Illiterate",
		name = getText("UI_trait_Illiterate"),
		cost = -8,
		desc = getText("UI_trait_IlliterateDesc"),
		---@class Traits.Illiterate.xpBoosts
		xpBoosts = {},
		---@class Traits.Illiterate.freeRecipes
		freeRecipes = {},
	},

	---@class Traits.Herbalist
	Herbalist = {
		type = "Herbalist",
		name = getText("UI_trait_Herbalist"),
		cost = 4,
		desc = getText("UI_trait_HerbalistDesc"),
		---@class Traits.Herbalist.xpBoosts
		xpBoosts = {
			{ perk = Perks.PlantScavenging, level = 1 },
		},
		---@class Traits.Herbalist.freeRecipes
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
