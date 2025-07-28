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
	local runningEffect = traitValues.runningEffect
	local sprintingEffect = traitValues.sprintingEffect

	local getDistanceToForfeit = function()
		return defaultDistanceToForfeit - (decreaseDistanceByLvl * player:getPerkLevel(decreaseDistancePerk))
	end

	local distanceToForfeit = getDistanceToForfeit()
	local isDriving = false

	---@param zombie IsoZombie
	UsefulOccupations.Functions.addEvent(Events.OnZombieUpdate, function(zombie)
		if zombie:getTarget() ~= player or isDriving then
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
		local multiplier = defaultMultiplier

		if player:isSneaking() then
			if player:isRunning() then
				multiplier = defaultMultiplier
			else
				multiplier = multiplier + sneakingEffect
			end
		elseif player:isRunning() then
			multiplier = multiplier + runningEffect
		elseif player:isSprinting() then
			multiplier = multiplier + sprintingEffect
		end

		distanceToForfeit = getDistanceToForfeit() * multiplier
		isDriving = player:isDriving()
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
