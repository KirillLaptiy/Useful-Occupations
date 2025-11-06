--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- Hard cooking items
---@class UO.HardCookingItem
---@field module string
---@field cookable string
---@field notCookable string

local oldTransfer = ISTransferAction.transferItem

local hardCookingItems = {
	{ module = "UO", cookable = "MetalAdapter", notCookable = "MetalAdapterCantCook" },
}

---@param itemType string
---@return UO.HardCookingItem | nil
local tryGetHardCookingItem = function(itemType)
	for _, hardCookingItem in ipairs(hardCookingItems) do
		if itemType == hardCookingItem.cookable or itemType == hardCookingItem.notCookable then
			return hardCookingItem
		end
	end

	return nil
end

---@param container ItemContainer
local isDestContainerValid = function(container)
	local isValidStove = container:isStove() and not container:isMicrowave()
	return container:getType() == "campfire" or isValidStove
end

---@param character IsoPlayer
---@param item InventoryItem
---@param srcContainer ItemContainer
---@param destContainer ItemContainer
---@param dropSquare IsoGridSquare
---@diagnostic disable-next-line: duplicate-set-field
function ISTransferAction:transferItem(character, item, srcContainer, destContainer, dropSquare)
	oldTransfer(self, character, item, srcContainer, destContainer, dropSquare)

	local itemType = item:getType()
	local hardCookingItem = tryGetHardCookingItem(itemType)

	if not hardCookingItem then
		return
	end

	local fireSourceValid = isDestContainerValid(destContainer)

	if itemType == hardCookingItem.notCookable and fireSourceValid then
		local cookable = destContainer:AddItem(hardCookingItem.module .. "." .. hardCookingItem.cookable)
		cookable:setCookingTime(item:getModData().UOMinutesToCook or 0)
		destContainer:Remove(item)
	elseif itemType == hardCookingItem.cookable and not fireSourceValid then
		local notCookable = destContainer:AddItem(hardCookingItem.module .. "." .. hardCookingItem.notCookable)
		notCookable:getModData().UOMinutesToCook = item:getCookingTime()
		destContainer:Remove(item)
	end
end
