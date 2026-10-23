--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local traitName
local muscleStrainModifier
local enduranceUseModifier

-- When chopping trees, the Axeman's accumulation of pain is reduced by 2 times
---@diagnostic disable-next-line: duplicate-set-field
function ISChopTreeAction:animEvent(event, _)
	if not isClient() then
		if event == "ChopTree" then
			---@diagnostic disable-next-line: param-type-mismatch
			self.tree:WeaponHit(self.character, self.axe)

			local modifier = 1

			if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitName)) then
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
		---@diagnostic disable-next-line: param-type-mismatch
		self.tree:WeaponHitEffects(self.character, self.axe)
	end
end

-- When chopping trees, the Axeman's endurance use is reduced by 2 times
---@diagnostic disable-next-line: duplicate-set-field
function ISChopTreeAction:useEndurance()
	---@type HandWeapon
	---@diagnostic disable-next-line: assign-type-mismatch
	local axe = self.axe

	if axe:isUseEndurance() then
		local use = axe:getWeight()
			* axe:getFatigueMod(self.character)
			* self.character:getFatigueMod()
			* axe:getEnduranceMod()
			* 0.1

		local useChargeDelta = 1.0

		use = use * useChargeDelta * 0.041

		if self.axe:isTwoHandWeapon() and self.character:getSecondaryHandItem() ~= self.axe then
			use = use + self.axe:getWeight() / 1.5 / 10 / 20
		end

		if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitName)) then
			use = use * enduranceUseModifier
		end

		self.character:getStats():set(CharacterStat.ENDURANCE, self.character:getStats():get(CharacterStat.ENDURANCE) - use)
	end
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	local trait = UsefulOccupations.PersonalTraits.Axeman

	traitName = trait.type
	muscleStrainModifier = trait.values.muscleStrainModifier()
	enduranceUseModifier = trait.values.enduranceUseModifier()
end)
