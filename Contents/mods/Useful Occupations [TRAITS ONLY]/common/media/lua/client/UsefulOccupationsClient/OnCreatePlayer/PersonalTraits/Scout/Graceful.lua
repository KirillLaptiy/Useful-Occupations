--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Graceful
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Graceful = function(player)
	-- Graceful values
	local traitValues = UsefulOccupations.PersonalTraits.Graceful.values

	---@class MovementValue
	local defaultWalk = {
		startBonusPercent = traitValues.defaultWalk.startBonusPercent(),
		percentPerLvl = traitValues.defaultWalk.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	local sneakWalk = {
		startBonusPercent = traitValues.sneakWalk.startBonusPercent(),
		percentPerLvl = traitValues.sneakWalk.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	local sneakRun = {
		startBonusPercent = traitValues.sneakRun.startBonusPercent(),
		percentPerLvl = traitValues.sneakRun.percentPerLvl(),
		targetPerk = Perks.Sprinting,
	}

	local defaultRun = {
		startBonusPercent = traitValues.defaultRun.startBonusPercent(),
		percentPerLvl = traitValues.defaultRun.percentPerLvl(),
		targetPerk = Perks.Sprinting,
	}

	local defaultSprint = {
		startBonusPercent = traitValues.defaultSprint.startBonusPercent(),
		percentPerLvl = traitValues.defaultSprint.percentPerLvl(),
		targetPerk = Perks.Sprinting,
	}

	local climbWall = {
		startBonusPercent = traitValues.climbWall.startBonusPercent(),
		percentPerLvl = traitValues.climbWall.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	local climbWindow = {
		startBonusPercent = traitValues.climbWindow.startBonusPercent(),
		percentPerLvl = traitValues.climbWindow.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	local climbFence_Walk = {
		startBonusPercent = traitValues.climbFence_Walk.startBonusPercent(),
		percentPerLvl = traitValues.climbFence_Walk.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	local climbFence_Run = {
		startBonusPercent = traitValues.climbFence_Run.startBonusPercent(),
		percentPerLvl = traitValues.climbFence_Run.percentPerLvl(),
		targetPerk = Perks.Sprinting,
	}

	local climbFence_Sprint = {
		startBonusPercent = traitValues.climbFence_Sprint.startBonusPercent(),
		percentPerLvl = traitValues.climbFence_Sprint.percentPerLvl(),
		targetPerk = Perks.Sprinting,
	}

	local turn = {
		startBonusPercent = traitValues.turn.startBonusPercent(),
		percentPerLvl = traitValues.turn.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	local turn180 = {
		startBonusPercent = traitValues.turn180.startBonusPercent(),
		percentPerLvl = traitValues.turn180.percentPerLvl(),
		targetPerk = Perks.Lightfoot,
	}

	-- Clothing weight reduce percent
	local clothingWeightReducePercent = traitValues.clothingWeightReducePercent() / 100

	local movementHandler = UOPlayerMovementHandler:getInstance()
	local speedTypes = movementHandler.getSpeedTypes()

	local turnMultiplier = 1

	-- Update every 30 ms
	local constantUpdating = function()
		-- Update walk turn speed
		if player:isAiming() then
			movementHandler.setSpeedMult(speedTypes.turn, 1, false, false)
		else
			movementHandler.setSpeedMult(speedTypes.turn, turnMultiplier, false, false)
		end
	end

	---@param value MovementValue
	local calculateNewMultipler = function(value)
		local targetPerkLvl = player:getPerkLevel(value.targetPerk)

		local newMultiplier = 1 + (value.startBonusPercent / 100) + (targetPerkLvl * (value.percentPerLvl / 100))

		return newMultiplier
	end

	-- Updating speed scale multipliers
	---@param perk PerkFactory.Perk | nil
	local updateSSMultipliers = function(perk)
		-- Update all multiplier on game start
		local needUpdateAll = perk == nil

		-- Update sneak walk speed
		if needUpdateAll or perk == sneakWalk.targetPerk then
			local sneakWalkMultiplier = calculateNewMultipler(sneakWalk)
			movementHandler.setSpeedMult(speedTypes.walkSneak, sneakWalkMultiplier, true, false)
		end

		-- Update walk speed
		if needUpdateAll or perk == defaultWalk.targetPerk then
			local defaultWalkMultiplier = calculateNewMultipler(defaultWalk)
			movementHandler.setSpeedMult(speedTypes.walk, defaultWalkMultiplier, true, false)
		end

		-- Update sneak run speed
		if needUpdateAll or perk == sneakRun.targetPerk then
			local sneakRunMultiplier = calculateNewMultipler(sneakRun)
			movementHandler.setSpeedMult(speedTypes.runSneak, sneakRunMultiplier, true, false)
		end

		-- Update default run speed
		if needUpdateAll or perk == defaultRun.targetPerk then
			local defaultRunMultiplier = calculateNewMultipler(defaultRun)
			movementHandler.setSpeedMult(speedTypes.run, defaultRunMultiplier, true, false)
		end

		-- Update default sprint speed
		if needUpdateAll or perk == defaultSprint.targetPerk then
			local defaultSprintMultiplier = calculateNewMultipler(defaultSprint)
			movementHandler.setSpeedMult(speedTypes.sprint, defaultSprintMultiplier, true, false)
		end

		-- Update climb wall speed
		if needUpdateAll or perk == climbWall.targetPerk then
			local climbWallMultiplier = calculateNewMultipler(climbWall)
			movementHandler.setSpeedMult(speedTypes.climbWall, climbWallMultiplier, true, false)
		end

		-- Update climb window speed
		if needUpdateAll or perk == climbWindow.targetPerk then
			local climbWindowMultiplier = calculateNewMultipler(climbWindow)
			movementHandler.setSpeedMult(speedTypes.climbWindow, climbWindowMultiplier, true, false)
		end

		-- Update walk climb fence speed
		if needUpdateAll or perk == climbFence_Walk.targetPerk then
			local climbFence_WalkMultiplier = calculateNewMultipler(climbFence_Walk)
			movementHandler.setSpeedMult(speedTypes.climbFenceWalk, climbFence_WalkMultiplier, true, false)
		end

		-- Update run climb fence speed
		if needUpdateAll or perk == climbFence_Run.targetPerk then
			local climbFence_RunMultiplier = calculateNewMultipler(climbFence_Run)
			movementHandler.setSpeedMult(speedTypes.climbFenceRun, climbFence_RunMultiplier, true, false)
		end

		-- Update sprint climb fence speed
		if needUpdateAll or perk == climbFence_Sprint.targetPerk then
			local climbFence_SprintMultiplier = calculateNewMultipler(climbFence_Sprint)
			movementHandler.setSpeedMult(speedTypes.climbFenceSprint, climbFence_SprintMultiplier, true, false)
		end

		-- Update turn speed
		if needUpdateAll or perk == turn.targetPerk then
			turnMultiplier = calculateNewMultipler(turn)
		end

		-- Update turn180 speed
		if needUpdateAll or perk == turn180.targetPerk then
			local turn180Multiplier = calculateNewMultipler(turn180)
			movementHandler.setSpeedMult(speedTypes.turn180, turn180Multiplier, true, false)
		end

		-- The character always climbs over the fence
		movementHandler.setClimbWallChance(100, 0, true)
	end

	-- Updating clothing stats
	---@param item Clothing
	---@param itemdata table
	local buffClothingStats = function(item, itemdata)
		item:setRunSpeedModifier(math.max(1, item:getRunSpeedModifier()))
		item:setCombatSpeedModifier(math.max(1, item:getCombatSpeedModifier()))
		item:setActualWeight(itemdata.actualWeight - (itemdata.actualWeight * clothingWeightReducePercent))
	end

	-- Updating container stats
	---@param item InventoryContainer
	---@param itemdata table
	local buffBackpackStats = function(item, itemdata)
		item:setActualWeight(itemdata.actualWeight - (itemdata.actualWeight * clothingWeightReducePercent))
	end

	---@class InventoryItemsStatsHandler.Graceful
	---@param item Clothing | InventoryContainer
	---@param itemdata table
	UsefulOccupations.InventoryItemsStatsHandler.Graceful = function(item, itemdata)
		if item:IsClothing() then
			---@diagnostic disable-next-line: param-type-mismatch
			buffClothingStats(item, itemdata)
		else
			---@diagnostic disable-next-line: param-type-mismatch
			buffBackpackStats(item, itemdata)
		end
	end

	updateSSMultipliers()
	constantUpdating()

	player:setVariable("hasGraceful", true)

	UsefulOccupations.Functions.processEveryMs(30, constantUpdating)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, _, _)
		updateSSMultipliers(perk)
	end)
end
