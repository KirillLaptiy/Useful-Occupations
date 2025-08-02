--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Invincible
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Invincible = function(player)
	local dodgeEnduranceCost = UsefulOccupations.PersonalTraits.Invincible.values.dodgeEnduranceCost / 100
	local dodgeEnduranceEdge = UsefulOccupations.PersonalTraits.Invincible.values.dodgeEnduranceEdge / 100
	local targetPerk = UsefulOccupations.PersonalTraits.Invincible.values.targetPerk
	local targetPerkEffect = UsefulOccupations.PersonalTraits.Invincible.values.targetPerkEffect / 100
	local perkActiveTime = UsefulOccupations.PersonalTraits.Invincible.values.perkActiveTime
	local perkCooldownTime = UsefulOccupations.PersonalTraits.Invincible.values.perkCooldownTime * 60

	local injuryFields = {
		Burn = {
			burnTime = { get = "getBurnTime", set = "setBurnTime" },
			burnSpeedModifier = { get = "getBurnSpeedModifier", set = "setBurnSpeedModifier" },
			needBurnWash = { get = "isNeedBurnWash", set = "setNeedBurnWash" },
			lastTimeBurnWash = { get = "getLastTimeBurnWash", set = "setLastTimeBurnWash" },
		},

		Cut = {
			isCut = { get = "isCut", set = "setCut" },
			cutTime = { get = "getCutTime", set = "setCutTime" },
			cutSpeedModifier = { get = "getCutSpeedModifier", set = "setCutSpeedModifier" },
		},

		DeepWound = {
			isDeepWounded = { get = "isDeepWounded", set = "setDeepWounded" },
			deepWoundTime = { get = "getDeepWoundTime", set = "setDeepWoundTime" },
			deepWoundSpeedModifier = { get = "getDeepWoundSpeedModifier", set = "setDeepWoundSpeedModifier" },
		},

		Bite = {
			bitten = { get = "bitten", set = "SetBitten" },
			biteTime = { get = "getBiteTime", set = "setBiteTime" },
		},

		Scratch = {
			scratched = { get = "scratched", set = "setScratched" },
			scratchTime = { get = "getScratchTime", set = "setScratchTime" },
			scratchSpeedModifier = { get = "getScratchSpeedModifier", set = "setScratchSpeedModifier" },
		},

		Infection = {
			infectedWound = { get = "isInfectedWound", set = "setInfectedWound" },
			woundInfectionLevel = { get = "getWoundInfectionLevel", set = "setWoundInfectionLevel" },
			isInfected = { get = "IsInfected", set = "SetInfected" },
			fakeInfected = { get = "IsFakeInfected", set = "SetFakeInfected" },
			cauterized = { get = "IsCauterized", set = "SetCauterized" },
		},

		Fracture = {
			fractureTime = { get = "getFractureTime", set = "setFractureTime" },
		},

		Bandage = {
			bandaged = { get = "bandaged", set = "setBandaged" },
			bandageLife = { get = "getBandageLife", set = "setBandageLife" },
			bandageType = { get = "getBandageType", set = "setBandageType" },
			stitched = { get = "stitched", set = "setStitched" },
			stitchTime = { get = "getStitchTime", set = "setStitchTime" },
		},

		Splint = {
			splint = { get = "isSplint", set = "setSplint" },
			splintFactor = { get = "getSplintFactor", set = "setSplintFactor" },
			splintItem = { get = "getSplintItem", set = "setSplintItem" },
		},

		OtherDamage = {
			haveBullet = { get = "haveBullet", set = "setHaveBullet" },
			haveGlass = { get = "haveGlass", set = "setHaveGlass" },
			stiffness = { get = "getStiffness", set = "setStiffness" },
			wetness = { get = "getWetness", set = "setWetness" },
			additionalPain = { get = "getAdditionalPain", set = "setAdditionalPain" },
			alcoholLevel = { get = "getAlcoholLevel", set = "setAlcoholLevel" },
			comfreyFactor = { get = "getComfreyFactor", set = "setComfreyFactor" },
			garlicFactor = { get = "getGarlicFactor", set = "setGarlicFactor" },
			plantainFactor = { get = "getPlantainFactor", set = "setPlantainFactor" },
			health = { get = "getHealth", set = "SetHealth" },
		},

		Bleeding = {
			bleeding = { get = "bleeding", set = "setBleeding" },
			bleedingTime = { get = "getBleedingTime", set = "setBleedingTime" },
			bleedingStemmed = { get = "IsBleedingStemmed", set = "SetBleedingStemmed" },
		},
	}

	local statsFields = {
		fatigue = { get = "getFatigue", set = "setFatigue" },
		hunger = { get = "getHunger", set = "setHunger" },
		thirst = { get = "getThirst", set = "setThirst" },
		stress = { get = "getStress", set = "setStress" },
		panic = { get = "getPanic", set = "setPanic" },
		drunkenness = { get = "getDrunkenness", set = "setDrunkenness" },
		pain = { get = "getPain", set = "setPain" },
		endurance = { get = "getEndurance", set = "setEndurance" },
		sickness = { get = "getSickness", set = "setSickness" },
		boredom = { get = "getBoredom", set = "setBoredom" },
	}

	local bodyDamageFields = {
		boredom = { get = "getBoredomLevel", set = "setBoredomLevel" },
		catchACold = { get = "getCatchACold", set = "setCatchACold" },
		coldDamageStage = { get = "getColdDamageStage", set = "setColdDamageStage" },
		coldProgressionRate = { get = "getColdProgressionRate", set = "setColdProgressionRate" },
		coldReduction = { get = "getColdReduction", set = "setColdReduction" },
		coldSneezeTimerMax = { get = "getColdSneezeTimerMax", set = "setColdSneezeTimerMax" },
		coldSneezeTimerMin = { get = "getColdSneezeTimerMin", set = "setColdSneezeTimerMin" },
		coldStrength = { get = "getColdStrength", set = "setColdStrength" },
		continualPainIncrease = { get = "getContinualPainIncrease", set = "setContinualPainIncrease" },
		fakeInfectionLevel = { get = "getFakeInfectionLevel", set = "setFakeInfectionLevel" },
		hasACold = { get = "isHasACold", set = "setHasACold" },
		infected = { get = "isInfected", set = "setInfected" },
		infectionGrowthRate = { get = "getInfectionGrowthRate", set = "setInfectionGrowthRate" },
		infectionLevel = { get = "getInfectionLevel", set = "setInfectionLevel" },
		infectionMortalityDuration = { get = "getInfectionMortalityDuration", set = "setInfectionMortalityDuration" },
		infectionTime = { get = "getInfectionTime", set = "setInfectionTime" },
		isFakeInfected = { get = "IsFakeInfected", set = "setIsFakeInfected" },
		overallBodyHealth = { get = "getOverallBodyHealth", set = "setOverallBodyHealth" },
		sneezeCoughDelay = { get = "getSneezeCoughDelay", set = "setSneezeCoughDelay" },
		sneezeCoughTime = { get = "getSneezeCoughTime", set = "setSneezeCoughTime" },
		wetness = { get = "getWetness", set = "setWetness" },
		healthFromFood = { get = "getHealthFromFood", set = "setHealthFromFood" },
		healthFromFoodTimer = { get = "getHealthFromFoodTimer", set = "setHealthFromFoodTimer" },
		foodSicknessLevel = { get = "getFoodSicknessLevel", set = "setFoodSicknessLevel" },
		poisonLevel = { get = "getPoisonLevel", set = "setPoisonLevel" },
		panicIncreaseValue = { get = "getPanicIncreaseValue", set = "setPanicIncreaseValue" },
		panicReductionValue = { get = "getPanicReductionValue", set = "setPanicReductionValue" },
		painReduction = { get = "getPainReduction", set = "setPainReduction" },
		painReductionFromMeds = { get = "getPainReductionFromMeds", set = "setPainReductionFromMeds" },
		sleepingHealthAddition = { get = "getSleepingHealthAddition", set = "setSleepingHealthAddition" },
		standardHealthAddition = { get = "getStandardHealthAddition", set = "setStandardHealthAddition" },
		unhappynessLevel = { get = "getUnhappynessLevel", set = "setUnhappynessLevel" },
	}

	local injurySettersExtraValues = {
		setBandaged = function()
			return 1
		end,
		setSplint = function()
			return 1
		end,
		setHaveBullet = function()
			return player:getPerkLevel(Perks.Doctor)
		end,
		setScratched = function()
			return true
		end,
	}

	local perkStates = {
		active = "active",
		ready = "ready",
		onCooldown = "onCooldown",
	}

	local modData = UsefulOccupations.Functions.getModData()

	local stats = player:getStats()

	local bodyDamage = player:getBodyDamage()
	local bodyParts = bodyDamage:getBodyParts()

	local canDodge = stats:getEndurance() > dodgeEnduranceEdge
	local dodgeCost = dodgeEnduranceCost - (targetPerkEffect * player:getPerkLevel(targetPerk))

	local updateBodyPartInjuries = function()
		modData.bodyPartsData = {}

		for i = 0, bodyParts:size() - 1 do
			local part = bodyParts:get(i)

			local entry = { index = part:getIndex() }

			for injuryType, fields in pairs(injuryFields) do
				entry[injuryType] = {}

				for fieldName, methods in pairs(fields) do
					local value = part[methods.get](part)
					entry[injuryType][fieldName] = value
				end
			end

			table.insert(modData.bodyPartsData, entry)
		end
	end

	local applyBodyPartInjuries = function()
		for _, entry in ipairs(modData.bodyPartsData) do
			---@type BodyPart
			local part = bodyParts:get(entry.index)

			for injuryType, fields in pairs(injuryFields) do
				local saved = entry[injuryType]

				if saved then
					for fieldName, value in pairs(saved) do
						local setter = fields[fieldName].set
						local extraValue = injurySettersExtraValues[setter]

						if extraValue ~= nil then
							part[setter](part, value, extraValue())
						else
							part[setter](part, value)
						end
					end
				end
			end
		end
	end

	local updateStats = function()
		modData.statsData = {}

		local entry = {}

		for statusType, fields in pairs(statsFields) do
			local value = stats[fields.get](stats)
			entry[statusType] = value
		end

		table.insert(modData.statsData, entry)
	end

	local applyStats = function()
		local saved = modData.statsData[1]

		if not saved then
			return
		end

		for statusType, value in pairs(saved) do
			local setter = statsFields[statusType].set

			if setter then
				stats[setter](stats, value)
			end
		end
	end

	local updateBodyDamage = function()
		modData.bodyDamageData = {}

		local entry = {}

		for bodyDamageType, fields in pairs(bodyDamageFields) do
			local value = bodyDamage[fields.get](bodyDamage)
			entry[bodyDamageType] = value
		end

		table.insert(modData.bodyDamageData, entry)
	end

	local applyBodyDamage = function()
		local saved = modData.bodyDamageData[1]

		if not saved then
			return
		end

		for bodyDamageType, value in pairs(saved) do
			local setter = bodyDamageFields[bodyDamageType].set

			if setter then
				bodyDamage[setter](bodyDamage, value)
			end
		end
	end

	local updateWeaponUnbreakable = function()
		local isPerkActive = modData.invincibleState == perkStates.active
		local inventory = player:getInventory()

		for i = 0, inventory:getItems():size() - 1 do
			---@type HandWeapon
			local item = inventory:getItems():get(i)

			if item:IsWeapon() then
				local itemdata = item:getModData()

				-- Save the original values if we haven't already
				if itemdata.conditionLowerChance == nil then
					itemdata.conditionLowerChance = item:getConditionLowerChance()
				end

				if itemdata.sharpness == nil then
					itemdata.sharpness = item:getSharpness()
				end

				if itemdata.headCondition == nil then
					itemdata.headCondition = item:getHeadCondition()
				end

				-- Remember the "current" parameters after all external buffs
				if itemdata.invincible_conditionLowerChance == nil then
					itemdata.invincible_conditionLowerChance = item:getConditionLowerChance()
				end

				if itemdata.invincible_sharpness == nil then
					itemdata.invincible_sharpness = item:getSharpness()
				end

				if itemdata.invincible_headCondition == nil then
					itemdata.invincible_headCondition = item:getHeadCondition()
				end

				if item:isEquipped() and isPerkActive then
					item:setConditionLowerChance(math.huge)
					item:setSharpness(itemdata.invincible_sharpness > 0.2 and itemdata.invincible_sharpness or 0.2)
					item:setHeadCondition(
						itemdata.invincible_headCondition > 1 and itemdata.invincible_headCondition or 2
					)
				else
					if isPerkActive then
						item:setConditionLowerChance(itemdata.conditionLowerChance)
						item:setSharpness(itemdata.sharpness)
						item:setHeadCondition(itemdata.headCondition)
					else
						item:setConditionLowerChance(itemdata.invincible_conditionLowerChance)
						item:setSharpness(itemdata.invincible_sharpness)
						item:setHeadCondition(itemdata.invincible_headCondition)
					end

					itemdata.invincible_conditionLowerChance = nil
					itemdata.invincible_sharpness = nil
					itemdata.invincible_headCondition = nil
				end
			end
		end
	end

	local doDodge = function()
		local endurance = stats:getEndurance()

		stats:setEndurance(endurance - dodgeCost)

		player:playerVoiceSound("JumpLow")
	end

	---@param zombie IsoZombie
	local dodgeAttackingZombies = function(zombie)
		zombie:setNoTeeth(true)

		UsefulOccupations.Functions.processAfterDelay(500, function()
			if not canDodge then
				zombie:setNoTeeth(false)
				return
			end

			local distance = player:DistTo(zombie)

			if distance <= 1.05 and zombie:isAttacking() then
				zombie:setStaggerBack(true)
				zombie:setKnockedDown(true)
				doDodge()
			end

			zombie:setNoTeeth(false)
		end)
	end

	local activatePerk = function()
		modData.invincibleState = perkStates.active
		modData.invincibleActiveTime = perkActiveTime

		player:setPlayingDeathSound(false)
		player:setDeathDragDown(false)
		---@diagnostic disable-next-line: param-type-mismatch
		player:setHitReaction(nil)

		updateBodyPartInjuries()
		updateStats()
		updateBodyDamage()

		player:setGodMod(true)
		player:setUnlimitedCarry(true)
	end

	---@param zombie IsoZombie
	local pushZombie = function(zombie)
		zombie:setKnockedDown(true)
		zombie:setStaggerBack(true)
		zombie:setHitReaction("")
		zombie:setPlayerAttackPosition("FRONT")
		zombie:setHitForce(5.0)
		zombie:reportEvent("wasHit")
	end

	local checkNearZombies = function()
		canDodge = stats:getEndurance() > dodgeEnduranceEdge
		local isDeathDragDown = player:isDeathDragDown()

		local enemies = player:getSpottedList()

		for i = 0, enemies:size() - 1 do
			---@type IsoZombie
			local enemy = enemies:get(i)

			if enemy:isZombie() and player:DistTo(enemy) <= 4 then
				if isDeathDragDown then
					if modData.invincibleState == perkStates.ready then
						activatePerk()
					end

					if not enemy:isKnockedDown() then
						pushZombie(enemy)
					end
				elseif canDodge and enemy:getTarget() == player and not enemy:isNoTeeth() and enemy:isAttacking() then
					-- dodgeAttackingZombies(enemy)
				end
			end
		end
	end

	local processPerkActiveState = function()
		if modData.invincibleState ~= perkStates.active then
			return
		end

		-- Do when perk is active
		modData.invincibleActiveTime = math.max(0, modData.invincibleActiveTime - 1)

		print(modData.invincibleActiveTime)

		updateWeaponUnbreakable()

		-- Switch perk state to "cooldown"
		if modData.invincibleActiveTime == 0 then
			modData.invincibleState = perkStates.onCooldown
			modData.invincibleCooldownTime = perkCooldownTime

			player:setGodMod(false)
			player:setUnlimitedCarry(false)

			updateWeaponUnbreakable()

			applyBodyPartInjuries()
			applyStats()
			applyBodyDamage()
		end
	end

	local processPerkCooldownState = function()
		if modData.invincibleState ~= perkStates.onCooldown then
			return
		end

		modData.invincibleCooldownTime = math.max(0, modData.invincibleCooldownTime - 10)

		-- Do when perk on cooldown

		-- Switch perk state to "ready"
		if modData.invincibleCooldownTime == 0 then
			modData.invincibleState = perkStates.ready
		end
	end

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			dodgeCost = dodgeEnduranceCost - (targetPerkEffect * perkLvl)
		end
	end)

	UsefulOccupations.Functions.addEvent(Events.EveryTenMinutes, processPerkCooldownState)

	UsefulOccupations.Functions.processEveryMs(30, checkNearZombies)
	UsefulOccupations.Functions.processEveryMs(1000, processPerkActiveState)
end
