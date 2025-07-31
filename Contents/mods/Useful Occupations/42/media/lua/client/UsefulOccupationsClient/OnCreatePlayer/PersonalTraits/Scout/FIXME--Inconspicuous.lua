--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local isZombie = false

---@class DoTraitsOnCreatePlayer.Inconspicuous
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Inconspicuous = function(player)
	local traitValues = UsefulOccupations.PersonalTraits.Inconspicuous.values

	local defaultDistanceToForfeit = traitValues.distanceToForfeit
	local decreaseDistanceByLvl = traitValues.decreaseDistanceByLvl
	local decreaseDistancePerk = traitValues.decreaseDistancePerk
	local stunDurationAfterForfeit = traitValues.stunDurationAfterForfeit
	local distanceToForfeitUpdateDelay = traitValues.distanceToForfeitUpdateDelay
	local defaultMultiplier = traitValues.defaultMultiplier
	local sneakingEffect = traitValues.sneakingEffect

	local getDistanceToForfeit = function()
		return defaultDistanceToForfeit - (decreaseDistanceByLvl * player:getPerkLevel(decreaseDistancePerk))
	end

	local distanceToForfeit = getDistanceToForfeit()
	local badConditions = false

	---@param zombie IsoZombie
	UsefulOccupations.Functions.addEvent(Events.OnZombieUpdate, function(zombie)
		if zombie:getTarget() ~= player or badConditions then
			return
		end

		local distance = player:DistTo(zombie)

		if isZombie or not zombie:CanSee(player) or distance >= distanceToForfeit then
			---@diagnostic disable-next-line: param-type-mismatch
			zombie:setTarget(nil)
			zombie:setUseless(true)

			UsefulOccupations.Functions.processAfterDelay(stunDurationAfterForfeit, function()
				zombie:setUseless(false)
			end)
		end
	end)

	-- Update distance to forfeit
	UsefulOccupations.Functions.processEveryMs(distanceToForfeitUpdateDelay, function()
		if player:isDriving() then
			badConditions = true
			return
		end

		local multiplier = defaultMultiplier

		if player:isSneaking() then
			-- Affect only sneak walk
			if not player:isRunning() then
				multiplier = multiplier + sneakingEffect
			end
		elseif player:isRunning() then
			badConditions = true
			return
		elseif player:isSprinting() then
			badConditions = true
			return
		end

		distanceToForfeit = getDistanceToForfeit() * multiplier
	end)
end

-- Events.OnKeyPressed.Add(function(key)
-- 	if key ~= 34 then -- G
-- 		return
-- 	end

-- 	local player = getPlayer()

-- 	if isZombie then
-- 		player:setVariable("scoutWalkType", "bob")
-- 	else
-- 		player:setVariable("scoutWalkType", "zombie")
-- 	end

-- 	isZombie = not isZombie

-- 	print(isZombie)
-- end)
