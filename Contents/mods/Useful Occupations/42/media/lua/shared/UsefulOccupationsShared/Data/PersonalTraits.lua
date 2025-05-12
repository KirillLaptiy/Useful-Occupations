---@class UsefulOccupations.PersonalTrait
---@field type string
---@field name string
---@field desc string
---@field xpBoosts UsefulOccupations.XpBoost[]
---@field freeRecipes string[]
---@field values table<string, integer>

---@class UsefulOccupations.PersonalTraits
---@field Wunderkind UsefulOccupations.PersonalTrait
---@field ScoutSkills UsefulOccupations.PersonalTrait
---@field Axeman UsefulOccupations.PersonalTrait
---@field Organized UsefulOccupations.PersonalTrait
---@field NightVision_Personal UsefulOccupations.PersonalTrait
---@field Outdoorsman UsefulOccupations.PersonalTrait
---@field Burglar UsefulOccupations.PersonalTrait

---@type UsefulOccupations.PersonalTraits
local PersonalTraits = {
	Wunderkind = {
		type = "Wunderkind",
		name = getText("UI_trait_wunderkind"),
		desc = getText("UI_trait_wunderkind_desc"),
		xpBoosts = {},
		freeRecipes = {},
		values = {
			-- set's last level for perk's +125% xp boost
			lastLevelForXpBoost = 3,
			-- multiplier for xp boost from books
			booksMultiplier = 2,
			-- set's last level for  book's multiplier
			lastBooksMultiplierLevel = 10,
		},
	},
	ScoutSkills = {
		type = "ScoutSkills",
		name = getText("UI_trait_scoutskills"),
		desc = getText("UI_trait_scoutskills_desc"),
		xpBoosts = {},
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
		values = {
			-- Default walk speed increase value
			-- (1.2: +20%)
			walkSpeedIncreaseMultiplier = 1.2,
			-- How much % of 100% will increase walk speed every light foot level
			-- (0.01: walk speed will increase by 1% per light foot level)
			lightFootInfluencePerLvl = 0.01,

			-- When moving, thirst and hunger accumulate more slowly.

			-- The maximum number of seconds that can accumulate for the hunger and thirst reduction effect
			maxWalkTime = 120,
			-- once in % Milliseconds effect will called
			msToCall = 1000,
			-- Hunger reduce per msToCall when walking
			hungerReducePerMinute = 0.000045,
			-- Thirst reduce per msToCall when walking
			thirstReducePerMinute = 0.000045,
			-- The less the character has walked, the weaker the effect.
			minFactor = 0.75,
			-- The more the character walked, the stronger the effect.
			maxFactor = 1.25,
		},
	},
	Axeman = {
		type = "Axeman",
		name = getText("UI_trait_axeman"),
		desc = getText("UI_trait_axemandesc"),
		xpBoosts = {},
		freeRecipes = {},
		values = {
			-- Multiplier to increase tree damage
			treeDamageMultiplier = 2,
			-- Muscle strain modifier when chopping tree
			muscleStrainModifier = 0.5,
			-- Endurance use modifier when chopping tree
			enduranceUseModifier = 0.5,
		},
	},
	Organized = {
		type = "Organized",
		name = getText("UI_trait_Packmule"),
		desc = getText("UI_trait_PackmuleDesc"),
		xpBoosts = {},
		freeRecipes = {},
		values = {},
	},
	NightVision_Personal = {
		type = "NightVision_Personal",
		name = getText("UI_trait_NightVision"),
		desc = getText("UI_trait_NightVisionDesc"),
		xpBoosts = {},
		freeRecipes = {},
		values = {},
	},
	Outdoorsman = {
		type = "Outdoorsman",
		name = getText("UI_trait_outdoorsman"),
		desc = getText("UI_trait_outdoorsmandesc"),
		xpBoosts = {},
		freeRecipes = {},
		values = {
			buildCampfireSpeedMultiplier = 2,
			removeCampfireSpeedMultiplier = 2,
			putOutCampfireSpeedMultiplier = 2,
			lightFromPetrolSpeedMultiplier = 2,
			lightFromLiteratureSpeedMultiplier = 2,
			lightFromKindleSpeedMultiplier = 2,
			addCampfireFuelSpeedMultiplier = 2,
			washClothesSpeedMultiplier = 2,
			washYourselfSpeedMultiplier = 2,
		},
	},
	Burglar = {
		type = "Burglar",
		name = getText("UI_prof_Burglar"),
		desc = getText("UI_trait_BurglarDesc"),
		xpBoosts = {},
		freeRecipes = {},
		values = {},
	},
}

return PersonalTraits
