-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

-- local itemType = "ThermoModule"
-- local warmMode = "warm"
-- local coldMode = "cold"

-- ---@param container ItemContainer
-- local tryGetThermoModule = function(container)
-- 	local allItems = container:getAllType(itemType)

-- 	for i = 0, allItems:size() - 1 do
-- 		---@type DrainableComboItem
-- 		local item = allItems:get(i)

-- 		if item and item:getCurrentUses() > 0 then
-- 			return item
-- 		end
-- 	end

-- 	return nil
-- end

-- ---@param player IsoPlayer
-- ---@param thermoModule DrainableComboItem
-- local processThermoMode = function(player, thermoModule)
-- 	local thermoMode = thermoModule:getModData().UOThermoMode
-- 	local temperature = player:getTemperature()

-- 	thermoModule:Use()

-- 	if thermoMode == warmMode then
-- 		player:setTemperature(temperature + 0.1)
-- 	else
-- 		player:setTemperature(temperature - 0.1)
-- 	end
-- end

-- local updateThermoModule = function()
-- 	local player = getPlayer()
-- 	local inv = player:getInventory()
-- 	local thermoModule = tryGetThermoModule(inv)

-- 	if thermoModule then
-- 		processThermoMode(player, thermoModule)
-- 	end
-- end

-- Events.OnCreatePlayer.Add(function(_, _)
-- 	UsefulOccupations.Functions.processEveryMs(3000, updateThermoModule)
-- end)

-- Events.OnPreFillInventoryObjectContextMenu.Add(function (playerNum, context, items)
--     print(items)
-- end)