--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.TrainedFighter
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.TrainedFighter = function(player)
	local traitValues = UsefulOccupations.PersonalTraits.TrainedFighter.values

	-- Strafe speed increased
	local strafeWalkSpeedDefault = traitValues.strafeWalkSpeedDefault() / 100
	local strafeWalkSpeedBonus = traitValues.strafeWalkSpeedBonus() / 100
	local strafeAimSpeedDefault = traitValues.strafeAimSpeedDefault() / 100
	local strafeAimSpeedBonus = traitValues.strafeAimSpeedBonus() / 100
	local strafeSpeedTargetPerk = Perks.Nimble

	-- Melee weapons buffs
	local minHitChance = traitValues.minHitChance()
	local minCritChance = traitValues.minCritChance()
	local critChanceDefaultMult = traitValues.critChanceDefaultMult()
	local critChanceBonusPerLvl = traitValues.critChanceBonusPerLvl()
	local maxRangeDefaultMult = traitValues.maxRangeDefaultMult()
	local maxRangeBonusPerLvl = traitValues.maxRangeBonusPerLvl()
	local minDamageDefaultMult = traitValues.minDamageDefaultMult()
	local minDamageBonusPerLvl = traitValues.minDamageBonusPerLvl()
	local maxDamageDefaultMult = traitValues.maxDamageDefaultMult()
	local maxDamageBonusPerLvl = traitValues.maxDamageBonusPerLvl()
	local conditionLowerChanceMult = traitValues.conditionLowerChanceMult()

	-- Stomp speed mult
	local stompSpeedMult = 1 + traitValues.stompSpeedDefault() / 100

	-- Shove speed mult
	local shoveSpeedMult = 1 + traitValues.shoveSpeedDefault() / 100

	-- Weapon swing speed mult
	local weaponSwingSpeedDefault = traitValues.weaponSwingSpeedDefault() / 100
	local weaponSwingSpeedBonus = traitValues.weaponSwingSpeedBonus() / 100

	-- Bump fall speed mult
	local bumpFallSpeedMult = 1 + traitValues.bumpFallSpeedDefault() / 100

	-- Get up speed mult
	local scrambleGetUpSpeedMult = 1 + traitValues.scrambleGetUpSpeedDefault() / 100
	local notScrambleGetUpSpeedMult = 1 + traitValues.notScrambleGetUpSpeedDefault() / 100

	local forwardDirections = {
		N = {
			side = { "wa", "aw", "sd", "ds" },
			backward = { "s", "a", "sa", "as" },
		},
		NE = {
			side = { "w", "s" },
			backward = { "a", "aw", "wa", "as", "sa" },
		},
		E = {
			side = { "sa", "as", "wd", "dw" },
			backward = { "w", "a", "wa", "aw" },
		},
		SE = {
			side = { "a", "d" },
			backward = { "w", "wa", "aw", "wd", "dw" },
		},
		S = {
			side = { "wa", "aw", "sd", "ds" },
			backward = { "w", "d", "wd", "dw" },
		},
		SW = {
			side = { "s", "w" },
			backward = { "d", "dw", "wd", "ds", "sd" },
		},
		W = {
			side = { "sa", "as", "wd", "dw" },
			backward = { "d", "s", "ds", "sd" },
		},
		NW = {
			side = { "a", "d" },
			backward = { "s", "sa", "as", "sd", "ds" },
		},
	}

	local muscleStrainBodyParts = {
		Hand_L = 1,
		ForeArm_L = 1,
		UpperArm_L = 1,
		Hand_R = 1,
		ForeArm_R = 1,
		UpperArm_R = 1,
		UpperLeg_R = 1,
		LowerLeg_R = 1,
		Foot_R = 1,
	}

	local core = getCore()

	local bodyDamage = player:getBodyDamage()

	local movementHandler = UOPlayerMovementHandler:getInstance()
	local speedTypes = movementHandler.getSpeedTypes()

	local strafeTurnSpeedMult = 1
		+ strafeAimSpeedDefault
		+ (strafeAimSpeedBonus * player:getPerkLevel(strafeSpeedTargetPerk))

	local appliedWalkType = nil

	-- Update strafe walk speed
	---@param additionalMult number | nil
	local updateStrafeWalkSpeed = function(additionalMult)
		local newMult = 1 + strafeWalkSpeedDefault + (strafeWalkSpeedBonus * player:getPerkLevel(strafeSpeedTargetPerk))

		if additionalMult ~= nil then
			newMult = newMult * additionalMult
		end

		movementHandler.setSpeedMult(speedTypes.strafeWalk, newMult, true, false)
	end

	-- Update strafe walk turn speed
	local updateStrafeWalkTurnSpeed = function()
		if player:isAiming() == true then
			movementHandler.setSpeedMult(speedTypes.turn, strafeTurnSpeedMult, false, false)
		else
			movementHandler.setSpeedMult(speedTypes.turn, 1, false, false)
		end
	end

	-- Update strafe idle turn speed
	local updateStrafeIdleTurnSpeed = function()
		movementHandler.setSpeedMult(speedTypes.strafeAimIdle, strafeTurnSpeedMult, false, false)
	end

	---@param item HandWeapon
	---@param itemdata UOItemsStatsHandler.itemValues
	local doMeleeBuffs = function(item, itemdata)
		local newHitChance = itemdata.hitChance > minHitChance and itemdata.hitChance or minHitChance
		local newCritChance = itemdata.criticalChance > minCritChance and itemdata.criticalChance or minCritChance

		local targetPerk = item:getPerk()
		local targetPerkLvl = player:getPerkLevel(targetPerk)

		-- Melee weapons buffs mults
		local critChanceMult = critChanceDefaultMult + (critChanceBonusPerLvl * targetPerkLvl)
		local maxRangeMult = maxRangeDefaultMult + (maxRangeBonusPerLvl * targetPerkLvl)
		local minDamageMult = minDamageDefaultMult + (minDamageBonusPerLvl * targetPerkLvl)
		local maxDamageMult = maxDamageDefaultMult + (maxDamageBonusPerLvl * targetPerkLvl)

		item:setHitChance(newHitChance)
		item:setCriticalChance(newCritChance * critChanceMult)
		item:setMaxRange(itemdata.maxRange * maxRangeMult)
		item:setMinDamage(itemdata.minDamage * minDamageMult)
		item:setMaxDamage(itemdata.maxDamage * maxDamageMult)
		item:setConditionLowerChance(itemdata.conditionLowerChance * conditionLowerChanceMult)

		local weaponSwingSpeedMult = 1 + weaponSwingSpeedDefault + (weaponSwingSpeedBonus * targetPerkLvl)
		movementHandler.setSpeedMult(speedTypes.combat, weaponSwingSpeedMult, false, false)
	end

	-- Save current fight muscle strain
	local saveMuscleStrain = function()
		for bodyPart, _ in pairs(muscleStrainBodyParts) do
			muscleStrainBodyParts[bodyPart] = bodyDamage:getBodyPart(BodyPartType[bodyPart]):getStiffness()
		end
	end

	-- Load saved fight muscle strain
	local loadMuscleStrain = function()
		for bodyPart, muscleStrainValue in pairs(muscleStrainBodyParts) do
			bodyDamage:getBodyPart(BodyPartType[bodyPart]):setStiffness(muscleStrainValue)
		end
	end

	-- Update melee stats
	---@class InventoryItemsStatsHandler.TrainedFighter
	---@param item HandWeapon
	---@param itemdata UOItemsStatsHandler.itemValues
	UsefulOccupations.InventoryItemsStatsHandler.TrainedFighter = function(item, itemdata)
		doMeleeBuffs(item, itemdata)
	end

	-- Make strafe footsteps silent
	player:setVariable("silentStrafe", true)
	player:setVariable("trainedFighter", true)

	-- Increase stopm speed
	movementHandler.setSpeedMult(speedTypes.stomp, stompSpeedMult, false, false)

	-- Increase shove speed
	movementHandler.setSpeedMult(speedTypes.shove, shoveSpeedMult, false, false)

	-- Increase bump fall speed
	movementHandler.setSpeedMult(speedTypes.bumpFall, bumpFallSpeedMult, false, false)

	-- Increase scramble get up speed
	movementHandler.setSpeedMult(speedTypes.scramble, scrambleGetUpSpeedMult, false, false)

	-- Increase not scramble get up speed
	movementHandler.setSpeedMult(speedTypes.notScramble, notScrambleGetUpSpeedMult, false, false)

	updateStrafeWalkSpeed()
	updateStrafeIdleTurnSpeed()

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == strafeSpeedTargetPerk then
			strafeTurnSpeedMult = 1 + strafeAimSpeedDefault + (strafeAimSpeedBonus * perkLvl)

			updateStrafeWalkSpeed()
			updateStrafeIdleTurnSpeed()

			appliedWalkType = nil
		end

		UOItemsStatsHandler:updateInventoryItemsStats()
	end)

	-- In a combat stance moves equally fast in all directions
	UsefulOccupations.Functions.addEvent(Events.OnPlayerMove, function()
		if not player:isAiming() then
			return
		end

		local lookDirection = player:getForwardIsoDirection():toString()

		local w = isKeyDown(core:getKey("Forward"))
		local a = isKeyDown(core:getKey("Left"))
		local s = isKeyDown(core:getKey("Backward"))
		local d = isKeyDown(core:getKey("Right"))

		local movDirection = ""

		if w then
			-- The forward key takes priority over the back key
			s = false
			movDirection = movDirection .. "w"
		end

		if a then
			-- The left key has priority over the right key
			d = false
			movDirection = movDirection .. "a"
		end

		if s then
			movDirection = movDirection .. "s"
		end

		if d then
			movDirection = movDirection .. "d"
		end

		if movDirection == "" then
			return
		end

		local forwardDirection = forwardDirections[lookDirection]

		if forwardDirection == nil then
			return
		end

		local walkType = nil

		for type, keys in pairs(forwardDirection) do
			for _, key in ipairs(keys) do
				if movDirection == key then
					walkType = type
					break
				end
			end
		end

		if walkType == "side" and appliedWalkType ~= "side" then
			appliedWalkType = "side"
			updateStrafeWalkSpeed(1.383)
		-- elseif walkType == "backward" and appliedWalkType ~= "backward" then
		-- 	appliedWalkType = "backward"
		-- 	updateStrafeWalkSpeed(2)
		elseif (walkType == "backward" or walkType == nil) and appliedWalkType ~= nil then
			appliedWalkType = nil
			updateStrafeWalkSpeed()
		end
	end)

	-- A trained fighter does not receiving muscle strain during a fight
	UsefulOccupations.Functions.addEvent(Events.OnWeaponSwing, function()
		saveMuscleStrain()
	end)

	UsefulOccupations.Functions.addEvent(Events.OnPlayerAttackFinished, function()
		loadMuscleStrain()
	end)

	-- Constantly update strafe turn speed while walking
	UsefulOccupations.Functions.processEveryMs(30, updateStrafeWalkTurnSpeed)
end
