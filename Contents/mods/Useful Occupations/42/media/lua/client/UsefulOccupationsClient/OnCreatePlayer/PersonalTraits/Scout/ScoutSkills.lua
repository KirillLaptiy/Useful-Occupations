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
	local msToCall = traitValues.msToCall
	local maxWalkTime = traitValues.maxWalkTime
	local thirstReducePerMinute = traitValues.thirstReducePerMinute
	local hungerReducePerMinute = traitValues.hungerReducePerMinute
	local minFactor = traitValues.minFactor
	local maxFactor = traitValues.maxFactor

	local modData = UsefulOccupations.Functions.getModData()

	-- When moving, thirst and hunger accumulate more slowly.
	UsefulOccupations.Functions.processEveryMs(msToCall, function()
		if player:isWalking() and not player:IsRunning() and not player:isSprinting() then
			modData.walkTime = math.min(modData.walkTime + (msToCall / 1000), maxWalkTime)
		else
			modData.walkTime = math.max(modData.walkTime - (msToCall / 1000), 0)
		end

		if modData.walkTime > 0 then
			local stats = player:getStats()

			-- Dynamic influence - more value - more influence
			local hungerFactor = minFactor + (maxFactor - minFactor) * (modData.walkTime / maxWalkTime)

			stats:setThirst(stats:getThirst() - (thirstReducePerMinute * hungerFactor))
			stats:setHunger(stats:getHunger() - (hungerReducePerMinute * hungerFactor))
		end
	end)
end
