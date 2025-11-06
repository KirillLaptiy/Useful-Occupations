--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Engineer
---@param _ IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Engineer = function(_)
	-- local PACK_TAG = "UO_MRE_PACK"
	-- local SEALED_TAG = "UO_MRE_SEALED"

	-- local oldCreateMenu = ISInventoryPaneContextMenu.createMenu

	-- ---@param MREPack InventoryItem
	-- ---@param player IsoPlayer
	-- local function restoreMREPack(MREPack, player)
	-- 	local modData = MREPack:getModData()
	-- 	if not modData.MREItems then
	-- 		return
	-- 	end

	-- 	for i, storedItem in ipairs(modData.MREItems) do
	-- 		---@type Food
	-- 		local item = player:getInventory():AddItem(storedItem.type)

	-- 		item:setHungChange(100)
	-- 		item:setUnhappyChange(0)

	-- 		print(item:getModData().FIMOZ)
	-- 	end
	-- end

	-- ---@param item HandWeapon
	-- local function sealMREPack(_, item)
	-- 	-- restoreMREPack(item, getPlayer())
	--     print(item:getName())
	--     print(item:getDisplayName())
	--     print(item:getEntityDisplayName())
	--     print(item:getAlternateModelName())
	--     print(item:getModName())
	--     print(item:getFileName())
	--     print(item:getClothingItemName())
	-- 	-- print(123)
	-- end

	-- ---@diagnostic disable-next-line: duplicate-set-field
	-- ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
	-- 	---@type ISContextMenu | nil
	-- 	local context = oldCreateMenu(player, isInPlayerInventory, items, x, y, origin)

	-- 	if context == nil then
	-- 		return context
	-- 	end

	-- 	for _, v in ipairs(items) do
	-- 		---@type InventoryItem
	-- 		local item = v

	-- 		if not instanceof(v, "InventoryItem") then
	-- 			item = v.items[1]
	-- 		end

	-- 		context:addOption("FIMOZ", items, sealMREPack, item)
	-- 	end
	-- end
end
