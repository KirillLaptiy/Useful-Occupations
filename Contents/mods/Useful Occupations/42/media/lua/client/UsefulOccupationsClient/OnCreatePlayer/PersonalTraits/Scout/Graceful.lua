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
	-- Sneak walk
	local sneakWalkSS = UsefulOccupations.MovementSpeedValues.sneakWalk.SpeedScale
	local sneakWalkBT = UsefulOccupations.MovementSpeedValues.sneakWalk.BlendTime
	local sneakWalkLowBT = UsefulOccupations.MovementSpeedValues.sneakWalkLow.BlendTime

	-- Sneak run
	local sneakRunBT = UsefulOccupations.MovementSpeedValues.sneakRun.BlendTime
	local sneakRunSS = UsefulOccupations.MovementSpeedValues.sneakRun.SpeedScale
	local sneakRunLowSS = UsefulOccupations.MovementSpeedValues.sneakRunLow.SpeedScale

	-- Graceful values
	local percentPerLvl = UsefulOccupations.PersonalTraits.Graceful.values.percentPerLvl
	local targetedWalkPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetedWalkPerk
	local targetedRunPerk = UsefulOccupations.PersonalTraits.Graceful.values.targetedRunPerk
	local clothingWeightMultiplier = UsefulOccupations.PersonalTraits.Graceful.values.clothingWeightMultiplier

	local sneakWalkMultiplier = 1
	local sneakRunMultiplier = 1

	local constantUpdating = function()
		-- Updating sneak walk speed scale, including scale by "sneakLimpSpeedScale"
		local sneakLimpSpeedScale = player:getVariableString(sneakWalkSS)

		local newSneakSS = sneakLimpSpeedScale * sneakWalkMultiplier
		local newSneakWalkBT = sneakWalkBT / sneakWalkMultiplier
		local newSneakWalkLowBT = sneakWalkLowBT / sneakWalkMultiplier

		player:setVariable("sneakWalkSS", newSneakSS)
		player:setVariable("sneakWalkBT", newSneakWalkBT)
		player:setVariable("sneakWalkLowBT", newSneakWalkLowBT)

		-- The character always climbs over the fence
		player:setVariable("ClimbFenceOutcome", "success")
		player:setVariable("ClimbFenceStruggle", false)
	end

	-- Update sneak run speed
	local updateSneakRunSpeed = function()
		local newSneakRunBT = sneakRunBT / sneakRunMultiplier
		local newSneakRunSS = sneakRunSS * sneakRunMultiplier
		local newSneakRunLowSS = sneakRunLowSS * sneakRunMultiplier

		player:setVariable("sneakRunBT", newSneakRunBT)
		player:setVariable("sneakRunSS", newSneakRunSS)
		player:setVariable("sneakRunLowSS", newSneakRunLowSS)
	end

	-- Updating speed scale multiplier
	local updateSSMultiplier = function()
		local sneakWalkTPLvl = player:getPerkLevel(targetedWalkPerk)
		sneakWalkMultiplier = 1 + (sneakWalkTPLvl * (percentPerLvl / 100))

		local sneakRunTPLvl = player:getPerkLevel(targetedRunPerk)
		sneakWalkMultiplier = 1 + (sneakRunTPLvl * (percentPerLvl / 100))

		updateSneakRunSpeed()
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

	updateSSMultiplier()
	constantUpdating()
	updateSneakRunSpeed()
	updateClothingStats()

	-- player:setVariable("scoutWalkType", "bob")
	player:setVariable("hasGraceful", true)

	UsefulOccupations.Functions.processEveryMs(30, constantUpdating)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, _, _)
		if perk == targetedWalkPerk or perk == targetedRunPerk then
			updateSSMultiplier()
		end
	end)

	UsefulOccupations.Functions.addEvent(Events.OnClothingUpdated, updateClothingStats)
end
