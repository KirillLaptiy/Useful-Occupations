--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.ScoutSkills
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.ScoutSkills = function(player)
	local traitValues = UsefulOccupations.PersonalTraits.ScoutSkills.values

	-- When moving, thirst and hunger accumulate more slowly.
	local msToCall = traitValues.msToCall()
	local maxWalkTime = traitValues.maxWalkTime()

	local hungerReduceMin = traitValues.hungerReduceMin() / 100
	local hungerReduceMax = traitValues.hungerReduceMax() / 100
	local hungerTimeToMax = traitValues.hungerTimeToMax()
	local thirstReduceMin = traitValues.thirstReduceMin() / 100
	local thirstReduceMax = traitValues.thirstReduceMax() / 100
	local thirstTimeToMax = traitValues.thirstTimeToMax()

	local modData = UsefulOccupations.Functions.getModData()

	local stats = player:getStats()

	local lastHunger = stats:get(CharacterStat.HUNGER)
	local lastThirst = stats:get(CharacterStat.THIRST)

	-- When moving, thirst and hunger accumulate more slowly.
	UsefulOccupations.Functions.processEveryMs(msToCall, function()
		if player:isWalking() and not player:IsRunning() and not player:isSprinting() then
			modData.walkTime = math.min(modData.walkTime + (msToCall / 1000), maxWalkTime)
		else
			modData.walkTime = math.max(modData.walkTime - (msToCall / 1000), 0)
		end

		if modData.walkTime > 0 then
			local hunger = stats:get(CharacterStat.HUNGER)
			local thirst = stats:get(CharacterStat.THIRST)

			local hungerDifference = math.abs(hunger - lastHunger)
			local thirstDifference = math.abs(thirst - lastThirst)

			-- Dynamic influence
			local hungerReducePercent = hungerReduceMin + (hungerReduceMax - hungerReduceMin) * (modData.walkTime / hungerTimeToMax)
			local thirstReducePercent = thirstReduceMin + (thirstReduceMax - thirstReduceMin) * (modData.walkTime / thirstTimeToMax)

			stats:set(CharacterStat.HUNGER, hunger - (hungerDifference * hungerReducePercent))
			stats:set(CharacterStat.THIRST, thirst - (thirstDifference * thirstReducePercent))

			-- Update last values
			lastHunger = stats:get(CharacterStat.HUNGER)
			lastThirst = stats:get(CharacterStat.THIRST)
		end
	end)
end
