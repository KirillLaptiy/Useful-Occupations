--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class some
local Func = {}

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

local group = BodyLocations.getGroup("Human")

for _, armorType in pairs(armorClothingLocations) do
	local bodyLocation = BodyLocation.new(group, armorType)
	group:getAllLocations():add(bodyLocation)
end

local itemsToRemove = {}

---@param item Clothing
---@param armorData table
---@param partType string
---@param plateStrength number | nil
local addArmorForBloodType = function(item, armorData, partType, plateStrength)
	local player = getPlayer()
	local inventoty = player:getInventory()

	if armorClothingLocations[partType] then
		-- TEST
		if plateStrength then
			print("ADDING PLATE")
			armorData["UOArmorPlates" .. partType] = plateStrength
		end

		if not armorData["UOArmorPlates" .. partType] then
			return
		end

		local itemType = "UO." .. armorClothingLocations[partType]

		-- print(item:getType())
		-- print(itemType)
		-- print(armorData["UOArmorPlates" .. partType])

		-- ---@type Clothing
		-- local armorClothing = inventoty:getItemFromType(itemType)

		---@type Clothing
		local armorClothing = player:getWornItem(armorClothingLocations[partType]) or instanceItem(itemType)

		-- print(armorClothing)

		-- if armorClothing then
		-- 	print(armorClothing:getType())
		-- end

		-- if not armorClothing then
		-- if armorData["UOArmorPlates" .. partType] then
		-- 	armorData["UOArmorPlates" .. partType] = math.max(0, armorData["UOArmorPlates" .. partType] - 1)
		-- end

		-- if armorData["UOArmorPlates" .. partType] > 0 then
		-- 	print("ADDING NEW ARMOR!")
		-- 	armorClothing = inventoty:AddItem(itemType)
		-- end

		-- 	armorClothing = inventoty:AddItem(itemType)
		-- end

		-- if armorClothing then
		-- if armorClothing:isBroken() then
		-- 	armorClothing:Remove()

		-- 	if armorData["UOArmorPlates" .. partType] then
		-- 		armorData["UOArmorPlates" .. partType] = math.max(0, armorData["UOArmorPlates" .. partType] - 1)
		-- 	end

		-- 	if armorData["UOArmorPlates" .. partType] > 0 then
		-- 		print("CHANGING BROKEN ARMOR!")
		-- 		armorClothing = inventoty:AddItem(itemType)
		-- 	end
		-- end

		-- print(armorClothing:getType())
		-- print(armorClothing:getCondition())

		if armorClothing:getCondition() < armorClothing:getConditionMax() then
			armorData["UOArmorPlates" .. partType] = math.max(0, armorData["UOArmorPlates" .. partType] - 1)
			armorClothing:setCondition(armorClothing:getConditionMax())
		end

		-- if armorClothing:getHolesNumber() > 0 then
		-- 	armorData["UOArmorPlates" .. partType] = math.max(0, armorData["UOArmorPlates" .. partType] - 1)

		-- 	for s = 0, BloodBodyPartType.MAX:index() - 1 do
		-- 		item:getVisual():removeHole(s)
		-- 	end

		-- 	print("FIXING ARMOR HOLES!")

		-- 	item:setCondition(item:getConditionMax())
		-- end

		if armorData["UOArmorPlates" .. partType] > 0 then
			player:setWornItem(armorClothing:getBodyLocation(), armorClothing)

			-- here we handle flating the mohawk!
			if
				player:getHumanVisual():getHairModel():contains("Mohawk")
				and (armorClothing:getBodyLocation() == "Hat" or armorClothing:getBodyLocation() == "FullHat")
			then
				player:getHumanVisual():setHairModel("MohawkFlat")
				player:resetModel()
			end
		else
			armorData["UOArmorPlates" .. partType] = nil
			table.insert(itemsToRemove, armorClothing)
		end
		-- end
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
			local item = wornItem:getItem()

			if item and item:getType() and item:IsClothing() and not armorClothingLocations[item:getType()] then
				local coveredParts = item:getCoveredParts()

				if coveredParts then
					local armorData = item:getModData()

					for h = 0, coveredParts:size() - 1 do
						local partStr = tostring(coveredParts:get(h))
						addArmorForBloodType(item, armorData, partStr)
					end
				end
			end
		end
	end
end

---@param _ IsoPlayer
Func.onClothingUpdated = function(_)
	-- Adds 1 ms delay to get real character worn items
	UsefulOccupations.Functions.processAfterDelay(1, function()
		local player = getPlayer()
		local wornItems = player:getWornItems()

		updateWornArmorPlates(wornItems)

		wornItems = player:getWornItems()

		-- Gets worn armor plates
		for f = 0, wornItems:size() - 1 do
			---@type WornItem
			local wornItem = wornItems:get(f)

			if wornItem then
				---@type Clothing
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

		-- Removes broken worn armor plates
		---@param item Clothing
		for _, item in ipairs(itemsToRemove) do
			player:removeWornItem(item)
		end

		-- Clears table for next iteration
		itemsToRemove = {}

		wornItems = player:getWornItems()

		updateWornArmorPlates(wornItems)
	end)
end

UsefulOccupations.Functions.processEveryMs(3000, function()
	local player = getPlayer()
	local wornItems = player:getWornItems()

	for f = 0, wornItems:size() - 1 do
		---@type WornItem
		local wornItem = wornItems:get(f)

		if wornItem then
			---@type Clothing
			local item = wornItem:getItem()

			print(item:getType())
		end
	end
end)

Events.OnClothingUpdated.Add(Func.onClothingUpdated)
Events.OnCreatePlayer.Add(Func.onClothingUpdated)

-- Adding context menu to inspect clothing action
-- Need to add armor plate to clothing
local realDoPatch = ISGarmentUI.doPatch

---@param player IsoPlayer
---@param clothing Clothing
---@param part BodyPartType
---@param plateStrength number
local addArmorPlate = function(player, clothing, part, plateStrength)
	addArmorForBloodType(clothing, clothing:getModData(), tostring(part), plateStrength)
end

---@diagnostic disable-next-line: duplicate-set-field
function ISGarmentUI:doPatch(fabric, thread, needle, part, context, submenu)
	local oursubmenu = realDoPatch(self, fabric, thread, needle, part, context, submenu)

	local armorOpt = context:addOption("Add armor plate")
	local armorMenu = context:getNew(context)
	context:addSubMenu(armorOpt, armorMenu)

	armorMenu:addOption("Weak plate", self.chr, addArmorPlate, self.clothing, part, 1)
	armorMenu:addOption("Medium plate", self.chr, addArmorPlate, self.clothing, part, 3)
	armorMenu:addOption("Strong plate", self.chr, addArmorPlate, self.clothing, part, 10)

	return oursubmenu
end

-- local Func = {}

-- ---@param player IsoPlayer
-- ---@param item Clothing
-- Func.addArmorPlate = function(player, item)
-- 	Func.removeHoles(item, player)

-- 	local modData = item:getModData()

-- 	modData.origScratchDef = item:getScratchDefense()
-- 	modData.origBiteDef = item:getBiteDefense()
-- 	modData.origBulletDef = item:getBulletDefense()

-- 	modData.UOArmorPlates = modData.UOArmorPlates + 1

-- 	if item:getScratchDefense() < 100 then
-- 		item:setScratchDefense(100)
-- 	end

-- 	if item:getBiteDefense() < 100 then
-- 		item:setBiteDefense(100)
-- 	end

-- 	if item:getBulletDefense() < 100 then
-- 		item:setBulletDefense(100)
-- 	end
-- end

-- ---@param _ IsoPlayer | nil
-- ---@param item Clothing
-- Func.removeArmorPlate = function(_, item)
-- 	local modData = item:getModData()

-- 	modData.UOArmorPlates = 0

-- 	item:setScratchDefense(modData.origScratchDef)
-- 	item:setBiteDefense(modData.origBiteDef)
-- 	item:setBulletDefense(modData.origBulletDef)
-- end

-- ---@param item Clothing
-- ---@param player IsoPlayer
-- Func.removeHoles = function(item, player)
-- 	local modData = item:getModData()

-- 	modData.UOArmorPlates = math.max(0, modData.UOArmorPlates - 1)

-- 	if modData.UOArmorPlates == 0 then
-- 		Func.removeArmorPlate(nil, item)
-- 	end

-- 	for i = 0, BloodBodyPartType.MAX:index() - 1 do
-- 		item:getVisual():removeHole(i)
-- 	end

-- 	item:setCondition(item:getConditionMax())

-- 	player:resetModel()
-- end

-- ---@param player IsoPlayer
-- Func.onClothingUpdated = function(player)
-- 	UsefulOccupations.Functions.processAfterDelay(1, function()
-- 		local inventory = player:getInventory()
-- 		local items = inventory:getItems()

-- 		for i = 0, items:size() - 1 do
-- 			---@type Clothing
-- 			local item = items:get(i)

-- 			local itemdata = item:getModData()

-- 			if item:IsClothing() and item:getHolesNumber() > 0 and itemdata.UOArmorPlates > 0 then
-- 				Func.removeHoles(item, player)
-- 			end
-- 		end
-- 	end)
-- end

-- ---@param playerObj IsoPlayer
-- ---@param clothing Clothing
-- ---@param hasArmorPlate boolean
-- Func.createArmorPlateOptions = function(playerObj, clothing, hasArmorPlate)
-- 	local option = hasArmorPlate and Func.removeArmorPlate or Func.addArmorPlate

-- 	if luautils.haveToBeTransfered(playerObj, clothing) then
-- 		local action =
-- 			ISInventoryTransferAction:new(playerObj, clothing, clothing:getContainer(), playerObj:getInventory())

-- 		action:setOnComplete(option, playerObj, clothing)

-- 		ISTimedActionQueue.add(action)
-- 	else
-- 		option(playerObj, clothing)
-- 	end
-- end

-- local oldInvCreateMenu = ISInventoryPaneContextMenu.createMenu

-- -- Create context option to add "Armor plate" to clothing
-- ---@diagnostic disable-next-line: duplicate-set-field
-- ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
-- 	---@type ISContextMenu
-- 	local context = oldInvCreateMenu(player, isInPlayerInventory, items, x, y, origin)

-- 	if context then
-- 		local playerObj = getSpecificPlayer(player)

-- 		---@type Clothing | nil
-- 		local clothingItem

-- 		-- Get last clothing item in stack
-- 		for _, v in ipairs(items) do
-- 			local testItem = v

-- 			if not instanceof(v, "InventoryItem") then
-- 				testItem = v.items[1]
-- 			end

-- 			if testItem:getCategory() == "Clothing" then
-- 				clothingItem = testItem
-- 			end
-- 		end

-- 		if clothingItem then
-- 			local itemdata = clothingItem:getModData()

-- 			itemdata.UOArmorPlates = itemdata.UOArmorPlates or 0

-- 			local hasArmorPlate = itemdata.UOArmorPlates > 0

-- 			local text = getText(hasArmorPlate and "IGUI_Remove_Armor_Plate" or "IGUI_Add_Armor_Plate")

-- 			context:addOption(text, playerObj, Func.createArmorPlateOptions, clothingItem, hasArmorPlate)
-- 		end
-- 	end
-- end

-- Events.OnClothingUpdated.Add(Func.onClothingUpdated)

-- group:getOrCreateLocation("Some_Group")

-- ---@param player IsoPlayer
-- ---@param item Clothing
-- Func.addArmorPlate = function(player, item)
-- 	Func.removeHoles(item, player)

-- 	local modData = item:getModData()

-- 	modData.origScratchDef = item:getScratchDefense()
-- 	modData.origBiteDef = item:getBiteDefense()
-- 	modData.origBulletDef = item:getBulletDefense()

-- 	modData.UOArmorPlates = modData.UOArmorPlates + 1

-- 	if item:getScratchDefense() < 100 then
-- 		item:setScratchDefense(100)
-- 	end

-- 	if item:getBiteDefense() < 100 then
-- 		item:setBiteDefense(100)
-- 	end

-- 	if item:getBulletDefense() < 100 then
-- 		item:setBulletDefense(100)
-- 	end
-- end

-- ---@param player IsoPlayer
-- ---@param item Clothing
-- Func.removeArmorPlate = function(player, item)
-- 	local modData = item:getModData()

-- 	modData.UOArmorPlates = 0

-- 	print("REMOVING PLATE")

-- 	-- local wornItem = player:getWornItem("FimozBodyLocation")

-- 	-- player:removeWornItem(wornItem)
-- end

-- ---@param item Clothing
-- ---@param player IsoPlayer
-- Func.removeHoles = function(item, player)
-- 	local modData = item:getModData()

-- 	print(item:getType())
-- 	print("ZATERPELA")
-- 	print(modData.UOArmorPlates)
-- 	print(item:getCondition())

-- 	modData.UOArmorPlates = math.max(0, modData.UOArmorPlates - 1)

-- 	if modData.UOArmorPlates == 0 then
-- 		Func.removeArmorPlate(player, item)
-- 	end

-- 	for i = 0, BloodBodyPartType.MAX:index() - 1 do
-- 		item:getVisual():removeHole(i)
-- 	end

-- 	item:setCondition(item:getConditionMax())

-- 	player:resetModel()
-- end

-- ---@param playerObj IsoPlayer
-- ---@param clothing Clothing
-- ---@param hasArmorPlate boolean
-- Func.createArmorPlateOptions = function(playerObj, clothing, hasArmorPlate)
-- 	local option = hasArmorPlate and Func.removeArmorPlate or Func.addArmorPlate

-- 	if luautils.haveToBeTransfered(playerObj, clothing) then
-- 		local action =
-- 			ISInventoryTransferAction:new(playerObj, clothing, clothing:getContainer(), playerObj:getInventory())

-- 		action:setOnComplete(option, playerObj, clothing)

-- 		ISTimedActionQueue.add(action)
-- 	else
-- 		option(playerObj, clothing)
-- 	end
-- end

-- local oldInvCreateMenu = ISInventoryPaneContextMenu.createMenu

-- Create context option to add "Armor plate" to clothing
-- ---@diagnostic disable-next-line: duplicate-set-field
-- ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
-- 	---@type ISContextMenu
-- 	local context = oldInvCreateMenu(player, isInPlayerInventory, items, x, y, origin)

-- 	-- if context then
-- 	-- 	local playerObj = getSpecificPlayer(player)

-- 	-- 	---@type Clothing | nil
-- 	-- 	local clothingItem

-- 	-- 	-- Get last clothing item in stack
-- 	-- 	for _, v in ipairs(items) do
-- 	-- 		local testItem = v

-- 	-- 		if not instanceof(v, "InventoryItem") then
-- 	-- 			testItem = v.items[1]
-- 	-- 		end

-- 	-- 		if testItem:getCategory() == "Clothing" then
-- 	-- 			clothingItem = testItem
-- 	-- 		end
-- 	-- 	end

-- 	-- 	if clothingItem then
-- 	-- 		local inventoty = playerObj:getInventory()

-- 	-- 		local affectParts = clothingItem:getBloodClothingType()

-- 	-- 		if not affectParts then
-- 	-- 			return
-- 	-- 		end

-- 			-- for i = 0, affectParts:size() - 1 do
-- 			-- 	---@type BloodClothingType
-- 			-- 	local bloodLocation = affectParts:get(i)

-- 			-- 	if armorClothingLocations[bloodLocation] then
-- 			-- 		print("ARMOR FOUND!")

-- 			-- 		local armorClothing = inventoty:getItemFromType("UO." .. armorClothingLocations[bloodLocation])

-- 			-- 		if not armorClothing then
-- 			-- 			armorClothing = inventoty:AddItem("UO." .. armorClothingLocations[bloodLocation])
-- 			-- 		end

-- 			-- 		armorClothing:getModData().UOArmorPlates = 10

-- 			-- 		playerObj:setWornItem(armorClothing:getBodyLocation(), armorClothing)

-- 			-- 		-- here we handle flating the mohawk!
-- 			-- 		if
-- 			-- 			playerObj:getHumanVisual():getHairModel():contains("Mohawk")
-- 			-- 			and (armorClothing:getBodyLocation() == "Hat" or armorClothing:getBodyLocation() == "FullHat")
-- 			-- 		then
-- 			-- 			playerObj:getHumanVisual():setHairModel("MohawkFlat")
-- 			-- 			playerObj:resetModel()
-- 			-- 		end
-- 			-- 	end
-- 			-- end

-- 			---@type Clothing
-- 			-- local fimoz = instanceItem("UO.Fimoz_FI")

-- 			-- for _, type in pairs(armorClothingLocations) do
-- 			-- 	local armorClothing = inventoty:getItemFromType("UO." .. type)

-- 			-- 	if not armorClothing then
-- 			-- 		armorClothing = inventoty:AddItem("UO." .. type)
-- 			-- 	end

-- 			-- 	armorClothing:getModData().UOArmorPlates = 10

-- 			-- 	playerObj:setWornItem(armorClothing:getBodyLocation(), armorClothing)

-- 			-- 	-- here we handle flating the mohawk!
-- 			-- 	if
-- 			-- 		playerObj:getHumanVisual():getHairModel():contains("Mohawk")
-- 			-- 		and (armorClothing:getBodyLocation() == "Hat" or armorClothing:getBodyLocation() == "FullHat")
-- 			-- 	then
-- 			-- 		playerObj:getHumanVisual():setHairModel("MohawkFlat")
-- 			-- 		playerObj:resetModel()
-- 			-- 	end
-- 			-- end
-- 	-- 	end
-- 	-- end
-- end