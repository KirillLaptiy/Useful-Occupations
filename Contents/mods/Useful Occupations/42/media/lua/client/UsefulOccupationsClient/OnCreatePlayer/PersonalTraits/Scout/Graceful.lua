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
	local sneakWalkSS = UsefulOccupations.MovementSpeedValues.sneakWalk.SpeedScale
	local sneakWalkBT = UsefulOccupations.MovementSpeedValues.sneakWalk.BlendTime
	local sneakWalkLowBT = UsefulOccupations.MovementSpeedValues.sneakWalkLow.BlendTime

	-- Sneak run
	local sneakRunBT = UsefulOccupations.MovementSpeedValues.sneakRun.BlendTime
	local sneakRunSS = UsefulOccupations.MovementSpeedValues.sneakRun.SpeedScale
	local sneakRunLowBT = UsefulOccupations.MovementSpeedValues.sneakRunLow.BlendTime
	local sneakRunLowSS = UsefulOccupations.MovementSpeedValues.sneakRunLow.SpeedScale

	-- Default walk
	local defaultWalkBT = UsefulOccupations.MovementSpeedValues.defaultWalk.BlendTime
	local defaultWalkSS = UsefulOccupations.MovementSpeedValues.defaultWalk.SpeedScale

	-- Default run
	local defaultRunBT = UsefulOccupations.MovementSpeedValues.defaultRun.BlendTime
	local defaultRunSS = UsefulOccupations.MovementSpeedValues.defaultRun.SpeedScale

	-- Default sprint
	local defaultSprintBT = UsefulOccupations.MovementSpeedValues.defaultSprint.BlendTime
	local defaultSprintSS = UsefulOccupations.MovementSpeedValues.defaultSprint.SpeedScale

	-- Graceful values
	-- Percents
	local startBonusPercent = UsefulOccupations.PersonalTraits.Graceful.values.startBonusPercent / 100
	local percentPerLvl = UsefulOccupations.PersonalTraits.Graceful.values.percentPerLvl / 100

	-- Target perks
	local targetDefaultWalkPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetDefaultWalkPerk
	local targetSneakWalkPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetSneakWalkPerk
	local targetSneakRunPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetSneakRunPerk
	local targetDefaultRunPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetDefaultRunPerk
	local targetDefaultSprintPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetDefaultSprintPerk

	-- Clothing multiplier
	local clothingWeightMultiplier = UsefulOccupations.PersonalTraits.Graceful.values.clothingWeightMultiplier

	local defaultWalkMultiplier = 1
	local sneakWalkMultiplier = 1
	local sneakRunMultiplier = 1
	local defaultRunMultiplier = 1
	local defaultSprintMultiplier = 1

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
	end

	-- Update every new target perk lvl
	local LevelPerkUpdate = function()
		-- Update walk speed
		player:setVariable("defaultWalkBT", defaultWalkBT / defaultWalkMultiplier)
		player:setVariable("defaultWalkSS", defaultWalkSS * defaultWalkMultiplier)

		-- Update sneak run speed
		player:setVariable("sneakRunBT", sneakRunBT / sneakRunMultiplier)
		player:setVariable("sneakRunSS", sneakRunSS * sneakRunMultiplier)
		player:setVariable("sneakRunLowBT", sneakRunLowBT / sneakRunMultiplier)
		player:setVariable("sneakRunLowSS", sneakRunLowSS * sneakRunMultiplier)

		-- Update run speed
		player:setVariable("defaultRunBT", defaultRunBT / defaultRunMultiplier)
		player:setVariable("defaultRunSS", defaultRunSS * defaultRunMultiplier)

		-- Update sprint speed
		player:setVariable("defaultSprintBT", defaultSprintBT / defaultSprintMultiplier)
		player:setVariable("defaultSprintSS", defaultSprintSS * defaultSprintMultiplier)
	end

	-- Updating speed scale multipliers
	local updateSSMultipliers = function()
		---@param targetPerk Perk
		local calculateNewMultipler = function(targetPerk)
			local targetPerkLvl = player:getPerkLevel(targetPerk)
			local newMultiplier = 1 + startBonusPercent + (targetPerkLvl * percentPerLvl)

			return newMultiplier
		end

		defaultWalkMultiplier = calculateNewMultipler(targetDefaultWalkPerk)
		sneakWalkMultiplier = calculateNewMultipler(targetSneakWalkPerk)
		sneakRunMultiplier = calculateNewMultipler(targetSneakRunPerk)
		defaultRunMultiplier = calculateNewMultipler(targetDefaultRunPerk)
		defaultSprintMultiplier = calculateNewMultipler(targetDefaultSprintPerk)

		LevelPerkUpdate()
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

	constantUpdating()
	LevelPerkUpdate()
	updateSSMultipliers()
	updateClothingStats()

	-- player:setVariable("scoutWalkType", "bob")
	player:setVariable("hasGraceful", true)

	UsefulOccupations.Functions.processEveryMs(30, constantUpdating)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, _, _, _)
		updateSSMultipliers()
	end)

	UsefulOccupations.Functions.addEvent(Events.OnClothingUpdated, updateClothingStats)
end
