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
function ISRepairLightbar:complete()
	local skill = self.character:getPerkLevel(Perks.Mechanics) - self.vehicle:getScript():getEngineRepairLevel()
	local giveXP = self.character:getMechanicsItem(self.part:getVehicle():getMechanicalID() .. "2") == nil

	if self.vehicle then
		if not self.part then
			---@diagnostic disable-next-line: undefined-global
			noise("no such part Ligthbar")
			return false
		end

		local condPerPart = 15 + skill

        -- Mechanic repairs light bar more effective
		if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType)) then
			local mechanicBonusMult = 1 + (UsefulOccupations.TraitsOnGameBoot.Mechanic.getBonusRepairPercent(self.character) / 100)
			condPerPart = condPerPart * mechanicBonusMult
		end

		self.part:setCondition(self.part:getCondition() + condPerPart)
		if self.part:getCondition() >= 100 then
			self.part:setCondition(100)
		end

		if giveXP then
			addXp(self.character, Perks.Mechanics, 5)
		end

		self.character:getInventory():Remove(self.item)

		if isServer() then
			sendRemoveItemFromContainer(self.character:getInventory(), self.item)
		end

		self.vehicle:transmitPartCondition(self.part)

		self.character:sendObjectChange("mechanicActionDone", { success = true })
		self.character:addMechanicsItem(
			self.item:getID() .. self.vehicle:getMechanicalID() .. "1",
			self.part,
			getGameTime():getCalender():getTimeInMillis()
		)
	else
		print("no such vehicle id=", self.vehicle)
	end

	self.character:addMechanicsItem(
		self.part:getVehicle():getMechanicalID() .. "2",
		self.part,
		getGameTime():getCalender():getTimeInMillis()
	)

	return true
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	traitType = UsefulOccupations.PersonalTraits.Mechanic.type
end)