--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

--TODO: ADD CARBON VEHICLE VARIANTS

local carbonPartsType = "UO.CarbonEngineParts"
local partsType = "Base.EngineParts"

-- Copy of original ISRepairEngine.complete but with carbon engine parts
---@diagnostic disable-next-line: duplicate-set-field
function ISTakeEngineParts:complete()
	local cond = self.part:getCondition()
	local skill = self.character:getPerkLevel(Perks.Mechanics) - self.vehicle:getScript():getEngineRepairLevel()
	local condForPart = math.max(20 - skill, 5)

	-- local carbonVehicle = self.part:getVehicle():getScriptName() == "VehicleBody"
	local carbonVehicle = true

	if self.vehicle then
		if not self.part then
			print("no such part Engine")
			return false
		end
		local cond = self.part:getCondition()
		local condForPart = math.max(20 - skill, 5)
		condForPart = ZombRand(condForPart / 3, condForPart)
		local numParts = math.floor(cond / condForPart)
		if numParts > 0 then
			local items = self.character
				:getInventory()
				:AddItems(carbonVehicle and carbonPartsType or partsType, tonumber(numParts))
			sendAddItemsToContainer(self.character:getInventory(), items)
		else
			addXp(self.character, Perks.Mechanics, 1)
		end
		self.part:setCondition(0)
		self.vehicle:transmitPartCondition(self.part)
		self.character:sendObjectChange("mechanicActionDone", { success = (numParts > 0) })
		if numParts > 0 then
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

	if not self.character:getMechanicsItem(self.vehicle:getMechanicalID() .. "3") then
		addXp(self.character, Perks.Mechanics, math.floor(cond / condForPart) / 2)
	end
	self.character:addMechanicsItem(
		self.vehicle:getMechanicalID() .. "3",
		self.part,
		getGameTime():getCalender():getTimeInMillis()
	)

	return true
end
