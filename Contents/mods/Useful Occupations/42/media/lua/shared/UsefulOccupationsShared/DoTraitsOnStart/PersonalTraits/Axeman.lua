--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- TODO: Проверить при трейдинге вызов события OnEquipPrimary
local axeman = function()
	local traitName = UsefulOccupations.PersonalTraits.Axeman.type

	local muscleStrainModifier = UsefulOccupations.PersonalTraits.Axeman.values.muscleStrainModifier
	local enduranceUseModifier = UsefulOccupations.PersonalTraits.Axeman.values.enduranceUseModifier
	local treeDamageMultiplier = UsefulOccupations.PersonalTraits.Axeman.values.treeDamageMultiplier

	local startChopTreeAction = ISChopTreeAction.start

	local OnEvent = {}

	---@type HandWeapon|nil
	local handWeapon = nil
	local wasDamageIncreased = false

	--- @param item HandWeapon
	local getTreeDamage = function(item)
		return math.floor(item:getTreeDamage() / item:getSharpnessMultiplier())
	end

	---@param item HandWeapon
	local increaseDamage = function(item)
		local newTreeDamage = getTreeDamage(item) * treeDamageMultiplier
		item:setTreeDamage(newTreeDamage)

		handWeapon = item

		wasDamageIncreased = true

		Events.OnPlayerUpdate.Remove(OnEvent.OnPlayerUpdate)
	end

	---@param item HandWeapon
	local decreaseDamage = function(item)
		local newTreeDamage = getTreeDamage(item) / treeDamageMultiplier
		item:setTreeDamage(newTreeDamage)

		handWeapon = nil

		Events.OnPlayerUpdate.Remove(OnEvent.OnPlayerUpdate)
	end

	-- Increase tree damage after join if weapon is equipped right now
	---@param player IsoPlayer
	OnEvent.OnPlayerUpdate = function(player)
		if player:getUseHandWeapon():getType() ~= "BareHands" and player:isAiming() then
			increaseDamage(player:getUseHandWeapon())
		end
	end

	---@param item InventoryItem
	OnEvent.OnEquipPrimary = function(_, item)
		if handWeapon then
			decreaseDamage(handWeapon)
		elseif item and instanceof(item, "HandWeapon") then
			---@diagnostic disable-next-line: param-type-mismatch
			increaseDamage(item)
		end
	end

	-- Increase tree damage after start if player used TimedAction to chop tree
	---@diagnostic disable-next-line: duplicate-set-field
	function ISChopTreeAction:start()
		startChopTreeAction(self)

		if self.character:HasTrait(traitName) and not wasDamageIncreased then
			increaseDamage(self.axe)
		end
	end

	UsefulOccupations.Functions.addEvent(Events.OnPlayerUpdate, OnEvent.OnPlayerUpdate)
	UsefulOccupations.Functions.addEvent(Events.OnEquipPrimary, OnEvent.OnEquipPrimary)

	-- When chopping trees, the Axeman's accumulation of pain is reduced by 2 times
	---@diagnostic disable-next-line: duplicate-set-field
	function ISChopTreeAction:animEvent(event, _)
		if not isClient() then
			if event == "ChopTree" then
				self.tree:WeaponHit(self.character, self.axe)

				local modifier = 1

				if self.character:HasTrait(traitName) then
					modifier = muscleStrainModifier
				end

				self.character:addCombatMuscleStrain(self.axe, 1, modifier)

				self:useEndurance()

				if self.tree:getObjectIndex() == -1 then
					if isServer() then
						---@diagnostic disable-next-line: undefined-field
						self.netAction:forceComplete()
					else
						self:forceComplete()
					end
				end
			end
		elseif event == "ChopTree" then
			self.tree:WeaponHitEffects(self.character, self.axe)
		end
	end

	-- When chopping trees, the Axeman's endurance use is reduced by 2 times
	---@diagnostic disable-next-line: duplicate-set-field
	function ISChopTreeAction:useEndurance()
		if self.axe:isUseEndurance() then
			local use = self.axe:getWeight()
				* self.axe:getFatigueMod(self.character)
				* self.character:getFatigueMod()
				* self.axe:getEnduranceMod()
				* 0.1

			local useChargeDelta = 1.0

			use = use * useChargeDelta * 0.041

			if self.axe:isTwoHandWeapon() and self.character:getSecondaryHandItem() ~= self.axe then
				use = use + self.axe:getWeight() / 1.5 / 10 / 20
			end

			if self.character:HasTrait(traitName) then
				use = use * enduranceUseModifier
			end

			self.character:getStats():setEndurance(self.character:getStats():getEndurance() - use)
		end
	end
end

return axeman
