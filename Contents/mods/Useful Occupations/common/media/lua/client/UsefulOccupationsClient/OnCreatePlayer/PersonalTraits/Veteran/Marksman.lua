--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Marksman
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Marksman = function(player)
	local traitValues = UsefulOccupations.PersonalTraits.Marksman.values

	local targetPerk = Perks.Aiming
	local reloadSpeedTargetPerk = Perks.Reloading

	local minHitChance = traitValues.minHitChance()
	local minCritChance = traitValues.minCritChance()
	local critChanceDefaultMult = traitValues.critChanceDefaultMult()
	local critChanceBonusPerLvl = traitValues.critChanceBonusPerLvl()
	local aimingTimeDefaultMult = traitValues.aimingTimeDefaultMult()
	local aimingTimeBonusPerLvl = traitValues.aimingTimeBonusPerLvl()
	local maxRangeDefaultMult = traitValues.maxRangeDefaultMult()
	local maxRangeBonusPerLvl = traitValues.maxRangeBonusPerLvl()
	local minDamageDefaultMult = traitValues.minDamageDefaultMult()
	local minDamageBonusPerLvl = traitValues.minDamageBonusPerLvl()
	local maxDamageDefaultMult = traitValues.maxDamageDefaultMult()
	local maxDamageBonusPerLvl = traitValues.maxDamageBonusPerLvl()
	local reloadSpeedDefaultMult = traitValues.reloadSpeedDefaultMult()
	local reloadSpeedBonusPerLvl = traitValues.reloadSpeedBonusPerLvl()
	local conditionLowerChanceMult = traitValues.conditionLowerChanceMult()

	-- Aiming bonuses
	local targetAimingPerkLevel = player:getPerkLevel(targetPerk)

	local critChanceMult = critChanceDefaultMult + (critChanceBonusPerLvl * targetAimingPerkLevel)
	local aimingTimeMult = aimingTimeDefaultMult + (aimingTimeBonusPerLvl * targetAimingPerkLevel)
	local maxRangeMult = maxRangeDefaultMult + (maxRangeBonusPerLvl * targetAimingPerkLevel)
	local minDamageMult = minDamageDefaultMult + (minDamageBonusPerLvl * targetAimingPerkLevel)
	local maxDamageMult = maxDamageDefaultMult + (maxDamageBonusPerLvl * targetAimingPerkLevel)

	-- Reloading bonuses
	local reloadSpeedMult = reloadSpeedDefaultMult
		+ (reloadSpeedBonusPerLvl * player:getPerkLevel(reloadSpeedTargetPerk))

	-- Update firearm stats
	---@class InventoryItemsStatsHandler.Marksman
	---@param item HandWeapon
	---@param itemdata table
	UsefulOccupations.InventoryItemsStatsHandler.Marksman = function(item, itemdata)
		local newHitChance = itemdata.hitChance > minHitChance and itemdata.hitChance or minHitChance
		local newCritChance = itemdata.criticalChance > minCritChance and itemdata.criticalChance or minCritChance

		item:setHitChance(newHitChance)
		item:setCriticalChance(newCritChance * critChanceMult)
		item:setAimingTime(itemdata.aimingTime / aimingTimeMult)
		item:setMaxRange(itemdata.maxRange * maxRangeMult)
		item:setMinAngle(0)
		item:setMaxAngle(0)
		item:setMinDamage(itemdata.minDamage * minDamageMult)
		item:setMaxDamage(itemdata.maxDamage * maxDamageMult)
		item:setConditionLowerChance(itemdata.conditionLowerChance * conditionLowerChanceMult)
	end

	-- Update reload speed
	UsefulOccupations.Functions.processEveryMs(30, function ()
		local defaultReloadSpeed = 0.8 + (0.1 * player:getPerkLevel(Perks.Reloading))
		player:setVariable("ReloadSpeed", defaultReloadSpeed * reloadSpeedMult)
	end)

	-- Calculating new multipliers
	---@param perk PerkFactory.Perk
	---@param perkLvl number
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			critChanceMult = critChanceDefaultMult + (critChanceBonusPerLvl * perkLvl)
			aimingTimeMult = aimingTimeDefaultMult + (aimingTimeBonusPerLvl * perkLvl)
			maxRangeMult = maxRangeDefaultMult + (maxRangeBonusPerLvl * perkLvl)
			minDamageMult = minDamageDefaultMult + (minDamageBonusPerLvl * perkLvl)
			maxDamageMult = maxDamageDefaultMult + (maxDamageBonusPerLvl * perkLvl)

			UOItemsStatsHandler:updateInventoryItemsStats()
		end

		if perk == reloadSpeedTargetPerk then
			reloadSpeedMult = reloadSpeedDefaultMult + (reloadSpeedBonusPerLvl * perkLvl)
		end
	end)
end
