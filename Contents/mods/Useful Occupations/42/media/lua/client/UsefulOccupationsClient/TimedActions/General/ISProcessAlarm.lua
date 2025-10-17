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

---@class ISCheckAlarm : ISBaseTimedAction
---@field character IsoPlayer
---@field obj IsoDoor | IsoWindow
---@field isCheckingAlarm boolean
---@field needToBeAlarmed boolean
---@field alarmController InventoryItem
---@field buildingDef BuildingDef
---@field maxTime number
ISProcessAlarm = ISBaseTimedAction:derive("ISCheckAlarm")

function ISProcessAlarm:isValid()
	return self.alarmController:getCurrentUses() > 0
end

function ISProcessAlarm:update() end

function ISProcessAlarm:start()
	self:setActionAnim("Loot")
end

function ISProcessAlarm:stop()
	ISBaseTimedAction.stop(self)
end

function ISProcessAlarm:perform()
	ISBaseTimedAction.perform(self)
end

function ISProcessAlarm:complete()
	if self.isCheckingAlarm then
		HaloTextHelper.addText(self.character, self.buildingDef:isAlarmed() and "Has alarm" or "No alarm")
	else
		self.buildingDef:setAlarmed(self.needToBeAlarmed)
		self.alarmController:Use()
		HaloTextHelper.addText(self.character, self.buildingDef:isAlarmed() and "Alarm added" or "Alarm removed")
	end

	return true
end

function ISProcessAlarm:getDuration()
	return self.isCheckingAlarm and 200 or 500
end

---@param character IsoPlayer
---@param obj IsoDoor | IsoWindow
---@param isCheckingAlarm boolean
---@param needToBeAlarmed boolean
---@param alarmController InventoryItem
---@param buildingDef BuildingDef
function ISProcessAlarm:new(character, obj, isCheckingAlarm, needToBeAlarmed, alarmController, buildingDef)
	---@type ISCheckAlarm
	---@diagnostic disable-next-line: assign-type-mismatch
	local o = ISBaseTimedAction.new(self, character)

	o.obj = obj
	o.isCheckingAlarm = isCheckingAlarm
	o.needToBeAlarmed = needToBeAlarmed
	o.alarmController = alarmController
	o.buildingDef = buildingDef
	o.maxTime = o:getDuration()

	return o
end
