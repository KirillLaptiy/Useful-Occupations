-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

local traitType

---@diagnostic disable-next-line: duplicate-set-field
function ISFixVehiclePartAction:complete()
	FixingManager.fixItem(self.item, self.character, self.fixing, self.fixer)

    -- Mechanic repairs vehicle parts more effective
	if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType)) then
		local mechanicBonusMult = 1
		+ (UsefulOccupations.TraitsOnGameBoot.Mechanic.getBonusRepairPercent(self.character) / 100)
		self.item:setCondition(self.item:getCondition() * mechanicBonusMult)
	end

	self.vehiclePart:setCondition(self.item:getCondition())
	self.vehiclePart:doInventoryItemStats(self.item, self.vehiclePart:getMechanicSkillInstaller())

	if self.vehiclePart:isContainer() and not self.vehiclePart:getItemContainer() then
		-- Changing condition might change capacity.
		-- This limits content amount to max capacity.
		---@diagnostic disable-next-line: undefined-global
		self.vehiclePart:setContainerContentAmount(part:getContainerContentAmount())
	end

	self.vehiclePart:getVehicle():updatePartStats()
	self.vehiclePart:getVehicle():updateBulletStats()
	self.vehiclePart:getVehicle():transmitPartItem(self.vehiclePart)

	return true
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	traitType = UsefulOccupations.PersonalTraits.Mechanic.type
end)
