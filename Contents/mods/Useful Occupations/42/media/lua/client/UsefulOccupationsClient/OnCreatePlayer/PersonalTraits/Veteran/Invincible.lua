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

	local injuryFields = {
		Burn = {
			burnTime = { get = "getBurnTime", set = "setBurnTime" },
			burnSpeedModifier = { get = "getBurnSpeedModifier", set = "setBurnSpeedModifier" },
			needBurnWash = { get = "isNeedBurnWash", set = "setNeedBurnWash" },
			lastTimeBurnWash = { get = "getLastTimeBurnWash", set = "setLastTimeBurnWash" },
		},

		Cut = {
			isCut = { get = "isCut", set = "setCut" },
			cutTime = { get = "getCutTime", set = "setCutTime" },
			cutSpeedModifier = { get = "getCutSpeedModifier", set = "setCutSpeedModifier" },
		},

		DeepWound = {
			isDeepWounded = { get = "isDeepWounded", set = "setDeepWounded" },
			deepWoundTime = { get = "getDeepWoundTime", set = "setDeepWoundTime" },
			deepWoundSpeedModifier = { get = "getDeepWoundSpeedModifier", set = "setDeepWoundSpeedModifier" },
		},

		Bite = {
			bitten = { get = "bitten", set = "SetBitten" },
			biteTime = { get = "getBiteTime", set = "setBiteTime" },
		},

		Scratch = {
			scratched = { get = "scratched", set = "setScratched" },
			scratchTime = { get = "getScratchTime", set = "setScratchTime" },
			scratchSpeedModifier = { get = "getScratchSpeedModifier", set = "setScratchSpeedModifier" },
		},

		Infection = {
			infectedWound = { get = "isInfectedWound", set = "setInfectedWound" },
			woundInfectionLevel = { get = "getWoundInfectionLevel", set = "setWoundInfectionLevel" },
			isInfected = { get = "IsInfected", set = "SetInfected" },
			fakeInfected = { get = "IsFakeInfected", set = "SetFakeInfected" },
			cauterized = { get = "IsCauterized", set = "SetCauterized" },
		},

		Fracture = {
			fractureTime = { get = "getFractureTime", set = "setFractureTime" },
		},

		Bandage = {
			bandaged = { get = "bandaged", set = "setBandaged" },
			bandageLife = { get = "getBandageLife", set = "setBandageLife" },
			bandageType = { get = "getBandageType", set = "setBandageType" },
			stitched = { get = "stitched", set = "setStitched" },
			stitchTime = { get = "getStitchTime", set = "setStitchTime" },
		},

		Splint = {
			splint = { get = "isSplint", set = "setSplint" },
			splintFactor = { get = "getSplintFactor", set = "setSplintFactor" },
			splintItem = { get = "getSplintItem", set = "setSplintItem" },
		},

		OtherDamage = {
			haveBullet = { get = "haveBullet", set = "setHaveBullet" },
			haveGlass = { get = "haveGlass", set = "setHaveGlass" },
			stiffness = { get = "getStiffness", set = "setStiffness" },
			wetness = { get = "getWetness", set = "setWetness" },
			additionalPain = { get = "getAdditionalPain", set = "setAdditionalPain" },
			alcoholLevel = { get = "getAlcoholLevel", set = "setAlcoholLevel" },
			comfreyFactor = { get = "getComfreyFactor", set = "setComfreyFactor" },
			garlicFactor = { get = "getGarlicFactor", set = "setGarlicFactor" },
			plantainFactor = { get = "getPlantainFactor", set = "setPlantainFactor" },
			health = { get = "getHealth", set = "SetHealth" },
		},

		Bleeding = {
			bleeding = { get = "bleeding", set = "setBleeding" },
			bleedingTime = { get = "getBleedingTime", set = "setBleedingTime" },
			bleedingStemmed = { get = "IsBleedingStemmed", set = "SetBleedingStemmed" },
		},
	}

	local settersExtraValues = {
		setBandaged = function()
			return 1
		end,
		setSplint = function()
			return 1
		end,
		setHaveBullet = function()
			return player:getPerkLevel(Perks.Doctor)
		end,
		setScratched = function()
			return true
		end,
	}

	local perkStates = {
		active = "active",
		ready = "ready",
		onCooldown = "onCooldown",
	}

	local modData = UsefulOccupations.Functions.getModData()

	local canDodge = player:getStats():getEndurance() > dodgeEnduranceEdge
	local dodgeCost = dodgeEnduranceCost - (targetPerkEffect * player:getPerkLevel(targetPerk))

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

	local function updateBodyPartInjuries()
		local bodyDamage = player:getBodyDamage()
		local bodyParts = bodyDamage:getBodyParts()

		modData.bodyPartsData = {}

		for i = 0, bodyParts:size() - 1 do
			local part = bodyParts:get(i)

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

	local function applyBodyPartInjuries()
		local bodyDamage = player:getBodyDamage()
		local bodyParts = bodyDamage:getBodyParts()

		for _, entry in ipairs(modData.bodyPartsData) do
			---@type BodyPart
			local part = bodyParts:get(entry.index)

			for injuryType, fields in pairs(injuryFields) do
				local saved = entry[injuryType]

				if saved then
					for fieldName, value in pairs(saved) do
						local setter = fields[fieldName].set
						local extraValue = settersExtraValues[setter]

						if extraValue ~= nil then
							part[setter](part, value, extraValue())
						else
							part[setter](part, value)
						end
					end
				end
			end
		end
	end

	local activatePerk = function()
		modData.invincibleState = perkStates.active

		updateBodyPartInjuries()

		player:setPlayingDeathSound(false)
		player:setDeathDragDown(false)
		---@diagnostic disable-next-line: param-type-mismatch
		player:setHitReaction(nil)
		player:setGodMod(true)

		-- UsefulOccupations.Functions.processAfterDelay(25000, function ()
		-- 	modData.invincibleState = perkStates.onCooldown

		-- 	applyBodyPartInjuries()
		-- end)
	end

	-- UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, _, _)
	-- 	if perk == Perks.Strength then
	-- 		applyBodyPartInjuries()
	-- 	else
	-- 		updateBodyPartInjuries()
	-- 	end

	-- 	modData.invincibleState = perkStates.ready
	-- end)

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
					if modData.invincibleState == perkStates.ready then
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
