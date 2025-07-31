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

	local modData = UsefulOccupations.Functions.getModData()

	local perkStates = {
		active = "active",
		ready = "ready",
		onCooldown = "onCooldown",
	}

	local perkState = perkStates.ready

	local doDodge = function()
		local stats = player:getStats()
		local endurance = stats:getEndurance()

		stats:setEndurance(endurance - dodgeCost)

		player:playerVoiceSound("JumpLow")
	end

	---@param zombie IsoZombie
	local dodgeAttackingZombies = function(zombie)
		zombie:setNoTeeth(true)

		UsefulOccupations.Functions.processAfterDelay(500, function()
			if not canDodge then
				zombie:setNoTeeth(false)
				return
			end

			local distance = player:DistTo(zombie)

			if distance <= 1.05 and zombie:isAttacking() then
				zombie:setStaggerBack(true)
				zombie:setKnockedDown(true)
				doDodge()
			end

			zombie:setNoTeeth(false)
		end)
	end

	local injuryFields = {
		Burn = {
			param_1 = { get = "isBurnt", set = "setBurned" },
			param_2 = { get = "getBurnTime", set = "setBurnTime" },
			param_3 = { get = "getBurnSpeedModifier", set = "setBurnSpeedModifier" },
			param_4 = { get = "isNeedBurnWash", set = "setNeedBurnWash" },
			param_5 = { get = "getLastTimeBurnWash", sFet = "setLastTimeBurnWash" },
		},
	}

	local function updateBodyPartInjuries()
		local bodyDamage = player:getBodyDamage()
		local bodyParts = bodyDamage:getBodyParts()

		modData.bodyPartsData = {}

		for i = 0, bodyParts:size() - 1 do
			local part = bodyParts:get(i)

			if part:HasInjury() then
				local entry = { index = part:getIndex() }

				for injuryType, fields in pairs(injuryFields) do
					entry[injuryType] = {}

					for fieldName, methods in pairs(fields) do
						local value = part[methods.get](part)
						entry[injuryType][fieldName] = value
					end
				end

				table.insert(modData.bodyPartsData, entry)
			end
		end
	end

	local function applyBodyPartInjuries()
		local bodyDamage = player:getBodyDamage()
		local bodyParts = bodyDamage:getBodyParts()

		for _, entry in ipairs(modData.bodyPartsData) do
			local part = bodyParts:get(entry.index)

			for injuryType, fields in pairs(injuryFields) do
				local saved = entry[injuryType]

				if saved then
					for fieldName, value in pairs(saved) do
						local setter = fields[fieldName].set
						part[setter](part, value)
					end
				end
			end
		end
	end

	local activatePerk = function()
		perkState = perkStates.active

		updateBodyPartInjuries()

		player:setPlayingDeathSound(false)
		player:setDeathDragDown(false)
		---@diagnostic disable-next-line: param-type-mismatch
		player:setHitReaction(nil)
		player:setGodMod(true)
	end

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, _, _, _)
		-- applyBodyPartInjuries()

		updateBodyPartInjuries()

		applyBodyPartInjuries()

		perkState = perkStates.ready
	end)

	---@param zombie IsoZombie
	local pushZombie = function(zombie)
		zombie:setKnockedDown(true)
		zombie:setStaggerBack(true)
		zombie:setHitReaction("")
		zombie:setPlayerAttackPosition("FRONT")
		zombie:setHitForce(5.0)
		zombie:reportEvent("wasHit")
	end

	local checkNearZombies = function()
		canDodge = player:getStats():getEndurance() > dodgeEnduranceEdge
		local isDeathDragDown = player:isDeathDragDown()

		local enemies = player:getSpottedList()

		for i = 0, enemies:size() - 1 do
			---@type IsoZombie
			local enemy = enemies:get(i)

			if enemy:isZombie() and player:DistTo(enemy) <= 4 then
				if isDeathDragDown then
					if perkState == perkStates.ready then
						activatePerk()
					end

					if not enemy:isKnockedDown() then
						pushZombie(enemy)
					end
				elseif canDodge and enemy:getTarget() == player and not enemy:isNoTeeth() and enemy:isAttacking() then
					-- dodgeAttackingZombies(enemy)
				end
			end
		end
	end

	UsefulOccupations.Functions.processEveryMs(30, checkNearZombies)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			dodgeCost = dodgeEnduranceCost - (targetPerkEffect * perkLvl)
		end
	end)
end
