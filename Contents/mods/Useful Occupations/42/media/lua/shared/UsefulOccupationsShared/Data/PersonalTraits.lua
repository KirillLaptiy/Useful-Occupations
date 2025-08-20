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

local getSandboxValue = function(value)
	return function()
		return SandboxVars[value]
	end
end

local some = getSandboxValue("BloodLevel")
local some1 = getSandboxValue("MultiHitZombies")

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
			-- Additional multiplier for xp boost from books
			booksMultiplier = 2,
			-- set's last level for active book's multiplier
			lastBooksMultiplierLevel = 10,
		},
	},

	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	----------------------------------- SCOUT -------------------------------------
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
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
		values = {
			-- Sets how much the strength will affect the character's carrying capacity
			strengthBonusCarrying = 12,
		},
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
			-- This is how much the lockpicking time is reduced for each level of target perk
			reduceDoorLockpickingTime = 30,
			-- Target perk that decreases lockpicking time with each lvl
			targetLockpickPerk = Perks.Sneak,
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
		values = {
			---@class PersonalTraits.Graceful.values.defaultWalk
			defaultWalk = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			---@class PersonalTraits.Graceful.values.sneakWalk
			sneakWalk = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			---@class PersonalTraits.Graceful.values.sneakRun
			sneakRun = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Sprinting,
			},

			---@class PersonalTraits.Graceful.values.defaultRun
			defaultRun = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Sprinting,
			},

			---@class PersonalTraits.Graceful.values.defaultSprint
			defaultSprint = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Sprinting,
			},

			---@class PersonalTraits.Graceful.values.climbWall
			climbWall = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			---@class PersonalTraits.Graceful.values.climbWindow
			climbWindow = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			---@class PersonalTraits.Graceful.values.climbFence_Walk
			climbFence_Walk = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			---@class PersonalTraits.Graceful.values.climbFence_Run
			climbFence_Run = {
				startBonusPercent = 10,
				percentPerLvl = 2,
				targetPerk = Perks.Sprinting,
			},

			---@class PersonalTraits.Graceful.values.climbFence_Sprint
			climbFence_Sprint = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Sprinting,
			},

			---@class PersonalTraits.Graceful.values.turn
			turn = {
				startBonusPercent = 30,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			---@class PersonalTraits.Graceful.values.turn180
			turn180 = {
				startBonusPercent = 80,
				percentPerLvl = 2,
				targetPerk = Perks.Lightfoot,
			},

			-- Weight Multiplier for worn clothing (0.25 - 75% reduce)
			clothingWeightMultiplier = 0.25,
		},
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
			distanceToForfeit = 15,
			-- Distance reduce (distanceToForfeit) per perk lvl
			decreaseDistanceByLvl = 0.5,
			-- Perk that will affect (decreaseDistanceByLvl)
			decreaseDistancePerk = Perks.Sneak,
			-- Duration of stun after zombie forfeits sight of player (in milliseconds)
			stunDurationAfterForfeit = 50,
			-- Delay to update distance to forfeit (in milliseconds)
			distanceToForfeitUpdateDelay = 20,
			-- Default multiplier (while walking) to distance to forfeit
			defaultMultiplier = 1,
			-- Sneaking effect for default multiplier to distance to forfeit
			sneakingEffect = -0.2,
		},
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
			-- Additional multiplier to reduce the transfer time (0.5 (50%) basic + (0.5 * 2 (multiplier)) = 0.75 (75% in total))
			transferAdditionalMultiplier = 2,
		},
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
	},

	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	----------------------------------- VETERAN -----------------------------------
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	---@class PersonalTraits.Marksman
	Marksman = {
		type = "Marksman",
		name = getText("UI_trait_marksman"),
		desc = getText("UI_trait_marksmandesc"),
		---@class PersonalTraits.Marksman.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.Marksman.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Marksman.values
		values = {
			-- The perk that affects all aiming bonuses
			targetPerk = Perks.Aiming,
			-- Minimum guaranteed hit chance (overrides lower weapon values)
			minHitChance = 100,
			-- Minimum guaranteed critical hit chance (overrides lower weapon values)
			minCritChance = 50,
			-- Base multiplier applied to the weapon's critical chance
			critChanceDefaultMult = 1.5,
			-- Additional multiplier per perk level added to critical chance
			critChanceBonusPerLvl = 0.05,
			-- Base multiplier for aiming time (e.g. 2 = twice as fast aiming)
			aimingTimeDefaultMult = 2,
			-- Additional multiplier per perk level to reduce aiming time
			aimingTimeBonusPerLvl = 0.1,
			-- Base multiplier for maximum weapon range
			maxRangeDefaultMult = 1.2,
			-- Bonus multiplier per perk level to increase max range
			maxRangeBonusPerLvl = 0.03,
			-- Base multiplier for the weapon's minimum damage
			minDamageDefaultMult = 1.2,
			-- Bonus multiplier per perk level to increase minimum damage
			minDamageBonusPerLvl = 0.03,
			-- Base multiplier for the weapon's maximum damage
			maxDamageDefaultMult = 1.2,
			-- Bonus multiplier per perk level to increase maximum damage
			maxDamageBonusPerLvl = 0.03,
			-- The perk that affects all reloading bonuses
			reloadSpeedTargetPerk = Perks.Reloading,
			-- Base multiplier for the reloading speed
			reloadSpeedDefaultMult = 1.3,
			-- Bonus multiplier per perk level to increase reloading speed
			reloadSpeedBonusPerLvl = 0.02,
			-- Bonus mult to reduce the chance of breaking ranged weapons
			conditionLowerChanceMult = 2,
		},
	},

	---@class PersonalTraits.Stout
	Stout = {
		type = "Stout",
		name = getText("UI_trait_stout"),
		desc = getText("UI_trait_stoutdesc"),
		---@class PersonalTraits.Strong.xpBoosts
		xpBoosts = {
			{ perk = Perks.Strength, level = 2 },
		},
		---@class PersonalTraits.Strong.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Strong.values
		values = {},
	},

	---@class PersonalTraits.Fit
	Fit = {
		type = "Fit",
		name = getText("UI_trait_fit"),
		desc = getText("UI_trait_fitdesc"),
		---@class PersonalTraits.Fit.xpBoosts
		xpBoosts = {
			{ perk = Perks.Fitness, level = 2 },
		},
		---@class PersonalTraits.Fit.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.Fit.values
		values = {},
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
			painReduction = 50,
			-- Maximum pain value (20 - second stage)
			maxPain = 20,
			-- Maximum fatigue value (81 - third stage)
			maxFatigue = 81,
		},
	},

	---@class PersonalTraits.TrainedFighter
	TrainedFighter = {
		type = "TrainedFighter",
		name = getText("UI_trait_TrainedFighter"),
		desc = getText("UI_trait_TrainedFighterDesc"),
		---@class PersonalTraits.TrainedFighter.xpBoosts
		xpBoosts = {},
		---@class PersonalTraits.TrainedFighter.freeRecipes
		freeRecipes = {},
		---@class PersonalTraits.TrainedFighter.values
		values = {
			-- Default strafe walk speed increase in percents
			strafeWalkSpeedDefault = 30,
			-- Bonus percents per target perk lvl
			strafeWalkSpeedBonus = 2,
			-- Default strafe aim speed increase in percents
			strafeAimSpeedDefault = 30,
			-- Bonus percents per target perk lvl
			strafeAimSpeedBonus = 2,
			-- Perk that will increase speed per lvl
			strafeSpeedTargetPerk = Perks.Nimble,
			-- Minimum guaranteed hit chance (overrides lower weapon values)
			minHitChance = 100,
			-- Minimum guaranteed critical hit chance (overrides lower weapon values)
			minCritChance = 50,
			-- Base multiplier applied to the weapon's critical chance
			critChanceDefaultMult = 1.5,
			-- Additional multiplier per perk level added to critical chance
			critChanceBonusPerLvl = 0.05,
			-- Base multiplier for maximum weapon range
			maxRangeDefaultMult = 1.2,
			-- Bonus multiplier per perk level to increase max range
			maxRangeBonusPerLvl = 0.03,
			-- Base multiplier for the weapon's minimum damage
			minDamageDefaultMult = 1.2,
			-- Bonus multiplier per perk level to increase minimum damage
			minDamageBonusPerLvl = 0.03,
			-- Base multiplier for the weapon's maximum damage
			maxDamageDefaultMult = 1.2,
			-- Bonus multiplier per perk level to increase maximum damage
			maxDamageBonusPerLvl = 0.03,
			-- Bonus mult to reduce the chance of breaking melee weapons
			conditionLowerChanceMult = 2,
			-- Stomp speed bonus percent
			stompSpeedDefault = 50,
			-- Default weapon swing speed increase in percents
			weaponSwingSpeedDefault = 30,
			-- Bonus percents per target perk lvl
			weaponSwingSpeedBonus = 2,
			-- Shove speed increase in percents
			shoveSpeedDefault = 25,
			-- Bump fall speed increase in percents
			bumpFallSpeedDefault = 50,
			-- Scramble get up speed increase in percents
			scrambleGetUpSpeedDefault = 50,
			-- Not scramble get up speed increase in percents
			notScrambleGetUpSpeedDefault = 200,
		},
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
			spendMainReduce = 40,
			-- Additional percentage increase in endurance recovery rate while resting
			enduranceRestBonus = 100,
			-- Target perk that will additional percentage reduction each lvl
			targetPerk = Perks.Fitness,
			-- Additional percentage reduction per target perk lvl
			spendPerkReduce = 3,
		},
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
			dodgeEnduranceCost = 3,
			-- Minimum endurance required to dodge (as a percentage of the total)
			dodgeEnduranceEdge = 30,
			-- Target perk that will affect the reduction of endurance consumption
			targetPerk = Perks.Nimble,
			-- Effect from target perk lvl
			targetPerkEffect = 0.1,
			-- Perk active time in real seconds
			perkActiveTime = 150,
			-- Perk cooldown time in game hours
			perkCooldownTime = 120,
			-- This is how much of the perk's cooldown must pass in percentage for the main debuffs to start working
			-- (5%, 6 game hours by default)
			perkCooldownEffectsStartPercent = 5,
		},
	},
}

return PersonalTraits
