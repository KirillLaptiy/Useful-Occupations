--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

UsefulOccupations.DoTraitsOnStart.ScoutSkills = function()
	local values = UsefulOccupations.PersonalTraits.ScoutSkills.values

	-- Ranger walk speed increased
	local walkSpeedIncreaseMultiplier = values.walkSpeedIncreaseMultiplier
	local defaultWalkBlendTime = UsefulOccupations.MovementSpeedValues.defaultWalk.BlendTime
	local defaultWalkSpeedScale = UsefulOccupations.MovementSpeedValues.defaultWalk.SpeedScale
	local lightFootInfluencePerLvl = values.lightFootInfluencePerLvl

	-- When moving, thirst and hunger accumulate more slowly.
	local msToCall = values.msToCall
	local maxWalkTime = values.maxWalkTime
	local thirstReducePerMinute = values.thirstReducePerMinute
	local hungerReducePerMinute = values.hungerReducePerMinute
	local minFactor = values.minFactor
	local maxFactor = values.maxFactor

	local player = getPlayer()

	local modData = UsefulOccupations.Functions.getModData()

	local walkTime = 0

	-- Ranger walk speed increased
	--- @param value number
	local function updateWalkSpeed(value)
		local newWalkSpeed = value + walkSpeedIncreaseMultiplier

		player:setVariable("defaultWalkBlendTime", defaultWalkBlendTime / newWalkSpeed)
		player:setVariable("defaultWalkSpeedScale", defaultWalkSpeedScale * newWalkSpeed)
	end

	-- Set light foot influence when create player
	for i = 0, Perks.getMaxIndex() - 1 do
		local perk = Perks.fromIndex(i)

		if perk == Perks.Lightfoot then
			local value = player:getPerkLevel(perk) * lightFootInfluencePerLvl

			updateWalkSpeed(value)

			break
		end
	end

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
		if player:isWalking() and not player:IsRunning() and not player:isSprinting() and not player:isSneaking() then
			walkTime = math.min(walkTime + (msToCall / 1000), maxWalkTime)
			modData.walkTime = modData.walkTime + 1
		else
			walkTime = math.max(walkTime - (msToCall / 1000), 0)
			modData.walkTime = modData.walkTime - 1
		end

		if walkTime > 0 then
			local stats = player:getStats()

			local hungerFactor = minFactor + (maxFactor - minFactor) * (walkTime / maxWalkTime)

			stats:setThirst(stats:getThirst() - (thirstReducePerMinute * hungerFactor))
			stats:setHunger(stats:getHunger() - (hungerReducePerMinute * hungerFactor))
		end
	end)
end
