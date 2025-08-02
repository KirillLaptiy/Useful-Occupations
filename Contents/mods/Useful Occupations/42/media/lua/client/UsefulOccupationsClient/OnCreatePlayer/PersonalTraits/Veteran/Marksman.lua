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

	local targetPerk = traitValues.targetPerk
	local reloadSpeedTargetPerk = traitValues.reloadSpeedTargetPerk

	local minHitChance = traitValues.minHitChance
	local minCritChance = traitValues.minCritChance
	local critChanceDefaultMult = traitValues.critChanceDefaultMult
	local critChanceBonusPerLvl = traitValues.critChanceBonusPerLvl
	local critDmgDefaultMult = traitValues.critDmgDefaultMult
	local critDmgBonusPerLvl = traitValues.critDmgBonusPerLvl
	local aimingTimeDefaultMult = traitValues.aimingTimeDefaultMult
	local aimingTimeBonusPerLvl = traitValues.aimingTimeBonusPerLvl
	local maxRangeDefaultMult = traitValues.maxRangeDefaultMult
	local maxRangeBonusPerLvl = traitValues.maxRangeBonusPerLvl
	local minDamageDefaultMult = traitValues.minDamageDefaultMult
	local minDamageBonusPerLvl = traitValues.minDamageBonusPerLvl
	local maxDamageDefaultMult = traitValues.maxDamageDefaultMult
	local maxDamageBonusPerLvl = traitValues.maxDamageBonusPerLvl
	local reloadSpeedDefaultMult = traitValues.reloadSpeedDefaultMult
	local reloadSpeedBonusPerLvl = traitValues.reloadSpeedBonusPerLvl

	-- Aiming bonuses
	local targetAimingPerkLevel = player:getPerkLevel(targetPerk)

	local critChanceMult = critChanceDefaultMult + (critChanceBonusPerLvl * targetAimingPerkLevel)
	local critDmgMult = critDmgDefaultMult + (critDmgBonusPerLvl * targetAimingPerkLevel)
	local aimingTimeMult = aimingTimeDefaultMult + (aimingTimeBonusPerLvl * targetAimingPerkLevel)
	local maxRangeMult = maxRangeDefaultMult + (maxRangeBonusPerLvl * targetAimingPerkLevel)
	local minDamageMult = minDamageDefaultMult + (minDamageBonusPerLvl * targetAimingPerkLevel)
	local maxDamageMult = maxDamageDefaultMult + (maxDamageBonusPerLvl * targetAimingPerkLevel)

	-- Reloading bonuses
	local reloadSpeedMult = reloadSpeedDefaultMult
		+ (reloadSpeedBonusPerLvl * player:getPerkLevel(reloadSpeedTargetPerk))

	local doAimingBuffs = function()
		local inventory = player:getInventory()

		UsefulOccupations.Functions.processAfterDelay(1, function()
			for i = 0, inventory:getItems():size() - 1 do
				---@type HandWeapon
				local item = inventory:getItems():get(i)

				if item:IsWeapon() and item:isAimedFirearm() then
					local itemdata = item:getModData()

					if itemdata.hitChance == nil then
						itemdata.hitChance = item:getHitChance()
					end

					if itemdata.criticalChance == nil then
						itemdata.criticalChance = item:getCriticalChance()
					end

					if itemdata.critDmgMultiplier == nil then
						itemdata.critDmgMultiplier = item:getCritDmgMultiplier()
					end

					if itemdata.aimingTime == nil then
						itemdata.aimingTime = item:getAimingTime()
					end

					if itemdata.maxRange == nil then
						itemdata.maxRange = item:getMaxRange()
					end

					if itemdata.minAngle == nil then
						itemdata.minAngle = item:getMinAngle()
					end

					if itemdata.maxAngle == nil then
						itemdata.maxAngle = item:getMaxAngle()
					end

					if itemdata.minDamage == nil then
						itemdata.minDamage = item:getMinDamage()
					end

					if itemdata.maxDamage == nil then
						itemdata.maxDamage = item:getMaxDamage()
					end

					if itemdata.conditionLowerChance == nil then
						itemdata.conditionLowerChance = item:getConditionLowerChance()
					end

					if item:isEquipped() then
						local newHitChance = itemdata.hitChance > minHitChance and itemdata.hitChance or minHitChance
						local newCritChance = itemdata.criticalChance > minCritChance and itemdata.criticalChance
							or minCritChance

						item:setHitChance(newHitChance)
						item:setCriticalChance(newCritChance * critChanceMult)
						item:setCritDmgMultiplier(itemdata.critDmgMultiplier * critDmgMult)
						item:setAimingTime(itemdata.aimingTime / aimingTimeMult)
						item:setMaxRange(itemdata.maxRange * maxRangeMult)
						item:setMinAngle(0)
						item:setMaxAngle(0)
						item:setMinDamage(itemdata.minDamage * minDamageMult)
						item:setMaxDamage(itemdata.maxDamage * maxDamageMult)

						item:setConditionLowerChance(itemdata.conditionLowerChance * 2)
					else
						item:setHitChance(itemdata.hitChance)
						item:setCriticalChance(itemdata.criticalChance)
						item:setCritDmgMultiplier(itemdata.critDmgMultiplier)
						item:setAimingTime(itemdata.aimingTime)
						item:setMaxRange(itemdata.maxRange)
						item:setMinAngle(itemdata.minAngle)
						item:setMaxAngle(itemdata.maxAngle)
						item:setMinDamage(itemdata.minDamage)
						item:setMaxDamage(itemdata.maxDamage)
						item:setConditionLowerChance(itemdata.conditionLowerChance)
					end
				end
			end
		end)
	end

	-- Update reload speed
	local updateReloadSpeed = function()
		local defaultReloadSpeed = 0.8 + (0.1 * player:getPerkLevel(Perks.Reloading))
		player:setVariable("UOReloadSpeed", defaultReloadSpeed * reloadSpeedMult)
	end

	doAimingBuffs()
	updateReloadSpeed()

	UsefulOccupations.Functions.addEvent(Events.OnEquipPrimary, doAimingBuffs)

	-- Calculating new multipliers
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			critChanceMult = critChanceDefaultMult + (critChanceBonusPerLvl * perkLvl)
			critDmgMult = critDmgDefaultMult + (critDmgBonusPerLvl * perkLvl)
			aimingTimeMult = aimingTimeDefaultMult + (aimingTimeBonusPerLvl * perkLvl)
			maxRangeMult = maxRangeDefaultMult + (maxRangeBonusPerLvl * perkLvl)
			minDamageMult = minDamageDefaultMult + (minDamageBonusPerLvl * perkLvl)
			maxDamageMult = maxDamageDefaultMult + (maxDamageBonusPerLvl * perkLvl)

			doAimingBuffs()
		end

		if perk == reloadSpeedTargetPerk then
			reloadSpeedMult = reloadSpeedDefaultMult + (reloadSpeedBonusPerLvl * perkLvl)
			updateReloadSpeed()
		end
	end)
end
