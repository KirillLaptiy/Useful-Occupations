--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local doctorType = UsefulOccupations.PersonalTraits.Doctor.type

local bandageMult = UsefulOccupations.PersonalTraits.Doctor.values.bandageLifePercent() / 50
local bandageMultPerLvl = UsefulOccupations.PersonalTraits.Doctor.values.bandageLifePercentPerLvl() / 100

---@param player IsoPlayer
local getBandageMult = function(player)
	return bandageMult + (bandageMultPerLvl * player:getPerkLevel(Perks.Doctor))
end

---@diagnostic disable-next-line: duplicate-set-field
function ISApplyBandage:complete()
	if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr("Hemophobic")) and self.bodyPart:getBleedingTime() > 0 then
		self.character:getStats():set(CharacterStat.PANIC, self.character:getStats():get(CharacterStat.PANIC) + 50)
		--Stat_Panic
		syncPlayerStats(self.character, 0x00000100)
	end
	-- random a bandage life depending on the doctor skill
	if self.doIt then
		local bandageLife = ZombRandFloat((self.doctorLevel + 1) * 0.5, (self.doctorLevel + 1) * 1.0)
			+ self.item:getBandagePower()

		if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(doctorType)) then
			bandageLife = bandageLife * getBandageMult(self.character)
		end

		if string.match(self.item:getType(), "Dirty") then
			bandageLife = 0
		end

		if self.bodyPart:isGetBandageXp() and bandageLife > 0 then
			addXp(self.character, Perks.Doctor, 5)
		end
		self.otherPlayer:getBodyDamage():SetBandaged(
			self.bodyPart:getIndex(),
			true,
			bandageLife,
			self.item:isAlcoholic(),
			self.item:getModule() .. "." .. self.item:getType()
		)
		self.character:getInventory():Remove(self.item)
		if isServer() then
			sendRemoveItemFromContainer(self.character:getInventory(), self.item)
		end

		if self.item:isInfected() then
			self.bodyPart:SetInfected(true)
		end
	else
		if self.bodyPart:getBandageType() then
			local bandage = instanceItem(self.bodyPart:getBandageType())
			self.character:getInventory():AddItem(bandage)

			if isServer() then
				sendAddItemToContainer(self.character:getInventory(), bandage)
			end

			if self.bodyPart:getBandageLife() <= 0 then
				bandage:UseAndSync()
			end
		end
		---@diagnostic disable-next-line: param-type-mismatch
		self.otherPlayer:getBodyDamage():SetBandaged(self.bodyPart:getIndex(), false, 0, false, nil)
	end

	-- This number is syncParam, flags are:
	-- BD_Bandaged + BD_bleeding + BD_IsInfected + BD_bitten + BD_cut + BD_alcoholicBandage + BD_stitched + BD_deepWounded
	-- BD_bandageType + BD_getBandageXp + BD_bandageLife + corresponding _Time flags
	syncBodyPart(self.bodyPart, 0xc001966b8e)

	return true
end
