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
			-- TRP: Time reduction percent
			buildingTPR = 50,
			removeCampfireTRP = 50,
			putOutCampfireTRP = 50,
			lightFromPetrolTRP = 50,
			lightFromLiteratureTRP = 50,
			lightFromKindleTRP = 50,
			addCampfireFuelTRP = 50,
			washClothesTRP = 50,
			washYourselfTRP = 50,
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
			stunDurationAfterForfeit = 1,
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
			-- TRP: Time reduction percent
			-- Additional percent to reduce the transfer time
			inventoryTransferTRP = 25,
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
			perkActiveTime = 180,
			-- Perk cooldown time in game hours
			perkCooldownTime = 120,
			-- This is how much of the perk's cooldown must pass in percentage for the main debuffs to start working
			-- (5%, 6 game hours by default)
			perkCooldownEffectsStartPercent = 5,
		},
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
			craftRecipesTRP = 50,
			-- Reduction per each required skill lvl
			craftRecipesTRPPerLvl = 3,
			-- EMP_Grenade stun time (in seconds)
			empStunTime = 20,
			-- EMP_Grenade stun horizontal radius (in tiles)
			empStunHRadis = 6,
			-- EMP_Grenade stun vertical radius (in tiles)
			empStunVRadis = 1,
		},
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
			{ perk = Perks.MetalWelding, level = 3 },
		},

		---@class PersonalTraits.Builder.freeRecipes
		freeRecipes = {},

		---@class PersonalTraits.Builder.values
		values = {
			-- Building time percent reduce
			buildingTPR = 50,
			-- Additional building TPR per lvl
			buildingTPRPerLvl = 3,
			-- Scrapping time percent reduce
			scrappingTPR = 50,
			-- Additional scrapping TPR per lvl
			scrappingTPRPerLvl = 1.5,
			-- Bonus building health percent
			buildingBHP = 300,
			-- Bonus building health percent per lvl
			buildingBHPPerLvl = 20,
			-- Bonus building capacity percent
			buildingCapBonus = 50,
			-- Bonus building capacity percent per lvl
			buildingCapBonusPerLvl = 5,
		},
	},

	---@class PersonalTraits.Mechanic
	Mechanic = {
		type = "Mechanic",
		name = getText("UI_trait_Mechanic"),
		desc = getText("UI_trait_MechanicDesc"),

		---@class PersonalTraits.Mechanic.xpBoosts
		xpBoosts = {
			{ perk = Perks.Mechanics, level = 3 },
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
		values = {},
	},

	---@class PersonalTraits.Doctor
	Doctor = {
		type = "Doctor",
		name = getText("UI_trait_Doctor"),
		desc = getText("UI_trait_DoctorDesc"),

		---@class PersonalTraits.Doctor.xpBoosts
		xpBoosts = {},

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
		values = {},
	},
}

return PersonalTraits
