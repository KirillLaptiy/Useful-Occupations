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
	local strafeWalkSpeedDefault = traitValues.strafeWalkSpeedDefault / 100
	local strafeWalkSpeedBonus = traitValues.strafeWalkSpeedBonus / 100
	local strafeAimSpeedDefault = traitValues.strafeAimSpeedDefault / 100
	local strafeAimSpeedBonus = traitValues.strafeAimSpeedBonus / 100
	local strafeSpeedTargetPerk = traitValues.strafeSpeedTargetPerk

	-- Melee weapons buffs
	local minHitChance = traitValues.minHitChance
	local minCritChance = traitValues.minCritChance
	local critChanceDefaultMult = traitValues.critChanceDefaultMult
	local critChanceBonusPerLvl = traitValues.critChanceBonusPerLvl
	local maxRangeDefaultMult = traitValues.maxRangeDefaultMult
	local maxRangeBonusPerLvl = traitValues.maxRangeBonusPerLvl
	local minDamageDefaultMult = traitValues.minDamageDefaultMult
	local minDamageBonusPerLvl = traitValues.minDamageBonusPerLvl
	local maxDamageDefaultMult = traitValues.maxDamageDefaultMult
	local maxDamageBonusPerLvl = traitValues.maxDamageBonusPerLvl
	local conditionLowerChanceMult = traitValues.conditionLowerChanceMult

	local movementHandler = UOPlayerMovementHandler:getInstance()
	local speedTypes = movementHandler.getSpeedTypes()

	local strafeTurnSpeedMult = 1
		+ strafeAimSpeedDefault
		+ (strafeAimSpeedBonus * player:getPerkLevel(strafeSpeedTargetPerk))

	-- Update strafe walk speed
	local updateStrafeWalkSpeed = function()
		local newMult = 1 + strafeWalkSpeedDefault + (strafeWalkSpeedBonus * player:getPerkLevel(strafeSpeedTargetPerk))
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
	end

	---@param item Clothing
	---@param itemdata UOItemsStatsHandler.itemValues
	local increaseStompPower = function(item, itemdata)
		item:setStompPower((itemdata.stompPower + 1) * 2)
	end

	-- Update melee stats
	---@class InventoryItemsStatsHandler.TrainedFighter
	---@param item HandWeapon | Clothing
	---@param itemdata UOItemsStatsHandler.itemValues
	UsefulOccupations.InventoryItemsStatsHandler.TrainedFighter = function(item, itemdata)
		if item:IsWeapon() then
			---@diagnostic disable-next-line: param-type-mismatch
			doMeleeBuffs(item, itemdata)
		else
			---@diagnostic disable-next-line: param-type-mismatch
			increaseStompPower(item, itemdata)
		end
	end

	-- Make strafe footsteps silent
	player:setVariable("silentStrafe", true)

	updateStrafeWalkSpeed()
	updateStrafeIdleTurnSpeed()

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == strafeSpeedTargetPerk then
			strafeTurnSpeedMult = 1 + strafeAimSpeedDefault + (strafeAimSpeedBonus * perkLvl)

			updateStrafeWalkSpeed()
			updateStrafeIdleTurnSpeed()
		end

		UOItemsStatsHandler:updateInventoryItemsStats()
	end)

	UsefulOccupations.Functions.processEveryMs(30, updateStrafeWalkTurnSpeed)
end
