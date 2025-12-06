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

local cataplasmMultiplier = UsefulOccupations.PersonalTraits.Doctor.values.cataplasmPowerPercent() / 50
local cataplasmMultiplierPerLvl = UsefulOccupations.PersonalTraits.Doctor.values.cataplasmPowerPercentPerLvl() / 100

---@param player IsoPlayer
local getCataplasmMult = function(player)
	return cataplasmMultiplier + (cataplasmMultiplierPerLvl * player:getPerkLevel(Perks.Doctor))
end

---@diagnostic disable-next-line: duplicate-set-field
function ISPlantainCataplasm:complete()
	if self.character:HasTrait("Hemophobic") and self.bodyPart:getBleedingTime() > 0 then
		self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
		--Stat_Panic
		syncPlayerStats(self.character, 0x00000100)
	end

	local cataplasmPower = ZombRandFloat((self.doctorLevel + 1) * 0.5, (self.doctorLevel + 1) * 1.0) + 10

	if self.character:HasTrait(doctorType) then
		cataplasmPower = cataplasmPower * getCataplasmMult(self.character)
	end

	self.bodyPart:setPlantainFactor(cataplasmPower)
	self.character:getInventory():Remove(self.item)

	if isServer() then
		sendRemoveItemFromContainer(self.character:getInventory(), self.item)
	end

	-- This number is syncParam, flags are:
	-- BD_plantainFactor
	syncBodyPart(self.bodyPart, 0x0000000800000000)

	return true
end

---@diagnostic disable-next-line: duplicate-set-field
function ISGarlicCataplasm:complete()
	if self.character:HasTrait("Hemophobic") and self.bodyPart:getBleedingTime() > 0 then
		self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
		--Stat_Panic
		syncPlayerStats(self.character, 0x00000100)
	end

	local cataplasmPower = ZombRandFloat((self.doctorLevel + 1) * 0.5, (self.doctorLevel + 1) * 1.0) + 10

	if self.character:HasTrait(doctorType) then
		cataplasmPower = cataplasmPower * getCataplasmMult(self.character)
	end

	self.bodyPart:setGarlicFactor(cataplasmPower)
	self.character:getInventory():Remove(self.item)
	if isServer() then
		sendRemoveItemFromContainer(self.character:getInventory(), self.item)
	end
	-- This number is syncParam, flags are:
	-- BD_garlicFactor
	syncBodyPart(self.bodyPart, 0x0000002000000000)

	return true
end

---@diagnostic disable-next-line: duplicate-set-field
function ISComfreyCataplasm:complete()
	if self.character:HasTrait("Hemophobic") and self.bodyPart:getBleedingTime() > 0 then
		self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
		--Stat_Panic
		syncPlayerStats(self.character, 0x00000100)
	end

	local cataplasmPower = ZombRandFloat((self.doctorLevel + 1) * 0.5, (self.doctorLevel + 1) * 1.0) + 10

	if self.character:HasTrait(doctorType) then
		cataplasmPower = cataplasmPower * getCataplasmMult(self.character)
	end

	self.bodyPart:setComfreyFactor(cataplasmPower)
	self.character:getInventory():Remove(self.item)
	if isServer() then
		sendRemoveItemFromContainer(self.character:getInventory(), self.item)
	end

	-- This number is syncParam, flags are:
	-- BD_comfreyFactor
	syncBodyPart(self.bodyPart, 0x0000001000000000)

	return true
end
