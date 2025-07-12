---@class UsefulOccupations.PersonalTrait
---@field type string
---@field name string
---@field desc string
---@field xpBoosts UsefulOccupations.XpBoost[]
---@field freeRecipes string[]
---@field values table<string, any>

----@class UsefulOccupations.PersonalTraits
----@field Wunderkind UsefulOccupations.PersonalTrait
----@field ScoutSkills UsefulOccupations.PersonalTrait
----@field Axeman UsefulOccupations.PersonalTrait
----@field Organized UsefulOccupations.PersonalTrait
----@field NightVision_Personal UsefulOccupations.PersonalTrait
----@field Outdoorsman UsefulOccupations.PersonalTrait
----@field Burglar UsefulOccupations.PersonalTrait
----@field Graceful UsefulOccupations.PersonalTrait
----@field Inconspicuous UsefulOccupations.PersonalTrait

---@class UsefulOccupations.PersonalTraits
local PersonalTraits = {
	-- Unemployed
	---@class PersonalTraits.Wunderkind
	Wunderkind = {
		type = "Wunderkind",
		name = getText("UI_trait_wunderkind"),
		desc = getText("UI_trait_wunderkind_desc"),
		---@class PersonalTraits.Wunderkind.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Wunderkind.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Wunderkind.values
		values = {
			-- set's last level for perk's +125% xp boost
			lastLevelForXpBoost = 3,
			-- multiplier for xp boost from books
			booksMultiplier = 2,
			-- set's last level for  book's multiplier
			lastBooksMultiplierLevel = 10,
		},
	},

	-- Ranger
	---@class PersonalTraits.ScoutSkills
	ScoutSkills = {
		type = "ScoutSkills",
		name = getText("UI_trait_scoutskills"),
		desc = getText("UI_trait_scoutskills_desc"),
		---@class PersonalTraits.ScoutSkills.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.ScoutSkills.freeRecipes
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
		---@class PersonalTraits.ScoutSkills.values
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
	---@class PersonalTraits.Axeman
	Axeman = {
		type = "Axeman",
		name = getText("UI_trait_axeman"),
		desc = getText("UI_trait_axemandesc"),
		---@class PersonalTraits.Axeman.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Axeman.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Axeman.values
		values = {
			-- Muscle strain modifier when chopping tree
			muscleStrainModifier = 0.5,
			-- Endurance use modifier when chopping tree
			enduranceUseModifier = 0.5,
		},
	},
	---@class PersonalTraits.Organized
	Organized = {
		type = "Organized",
		name = getText("UI_trait_Packmule"),
		desc = getText("UI_trait_PackmuleDesc"),
		---@class PersonalTraits.Organized.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Organized.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Organized.values
		values = {},
	},
	---@class PersonalTraits.NightVision_Personal
	NightVision_Personal = {
		type = "NightVision_Personal",
		name = getText("UI_trait_NightVision"),
		desc = getText("UI_trait_NightVisionDesc"),
		---@class PersonalTraits.NightVision_Personal.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.NightVision_Personal.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.NightVision_Personal.values
		values = {},
	},
	---@class PersonalTraits.Outdoorsman
	Outdoorsman = {
		type = "Outdoorsman",
		name = getText("UI_trait_outdoorsman"),
		desc = getText("UI_trait_outdoorsmandesc"),
		---@class PersonalTraits.Outdoorsman.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Outdoorsman.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Outdoorsman.values
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

	-- Burglar
	---@class PersonalTraits.Burglar
	Burglar = {
		type = "Burglar",
		name = getText("UI_prof_Burglar"),
		desc = getText("UI_trait_BurglarDesc"),
		---@class PersonalTraits.Burglar.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Burglar.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Burglar.values
		values = {
			-- Default door lockpicking time
			defaultDoorLockpickingTime = 500,
			-- This is how much the lockpicking time is reduced for each level of nimble
			reduceDoorLockpickingTime = 30,
		},
	},
	---@class PersonalTraits.Graceful
	Graceful = {
		type = "Graceful",
		name = getText("UI_trait_graceful"),
		desc = getText("UI_trait_gracefuldesc"),
		---@class PersonalTraits.Graceful.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Graceful.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Graceful.values
		values = {},
	},
	---@class PersonalTraits.Inconspicuous
	Inconspicuous = {
		type = "Inconspicuous",
		name = getText("UI_trait_Inconspicuous"),
		desc = getText("UI_trait_InconspicuousDesc"),
		---@class PersonalTraits.Inconspicuous.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Inconspicuous.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Inconspicuous.values
		values = {
			-- Default distance (start) for zombies between player to forfeit player from view
			distanceToForfeit = 6,
			-- Distance reduce (distanceToForfeit) per perk lvl
			decreaseDistanceByLvl = 0.3,
			-- Perk that will affect (decreaseDistanceByLvl)
			decreaseDistancePerk = Perks.Sneak,
			-- Duration of stun after zombie forfeits sight of player (in milliseconds)
			stunDurationAfterForfeit = 2000,
		},
	},
}

return PersonalTraits
