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

	-- Ranger walk speed increased
	local walkSpeedIncreaseMultiplier = traitValues.walkSpeedIncreaseMultiplier
	local defaultWalkBlendTime = UsefulOccupations.MovementSpeedValues.defaultWalk.BlendTime
	local defaultWalkSpeedScale = UsefulOccupations.MovementSpeedValues.defaultWalk.SpeedScale
	local lightFootInfluencePerLvl = traitValues.lightFootInfluencePerLvl

	-- When moving, thirst and hunger accumulate more slowly.
	local msToCall = traitValues.msToCall
	local maxWalkTime = traitValues.maxWalkTime
	local thirstReducePerMinute = traitValues.thirstReducePerMinute
	local hungerReducePerMinute = traitValues.hungerReducePerMinute
	local minFactor = traitValues.minFactor
	local maxFactor = traitValues.maxFactor

	local modData = UsefulOccupations.Functions.getModData()

	-- Ranger walk speed increased
	--- @param value number
	local function updateWalkSpeed(value)
		local multiplier = value + walkSpeedIncreaseMultiplier

		player:setVariable("defaultWalkBT", defaultWalkBlendTime / multiplier)
		player:setVariable("defaultWalkSS", defaultWalkSpeedScale * multiplier)
	end

	-- Set light foot influence when create player
	local startValue = player:getPerkLevel(Perks.Lightfoot) * lightFootInfluencePerLvl
	updateWalkSpeed(startValue)

	-- Set light foot influence on new light foot level
	--- @param perk Perk
	--- @param perkLvl integer
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == Perks.Lightfoot then
			local value = perkLvl * lightFootInfluencePerLvl
			updateWalkSpeed(value)
		end
	end)

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
