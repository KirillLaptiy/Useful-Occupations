--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UO.ArmorPlate.Func
local Func = {}

local clothArmorPlateType = "ClothArmorPlate"
local metalArmorPlateType = "MetalArmorPlate"
local carbonArmorPlateType = "CarbonArmorPlate"

local armorClothingLocations = {
	Back = "ArmorPlate_Back",
	Head = "ArmorPlate_Head",
	Neck = "ArmorPlate_Neck",
	Groin = "ArmorPlate_Groin",
	Torso_Upper = "ArmorPlate_Torso_Upper",
	Torso_Lower = "ArmorPlate_Torso_Lower",
	Hand_L = "ArmorPlate_Hand_L",
	Hand_R = "ArmorPlate_Hand_R",
	ForeArm_L = "ArmorPlate_ForeArm_L",
	ForeArm_R = "ArmorPlate_ForeArm_R",
	UpperArm_L = "ArmorPlate_UpperArm_L",
	UpperArm_R = "ArmorPlate_UpperArm_R",
	UpperLeg_L = "ArmorPlate_UpperLeg_L",
	UpperLeg_R = "ArmorPlate_UpperLeg_R",
	LowerLeg_L = "ArmorPlate_LowerLeg_L",
	LowerLeg_R = "ArmorPlate_LowerLeg_R",
	Foot_L = "ArmorPlate_Foot_L",
	Foot_R = "ArmorPlate_Foot_R",
}

---@class UO.armorPlateType
---@field type string
---@field maxCond number

---@class UO.armorPlateTypes
---@field ClothArmorPlate UO.armorPlateType
---@field MetalArmorPlate UO.armorPlateType
---@field CarbonArmorPlate UO.armorPlateType
local armorPlateTypes = {
	ClothArmorPlate = {
		type = clothArmorPlateType,
		maxCond = 1,
	},

	MetalArmorPlate = {
		type = metalArmorPlateType,
		maxCond = 3,
	},

	CarbonArmorPlate = {
		type = carbonArmorPlateType,
		maxCond = 10,
	},
}

local group = BodyLocations.getGroup("Human")

for _, armorType in pairs(armorClothingLocations) do
	local bodyLocation = BodyLocation.new(group, armorType)
	group:getAllLocations():add(bodyLocation)
end

local itemsToRemove = {}

---@param item Clothing
---@param itemData table
---@param partType string
---@diagnostic disable-next-line: unused-local
local addArmorForBloodType = function(item, itemData, partType)
	local player = getPlayer()

	if armorClothingLocations[partType] and itemData["UOArmorPlates" .. partType] then
		local itemType = "UO." .. armorClothingLocations[partType]

		---@type Clothing
		---@diagnostic disable-next-line: assign-type-mismatch
		local armorClothing = player:getWornItem(armorClothingLocations[partType]) or instanceItem(itemType)

		if armorClothing:getCondition() < armorClothing:getConditionMax() then
			itemData["UOArmorPlates" .. partType] = math.max(0, itemData["UOArmorPlates" .. partType] - 1)
			armorClothing:setCondition(armorClothing:getConditionMax())
		end

		if itemData["UOArmorPlates" .. partType] > 0 then
			player:setWornItem(armorClothing:getBodyLocation(), armorClothing)

			-- handle flating the mohawk!
			if
				player:getHumanVisual():getHairModel():contains("Mohawk")
				and (armorClothing:getBodyLocation() == "Hat" or armorClothing:getBodyLocation() == "FullHat")
			then
				player:getHumanVisual():setHairModel("MohawkFlat")
				player:resetModel()
			end
		else
			itemData["UOArmorPlates" .. partType] = nil
			itemData["UOArmorType" .. partType] = nil
			table.insert(itemsToRemove, armorClothing)
		end
	end
end

local function findKeyByValue(tbl, value)
	for k, v in pairs(tbl) do
		if v == value then
			return k
		end
	end
	return nil
end

---@param wornItems WornItems
local updateWornArmorPlates = function(wornItems)
	for i = 0, wornItems:size() - 1 do
		---@type WornItem
		local wornItem = wornItems:get(i)

		if wornItem then
			---@type Clothing
			---@diagnostic disable-next-line: assign-type-mismatch
			local item = wornItem:getItem()

			if item and item:getType() and item:IsClothing() and not armorClothingLocations[item:getType()] then
				local coveredParts = item:getCoveredParts()

				if coveredParts then
					local itemData = item:getModData()

					for h = 0, coveredParts:size() - 1 do
						local partStr = tostring(coveredParts:get(h))
						addArmorForBloodType(item, itemData, partStr)
					end
				end
			end
		end
	end
end

Func.onClothingUpdated = function()
	-- Adds 1 ms delay to get real character worn items
	UsefulOccupations.Functions.processAfterDelay(1, function()
		local player = getPlayer()
		local wornItems = player:getWornItems()

		-- Calls update first time to update armor condtion
		updateWornArmorPlates(wornItems)

		wornItems = player:getWornItems()

		-- Gets worn armor plates
		for f = 0, wornItems:size() - 1 do
			---@type WornItem
			local wornItem = wornItems:get(f)

			if wornItem then
				---@type Clothing
				---@diagnostic disable-next-line: assign-type-mismatch
				local item = wornItem:getItem()

				if
					item
					and item:getType()
					and item:IsClothing()
					and findKeyByValue(armorClothingLocations, item:getType())
				then
					table.insert(itemsToRemove, item)
				end
			end
		end

		-- Removes worn armor plates
		-- Need to handle cases where a character, for some reason, lacks the target clothing but has armor
		---@param item Clothing
		for _, item in ipairs(itemsToRemove) do
			player:removeWornItem(item)
		end

		-- Clears table for next iteration
		itemsToRemove = {}

		wornItems = player:getWornItems()

		-- Calls update second time after removing worn armor
		updateWornArmorPlates(wornItems)
	end)
end

Events.OnClothingUpdated.Add(Func.onClothingUpdated)
table.insert(UsefulOccupations.DoFuncsOnCreatePlayer, Func.onClothingUpdated)

-- Adding context menu to inspect clothing action
-- Need to add armor plate to clothing
local realDoContextMenu = ISGarmentUI.doContextMenu

-- Adds plates visual in clothing inspenct
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local br, bg, bb =
	getCore():getBadHighlitedColor():getR(),
	getCore():getBadHighlitedColor():getG(),
	getCore():getBadHighlitedColor():getB()
local gr, gg, gb =
	getCore():getGoodHighlitedColor():getR(),
	getCore():getGoodHighlitedColor():getG(),
	getCore():getGoodHighlitedColor():getB()

---@param player IsoPlayer
---@param item Clothing
---@param bodyPartType BodyPartType
---@param armorPlate InventoryItem
---@param partStr string
local addArmorPlate = function(player, item, bodyPartType, armorPlate, partStr)
	local itemData = item:getModData()
	local bodyDamage = getPlayer():getBodyDamage()

	if bodyPartType == BodyPartType.MAX then
		bodyPartType = BodyPartType.Torso_Upper
	end

	local bodyPart = bodyDamage:getBodyPart(bodyPartType)

	local plateType = armorPlateTypes[armorPlate:getType()]

	local onComplete = function()
		-- Can be added sandbox value like "Additional condition"
		itemData["UOArmorPlates" .. partStr] = armorPlate:getCondition()
		itemData["UOArmorType" .. partStr] = plateType.type

		Func.onClothingUpdated()

		player:getInventory():Remove(armorPlate)
	end

	local checkValidity = function()
		local clothingHasArmor = Func.getClothingArmorPlate(itemData, partStr)
		return clothingHasArmor == nil
	end

	---@diagnostic disable-next-line: param-type-mismatch
	ISInventoryPaneContextMenu.transferIfNeeded(player, armorPlate)
	ISTimedActionQueue.add(
		ISChangeArmorPlate:new(player, armorPlate, onComplete, bodyPart, item:isEquipped(), checkValidity)
	)
end

---@param player IsoPlayer
---@param item Clothing
---@param bodyPartType BodyPartType
---@param plateType UO.armorPlateType
---@param partStr string
local removeArmorPlate = function(player, item, bodyPartType, plateType, partStr)
	local itemData = item:getModData()
	local bodyDamage = getPlayer():getBodyDamage()

	if bodyPartType == BodyPartType.MAX then
		bodyPartType = BodyPartType.Torso_Upper
	end

	local bodyPart = bodyDamage:getBodyPart(bodyPartType)

	local plateHealth = itemData["UOArmorPlates" .. partStr]

	local onComplete = function()
		itemData["UOArmorPlates" .. partStr] = nil
		itemData["UOArmorType" .. partStr] = nil

		Func.onClothingUpdated()

		local returnedPlate = player:getInventory():AddItem("UO." .. plateType.type)
		returnedPlate:setCondition(plateHealth)
	end

	local checkValidity = function()
		local clothingHasArmor = Func.getClothingArmorPlate(itemData, partStr)
		return clothingHasArmor ~= nil
	end

	ISTimedActionQueue.add(ISChangeArmorPlate:new(player, nil, onComplete, bodyPart, item:isEquipped(), checkValidity))
end

---@param itemData table
---@param partType string
---@return UO.armorPlateType | nil
Func.getClothingArmorPlate = function(itemData, partType)
	return armorPlateTypes[itemData["UOArmorType" .. partType]]
end

---@param containers ArrayList
---@param plateType string
---@return InventoryItem | nil
local getArmorPlateFromContainers = function(containers, plateType)
	for i = 0, containers:size() - 1 do
		---@type ItemContainer
		local container = containers:get(i):getItemContainer()

		if container then
			local armorPlate = container:getFirstType(plateType)

			if armorPlate then
				return armorPlate
			end
		end
	end

	return nil
end

---@param plateType string
---@return number
local getArmorPlateMaxCond = function(plateType)
	return armorPlateTypes[plateType].maxCond
end

---@diagnostic disable-next-line: duplicate-set-field
function ISGarmentUI:doContextMenu(part, x, y)
	local context = realDoContextMenu(self, part, x, y)

	local armorOpt = context:addOption("Armor plate")
	local armorMenu = context:getNew(context)
	context:addSubMenu(armorOpt, armorMenu)

	local itemData = self.clothing:getModData()
	local partStr = tostring(part)
	local bodyPartType = BodyPartType.FromString(partStr)

	local inventory = getPlayer():getInventory()
	local backpacks = inventory:getAllCategory("Container")

	local sheetPlate = inventory:getFirstType(clothArmorPlateType)
		or getArmorPlateFromContainers(backpacks, clothArmorPlateType)
	local metalPlate = inventory:getFirstType(metalArmorPlateType)
		or getArmorPlateFromContainers(backpacks, metalArmorPlateType)
	local blackMetalPlate = inventory:getFirstType(carbonArmorPlateType)
		or getArmorPlateFromContainers(backpacks, carbonArmorPlateType)

	local sheet = armorMenu:addOption(
		"Add sheet plate",
		self.chr,
		addArmorPlate,
		self.clothing,
		bodyPartType,
		sheetPlate,
		partStr
	)
	local metal = armorMenu:addOption(
		"Add metal plate",
		self.chr,
		addArmorPlate,
		self.clothing,
		bodyPartType,
		metalPlate,
		partStr
	)
	local blackMetal = armorMenu:addOption(
		"Add black-metal plate",
		self.chr,
		addArmorPlate,
		self.clothing,
		bodyPartType,
		blackMetalPlate,
		partStr
	)

	if not sheetPlate then
		local tooltip = ISInventoryPaneContextMenu.addToolTip()
		tooltip.description = getText("Tooltip_NeedSheetPlate")

		sheet.notAvailable = true
		sheet.toolTip = tooltip
	end

	if not metalPlate then
		local tooltip = ISInventoryPaneContextMenu.addToolTip()
		tooltip.description = getText("Tooltip_NeedMetalPlate")

		metal.notAvailable = true
		metal.toolTip = tooltip
	end

	if not blackMetalPlate then
		local tooltip = ISInventoryPaneContextMenu.addToolTip()
		tooltip.description = getText("Tooltip_NeedBlackMetalPlate")

		blackMetal.notAvailable = true
		blackMetal.toolTip = tooltip
	end

	local clothingArmorPlate = Func.getClothingArmorPlate(itemData, partStr)
	local removeOpt = armorMenu:addOption(
		"Remove armor plate",
		self.chr,
		removeArmorPlate,
		self.clothing,
		bodyPartType,
		clothingArmorPlate,
		partStr
	)

	if clothingArmorPlate then
		local tooltip = ISInventoryPaneContextMenu.addToolTip()
		tooltip.description = getText("Tooltip_AlreadyHavePlate")

		sheet.notAvailable = true
		metal.notAvailable = true
		blackMetal.notAvailable = true

		sheet.toolTip = tooltip
		metal.toolTip = tooltip
		blackMetal.toolTip = tooltip
	else
		local tooltip = ISInventoryPaneContextMenu.addToolTip()
		tooltip.description = getText("Tooltip_NoClothingArmorPlate")

		removeOpt.notAvailable = true
		removeOpt.toolTip = tooltip
	end

	return context
end

---@diagnostic disable-next-line: duplicate-set-field, unused-local
function ISGarmentUI:doDrawItem(y, item, alt)
	local part = item.item
	local partType = tostring(part)

	---@diagnostic disable-next-line: undefined-field
	local parent = self.parent

	---@type Clothing
	local clothing = parent.clothing

	local armorPlate = clothing:getModData()["UOArmorType" .. partType]

	local biteDef = clothing:getDefForPart(part, true, false)
	local scratchDef = clothing:getDefForPart(part, false, false)
	local bulletDef = clothing:getDefForPart(part, false, true)

	---@diagnostic disable-next-line: undefined-field
	if item.itemindex == self.selected then
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawRect(0, y, self:getWidth(), item.height, 0.2, 1.0, 1.0, 1.0)
	---@diagnostic disable-next-line: undefined-field
	elseif item.itemindex == self.mouseoverselected then
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawRect(0, y, self:getWidth(), item.height, 0.1, 1.0, 1.0, 1.0)
	end

	---@diagnostic disable-next-line: param-type-mismatch
	self:drawText(part:getDisplayName(), 0, y, 1, 1, 1, 1, UIFont.Small)
	---@diagnostic disable-next-line: param-type-mismatch
	self:drawText(
		armorPlate and biteDef < 100 and "100%" or biteDef .. "%",
		parent.biteColumn - self.x,
		y,
		armorPlate and gr or 1,
		armorPlate and gg or 1,
		armorPlate and gb or 1,
		1,
		UIFont.Small
	)
	---@diagnostic disable-next-line: param-type-mismatch
	self:drawText(
		armorPlate and scratchDef < 100 and "100%" or scratchDef .. "%",
		parent.scratchColumn - self.x,
		y,
		armorPlate and gr or 1,
		armorPlate and gg or 1,
		armorPlate and gb or 1,
		1,
		UIFont.Small
	)
	---@diagnostic disable-next-line: param-type-mismatch
	self:drawText(
		armorPlate and bulletDef < 100 and "100%" or bulletDef .. "%",
		parent.bulletColumn - self.x,
		y,
		armorPlate and gr or 1,
		armorPlate and gg or 1,
		armorPlate and gb or 1,
		1,
		UIFont.Small
	)

	if clothing:getVisual():getHole(part) > 0 then
		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(getText("IGUI_garment_Hole"), 10, y, br, bg, bb, 1, UIFont.Small)
	end

	if clothing:getBloodlevelForPart(part) > 0 then
		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(
			getText("IGUI_garment_Blood") .. round(clothing:getBloodlevelForPart(part) * 100, 0) .. "%",
			10,
			y,
			br,
			bg,
			bb,
			1,
			UIFont.Small
		)
	end

	local patch = clothing:getPatchType(part)

	if patch then
		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(
			"- " .. getText("IGUI_TypeOfPatch", patch:getFabricTypeName()),
			10,
			y,
			gr,
			gg,
			gb,
			1,
			UIFont.Small
		)
	end

	-- Adds armor plate info
	if armorPlate then
		local armorPlateCond = clothing:getModData()["UOArmorPlates" .. partType]
		local maxCond = getArmorPlateMaxCond(armorPlate)

		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(getText("Armor Plate: "), 10, y, 0.7, 0.7, 0.7, 1, UIFont.Small)
		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(getText("Type: ") .. armorPlate, 10, y, 0.7, 0.7, 0.7, 1, UIFont.Small)

		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(getText("Durability:"), 10, y, 0.7, 0.7, 0.7, 1, UIFont.Small)

		local textWidth = getTextManager():MeasureStringX(UIFont.Small, getText("Durability:"))
		local armorText = armorPlateCond .. " / " .. tostring(maxCond)

		local fraction = armorPlateCond / maxCond

		local r, g, b = 1, 1, 0

		if fraction > 0.5 then
			r = (1 - fraction) * 2
		else
			g = fraction * 2
		end

		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(armorText, 10 + textWidth + 5, y, r, g, b, 1, UIFont.Small)
	end

	local x = 10
	local fgBar = { r = 0.5, g = 0.5, b = 0.5, a = 0.5 }
	local garmentUI = parent
	local bodyPartAction = garmentUI.bodyPartAction and garmentUI.bodyPartAction[part] or nil
	if bodyPartAction then
		y = y + FONT_HGT_SMALL
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawProgressBar(x, y, self.width - 10 - x, FONT_HGT_SMALL, bodyPartAction.delta, fgBar)
		---@diagnostic disable-next-line: param-type-mismatch
		self:drawText(bodyPartAction.jobType, x + 4, y, 0.8, 0.8, 0.8, 1, UIFont.Small)
	else
		local actionQueue = ISTimedActionQueue.getTimedActionQueue(garmentUI.chr)
		if
			actionQueue
			and actionQueue.queue
			and garmentUI.actionToBodyPart
			and (garmentUI.actionToBodyPart[actionQueue.queue[1]] == part)
		then
			y = y + FONT_HGT_SMALL
			---@diagnostic disable-next-line: param-type-mismatch
			self:drawProgressBar(x, y, self.width - 10 - x, FONT_HGT_SMALL, actionQueue.queue[1]:getJobDelta(), fgBar)
			---@diagnostic disable-next-line: param-type-mismatch
			self:drawText(actionQueue.queue[1].jobType or "???", x + 4, y, 0.8, 0.8, 0.8, 1, UIFont.Small) -- jobType is a hack for CraftingUI and ISHealthPanel also
		end
	end

	return y + FONT_HGT_SMALL
end
