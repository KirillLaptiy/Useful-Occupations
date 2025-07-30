-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

require("TimedActions/ISBaseTimedAction")

---@class ISLockpickVehicleDoor : ISBaseTimedAction
---@field character IsoPlayer
---@field vehicle BaseVehicle
---@field part VehiclePart
---@field vehicleDoor VehicleDoor
---@field needToBeLocked boolean
---@field lockpick InventoryItem
---@field maxTime number
ISLockpickVehicleDoor = ISBaseTimedAction:derive("ISLockpickVehicleDoor")

function ISLockpickVehicleDoor:isValid()
	if not self.lockpick or self.lockpick:getCondition() < 1 then
		return false
	end

	return true
end

function ISLockpickVehicleDoor:waitToStart()
	self.character:faceThisObject(self.vehicle)
	return self.character:shouldBeTurning()
end

function ISLockpickVehicleDoor:update() end

function ISLockpickVehicleDoor:start()
	if self.vehicleDoor:isLockBroken() then
		HaloTextHelper.addBadText(self.character, getText("IGUI_PlayerText_VehicleLockIsBroken"))
		self:forceStop()
	end

	self:setActionAnim("Loot")
end

function ISLockpickVehicleDoor:stop()
	ISBaseTimedAction.stop(self)
end

function ISLockpickVehicleDoor:perform()
	ISBaseTimedAction.perform(self)
end

function ISLockpickVehicleDoor:complete()
	self.vehicleDoor:setLocked(self.needToBeLocked)

	self.vehicle:transmitPartDoor(self.part)

	local lockpickCondition = self.lockpick:getCondition()

	if lockpickCondition == 1 then
		self.character:getInventory():Remove(self.lockpick)
	else
		self.lockpick:setCondition(lockpickCondition - 1)
	end

	return true
end

function ISLockpickVehicleDoor:getDuration()
	local defaultTime = UsefulOccupations.PersonalTraits.Burglar.values.defaultDoorLockpickingTime
	local timeReducePerLvl = UsefulOccupations.PersonalTraits.Burglar.values.reduceDoorLockpickingTime
	local targetPerk = UsefulOccupations.PersonalTraits.Burglar.values.targetLockpickPerk

	local targetPerkLvl = self.character:getPerkLevel(targetPerk)

	return defaultTime - (timeReducePerLvl * targetPerkLvl)
end

---@param character IsoPlayer
---@param part VehiclePart
---@param vehicleDoor VehicleDoor
---@param needToBeLocked boolean
---@param lockpick InventoryItem
function ISLockpickVehicleDoor:new(character, part, vehicleDoor, needToBeLocked, lockpick)
	---@type ISLockpickVehicleDoor
	---@diagnostic disable-next-line: assign-type-mismatch
	local o = ISBaseTimedAction.new(self, character)

	o.vehicle = part:getVehicle()
	o.part = part
	o.vehicleDoor = vehicleDoor
	o.needToBeLocked = needToBeLocked
	o.maxTime = o:getDuration()
	o.lockpick = lockpick

	return o
end
