--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- FIXME
-- при входе в игру персонаж должен сам включать режим зомби, если был включен до выхода из игры
-- пофиксить анимку при действиях (перелазание окна)

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

	-- State instances
	local swipeStatePlayer = SwipeStatePlayer.instance()
	local climbThroughWindowState = ClimbThroughWindowState.instance()
	local climbOverFenceState = ClimbOverFenceState.instance()

	-- Pretending state
	local targetingZombies = {}

	local isPretendingZombie = false
	local badPretendingConditions = false
	local badPretendingConditionsTimer = 0

	local isDriving = player:isDriving()

	-- Climbing condititions
	local climbStarted = false
	local isClimbRunning = false

	local getDistanceToForfeit = function()
		return defaultDistanceToForfeit - (decreaseDistanceByLvl * player:getPerkLevel(decreaseDistancePerk))
	end

	-- local distanceToForfeit = getDistanceToForfeit()
	-- local badConditions = false

	---@param zombie IsoZombie
	local forfeitPlayer = function(zombie)
		---@diagnostic disable-next-line: param-type-mismatch
		zombie:setTarget(nil)
		zombie:setUseless(true)

		UsefulOccupations.Functions.processAfterDelay(stunDurationAfterForfeit, function()
			zombie:setUseless(false)
		end)
	end

	---@param zombie IsoZombie
	local clearTargetingZombie = function(zombie)
		targetingZombies[zombie] = nil
	end

	-- Clears non-existent targeted zombies (like dead zombies)
	local clearNETargetedZombies = function()
		---@param zombie IsoZombie
		for zombie, _ in pairs(targetingZombies) do
			if zombie:isExistInTheWorld() == false or zombie:isAlive() == false then
				clearTargetingZombie(zombie)
			end
		end
	end

	---@return boolean
	local isTargetedByZombies = function()
		for _ in pairs(targetingZombies) do
			return true
		end

		return false
	end

	local updateBadPretendingConditions = function()
		-- Clears bad pretending conditions
		-- if badPretendingConditionsTimer == 1 then
		-- 	badPretendingConditionsTimer = 0
		-- 	badPretendingConditions = false
		-- end

		if badPretendingConditions == true then
			if isTargetedByZombies() == false then
				badPretendingConditions = false
			end
		end

		-- Bad conditions when:
		-- Running or sprinting
		-- Hitting
		-- Strafing
		-- Sneaking
		if
			(player:isWalking() and (player:isRunning() or player:isSprinting()))
			or player:isCurrentState(swipeStatePlayer)
			or player:isStrafing()
			or player:isSneaking()
		then
			badPretendingConditions = true
		end

		print(badPretendingConditions)
	end

	local updateClimbingConditions = function()
		local isClimbing = player:isCurrentState(climbThroughWindowState) or player:isCurrentState(climbOverFenceState)

		-- Climbing started
		if isClimbing == true and climbStarted == false then
			climbStarted = true
			isClimbRunning = (player:isWalking() and (player:isRunning() or player:isSprinting()))
		end

		-- Climbing ended
		if isClimbing == false and climbStarted == true then
			print("CLIMBED WINDOW!")
			climbStarted = false

			if isPretendingZombie == true and isClimbRunning == false then
				player:setBlockMovement(true)

				UsefulOccupations.Functions.processAfterDelay(500, function()
					player:setBlockMovement(false)
				end)
			end
		end
	end

	---@param zombie IsoZombie
	UsefulOccupations.Functions.addEvent(Events.OnZombieUpdate, function(zombie)
		if isDriving == true or zombie:getTarget() ~= player then
			clearTargetingZombie(zombie)
			return
		end

		targetingZombies[zombie] = true

		-- local distance = player:DistTo(zombie)

		-- Zombie instantly forfeit player if can't see
		if zombie:CanSee(player) == false then
			forfeitPlayer(zombie)
		end

		-- Zombie forfeits player that pretending zombie's walk
		if isPretendingZombie == true and badPretendingConditions == false then
			forfeitPlayer(zombie)
		end

		-- zombie:getSeeNearbyCharacterDistance() -- проверить
	end)

	-- Update distance to forfeit
	-- UsefulOccupations.Functions.processEveryMs(distanceToForfeitUpdateDelay, function()
	-- 	if player:isDriving() then
	-- 		badConditions = true
	-- 		return
	-- 	end

	-- 	local multiplier = defaultMultiplier

	-- 	if player:isSneaking() then
	-- 		-- Affect only sneak walk
	-- 		if not player:isRunning() then
	-- 			multiplier = multiplier + sneakingEffect
	-- 		end
	-- 	elseif player:isRunning() then
	-- 		badConditions = true
	-- 		return
	-- 	elseif player:isSprinting() then
	-- 		badConditions = true
	-- 		return
	-- 	end

	-- 	distanceToForfeit = getDistanceToForfeit() * multiplier
	-- end)

	-- Constantly updates player's conditions
	UsefulOccupations.Functions.processEveryMs(30, function()
		isDriving = player:isDriving()

		-- Clears non-existent targeted zombies
		clearNETargetedZombies()

		updateBadPretendingConditions()
	end)

	UsefulOccupations.Functions.addEvent(Events.OnTick, updateClimbingConditions)

	---@param key number
	UsefulOccupations.Functions.addEvent(Events.OnKeyPressed, function(key)
		-- When pressed "G" key and not climbing
		if key ~= 34 or climbStarted == true then
			return
		end

		if isPretendingZombie == true then
			player:setVariable("inconspicuousWalkType", "bob")
		else
			-- Can't activate zombie walk if zombies see the player
			if isTargetedByZombies() == true then
				player:SayShout("Aaaa! Zombi!!!")
				return
			end

			player:setVariable("inconspicuousWalkType", "zombie")
		end

		print(player:getVariableString("inconspicuousWalkType"))

		isPretendingZombie = not isPretendingZombie
	end)
end
