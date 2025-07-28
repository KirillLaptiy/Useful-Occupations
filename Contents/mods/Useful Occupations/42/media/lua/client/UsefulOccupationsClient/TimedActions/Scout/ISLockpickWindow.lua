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

---@class ISLockpickWindow : ISBaseTimedAction
---@field character IsoPlayer
---@field window IsoWindow
---@field needToBeLocked boolean
---@field lockpick InventoryItem
---@field maxTime number
ISLockpickWindow = ISBaseTimedAction:derive("ISLockpickWindow")

function ISLockpickWindow:isValid()
	if not self.lockpick or self.lockpick:getCondition() < 1 then
		return false
	end

	if self.window:isSmashed() then
		return false
	end

	if self.window:isPermaLocked() then
		return false
	end

	return true
end

function ISLockpickWindow:waitToStart()
	self.character:faceThisObject(self.window)
	return self.character:shouldBeTurning()
end

function ISLockpickWindow:update() end

function ISLockpickWindow:start()
	if self.window:IsOpen() then
		self.character:SayShout("Window must be closed!")
		self:forceStop()
	end

	if self.needToBeLocked == self.window:isLocked() then
		self.character:SayShout(self.needToBeLocked and "Window is already locked" or "Window is already unlocked")
		self:forceStop()
	end

	self:setActionAnim("Loot")
end

function ISLockpickWindow:stop()
	if not self:isValid() then
		self.character:faceThisObject(self.window)
	end

	ISBaseTimedAction.stop(self)
end

function ISLockpickWindow:perform()
	ISBaseTimedAction.perform(self)
end

function ISLockpickWindow:complete()
	if self.needToBeLocked then
		self.window:setIsLocked(true)
	else
		self.window:setIsLocked(false)
	end

	---@diagnostic disable-next-line: param-type-mismatch
	self.window:syncIsoObject(false, 0, nil, nil)

	local lockpickCondition = self.lockpick:getCondition()

	if lockpickCondition == 1 then
		self.character:getInventory():Remove(self.lockpick)
	else
		self.lockpick:setCondition(lockpickCondition - 1)
	end

	return true
end

function ISLockpickWindow:getDuration()
	local defaultTime = UsefulOccupations.PersonalTraits.Burglar.values.defaultDoorLockpickingTime
	local timeReducePerLvl = UsefulOccupations.PersonalTraits.Burglar.values.reduceDoorLockpickingTime

	local nimbleLvl = self.character:getPerkLevel(Perks.Nimble)

	return defaultTime - (timeReducePerLvl * nimbleLvl)
end

---@param character IsoPlayer
---@param window IsoWindow
---@param needToBeLocked boolean
---@param lockpick InventoryItem
function ISLockpickWindow:new(character, window, needToBeLocked, lockpick)
	---@type ISLockpickWindow
	---@diagnostic disable-next-line: assign-type-mismatch
	local o = ISBaseTimedAction.new(self, character)

	o.window = window
	o.needToBeLocked = needToBeLocked
	o.maxTime = o:getDuration()
	o.lockpick = lockpick

	return o
end
