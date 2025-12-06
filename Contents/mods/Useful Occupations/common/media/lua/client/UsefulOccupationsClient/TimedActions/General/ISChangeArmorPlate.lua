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

---@class ISChangeArmorPlate : ISBaseTimedAction
---@field character IsoPlayer
---@field armorPlate InventoryItem | nil
---@field armorPlateType string | nil
---@field onComplete function
---@field bodyPart BodyPart
---@field isClothingEquipped boolean
---@field checkValidity function
ISChangeArmorPlate = ISBaseTimedAction:derive("ISChangeArmorPlate")

function ISChangeArmorPlate:isValid()
	if self.armorPlate and not self.character:getInventory():getFirstType(self.armorPlateType) then
		return false
	end

	return self.checkValidity()
end

function ISChangeArmorPlate:update() end

function ISChangeArmorPlate:start()
	if self.isClothingEquipped then
		self:setActionAnim(CharacterActionAnims.Bandage)
		self:setAnimVariable("BandageType", ISHealthPanel.getBandageType(self.bodyPart))
	else
		self:setActionAnim("Loot")
	end
end

function ISChangeArmorPlate:stop()
	ISBaseTimedAction.stop(self)
end

function ISChangeArmorPlate:perform()
	ISBaseTimedAction.perform(self)
end

function ISChangeArmorPlate:complete()
	self.onComplete()
	return true
end

function ISChangeArmorPlate:getDuration()
	return 500
end

---@param character IsoPlayer
---@param armorPlate InventoryItem | nil
---@param onComplete function
---@param bodyPart BodyPart
---@param isClothingEquipped boolean
---@param checkValidity function
function ISChangeArmorPlate:new(character, armorPlate, onComplete, bodyPart, isClothingEquipped, checkValidity)
	---@type ISChangeArmorPlate
	---@diagnostic disable-next-line: assign-type-mismatch
	local o = ISBaseTimedAction.new(self, character)

	o.armorPlate = armorPlate
	o.armorPlateType = armorPlate and armorPlate:getType() or nil
	o.maxTime = o:getDuration()
	o.onComplete = onComplete
	o.bodyPart = bodyPart
	o.isClothingEquipped = isClothingEquipped
	o.checkValidity = checkValidity
	o.stopOnWalk = not isClothingEquipped

	return o
end
