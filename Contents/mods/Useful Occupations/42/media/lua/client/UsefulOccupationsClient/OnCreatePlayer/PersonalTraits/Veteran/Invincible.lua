--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Invincible
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Invincible = function(player)
	local dodgeEnduranceCost = UsefulOccupations.PersonalTraits.Invincible.values.dodgeEnduranceCost / 100
	local dodgeEnduranceEdge = UsefulOccupations.PersonalTraits.Invincible.values.dodgeEnduranceEdge / 100
	local targetPerk = UsefulOccupations.PersonalTraits.Invincible.values.targetPerk
	local targetPerkEffect = UsefulOccupations.PersonalTraits.Invincible.values.targetPerkEffect / 100

	local canDodge = player:getStats():getEndurance() > dodgeEnduranceEdge
	local dodgeCost = dodgeEnduranceCost - (targetPerkEffect * player:getPerkLevel(targetPerk))

	local doDodge = function()
		local stats = player:getStats()
		local endurance = stats:getEndurance()

		stats:setEndurance(endurance - dodgeCost)

		player:playerVoiceSound("JumpLow")
	end

	local dodgeAttackingZombies = function()
		canDodge = player:getStats():getEndurance() > dodgeEnduranceEdge

		if not canDodge then
			return
		end

		local enemies = player:getSpottedList()

		for i = 0, enemies:size() - 1 do
			---@type IsoZombie
			local enemy = enemies:get(i)

			if enemy:isZombie() and enemy:getTarget() == player and not enemy:isNoTeeth() and enemy:isAttacking() then
				enemy:setNoTeeth(true)

				UsefulOccupations.Functions.processAfterDelay(500, function()
					if not canDodge then
						return
					end

					local distance = player:DistTo(enemy)

					if distance <= 1.05 and enemy:isAttacking() then
						enemy:setStaggerBack(true)
						enemy:setKnockedDown(true)
						doDodge()
					end

					enemy:setNoTeeth(false)
				end)
			end
		end
	end

	UsefulOccupations.Functions.processEveryMs(30, dodgeAttackingZombies)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			dodgeCost = dodgeEnduranceCost - (targetPerkEffect * perkLvl)
		end
	end)
end
