--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local carbonPartsType = "EngineSpecialParts"
local partsType = "EngineParts"

-- Copy of original ISRepairEngine.complete but with carbon engine parts
---@diagnostic disable-next-line: duplicate-set-field
function ISRepairEngine:complete()
	local skill = self.character:getPerkLevel(Perks.Mechanics) - self.vehicle:getScript():getEngineRepairLevel()
	local giveXP = self.character:getMechanicsItem(self.part:getVehicle():getMechanicalID() .. "2") == nil

	-- local carbonVehicle = self.part:getVehicle():getScriptName() == "VehicleBody"
	local carbonVehicle = true

	local numberOfParts =
		self.character:getInventory():getNumberOfItem(carbonVehicle and carbonPartsType or partsType, false, true)

	if self.vehicle then
		if not self.part then
			---@diagnostic disable-next-line: undefined-global
			noise("no such part Engine")
			return false
		end

		local condPerPart = 1 + (skill / 2)

		if condPerPart > 5 then
			condPerPart = 5
		end

		local done = 0

		for _ = 1, numberOfParts do
			self.part:setCondition(self.part:getCondition() + condPerPart)

			done = done + 1

			if self.part:getCondition() >= 100 then
				self.part:setCondition(100)
				break
			end
		end

		if done > 0 then
			if giveXP then
				addXp(self.character, Perks.Mechanics, done)
			end

			local items =
			---@diagnostic disable-next-line: param-type-mismatch
				self.character:getInventory():RemoveAll(carbonVehicle and carbonPartsType or partsType, tonumber(done))

			sendRemoveItemsFromContainer(self.character:getInventory(), items)

			self.vehicle:transmitPartCondition(self.part)
		else
			addXp(self.character, Perks.Mechanics, 1)
		end

		self.character:sendObjectChange("mechanicActionDone", { success = (done > 0) })

		if done > 0 then
			self.character:addMechanicsItem(
				self.item:getID() .. self.vehicle:getMechanicalID() .. "1",
				self.part,
				getGameTime():getCalender():getTimeInMillis()
			)
		else
			addXp(self.character, Perks.Mechanics, 1)
		end
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
