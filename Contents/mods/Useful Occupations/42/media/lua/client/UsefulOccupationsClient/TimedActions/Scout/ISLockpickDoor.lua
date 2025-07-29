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

---@class ISLockpickDoor : ISBaseTimedAction
---@field character IsoPlayer
---@field door IsoDoor
---@field needToBeLocked boolean
---@field lockpick InventoryItem
---@field maxTime number
ISLockpickDoor = ISBaseTimedAction:derive("ISLockpickDoor")

function ISLockpickDoor:isValid()
	-- if self.door:getProperties():Is("forceLocked") then
	-- 	return false
	-- end

	if self.door:getModData().CustomLock then
		return false
	end

	if not self.lockpick or self.lockpick:getCondition() < 1 then
		return false
	end

	return true
end

function ISLockpickDoor:waitToStart()
	self.character:faceThisObject(self.door)
	return self.character:shouldBeTurning()
end

function ISLockpickDoor:update() end

function ISLockpickDoor:start()
	if self.needToBeLocked == self.door:isLockedByKey() then
		self.character:SayShout(self.needToBeLocked and "Door is already locked" or "Door is already unlocked")
		self:forceStop()
	end

	self:setActionAnim("Loot")
end

function ISLockpickDoor:stop()
	if not self:isValid() then
		self.character:faceThisObject(self.door)
		self.character:getEmitter():playSound("DoorIsLocked")
	end

	ISBaseTimedAction.stop(self)
end

function ISLockpickDoor:getSoundPrefix()
	local sprite = self.door:getSprite()

	if not sprite then
		return
	end

	if sprite:getProperties():Is("DoorSound") then
		return sprite:getProperties():Val("DoorSound")
	end

	return "WoodDoor"
end

function ISLockpickDoor:perform()
	local soundPrefix = self:getSoundPrefix()

	if self.needToBeLocked then
		self.character:getEmitter():playSound(soundPrefix .. "Lock")
	else
		self.character:getEmitter():playSound(soundPrefix .. "Unlock")
	end

	ISBaseTimedAction.perform(self)
end

function ISLockpickDoor:complete()
	if self.needToBeLocked then
		self.door:setLockedByKey(true)
	else
		self.door:setLockedByKey(false)
	end

	---@diagnostic disable-next-line: param-type-mismatch
	self.door:syncIsoObject(false, 0, nil, nil)

	local doubleDoorObjects = buildUtil.getDoubleDoorObjects(self.door)
	for i = 1, #doubleDoorObjects do
		local object = doubleDoorObjects[i]
		object:setLockedByKey(self.needToBeLocked)
		object:syncIsoObject(false, 0, nil, nil)
	end

	local garageDoorObjects = buildUtil.getGarageDoorObjects(self.door)
	for i = 1, #garageDoorObjects do
		local object = garageDoorObjects[i]
		object:setLockedByKey(self.needToBeLocked)
		object:syncIsoObject(false, 0, nil, nil)
	end

	local lockpickCondition = self.lockpick:getCondition()

	if lockpickCondition == 1 then
		self.character:getInventory():Remove(self.lockpick)
	else
		self.lockpick:setCondition(lockpickCondition - 1)
	end

	return true
end

function ISLockpickDoor:getDuration()
	local defaultTime = UsefulOccupations.PersonalTraits.Burglar.values.defaultDoorLockpickingTime
	local timeReducePerLvl = UsefulOccupations.PersonalTraits.Burglar.values.reduceDoorLockpickingTime

	local nimbleLvl = self.character:getPerkLevel(Perks.Nimble)

	return defaultTime - (timeReducePerLvl * nimbleLvl)
end

---@param character IsoPlayer
---@param door IsoDoor
---@param needToBeLocked boolean
---@param lockpick InventoryItem
function ISLockpickDoor:new(character, door, needToBeLocked, lockpick)
	---@type ISLockpickDoor
	---@diagnostic disable-next-line: assign-type-mismatch
	local o = ISBaseTimedAction.new(self, character)

	o.door = door
	o.needToBeLocked = needToBeLocked
	o.maxTime = o:getDuration()
	o.lockpick = lockpick

	return o
end
