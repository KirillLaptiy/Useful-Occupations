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
	-- Movement speed values
	-- Sneak walk
	local sneakWalkSS = UsefulOccupations.MovementSpeedValues.type_sneakLimpSpeedScale
	local sneakWalkBT = UsefulOccupations.MovementSpeedValues.type_050
	local sneakWalkLowBT = UsefulOccupations.MovementSpeedValues.type_070

	-- Sneak run
	local sneakRunBT = UsefulOccupations.MovementSpeedValues.type_050
	local sneakRunSS = UsefulOccupations.MovementSpeedValues.type_092
	local sneakRunLowBT = UsefulOccupations.MovementSpeedValues.type_050
	local sneakRunLowSS = UsefulOccupations.MovementSpeedValues.type_104

	-- Default walk
	local defaultWalkBT = UsefulOccupations.MovementSpeedValues.type_020
	local defaultWalkSS = UsefulOccupations.MovementSpeedValues.type_104

	-- Default run
	local defaultRunBT = UsefulOccupations.MovementSpeedValues.type_035
	local defaultRunSS = UsefulOccupations.MovementSpeedValues.type_104

	-- Default sprint
	local defaultSprintBT = UsefulOccupations.MovementSpeedValues.type_015
	local defaultSprintSS = UsefulOccupations.MovementSpeedValues.type_096

	-- Climb wall
	local climbWallBT = UsefulOccupations.MovementSpeedValues.type_020
	local climbWallSS = UsefulOccupations.MovementSpeedValues.type_120

	-- Climb window
	local climbWindow_StartBOT = UsefulOccupations.MovementSpeedValues.type_020
	local climbWindow_EndBT = UsefulOccupations.MovementSpeedValues.type_040
	local climbWindow_ObstacleBT = UsefulOccupations.MovementSpeedValues.type_020
	local climbWindow_StartSS = UsefulOccupations.MovementSpeedValues.type_096
	local climbWindow_EndSS = UsefulOccupations.MovementSpeedValues.type_096
	local climbWindow_ObstacleSS = UsefulOccupations.MovementSpeedValues.type_080

	-- Climb fence
	local climbFence_WalkBT = UsefulOccupations.MovementSpeedValues.type_005
	local climbFence_WalkSS = UsefulOccupations.MovementSpeedValues.type_104
	local climbFence_RunBT = UsefulOccupations.MovementSpeedValues.type_005
	local climbFence_RunBOT = UsefulOccupations.MovementSpeedValues.type_035
	local climbFence_RunSS = UsefulOccupations.MovementSpeedValues.type_080
	local climbFence_SprintBT = UsefulOccupations.MovementSpeedValues.type_010
	local climbFence_SprintSS = UsefulOccupations.MovementSpeedValues.type_080

	-- Turn 180
	-- Blend time
	local turn_type_010BT = UsefulOccupations.MovementSpeedValues.type_010
	local turn_type_030BT = UsefulOccupations.MovementSpeedValues.type_030

	-- Blend out time
	local turn_type_020BOT = UsefulOccupations.MovementSpeedValues.type_020
	local turn_type_030BOT = UsefulOccupations.MovementSpeedValues.type_030

	-- Speed scale
	local turn_type_080SS = UsefulOccupations.MovementSpeedValues.type_080
	local turn_type_104SS = UsefulOccupations.MovementSpeedValues.type_104

	-- Graceful values
	local traitValues = UsefulOccupations.PersonalTraits.Graceful.values

	---@class MovementValue
	local defaultWalk = {
		startBonusPercent = traitValues.defaultWalk.startBonusPercent,
		percentPerLvl = traitValues.defaultWalk.percentPerLvl,
		targetPerk = traitValues.defaultWalk.targetPerk,
	}

	local sneakWalk = {
		startBonusPercent = traitValues.sneakWalk.startBonusPercent,
		percentPerLvl = traitValues.sneakWalk.percentPerLvl,
		targetPerk = traitValues.sneakWalk.targetPerk,
	}

	local sneakRun = {
		startBonusPercent = traitValues.sneakRun.startBonusPercent,
		percentPerLvl = traitValues.sneakRun.percentPerLvl,
		targetPerk = traitValues.sneakRun.targetPerk,
	}

	local defaultRun = {
		startBonusPercent = traitValues.defaultRun.startBonusPercent,
		percentPerLvl = traitValues.defaultRun.percentPerLvl,
		targetPerk = traitValues.defaultRun.targetPerk,
	}

	local defaultSprint = {
		startBonusPercent = traitValues.defaultSprint.startBonusPercent,
		percentPerLvl = traitValues.defaultSprint.percentPerLvl,
		targetPerk = traitValues.defaultSprint.targetPerk,
	}

	local climbWall = {
		startBonusPercent = traitValues.climbWall.startBonusPercent,
		percentPerLvl = traitValues.climbWall.percentPerLvl,
		targetPerk = traitValues.climbWall.targetPerk,
	}

	local climbWindow = {
		startBonusPercent = traitValues.climbWindow.startBonusPercent,
		percentPerLvl = traitValues.climbWindow.percentPerLvl,
		targetPerk = traitValues.climbWindow.targetPerk,
	}

	local climbFence_Walk = {
		startBonusPercent = traitValues.climbFence_Walk.startBonusPercent,
		percentPerLvl = traitValues.climbFence_Walk.percentPerLvl,
		targetPerk = traitValues.climbFence_Walk.targetPerk,
	}

	local climbFence_Run = {
		startBonusPercent = traitValues.climbFence_Run.startBonusPercent,
		percentPerLvl = traitValues.climbFence_Run.percentPerLvl,
		targetPerk = traitValues.climbFence_Run.targetPerk,
	}

	local climbFence_Sprint = {
		startBonusPercent = traitValues.climbFence_Sprint.startBonusPercent,
		percentPerLvl = traitValues.climbFence_Sprint.percentPerLvl,
		targetPerk = traitValues.climbFence_Sprint.targetPerk,
	}

	local turn = {
		startBonusPercent = traitValues.turn.startBonusPercent,
		percentPerLvl = traitValues.turn.percentPerLvl,
		targetPerk = traitValues.turn.targetPerk,
	}

	local turn180 = {
		startBonusPercent = traitValues.turn180.startBonusPercent,
		percentPerLvl = traitValues.turn180.percentPerLvl,
		targetPerk = traitValues.turn180.targetPerk,
	}

	-- Clothing multiplier
	local clothingWeightMultiplier = traitValues.clothingWeightMultiplier

	local sneakWalkMultiplier = 1
	local turnMultiplier = 1

	-- Update every 30 ms
	local constantUpdating = function()
		-- Updating sneak walk speed, including scale by "sneakLimpSpeedScale"
		local sneakLimpSpeedScale = player:getVariableString(sneakWalkSS)

		player:setVariable("sneakWalkSS", sneakLimpSpeedScale * sneakWalkMultiplier)
		player:setVariable("sneakWalkBT", sneakWalkBT / sneakWalkMultiplier)
		player:setVariable("sneakWalkLowSS", sneakLimpSpeedScale * sneakWalkMultiplier)
		player:setVariable("sneakWalkLowBT", sneakWalkLowBT / sneakWalkMultiplier)

		-- The character always climbs over the fence
		player:setVariable("ClimbFenceOutcome", "success")
		player:setVariable("ClimbFenceStruggle", false)

		-- Update walk turn speed
		if player:isAiming() then
			player:setTurnDelta(1)
		else
			player:setTurnDelta(turnMultiplier)
		end
	end

	-- Updating speed scale multipliers
	---@param perk Perk | nil
	local updateSSMultipliers = function(perk)
		---@param value MovementValue
		local calculateNewMultipler = function(value)
			local targetPerkLvl = player:getPerkLevel(value.targetPerk)
			local newMultiplier = 1 + (value.startBonusPercent / 100) + (targetPerkLvl * (value.percentPerLvl / 100))

			return newMultiplier
		end

		local needUpdateAll = not perk

		-- Update sneak walk speed
		if needUpdateAll or perk == sneakWalk.targetPerk then
			sneakWalkMultiplier = calculateNewMultipler(sneakWalk)
		end

		-- Update walk speed
		if needUpdateAll or perk == defaultWalk.targetPerk then
			local defaultWalkMultiplier = calculateNewMultipler(defaultWalk)
			player:setVariable("defaultWalkBT", defaultWalkBT / defaultWalkMultiplier)
			player:setVariable("defaultWalkSS", defaultWalkSS * defaultWalkMultiplier)
		end

		-- Update sneak run speed
		if needUpdateAll or perk == sneakRun.targetPerk then
			local sneakRunMultiplier = calculateNewMultipler(sneakRun)
			player:setVariable("sneakRunBT", sneakRunBT / sneakRunMultiplier)
			player:setVariable("sneakRunSS", sneakRunSS * sneakRunMultiplier)
			player:setVariable("sneakRunLowBT", sneakRunLowBT / sneakRunMultiplier)
			player:setVariable("sneakRunLowSS", sneakRunLowSS * sneakRunMultiplier)
		end

		-- Update default run speed
		if needUpdateAll or perk == defaultRun.targetPerk then
			local defaultRunMultiplier = calculateNewMultipler(defaultRun)
			player:setVariable("defaultRunBT", defaultRunBT / defaultRunMultiplier)
			player:setVariable("defaultRunSS", defaultRunSS * defaultRunMultiplier)
		end

		-- Update default sprint speed
		if needUpdateAll or perk == defaultSprint.targetPerk then
			local defaultSprintMultiplier = calculateNewMultipler(defaultSprint)
			player:setVariable("defaultSprintBT", defaultSprintBT / defaultSprintMultiplier)
			player:setVariable("defaultSprintSS", defaultSprintSS * defaultSprintMultiplier)
		end

		-- Update climb wall speed
		if needUpdateAll or perk == climbWall.targetPerk then
			local climbWallMultiplier = calculateNewMultipler(climbWall)
			player:setVariable("climbWallBT", climbWallBT / climbWallMultiplier)
			player:setVariable("climbWallSS", climbWallSS * climbWallMultiplier)
		end

		-- Update climb window speed
		if needUpdateAll or perk == climbWindow.targetPerk then
			local climbWindowMultiplier = calculateNewMultipler(climbWindow)
			player:setVariable("climbWindow_StartBOT", climbWindow_StartBOT / climbWindowMultiplier)
			player:setVariable("climbWindow_EndBT", climbWindow_EndBT / climbWindowMultiplier)
			player:setVariable("climbWindow_ObstacleBT", climbWindow_ObstacleBT / climbWindowMultiplier)
			player:setVariable("climbWindow_StartSS", climbWindow_StartSS * climbWindowMultiplier)
			player:setVariable("climbWindow_EndSS", climbWindow_EndSS * climbWindowMultiplier)
			player:setVariable("climbWindow_ObstacleSS", climbWindow_ObstacleSS * climbWindowMultiplier)
		end

		-- Update walk climb fence speed
		if needUpdateAll or perk == climbFence_Walk.targetPerk then
			local climbFence_WalkMultiplier = calculateNewMultipler(climbFence_Walk)
			player:setVariable("climbFence_WalkBT", climbFence_WalkBT / climbFence_WalkMultiplier)
			player:setVariable("climbFence_WalkSS", climbFence_WalkSS * climbFence_WalkMultiplier)
		end

		-- Update run climb fence speed
		if needUpdateAll or perk == climbFence_Run.targetPerk then
			local climbFence_RunMultiplier = calculateNewMultipler(climbFence_Run)
			player:setVariable("climbFence_RunBT", climbFence_RunBT / climbFence_RunMultiplier)
			player:setVariable("climbFence_RunBOT", climbFence_RunBOT / climbFence_RunMultiplier)
			player:setVariable("climbFence_RunSS", climbFence_RunSS * climbFence_RunMultiplier)
		end

		-- Update sprint climb fence speed
		if needUpdateAll or perk == climbFence_Sprint.targetPerk then
			local climbFence_SprintMultiplier = calculateNewMultipler(climbFence_Sprint)
			player:setVariable("climbFence_SprintBT", climbFence_SprintBT / climbFence_SprintMultiplier)
			player:setVariable("climbFence_SprintSS", climbFence_SprintSS * climbFence_SprintMultiplier)
		end

		-- Update turn speed
		if needUpdateAll or perk == turn.targetPerk then
			turnMultiplier = calculateNewMultipler(turn)
		end

		-- Update turn180 speed
		if needUpdateAll or perk == turn180.targetPerk then
			local turn180Multiplier = calculateNewMultipler(turn180)
			player:setVariable("turn_type_010BT", turn_type_010BT / turn180Multiplier)
			player:setVariable("turn_type_030BT", turn_type_030BT / turn180Multiplier)
			player:setVariable("turn_type_020BOT", turn_type_020BOT / turn180Multiplier)
			player:setVariable("turn_type_030BOT", turn_type_030BOT / turn180Multiplier)
			player:setVariable("turn_type_080SS", turn_type_080SS * turn180Multiplier)
			player:setVariable("turn_type_104SS", turn_type_104SS * turn180Multiplier)
		end
	end

	-- Updating clothing stats
	local updateClothingStats = function()
		local inventory = player:getInventory()

		UsefulOccupations.Functions.processAfterDelay(1, function()
			for i = 0, inventory:getItems():size() - 1 do
				---@type Clothing
				local item = inventory:getItems():get(i)

				local isClothing = item:IsClothing()
				local isContainer = item:IsInventoryContainer()

				if isClothing or isContainer then
					local itemdata = item:getModData()

					if not itemdata.actualWeight then
						if isClothing then
							itemdata.runSpeedModifier = item:getRunSpeedModifier()
							itemdata.combatSpeedModifier = item:getCombatSpeedModifier()
						end

						itemdata.actualWeight = item:getActualWeight()
					end

					if item:isEquipped() then
						if isClothing then
							if item:getRunSpeedModifier() < 1 then
								item:setRunSpeedModifier(1)
							end

							if item:getCombatSpeedModifier() < 1 then
								item:setCombatSpeedModifier(1)
							end
						end

						item:setActualWeight(itemdata.actualWeight * clothingWeightMultiplier)
					else
						if isClothing then
							item:setRunSpeedModifier(itemdata.runSpeedModifier)
							item:setCombatSpeedModifier(itemdata.combatSpeedModifier)
						end

						item:setActualWeight(itemdata.actualWeight)
					end
				end
			end
		end)
	end

	updateSSMultipliers()
	updateClothingStats()
	constantUpdating()

	-- player:setVariable("scoutWalkType", "bob")
	player:setVariable("hasGraceful", true)

	UsefulOccupations.Functions.processEveryMs(30, constantUpdating)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, _, _)
		updateSSMultipliers(perk)
	end)

	UsefulOccupations.Functions.addEvent(Events.OnClothingUpdated, updateClothingStats)
end
