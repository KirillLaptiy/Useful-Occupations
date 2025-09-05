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
-- Пофиксить анимку оружия во время зомби-ходьбы

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
	local climbOverWallState = ClimbOverWallState.instance()

	-- Sandbox vars
	local zSight = SandboxVars.ZombieLore.Sight

	-- Zombie's vision distance by zSight
	local zSightValues = {
		zSight_1 = 20,
		zSight_2 = 19.2,
		zSight_3 = 10,
	}

	-- Mod data
	local modData = UsefulOccupations.Functions.getModData()

	-- Movement Handler
	local movementHandler = UOPlayerMovementHandler:getInstance()

	-- Pretending conditions
	local zombiesSights = {}

	local zombiesTime = {}

	local canPretendZombie = true
	local isPretendingZombie = false
	local badPretendingConditions = false

	local isDriving = player:isDriving()

	-- Climbing condititions
	local climbStarted = false
	local isClimbRunning = false

	-- Forfeit by distance conditions
	-- 0.1 - Sneak walk
	-- 0.07 - Sneak run / Default walk / Strafing
	-- 0.04 - Run
	-- 0.02 - Sprint
	local playerActivityBonus = 0

	---@param zombie IsoZombie
	local forfeitPlayer = function(zombie)
		zombiesTime[zombie] = nil

		---@diagnostic disable-next-line: param-type-mismatch
		zombie:setTarget(nil)
		zombie:setUseless(true)

		UsefulOccupations.Functions.processAfterDelay(stunDurationAfterForfeit, function()
			zombie:setUseless(false)
		end)
	end

	-- Clears non-existent targeted zombies (like dead zombies)
	local clearNETargetedZombies = function()
		---@param zombie IsoZombie
		for zombie, _ in pairs(zombiesSights) do
			if zombie:isExistInTheWorld() == false or zombie:isAlive() == false then
				zombiesSights[zombie] = nil
				zombiesTime[zombie] = nil
			end
		end
	end

	---@param zombie IsoZombie
	local doZombieSight = function(zombie)
		local sight = zSight

		if sight == 4 then
			sight = ZombRand(3) + 1
		elseif sight == 5 then
			sight = ZombRand(2) + 2
		end

		zombiesSights[zombie] = sight
	end

	---@return boolean
	local isTargetedByZombies = function()
		for _, time in pairs(zombiesTime) do
			if time == 5 then
				return true
			end
		end

		return false
	end

	local updateBadPretendingConditions = function()
		-- Clears bad pretending conditions
		if isTargetedByZombies() == false then
			badPretendingConditions = false
		end

		-- Bad conditions when:
		-- Running or sprinting
		-- Hitting
		-- Strafing
		-- Sneaking
		-- Climbing wall
		if
			(player:isWalking() and (player:isRunning() or player:isSprinting()))
			or player:isCurrentState(swipeStatePlayer)
			or player:isStrafing()
			or player:isSneaking()
			or player:isCurrentState(climbOverWallState)
			or player:isSitOnGround()
			or player:isSittingOnFurniture()
			or player:isAsleep()
		then
			badPretendingConditions = true
		end
	end

	local updateClimbingConditions = function()
		local isClimbing = player:isCurrentState(climbThroughWindowState) or player:isCurrentState(climbOverFenceState)

		-- Climbing started
		if isClimbing == true and climbStarted == false then
			climbStarted = true

			isClimbRunning = (player:isWalking() and (player:isRunning() or player:isSprinting()))

			canPretendZombie = false
		end

		-- Climbing ended
		if isClimbing == false and climbStarted == true then
			climbStarted = false

			canPretendZombie = true

			if isPretendingZombie == true and isClimbRunning == false then
				player:setBlockMovement(true)

				UsefulOccupations.Functions.processAfterDelay(500, function()
					player:setBlockMovement(false)
				end)
			end
		end
	end

	local togglePretendingZombie = function()
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

		isPretendingZombie = not isPretendingZombie

		modData.isPretendingZombie = isPretendingZombie

		movementHandler.setIsPretendingZombie(isPretendingZombie)
	end

	---@param zombie IsoZombie
	local checkForfeitDistance = function(zombie)
		if zombiesSights[zombie] == nil then
			doZombieSight(zombie)
		end

		local zVisionDistance = zSightValues["zSight_" .. zombiesSights[zombie]]

		local forfeitDistance = zVisionDistance
			- (zVisionDistance * ((zombiesSights[zombie] * 0.1) + playerActivityBonus))

		local distance = player:DistTo(zombie)

		-- Zombies notice the player from a shorter distance.
		if distance > forfeitDistance and zombiesTime[zombie] < 5 then
			forfeitPlayer(zombie)
			return
		end
	end

	-- Enable pretending zombie on join
	if modData.isPretendingZombie == true then
		togglePretendingZombie()
	end

	---@param zombie IsoZombie
	UsefulOccupations.Functions.addEvent(Events.OnZombieUpdate, function(zombie)
		if isDriving == true or zombie:getTarget() ~= player then
			zombiesTime[zombie] = nil
			return
		end

		zombiesTime[zombie] = math.min(5, (zombiesTime[zombie] or 0) + 1)

		-- Zombie instantly forfeit player if can't see
		if zombie:CanSee(player) == false then
			forfeitPlayer(zombie)
			return
		end

		-- Zombie forfeits player that pretending zombie's walk
		if isPretendingZombie == true and badPretendingConditions == false then
			forfeitPlayer(zombie)
			return
		end

		-- Zombies notice the player from a shorter distance
		checkForfeitDistance(zombie)
	end)

	-- Constantly updates player's conditions
	UsefulOccupations.Functions.processEveryMs(30, function()
		isDriving = player:isDriving()

		if player:isRunning() and player:isSneaking() == false then
			playerActivityBonus = 0.04
		elseif player:isSprinting() then
			playerActivityBonus = 0.02
		elseif player:isSneaking() and player:isRunning() == false then
			playerActivityBonus = 0.1
		else
			playerActivityBonus = 0.07
		end

		-- Clears non-existent targeted zombies
		clearNETargetedZombies()

		updateBadPretendingConditions()
	end)

	UsefulOccupations.Functions.addEvent(Events.OnTick, updateClimbingConditions)

	-- Toggle pretending zombie when pressed "G" key and not climbing
	---@param key number
	UsefulOccupations.Functions.addEvent(Events.OnKeyPressed, function(key)
		if key == 34 and canPretendZombie == true then
			togglePretendingZombie()
		end
	end)
end
