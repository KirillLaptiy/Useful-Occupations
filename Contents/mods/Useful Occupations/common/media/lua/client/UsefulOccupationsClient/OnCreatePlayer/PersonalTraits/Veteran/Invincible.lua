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
	local dodgeEnduranceCost = UsefulOccupations.PersonalTraits.Invincible.values.dodgeEnduranceCost() / 100
	local dodgeEnduranceEdge = UsefulOccupations.PersonalTraits.Invincible.values.dodgeEnduranceEdge() / 100
	local targetPerkEffect = UsefulOccupations.PersonalTraits.Invincible.values.targetPerkEffect() / 100
	local perkActiveTime = UsefulOccupations.PersonalTraits.Invincible.values.perkActiveTime()
	local perkCooldownTime = UsefulOccupations.PersonalTraits.Invincible.values.perkCooldownTime() * 60
	local zombieDisableCost = UsefulOccupations.PersonalTraits.Invincible.values.zombieDisableCost() / 100
	local zombieDisableEdge = UsefulOccupations.PersonalTraits.Invincible.values.zombieDisableEdge() / 100

	local targetPerk = Perks.Nimble

	local perkStates = {
		active = "active",
		ready = "ready",
		onCooldown = "onCooldown",
	}

	local modData = UsefulOccupations.Functions.getModData()

	local bodyDamage = player:getBodyDamage()
	local stats = player:getStats()

	local canDodge = stats:get(CharacterStat.ENDURANCE) > dodgeEnduranceEdge
	local dodgeCost = dodgeEnduranceCost - (targetPerkEffect * player:getPerkLevel(targetPerk))

	local zombieCrawlerCost = zombieDisableCost - (targetPerkEffect * player:getPerkLevel(targetPerk))

	local doDodge = function()
		local endurance = stats:get(CharacterStat.ENDURANCE)
		stats:set(CharacterStat.ENDURANCE, endurance - dodgeCost)
		player:playerVoiceSound("JumpLow")
	end

	---@param zombie IsoZombie
	local dodgeAttackingZombie = function(zombie)
		if zombie:isCrawling() then
			zombie:setUseless(true)

			UsefulOccupations.Functions.processAfterDelay(1000 + ZombRand(1000), function()
				zombie:setUseless(false)
			end)

			return
		end

		zombie:setNoTeeth(true)

		UsefulOccupations.Functions.processAfterDelay(500, function()
			local distance = player:DistTo(zombie)

			if distance <= 1.05 and zombie:isAttacking() then
				zombie:setStaggerBack(true)
				zombie:setKnockedDown(true)
				doDodge()
			end
		end)

		UsefulOccupations.Functions.processAfterDelay(1000, function()
			zombie:setNoTeeth(false)
		end)
	end

	-- NOT WORKING
	-- Aborts death drag down and pushes near zombies
	-- ---@param zombie IsoZombie
	-- local abortDeathDragDown = function(zombie)
	-- 	player:setDeathDragDown(false)
	-- 	player:setPlayingDeathSound(false)

	-- 	if not zombie:isKnockedDown() then
	-- 		zombie:setKnockedDown(true)
	-- 		zombie:setStaggerBack(true)
	-- 		zombie:setHitReaction("")
	-- 		zombie:setPlayerAttackPosition("FRONT")
	-- 		zombie:setHitForce(5.0)
	-- 		zombie:reportEvent("wasHit")
	-- 	end
	-- end

	local checkNearZombies = function()
		-- local isDeathDragDown = player:isDeathDragDown()
		-- if not canDodge and not isDeathDragDown then return end

		if not canDodge then return end

		local playerSquare = player:getSquare()
		local px, py, pz = playerSquare:getX(), playerSquare:getY(), playerSquare:getZ()
		local cell = player:getCell()

		canDodge = stats:get(CharacterStat.ENDURANCE) > dodgeEnduranceEdge

		for dx = -1, 1 do
			for dy = -1, 1 do
				local square = cell:getGridSquare(px + dx, py + dy, pz)

				if square then
					local movingObjects = square:getMovingObjects()

					for i = 0, movingObjects:size() - 1 do
						---@type IsoZombie
						---@diagnostic disable-next-line: assign-type-mismatch
						local enemy = movingObjects:get(i)

						if enemy:isZombie() then
							-- Dodge zombie attack
							if
								canDodge == true
								and enemy:getTarget() == player
								and enemy:isNoTeeth() == false
								and enemy:isAttacking() == true
							then
								dodgeAttackingZombie(enemy)
							end

							-- NOT WORKING
							-- Activate perk if character at death's door
							-- if isDeathDragDown then
							-- 	abortDeathDragDown(enemy)
							-- end
						end
					end
				end
			end
		end
	end

	local processActiveState = function()
		if modData.invincibleState ~= perkStates.active then
			return
		end

		local bodyParts = bodyDamage:getBodyParts()

		for i = 0, bodyParts:size() - 1 do
			---@type BodyPart
			---@diagnostic disable-next-line: assign-type-mismatch
			local bodyPart = bodyParts:get(i)

			bodyPart:SetHealth(100)
		end
	end

	local processReadyState = function()
		-- Switch perk state to "active"
		if bodyDamage:getHealth() <= 30 and modData.invincibleState == perkStates.ready then
			modData.invincibleState = perkStates.active
			modData.invincibleActiveTime = perkActiveTime

			processActiveState()
		end
	end

	-- Updates trait's remaining active time
	local updateActiveTime = function()
		if modData.invincibleState ~= perkStates.active then
			return
		end

		-- Makes game speed affects active time
		local time = 0.1

		local gameSpeed = getGameSpeed()

		if gameSpeed == 2 then
			time = time * 5
		elseif gameSpeed == 3 then
			time = time * 20
		elseif gameSpeed == 4 then
			time = time * 40
		end

		-- Decrease perk active time
		modData.invincibleActiveTime = math.max(0, modData.invincibleActiveTime - time)

		-- Switch perk state to "cooldown"
		if modData.invincibleActiveTime == 0 then
			modData.invincibleState = perkStates.onCooldown
			modData.invincibleCooldownTime = perkCooldownTime
		end
	end

	-- Updates trait's remaining cooldown time
	local updateCooldownTime = function()
		if modData.invincibleState ~= perkStates.onCooldown then
			return
		end

		modData.invincibleCooldownTime = math.max(0, modData.invincibleCooldownTime - 10)

		-- Switch perk state to "ready"
		if modData.invincibleCooldownTime == 0 then
			modData.invincibleState = perkStates.ready
		end
	end

	-- Update dodge cost on new perk level
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			dodgeCost = dodgeEnduranceCost - (targetPerkEffect * perkLvl)
			zombieCrawlerCost = zombieDisableCost - (targetPerkEffect * perkLvl)
		end
	end)

	UsefulOccupations.Functions.processEveryMs(20, function()
		processReadyState()
		checkNearZombies()
		processActiveState()
	end)

	UsefulOccupations.Functions.processEveryMs(100, updateActiveTime)
	UsefulOccupations.Functions.addEvent(Events.EveryTenMinutes, updateCooldownTime)

	-- When bumps a zombie while running, disables it by consuming endurance
	---@param character IsoGameCharacter
	---@param collidedCharacter IsoZombie
	UsefulOccupations.Functions.addEvent(Events.OnCharacterCollide, function(character, collidedCharacter)
		if character ~= player or not collidedCharacter:isZombie() or collidedCharacter:isKnockedDown() then
			return
		end

		local endurance = stats:get(CharacterStat.ENDURANCE)

		-- The character needs endurance to disable a zombie
		if endurance < zombieDisableEdge then
			return
		end

		local running = player:isPlayerMoving() and (player:isRunning() or player:isSprinting())

		if running == true and collidedCharacter:isZombie() == true then
			collidedCharacter:setKnockedDown(true)
			collidedCharacter:setStaggerBack(true)
			collidedCharacter:setBecomeCrawler(true)

			stats:set(CharacterStat.ENDURANCE, endurance - zombieCrawlerCost)
			player:playerVoiceSound("JumpLow")
		end
	end)

	-- The character does not fall. Re-enables sprint after bump
	UsefulOccupations.Functions.addEvent(Events.OnTick, function(_)
		if player:isBumped() then
			if player:isSprinting() then
				UsefulOccupations.Functions.processAfterDelay(50, function()
					player:setForceSprint(true)
				end)
			end

			player:setBumpFall(false)
			player:setBumpStaggered(false)
		end
	end)
end
