--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UsefulOccupations.PersonalTrait
---@field type string
---@field name string
---@field desc string
---@field xpBoosts UsefulOccupations.XpBoost[]
---@field freeRecipes string[]
---@field values table<string, any>
---@field mutualExclusives table<string>

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

local opts = SandboxOptions:getInstance()

local getSandboxValue = function(value)
	return function()
		local option = opts:getOptionByName(value)

		if not option then
			error("OPTION WITH NAME" .. " " .. value .. " " .. "NOT FOUND")
		end

		return option:asConfigOption():getValueAsObject()
	end
end

---@class UsefulOccupations.PersonalTraits
local PersonalTraits = {
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	----------------------------------- UNEMPLOYED --------------------------------
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	---@class PersonalTraits.Wunderkind
	Wunderkind = {
		type = "Wunderkind",
		name = getText("UI_trait_Wunderkind"),
		desc = getText("UI_trait_WunderkindDesc"),
		---@class PersonalTraits.Wunderkind.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Wunderkind.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Wunderkind.values
		values = {
			-- set's last level for perk's +125% xp boost
			lastLevelForXpBoost = getSandboxValue("UO.Wunderkind.lastLevelForXpBoost"),
			-- Additional multiplier for xp boost from books
			booksMultiplier = getSandboxValue("UO.Wunderkind.booksMultiplier"),
			-- set's last level for active book's multiplier
			lastBooksMultiplierLevel = getSandboxValue("UO.Wunderkind.lastBooksMultiplierLevel"),
		},
		---@class PersonalTraits.Wunderkind.MutualExclusives
		mutualExclusives = {},
	},

	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	----------------------------------- SCOUT -------------------------------------
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	---@class PersonalTraits.ScoutSkills
	ScoutSkills = {
		type = "ScoutSkills",
		name = getText("UI_trait_ScoutSkills"),
		desc = getText("UI_trait_ScoutSkillsDesc"),
		---@class PersonalTraits.ScoutSkills.xpBoosts
		xpBoosts = {
			{ perk = Perks.PlantScavenging, level = 3 },
			{ perk = Perks.Fishing, level = 3 },
			{ perk = Perks.Trapping, level = 3 },
			{ perk = Perks.Tracking, level = 3 },
		},
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
			"MakeFishingRod",
			"FixFishingRod",
			"MakeChum",
			"MakeSnareTrap",
			"MakeStickTrap",
			"MakeWoodenBoxTrap",
			"MakeTrapBox",
			"MakeCageTrap",
			"MakeStagHeadTrophy",
		},
		---@class PersonalTraits.ScoutSkills.values
		values = {
			-- The maximum number of seconds that can accumulate for the hunger and thirst reduction effect
			maxWalkTime = getSandboxValue("UO.ScoutSkills.maxWalkTime"),
			-- once in % Milliseconds effect will called
			msToCall = getSandboxValue("UO.ScoutSkills.msToCall"),
			-- Min, max hunger reduce percent per msToCall
			hungerReduceMin = getSandboxValue("UO.ScoutSkills.hungerReduceMin"),
			hungerReduceMax = getSandboxValue("UO.ScoutSkills.hungerReduceMax"),
			-- Time (msToCall) to reach max hunger reduce percent
			hungerTimeToMax = getSandboxValue("UO.ScoutSkills.hungerTimeToMax"),
			-- Min, max thirst reduce percent per msToCall
			thirstReduceMin = getSandboxValue("UO.ScoutSkills.thirstReduceMin"),
			thirstReduceMax = getSandboxValue("UO.ScoutSkills.thirstReduceMax"),
			-- Time (msToCall) to reach max thirst reduce percent
			thirstTimeToMax = getSandboxValue("UO.ScoutSkills.thirstTimeToMax"),
		},
		---@class PersonalTraits.ScoutSkills.MutualExclusives
		mutualExclusives = {
			"Illiterate",
		},
	},

	---@class PersonalTraits.Axeman
	Axeman = {
		type = "Axeman",
		name = getText("UI_trait_Axeman"),
		desc = getText("UI_trait_AxemanDesc"),
		---@class PersonalTraits.Axeman.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Axeman.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Axeman.values
		values = {
			-- Muscle strain modifier when chopping tree
			muscleStrainModifier = getSandboxValue("UO.Axeman.muscleStrainModifier"),
			-- Endurance use modifier when chopping tree
			enduranceUseModifier = getSandboxValue("UO.Axeman.enduranceUseModifier"),
		},
		---@class PersonalTraits.Axeman.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Organized
	Organized = {
		type = "Organized",
		name = getText("UI_trait_Organized"),
		desc = getText("UI_trait_OrganizedDesc"),
		---@class PersonalTraits.Organized.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Organized.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Organized.values
		values = {
			-- Sets how much the strength will affect the character's carrying capacity
			strengthBonusCarrying = getSandboxValue("UO.Organized.strengthBonusCarrying"),
		},
		---@class PersonalTraits.Organized.MutualExclusives
		mutualExclusives = {},
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
		---@class PersonalTraits.NightVision_Personal.MutualExclusives
		mutualExclusives = { "NightVision" },
	},

	---@class PersonalTraits.Outdoorsman
	Outdoorsman = {
		type = "Outdoorsman",
		name = getText("UI_trait_Outdoorsman"),
		desc = getText("UI_trait_OutdoorsmanDesc"),
		---@class PersonalTraits.Outdoorsman.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Outdoorsman.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Outdoorsman.values
		values = {
			-- TRP: Time reduction percent
			buildingTPR = getSandboxValue("UO.Outdoorsman.buildingTPR"),
			removeCampfireTRP = getSandboxValue("UO.Outdoorsman.removeCampfireTRP"),
			putOutCampfireTRP = getSandboxValue("UO.Outdoorsman.putOutCampfireTRP"),
			lightFromPetrolTRP = getSandboxValue("UO.Outdoorsman.lightFromPetrolTRP"),
			lightFromLiteratureTRP = getSandboxValue("UO.Outdoorsman.lightFromLiteratureTRP"),
			lightFromKindleTRP = getSandboxValue("UO.Outdoorsman.lightFromKindleTRP"),
			addCampfireFuelTRP = getSandboxValue("UO.Outdoorsman.addCampfireFuelTRP"),
			washClothesTRP = getSandboxValue("UO.Outdoorsman.washClothesTRP"),
			washYourselfTRP = getSandboxValue("UO.Outdoorsman.washYourselfTRP"),
		},
		---@class PersonalTraits.Outdoorsman.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Burglar
	Burglar = {
		type = "Burglar",
		name = getText("UI_trait_Burglar"),
		desc = getText("UI_trait_BurglarDesc"),
		---@class PersonalTraits.Burglar.xpBoosts
		xpBoosts = {
			{ perk = Perks.Sneak, level = 1 },
		},
		---@class PersonalTraits.Burglar.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Burglar.values
		values = {
			-- Default door lockpicking time
			defaultLockpickingTime = getSandboxValue("UO.Burglar.defaultLockpickingTime"),
			-- This is how much the lockpicking time is reduced for each sneak level
			reduceDoorLockpickingTime = getSandboxValue("UO.Burglar.reduceDoorLockpickingTime"),
		},
		---@class PersonalTraits.Outdoorsman.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Graceful
	Graceful = {
		type = "Graceful",
		name = getText("UI_trait_Graceful"),
		desc = getText("UI_trait_GracefulDesc"),
		---@class PersonalTraits.Graceful.xpBoosts
		xpBoosts = {
			{ perk = Perks.Sprinting, level = 3 },
			{ perk = Perks.Lightfoot, level = 3 },
		},
		---@class PersonalTraits.Graceful.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Graceful.values
		values = {
			---@class PersonalTraits.Graceful.values.defaultWalk
			defaultWalk = {
				startBonusPercent = getSandboxValue("UO.Graceful.defaultWalk_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.defaultWalk_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.sneakWalk
			sneakWalk = {
				startBonusPercent = getSandboxValue("UO.Graceful.sneakWalk_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.sneakWalk_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.sneakRun
			sneakRun = {
				startBonusPercent = getSandboxValue("UO.Graceful.sneakRun_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.sneakRun_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.defaultRun
			defaultRun = {
				startBonusPercent = getSandboxValue("UO.Graceful.defaultRun_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.defaultRun_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.defaultSprint
			defaultSprint = {
				startBonusPercent = getSandboxValue("UO.Graceful.defaultSprint_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.defaultSprint_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.climbWall
			climbWall = {
				startBonusPercent = getSandboxValue("UO.Graceful.climbWall_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.climbWall_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.climbWindow
			climbWindow = {
				startBonusPercent = getSandboxValue("UO.Graceful.climbWindow_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.climbWindow_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.climbFence_Walk
			climbFence_Walk = {
				startBonusPercent = getSandboxValue("UO.Graceful.climbFence_Walk_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.climbFence_Walk_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.climbFence_Run
			climbFence_Run = {
				startBonusPercent = getSandboxValue("UO.Graceful.climbFence_Run_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.climbFence_Run_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.climbFence_Sprint
			climbFence_Sprint = {
				startBonusPercent = getSandboxValue("UO.Graceful.climbFence_Sprint_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.climbFence_Sprint_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.turn
			turn = {
				startBonusPercent = getSandboxValue("UO.Graceful.turn_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.turn_percentPerLvl"),
			},

			---@class PersonalTraits.Graceful.values.turn180
			turn180 = {
				startBonusPercent = getSandboxValue("UO.Graceful.turn180_startBonusPercent"),
				percentPerLvl = getSandboxValue("UO.Graceful.turn180_percentPerLvl"),
			},

			-- Weight Multiplier for worn clothing (0.25 - 75% reduce)
			clothingWeightReducePercent = getSandboxValue("UO.Graceful.clothingWeightReducePercent"),
		},
		---@class PersonalTraits.Graceful.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Inconspicuous
	Inconspicuous = {
		type = "Inconspicuous",
		name = getText("UI_trait_Inconspicuous"),
		desc = getText("UI_trait_InconspicuousDesc"),
		---@class PersonalTraits.Inconspicuous.xpBoosts
		xpBoosts = {
			{ perk = Perks.Sneak, level = 2 },
		},
		---@class PersonalTraits.Inconspicuous.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Inconspicuous.values
		values = {
			-- Bonus activity multipliers to reduce forfeit distance (sneaking, running, etc.)
			sneakingBonusMult = getSandboxValue("UO.Inconspicuous.sneakingBonusMult"),
			runningBonusMult = getSandboxValue("UO.Inconspicuous.runningBonusMult"),
			sprintingBonusMult = getSandboxValue("UO.Inconspicuous.sprintingBonusMult"),
			defaultBonusMult = getSandboxValue("UO.Inconspicuous.defaultBonusMult"),
		},
		---@class PersonalTraits.Inconspicuous.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Dextrous
	Dextrous = {
		type = "Dextrous",
		name = getText("UI_trait_Dexterous"),
		desc = getText("UI_trait_DexterousDesc"),
		---@class PersonalTraits.Dextrous.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Dextrous.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Dextrous.values
		values = {
			-- TRP: Time reduction percent
			-- Additional percent to reduce the transfer time
			inventoryTransferTRP = getSandboxValue("UO.Dextrous.inventoryTransferTRP"),
		},
		---@class PersonalTraits.Dextrous.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Gymnast
	Gymnast = {
		type = "Gymnast",
		name = getText("UI_trait_Gymnast"),
		desc = getText("UI_trait_GymnastDesc"),
		---@class PersonalTraits.Gymnast.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Gymnast.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Gymnast.values
		values = {},
		---@class PersonalTraits.Gymnast.MutualExclusives
		mutualExclusives = {},
	},

	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	----------------------------------- VETERAN -----------------------------------
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	---@class PersonalTraits.Marksman
	Marksman = {
		type = "Marksman",
		name = getText("UI_trait_Marksman"),
		desc = getText("UI_trait_MarksmanDesc"),
		---@class PersonalTraits.Marksman.xpBoosts
		xpBoosts = {
			{ perk = Perks.Aiming, level = 3 },
			{ perk = Perks.Reloading, level = 3 },
		},
		---@class PersonalTraits.Marksman.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Marksman.values
		values = {
			-- Minimum guaranteed hit chance (overrides lower weapon values)
			minHitChance = getSandboxValue("UO.Marksman.minHitChance"),
			-- Minimum guaranteed critical hit chance (overrides lower weapon values)
			minCritChance = getSandboxValue("UO.Marksman.minCritChance"),
			-- Base multiplier applied to the weapon's critical chance
			critChanceDefaultMult = getSandboxValue("UO.Marksman.critChanceDefaultMult"),
			-- Additional multiplier per perk level added to critical chance
			critChanceBonusPerLvl = getSandboxValue("UO.Marksman.critChanceBonusPerLvl"),
			-- Base multiplier for aiming time (e.g. 2 = twice as fast aiming)
			aimingTimeDefaultMult = getSandboxValue("UO.Marksman.aimingTimeDefaultMult"),
			-- Additional multiplier per perk level to reduce aiming time
			aimingTimeBonusPerLvl = getSandboxValue("UO.Marksman.aimingTimeBonusPerLvl"),
			-- Base multiplier for maximum weapon range
			maxRangeDefaultMult = getSandboxValue("UO.Marksman.maxRangeDefaultMult"),
			-- Bonus multiplier per perk level to increase max range
			maxRangeBonusPerLvl = getSandboxValue("UO.Marksman.maxRangeBonusPerLvl"),
			-- Base multiplier for the weapon's minimum damage
			minDamageDefaultMult = getSandboxValue("UO.Marksman.minDamageDefaultMult"),
			-- Bonus multiplier per perk level to increase minimum damage
			minDamageBonusPerLvl = getSandboxValue("UO.Marksman.minDamageBonusPerLvl"),
			-- Base multiplier for the weapon's maximum damage
			maxDamageDefaultMult = getSandboxValue("UO.Marksman.maxDamageDefaultMult"),
			-- Bonus multiplier per perk level to increase maximum damage
			maxDamageBonusPerLvl = getSandboxValue("UO.Marksman.maxDamageBonusPerLvl"),
			-- Base multiplier for the reloading speed
			reloadSpeedDefaultMult = getSandboxValue("UO.Marksman.reloadSpeedDefaultMult"),
			-- Bonus multiplier per perk level to increase reloading speed
			reloadSpeedBonusPerLvl = getSandboxValue("UO.Marksman.reloadSpeedBonusPerLvl"),
			-- Bonus mult to reduce the chance of breaking ranged weapons
			conditionLowerChanceMult = getSandboxValue("UO.Marksman.conditionLowerChanceMult"),
		},
		---@class PersonalTraits.Marksman.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Stout
	Stout_Personal = {
		type = "Stout_Personal",
		name = getText("UI_trait_stout"),
		desc = getText("UI_trait_stoutdesc"),
		---@class PersonalTraits.Stout_Personal.xpBoosts
		xpBoosts = {
			{ perk = Perks.Strength, level = 2 },
		},
		---@class PersonalTraits.Stout_Personal.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Stout_Personal.values
		values = {},
		---@class PersonalTraits.Stout_Personal.MutualExclusives
		mutualExclusives = { "Stout" },
	},

	---@class PersonalTraits.Fit_Personal
	Fit_Personal = {
		type = "Fit_Personal",
		name = getText("UI_trait_fit"),
		desc = getText("UI_trait_fitdesc"),
		---@class PersonalTraits.Fit_Personal.xpBoosts
		xpBoosts = {
			{ perk = Perks.Fitness, level = 2 },
		},
		---@class PersonalTraits.Fit_Personal.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Fit_Personal.values
		values = {},
		---@class PersonalTraits.Fit_Personal.MutualExclusives
		mutualExclusives = { "Fit" },
	},

	---@class PersonalTraits.NightOwl
	NightOwl = {
		type = "NightOwl",
		name = getText("UI_trait_nightowl"),
		desc = getText("UI_trait_nightowldesc"),
		---@class PersonalTraits.NightOwl.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.NightOwl.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.NightOwl.values
		values = {},
		---@class PersonalTraits.NightOwl.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Desensitized
	Desensitized = {
		type = "Desensitized",
		name = getText("UI_trait_Desensitized"),
		desc = getText("UI_trait_DesensitizedDesc"),
		---@class PersonalTraits.Desensitized.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Desensitized.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Desensitized.values
		values = {
			-- Pain persistence (NOT PERCENTAGE)
			painReduction = getSandboxValue("UO.Desensitized.painReduction"),
			-- Maximum pain value (20 - second stage)
			maxPain = getSandboxValue("UO.Desensitized.maxPain"),
			-- Maximum fatigue value (81 - third stage)
			maxFatigue = getSandboxValue("UO.Desensitized.maxFatigue"),
		},
		---@class PersonalTraits.Desensitized.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.TrainedFighter
	TrainedFighter = {
		type = "TrainedFighter",
		name = getText("UI_trait_TrainedFighter"),
		desc = getText("UI_trait_TrainedFighterDesc"),
		---@class PersonalTraits.TrainedFighter.xpBoosts
		xpBoosts = {
			{ perk = Perks.Axe, level = 3 },
			{ perk = Perks.Blunt, level = 3 },
			{ perk = Perks.SmallBlunt, level = 3 },
			{ perk = Perks.LongBlade, level = 3 },
			{ perk = Perks.SmallBlade, level = 3 },
			{ perk = Perks.Spear, level = 3 },
			{ perk = Perks.Maintenance, level = 3 },
			{ perk = Perks.Nimble, level = 3 },
		},
		---@class PersonalTraits.TrainedFighter.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.TrainedFighter.values
		values = {
			-- Default strafe walk speed increase in percents
			strafeWalkSpeedDefault = getSandboxValue("UO.TrainedFighter.strafeWalkSpeedDefault"),
			-- Bonus percents per target perk lvl
			strafeWalkSpeedBonus = getSandboxValue("UO.TrainedFighter.strafeWalkSpeedBonus"),
			-- Default strafe aim speed increase in percents
			strafeAimSpeedDefault = getSandboxValue("UO.TrainedFighter.strafeAimSpeedDefault"),
			-- Bonus percents per target perk lvl
			strafeAimSpeedBonus = getSandboxValue("UO.TrainedFighter.strafeAimSpeedBonus"),
			-- Minimum guaranteed hit chance (overrides lower weapon values)
			minHitChance = getSandboxValue("UO.TrainedFighter.minHitChance"),
			-- Minimum guaranteed critical hit chance (overrides lower weapon values)
			minCritChance = getSandboxValue("UO.TrainedFighter.minCritChance"),
			-- Base multiplier applied to the weapon's critical chance
			critChanceDefaultMult = getSandboxValue("UO.TrainedFighter.critChanceDefaultMult"),
			-- Additional multiplier per perk level added to critical chance
			critChanceBonusPerLvl = getSandboxValue("UO.TrainedFighter.critChanceBonusPerLvl"),
			-- Base multiplier for maximum weapon range
			maxRangeDefaultMult = getSandboxValue("UO.TrainedFighter.maxRangeDefaultMult"),
			-- Bonus multiplier per perk level to increase max range
			maxRangeBonusPerLvl = getSandboxValue("UO.TrainedFighter.maxRangeBonusPerLvl"),
			-- Base multiplier for the weapon's minimum damage
			minDamageDefaultMult = getSandboxValue("UO.TrainedFighter.minDamageDefaultMult"),
			-- Bonus multiplier per perk level to increase minimum damage
			minDamageBonusPerLvl = getSandboxValue("UO.TrainedFighter.minDamageBonusPerLvl"),
			-- Base multiplier for the weapon's maximum damage
			maxDamageDefaultMult = getSandboxValue("UO.TrainedFighter.maxDamageDefaultMult"),
			-- Bonus multiplier per perk level to increase maximum damage
			maxDamageBonusPerLvl = getSandboxValue("UO.TrainedFighter.maxDamageBonusPerLvl"),
			-- Bonus mult to reduce the chance of breaking melee weapons
			conditionLowerChanceMult = getSandboxValue("UO.TrainedFighter.conditionLowerChanceMult"),
			-- Stomp speed bonus percent
			stompSpeedDefault = getSandboxValue("UO.TrainedFighter.stompSpeedDefault"),
			-- Default weapon swing speed increase in percents
			weaponSwingSpeedDefault = getSandboxValue("UO.TrainedFighter.weaponSwingSpeedDefault"),
			-- Bonus percents per target perk lvl
			weaponSwingSpeedBonus = getSandboxValue("UO.TrainedFighter.weaponSwingSpeedBonus"),
			-- Shove speed increase in percents
			shoveSpeedDefault = getSandboxValue("UO.TrainedFighter.shoveSpeedDefault"),
			-- Bump fall speed increase in percents
			bumpFallSpeedDefault = getSandboxValue("UO.TrainedFighter.bumpFallSpeedDefault"),
			-- Scramble get up speed increase in percents
			scrambleGetUpSpeedDefault = getSandboxValue("UO.TrainedFighter.scrambleGetUpSpeedDefault"),
			-- Not scramble get up speed increase in percents
			notScrambleGetUpSpeedDefault = getSandboxValue("UO.TrainedFighter.notScrambleGetUpSpeedDefault"),
		},
		---@class PersonalTraits.TrainedFighter.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.EnduranceSecret
	EnduranceSecret = {
		type = "EnduranceSecret",
		name = getText("UI_trait_EnduranceSecret"),
		desc = getText("UI_trait_EnduranceSecretDesc"),
		---@class PersonalTraits.EnduranceSecret.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.EnduranceSecret.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.EnduranceSecret.values
		values = {
			-- Percentage reduction in endurance cost from all sources
			spendMainReduce = getSandboxValue("UO.EnduranceSecret.spendMainReduce"),
			-- Additional percentage increase in endurance recovery rate while resting
			enduranceRestBonus = getSandboxValue("UO.EnduranceSecret.enduranceRestBonus"),
			-- Additional percentage reduction per target perk lvl
			spendPerkReduce = getSandboxValue("UO.EnduranceSecret.spendPerkReduce"),
		},
		---@class PersonalTraits.EnduranceSecret.MutualExclusives
		mutualExclusives = { "Asthmatic" },
	},

	---@class PersonalTraits.Invincible
	Invincible = {
		type = "Invincible",
		name = getText("UI_trait_Invincible"),
		desc = getText("UI_trait_InvincibleDesc"),
		---@class PersonalTraits.Invincible.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Invincible.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Invincible.values
		values = {
			-- Dodge cost as a percentage of total endurance
			dodgeEnduranceCost = getSandboxValue("UO.Invincible.dodgeEnduranceCost"),
			-- Minimum endurance required to dodge (as a percentage of the total)
			dodgeEnduranceEdge = getSandboxValue("UO.Invincible.dodgeEnduranceEdge"),
			-- Effect from target perk lvl
			targetPerkEffect = getSandboxValue("UO.Invincible.targetPerkEffect"),
			-- Perk active time in real seconds
			perkActiveTime = getSandboxValue("UO.Invincible.perkActiveTime"),
			-- Perk cooldown time in game hours
			perkCooldownTime = getSandboxValue("UO.Invincible.perkCooldownTime"),
			-- This is how much of the perk's cooldown must pass in percentage for the main debuffs to start working
			-- (5%, 6 game hours by default)
			perkCooldownEffectsStartPercent = getSandboxValue("UO.Invincible.perkCooldownEffectsStartPercent"),
			-- Zombie disable cost as a percentage of total endurance
			zombieDisableCost = getSandboxValue("UO.Invincible.zombieDisableCost"),
			-- Minimum endurance required for a zombie to turn into a crawler (as a percentage of the total)
			zombieDisableEdge = getSandboxValue("UO.Invincible.zombieDisableEdge"),
		},
		---@class PersonalTraits.Invincible.MutualExclusives
		mutualExclusives = {},
	},

	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	------------------------ SPM (Special Purpose Master) -------------------------
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	---@class PersonalTraits.Engineer
	Engineer = {
		type = "Engineer",
		name = getText("UI_trait_Engineer"),
		desc = getText("UI_trait_EngineerDesc"),

		---@class PersonalTraits.Engineer.xpBoosts
		xpBoosts = {
			{ perk = Perks.Blacksmith, level = 3 },
			{ perk = Perks.Carving, level = 3 },
			{ perk = Perks.FlintKnapping, level = 3 },
			{ perk = Perks.Electricity, level = 3 },
			{ perk = Perks.Pottery, level = 3 },
			{ perk = Perks.Glassmaking, level = 3 },
		},

		---@class PersonalTraits.Engineer.freeRecipes
		---@class PersonalTraits.Engineer.freeRecipes
		freeRecipes = {
			-- Vanilla recipes
			-- Literature
			-- ArmorMag1
			"MakeTireBodyArmor",
			"MakeTireForearmArmor",
			"MakeTireShinArmor",
			"MakeTireShoulderArmorLeft",
			"MakeTireShoulderArmorRight",
			"SpikePadding",
			"SewLeatherCodpiece",
			"SewLeatherGorget",
			-- ArmorMag2
			"MakeBoneBodyArmor",
			"MakeBoneChoker",
			"MakeBoneForearmArmor",
			"MakeBoneShinArmor",
			"MakeBoneShoulderArmor",
			"MakeBoneThighArmor",
			"MakeWoodBodyArmor",
			"MakeWoodForearmArmor",
			"MakeWoodShinArmor",
			"MakeWoodShoulderArmor",
			"MakeWoodThighArmor",
			-- ArmorMag3
			"MakeScrapMetalHelmet",
			"MakeScrapMetalBodyArmor",
			"MakeScrapMetalShoulderArmor",
			"MakeScrapMetalThighArmor",
			-- ArmorMag4
			"MakeCoatOfPlates",
			-- ArmorMag5
			"Assemble_Forearm_Armor",
			"Forge_Body_Armor",
			"Assemble_Simple_Shoulder_Armor",
			"Assemble_Thigh_Armor",
			"Assemble_Shin_Armor",
			"Forge_Metal_Mask",
			"Forge_Buckle",
			-- ArmorMag6
			"SpikeArmorWelding",
			"ForgeSpearHead",
			"ForgeLongSpearHead",
			-- ArmorMag7
			"MakeBulletproofLimbArmor",
			-- ElectronicsMag1
			"MakeRemoteControllerV1",
			"MakeRemoteControllerV2",
			"MakeRemoteControllerV3",
			"MakeRemoteTrigger",
			"AddCraftedTriggerToBomb",
			-- ElectronicsMag2
			"MakeTimer",
			"AddTimerToBomb",
			-- ElectronicsMag3
			"AddMotionSensorV1ToBomb",
			"AddMotionSensorV2ToBomb",
			"AddMotionSensorV3ToBomb",
			-- ElectronicsMag4
			"Generator",
			-- ElectronicsMag5
			"MakeImprovisedFlashlight",
			"MakeImprovisedLantern",
			-- EngineerMagazine1
			"MakeNoiseMaker",
			"MakeFirecracker",
			-- EngineerMagazine2
			"MakeSmokeBomb",
			"MakeCraftedGasMaskFilter",
			"MakeImprovisedGasMask",
			"RechargeFilters",
			-- EngineerMagazine3
			"MakeAerosolBomb",
			"MakeFlameBomb",
			"MakePipeBomb",
			-- GlassmakingMag1
			"MakeWineGlass",
			"MakeLanternGlass",
			-- GlassmakingMag2
			"MakeDrinkingGlass",
			"MakeGlassPanel",
			-- GlassmakingMag3
			"MakeGlassBottle",
			"MakeGlassJar",
			-- KeyMag1
			"CopyBuildingKey",
			"MakeScrewdriver",
			-- PrimitiveToolMag1
			"MakeLargeStoneAxeHead",
			"MakeStoneBlade",
			"MakeStoneMaulHead",
			"BindSpear",
			"MakeStoneBladeScythe",
			"SharpenBone",
			"CarveFleshingTool",
			"RemakeLongStoneBlade",
			-- PrimitiveToolMag2
			"MakeBoneFishingHook",
			"MakeStoneAwl",
			"MakeStoneChisel",
			"MakeStoneDrill",
			"MakeCrudeWhetstone",
			"MakeStoneBladeSaw",
			"CarveWhistle",
			-- PrimitiveToolMag3
			"CarveKnittingNeedles",
			"CarveWoodenFork",
			"MakeBoneFork",
			"CarveWoodenSpade",
			"CarveGoblets",
			"CarveBucket",
			-- TrickMag1
			"MakeHollowBook",
			-- TrickMag2
			"MakeBlankID",
			-- WeaponMag1
			"MakeBoneHatchetHead",
			"MakeJawboneAxe",
			"MakeJawboneClub",
			"MakeBoneClub",
			"SharpenLongBone",
			"SharpenJawbone",
			"BoneSpikeWeapon",
			-- WeaponMag2
			"CanReinforceWeapon",
			-- WeaponMag3
			"MakeShiv",
			"MakeGlassShiv",
			"MakeToothbrushShiv",
			"MakeMagazineArmor",
			"MakeImprovisedLighter",
			-- WeaponMag4
			"BarbedWireWeapon",
			-- WeaponMag5
			"MakeRakeHeadWeapon",
			"MakeSawbladeWeapon",
			"SheetMetalWeapon",
			"MakeSawPlank",
			"MakeBucketMaul",
			"MakeKettleMaul",
			"MakeBrakeWeapon",
			-- WeaponMag6
			"MakeGardenForkHeadWeapon",
			"MakeSpadeHeadCudgel",
			"MakeRailspikeWeapon",
			-- WeaponMag7
			"CarveBat",
			-- Professions
			-- UO recipes
			-- HerbalistMag
			"FireHardenSpear",
			-- Handy
			"BoltBat",
			"CanReinforceLongWeapon",
			"CanReinforceShortWeapon",
			"RailspikeBaseballBat",
			"MakeRailspikeCudgel",
			"MakeRailspikeIronPipe",
			"MakeRailspikeLongHandle",
			"MakeSawbladeCudgel",
			"MakeSawbladeLongHandle",
			"MakeSawbladePlank",
			"MakeSawbladeTableLeg",
			-- wilderness
			"MakeLongStoneBlade",
			"WireSpear",
			"MakeBoneSewingNeedle",
			"MakeBoneAwl",
			"MakeSnareTrap",
			-- whittler
			"MakeLargeBoneBead",
			"MakeLargeBoneBeads",
			"CarveShortBat",
			-- metalworker
			"Advanced_Forge",
			"Blast_Furnace",
			"Charcoal_Burner",
			"Construct_Charcoal_Pit",
			"Construct_Dome_Kiln",
			"Forge",
			"Construct_Makeshift_Electric_Blower_Forge",
			"Smelting_Furnace",
			"Forge_Primitive_Forge",
			"Primitive_Furnace",
			"Forge_Baking_Pan",
			"Forge_Baking_Tray",
			"Forge_Bucket",
			"Forge_Ball_Peen_Hammer_Head",
			"Forge_Clawhammer_Head",
			"Forge_Cooking_Pot",
			"Forge_Corkscrew",
			"Forge_Crowbar",
			"Forge_Crude_Shortsword_Blade",
			"Forge_Crude_Sword_Blade",
			"Forge_Door_Knob",
			"Forge_Fine_Butter_Knives",
			"Forge_Fine_Forks",
			"Forge_Fine_Spoons",
			"Forge_Fishing_Hooks",
			"Forge_Forceps",
			"Forge_Forks",
			"Forge_Frying_Pan",
			"Forge_Garden_Hoe_Head",
			"Forge_Gardening_Trowel",
			"Forge_Hand_Scythe_Head",
			"Forge_Hinge",
			"Forge_Hunting_Knife_Blade",
			"Forge_Kettle",
			"Forge_Kitchen_Knife_Blade",
			"Forge_Large_Knife_Blade",
			"Forge_Machete_Blade",
			"Forge_Masons_Chisel",
			"Forge_Masons_Trowel",
			"Forge_Meat_Cleaver_Blade",
			"Forge_Metalworking_Chisel",
			"Forge_Metalworking_Pliers",
			"Forge_Metalworking_Punch",
			"Forge_File",
			"Forge_Drill",
			"Forge_Nails",
			"Forge_Needle",
			"Forge_Pick_Axe_Head",
			"Forge_Railroad_Spike_Knife",
			"Forge_Roasting_Pan",
			"Forge_Saucepan",
			"Forge_Saw",
			"Forge_Scissors",
			"Forge_Scythe_Head",
			"Forge_Spade_Head",
			"Forge_Sheep_Shears",
			"Forge_Sledgehammer_Head",
			"Forge_Small_Knife",
			"Forge_Small_Steel_Sheet",
			"Forge_Smithing_Hammer_Head",
			"Forge_Spoons",
			"Forge_Steel_Sheet",
			"Forge_Straight_Razor",
			"Forge_Sword_Blade",
			"Forge_ShortSword_Blade",
			"Forge_Tongs",
			"Forge_Tweezers",
			"Make_Metal_Drum",
			"Forge_Heading_Tool",
			"Forge_Draw_Plate",
			"ForgeMaceHead",
			"MakeSpikedClub",
			"Forge_Wood_Axe_Head",
			"Forge_Old_Axe_Head",
			"Forge_Hand_Axe_Head",
			"Forge_Fleshing_Tool",
			"Forge_Goblets",
			"Forge_Cup",
			"Forge_Lantern",
			"Forge_Carpentry_Chisel",
			"Forge_Wrench",
			-- carpenter
			"MakeAdvancedFramepackFrame",
			"MakeAdvancedLargeFramepackFrame",
			-- burglar
			"MakeForearmMagazineArmor",
			"MakeThighMagazineArmor",
			"MakeShinMagazineArmor",
			"MakeBodyMagazineArmor",
			"MakeForearmBulletproofVestArmor",
			"MakeShinBulletproofVestArmor",
			"MakeThighBulletproofVestArmor",
			"Hemp Growing Season",
			-- artisan
			-- electrician
			"CraftMakeshiftRadio",
			"CraftMakeshiftHAMRadio",
			"CraftMakeshiftWalkieTalkie",
			-- engineer
			"MakeNoisegenerator",
			"RechargeGasMaskFilter",
			"RechargeRespiratorFilters",
			-- rancher
			"MakeBarbedWire",
		},

		---@class PersonalTraits.Engineer.values
		values = {
			-- TRP: Time reduction percent
			-- Base craft recipes percent reduction (Except "Packing" recipes)
			craftRecipesTRP = getSandboxValue("UO.Engineer.craftRecipesTRP"),
			-- Reduction per each required skill lvl
			craftRecipesTRPPerLvl = getSandboxValue("UO.Engineer.craftRecipesTRPPerLvl"),
			-- EMP_Grenade stun time (in seconds)
			empStunTime = getSandboxValue("UO.Engineer.empStunTime"),
			-- EMP_Grenade stun horizontal radius (in tiles)
			empStunHRadis = getSandboxValue("UO.Engineer.empStunHRadis"),
			-- EMP_Grenade stun vertical radius (in tiles)
			empStunVRadis = getSandboxValue("UO.Engineer.empStunVRadis"),
		},
		---@class PersonalTraits.Engineer.MutualExclusives
		mutualExclusives = { "Illiterate" },
	},

	---@class PersonalTraits.Builder
	Builder = {
		type = "Builder",
		name = getText("UI_trait_Builder"),
		desc = getText("UI_trait_BuilderDesc"),

		---@class PersonalTraits.Builder.xpBoosts
		xpBoosts = {
			{ perk = Perks.Woodwork, level = 3 },
			{ perk = Perks.Masonry, level = 3 },
			{ perk = Perks.MetalWelding, level = 1 },
		},

		---@class PersonalTraits.Builder.freeRecipes
		freeRecipes = {},

		---@class PersonalTraits.Builder.values
		values = {
			-- Building time percent reduce
			buildingTPR = getSandboxValue("UO.Builder.buildingTPR"),
			-- Additional building TPR per lvl
			buildingTPRPerLvl = getSandboxValue("UO.Builder.buildingTPRPerLvl"),
			-- Scrapping time percent reduce
			scrappingTPR = getSandboxValue("UO.Builder.scrappingTPR"),
			-- Additional scrapping TPR per lvl
			scrappingTPRPerLvl = getSandboxValue("UO.Builder.scrappingTPRPerLvl"),
			-- Bonus building health percent
			buildingBHP = getSandboxValue("UO.Builder.buildingBHP"),
			-- Bonus building health percent per lvl
			buildingBHPPerLvl = getSandboxValue("UO.Builder.buildingBHPPerLvl"),
			-- Bonus building capacity percent
			buildingCapBonus = getSandboxValue("UO.Builder.buildingCapBonus"),
			-- Bonus building capacity percent per lvl
			buildingCapBonusPerLvl = getSandboxValue("UO.Builder.buildingCapBonusPerLvl"),
		},
		---@class PersonalTraits.Builder.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Mechanic
	Mechanic = {
		type = "Mechanic",
		name = getText("UI_trait_Mechanic"),
		desc = getText("UI_trait_MechanicDesc"),

		---@class PersonalTraits.Mechanic.xpBoosts
		xpBoosts = {
			{ perk = Perks.Mechanics, level = 3 },
			{ perk = Perks.MetalWelding, level = 2 },
		},

		---@class PersonalTraits.Mechanic.freeRecipes
		freeRecipes = {
			-- MechanicMag1
			"Basic Mechanics",
			-- MechanicMag2
			"Intermediate Mechanics",
			-- MechanicMag3
			"Advanced Mechanics",
			-- MetalworkMag1
			"MetalWallLvl1",
			"MetalWallLvl2",
			"MetalFloorLvl1",
			"MetalWindowFrameLvl1",
			"MetalWindowFrameLvl2",
			"MetalWallFrame",
			"MetalDoorFrameLvl1",
			"MetalDoorFrameLvl2",
			"Metal_Stairs",
			-- MetalworkMag2
			"Metal_Counter_Lvl1",
			"Metal_Counter_Lvl2",
			"Metal_CounterCorner_Lvl1",
			"Metal_CounterCorner_Lvl2",
			"Metal_Crate_Lvl1",
			"Metal_Crate_Lvl2",
			"Metal_LockerBig_Lvl1",
			"Metal_LockerBig_Lvl2",
			"Metal_LockerSmall_Lvl1",
			"Metal_LockerSmall_Lvl2",
			"Metal_Shelves_Lvl1",
			"Metal_Shelves_Lvl2",
			-- MetalworkMag3
			"MetalPoleFenceGate",
			"MetalWireFenceGate",
			"MetalWireFenceGateSmall",
			"DoubleFenceGate",
			"DoubleWireGate",
			"MetalBigWireFence",
			"MetalBigMetalFence",
			"MetalPoleFenceGateSmall",
			"MetalSmallPoleFence",
			"MetalFenceLvl1",
			"MetalSmallWireFence",
			-- MetalworkMag4
			"MakeMetalSheet",
			"MakeSmallMetalSheet",
			-- metalworker
			"Make Metal Walls",
			"Make Metal Fences",
			"Make Metal Containers",
			"Make Metal Sheet",
			"Make Small Metal Sheet",
			"Make Metal Roof",
			"MakeScrapMetalHelmet",
			"MakeScrapMetalShoulderArmor",
			"MakeScrapMetalThighArmor",
			"MakeScrapMetalBodyArmor",
			"SpikeArmorWelding",
			"Drill_Draw_Plate",
			"Drill_Heading_Tool",
		},

		---@class PersonalTraits.Mechanic.values
		values = {
			-- Burnt cars scrapping time percent reduce
			scrappingTPR = getSandboxValue("UO.Mechanic.scrappingTPR"),
			-- Additional scrapping TPR per lvl
			scrappingTPRPerLvl = getSandboxValue("UO.Mechanic.scrappingTPRPerLvl"),
			-- Install and uninstall vehicle parts time percent reduce
			installTPR = getSandboxValue("UO.Mechanic.installTPR"),
			-- Additional install and uninstall TPR per lvl
			installTPRPerLvl = getSandboxValue("UO.Mechanic.installTPRPerLvl"),
			-- Bonus vehicle repairing percent
			repairBonusPercent = getSandboxValue("UO.Mechanic.repairBonusPercent"),
			-- Bonus vehicle repairing percent per lvl
			repairBonusPercentPerLvl = getSandboxValue("UO.Mechanic.repairBonusPercentPerLvl"),
		},
		---@class PersonalTraits.Mechanic.MutualExclusives
		mutualExclusives = {},
	},

	---@class PersonalTraits.Doctor
	Doctor = {
		type = "Doctor",
		name = getText("UI_trait_Doctor"),
		desc = getText("UI_trait_DoctorDesc"),

		---@class PersonalTraits.Doctor.xpBoosts
		xpBoosts = {
			{ perk = Perks.Doctor, level = 3 },
			{ perk = Perks.Cooking, level = 3 },
			{ perk = Perks.Tailoring, level = 3 },
		},

		---@class PersonalTraits.Doctor.freeRecipes
		freeRecipes = {
			-- TailoringMag1
			"MakeBoneAwl",
			"MakeBoneSewingNeedle",
			"SewHideHoodie",
			"SewHideRobe",
			"SewHidePants",
			"WeaveTwineShoes",
			-- TailoringMag2
			"MakeGarbageBagTankTop",
			"MakeGarbageBagDress",
			-- TailoringMag3
			"SewHideBoots",
			"SewHideCoat",
			"SewHideHat",
			"SewHideJacket",
			-- TailoringMag4
			"SewHideWallet",
			"SewBelt",
			"SewLeatherToolRoll",
			"SewSandals",
			"SewLeatherGloves",
			-- TailoringMag5
			"SewHolster",
			"SewHolsterDouble",
			"MakeWesternBoots",
			"SewFurredHideCoat",
			"SewFurredHideJacket",
			"SewLeatherPants",
			"SewSheepskinVest",
			-- TailoringMag6
			"SewLeatherVambrace",
			"SewLeatherCodpiece",
			"SewLeatherGorget",
			"SewElbowPads",
			"SewKneePads",
			-- TailoringMag7
			"AssembleSmallFramepack",
			"AssembleLargeFramepack",
			"SewClothSatchel",
			"SewCrudeLeatherBackpack",
			-- TailoringMag8
			"SewLeatherGaiter",
			"SewLeatherWaterBag",
			"SewHideSleepingBag",
			"SewBandolier",
			"SewHideFannyBag",
			-- TailoringMag9
			"MakeAdvancedFramepackFrame",
			"MakeAdvancedLargeFramepackFrame",
			"AssembleAdvancedFramepack",
			"AssembleAdvancedLargeFramepack",
			"SewSheepskinPants",
			-- TailoringMag10
			"SewDressKnees",
			"SewDressLong",
			"SewShirt",
			"SewSkirtKnees",
			"SewSkirtLong",
			"SewLongjohns",
			"SewLongjohnsBottom",
			"SewShirtSleeveless",
			"SewTrousers",
			-- KnittingMag1
			"KnitScarf",
			"KnitLegwarmers",
			"KnitSweaterVest",
			"KnitSocks",
			"KnitDoily",
			-- KnittingMag2
			"KnitWoolyHat",
			"KnitBalaclavaFace",
			"KnitBalaclavaFull",
			"KnitBeany",
			-- FarmingMag1
			"MakeMildewCure",
			-- FarmingMag2
			"MakeFliesCureFromCigarettes",
			"MakeFliesCureFromLooseTobacco",
			"MakeFliesCureFromChewingTobacco",
			"MakeAphidsCure",
			-- FarmingMag3
			"Chamomile Growing Season",
			"Marigold Growing Season",
			"Sunflower Growing Season",
			"Rose Growing Season",
			"Poppy Growing Season",
			"Lavender Growing Season",
			-- FarmingMag4
			"MakeScarecrow",
			"MakeBarbedWire",
			-- FarmingMag5
			"MakeJar",
			-- FarmingMag6
			"Barley Growing Season",
			"Corn Growing Season",
			"Flax Growing Season",
			"Rye Growing Season",
			"Soybean Growing Season",
			"Sugar Beet Growing Season",
			"Tobacco Growing Season",
			"Wheat Growing Season",
			-- FarmingMag7
			"Bell Pepper Growing Season",
			"Broccoli Growing Season",
			"Cabbage Growing Season",
			"Carrot Growing Season",
			"Cauliflower Growing Season",
			"Cucumber Growing Season",
			"Garlic Growing Season",
			"Green Pea Growing Season",
			"Habanero Growing Season",
			"Jalapeno Growing Season",
			"Kale Growing Season",
			"Leek Growing Season",
			"Lettuce Growing Season",
			"Onion Growing Season",
			"Potato Growing Season",
			"Pumpkin Growing Season",
			"Radish Growing Season",
			"Spinach Growing Season",
			"Strawberry Growing Season",
			"Sweet Potato Growing Season",
			"Tomato Growing Season",
			"Turnip Growing Season",
			"Watermelon Growing Season",
			"Zucchini Growing Season",
			-- FarmingMag8
			"Basil Growing Season",
			"Chives Growing Season",
			"Cilantro Growing Season",
			"Lemongrass Growing Season",
			"Mint Growing Season",
			"Oregano Growing Season",
			"Parsley Growing Season",
			"Sage Growing Season",
			"Rosemary Growing Season",
			"Thyme Growing Season",
			"Hops Growing Season",
			-- FarmingMag9
			"Black Sage Growing Season",
			"Broadleaf Plantain Growing Season",
			"Comfrey Growing Season",
			"Common Mallow Growing Season",
			"Wild Garlic Growing Season",
			-- CookingMag1
			"MakeCakeBatter",
			"MakePieDough",
			-- CookingMag2
			"MakeBreadDough",
			"MakeBaguetteDough",
			"MakeBiscuits",
			-- CookingMag3
			"MakePizza",
			-- CookingMag4
			"MakeChocolateCookieDough",
			"MakeChocolateChipCookieDough",
			"MakeOatmealCookieDough",
			"MakeSugarCookieDough",
			"MakeShortbreadCookieDough",
			-- CookingMag5
			"MakeSushi",
			"MakeMaki",
			"MakeOnigiri",
			-- CookingMag6
			"MakeFriedShrimp",
			"MakeFriedOnionRings",
			"MakeCabbageRolls",
			"MakeGuacamole",
			-- HerbalistMag
			"MakePlantainPoultice",
			"MakeComfreyPoultice",
			"MakeWildGarlicPoultice",
			-- Gardener
			"MakeJarofTomatoes",
			"MakeJarofCarrots",
			"MakeJarofPotatoes",
			"MakeJarofEggplant",
			"MakeJarofLeeks",
			"MakeJarofRedRadishes",
			"MakeJarofBellPeppers",
			"MakeJarofCabbage",
			"MakeJarofBroccoli",
			-- Tailor
			"MakeTarpChestRig",
			"MakeTarpTankTop",
			"MakeTarpDress",
			"SewShellsBandolier",
			-- Cook
			"MakeCookieDough",
			-- chef
			"PrepareMuffins",
		},

		---@class PersonalTraits.Doctor.values
		values = {
			-- Bonus medicine actions time reduce percent
			medicineActionsTRP = getSandboxValue("UO.Doctor.medicineActionsTRP"),
			-- Bonus medicine actions time reduce percent per lvl
			medicineActionsTRPPerLvl = getSandboxValue("UO.Doctor.medicineActionsTRPPerLvl"),
			-- Affects additional cataplasm power
			cataplasmPowerPercent = getSandboxValue("UO.Doctor.cataplasmPowerPercent"),
			-- Affects additional cataplasm power per doctor lvl
			cataplasmPowerPercentPerLvl = getSandboxValue("UO.Doctor.cataplasmPowerPercentPerLvl"),
			-- Affects additional bandage life time
			bandageLifePercent = getSandboxValue("UO.Doctor.bandageLifePercent"),
			-- Affects additional bandage life time per doctor lvl
			bandageLifePercentPerLvl = getSandboxValue("UO.Doctor.bandageLifePercentPerLvl"),
			-- Additional multiplier for food quality
			hungModifier = getSandboxValue("UO.Doctor.hungModifier"),
			-- Additional multiplier for food quality per cooking lvl
			hungModifierPerLvl = getSandboxValue("UO.Doctor.hungModifierPerLvl"),
		},
		---@class PersonalTraits.Doctor.MutualExclusives
		mutualExclusives = {},
	},
}

return PersonalTraits
