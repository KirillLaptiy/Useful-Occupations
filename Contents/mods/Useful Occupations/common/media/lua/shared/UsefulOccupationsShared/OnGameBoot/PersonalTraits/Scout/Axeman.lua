--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnGameBoot.Axeman
UsefulOccupations.DoTraitsOnGameBoot.Axeman = function()
	local traitName = UsefulOccupations.PersonalTraits.Axeman.type
	local muscleStrainModifier = UsefulOccupations.PersonalTraits.Axeman.values.muscleStrainModifier()
	local enduranceUseModifier = UsefulOccupations.PersonalTraits.Axeman.values.enduranceUseModifier()

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
						---@diagnostic disable-next-line: param-type-mismatch
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
