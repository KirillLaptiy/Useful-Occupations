--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- Проверить разлом печки с кувалды
-- Проверить разлом печки с кувалды
-- Проверить разлом печки с кувалды
-- Проверить разлом печки с кувалды
local oldTransfer = ISTransferAction.transferItem

---@param character IsoPlayer
---@param item InventoryItem
---@param srcContainer ItemContainer
---@param destContainer ItemContainer
---@param dropSquare IsoGridSquare
function ISTransferAction:transferItem(character, item, srcContainer, destContainer, dropSquare)
    oldTransfer(self, character, item, srcContainer, destContainer, dropSquare)

    if item:getType() == "MetalAdapterCantCook" and destContainer:getType() == "campfire" then
        local cookable = destContainer:AddItem("UO.MetalAdapter")
        cookable:setCookingTime(item:getModData().UOMinutesToCook or 0)
        destContainer:Remove(item)
    elseif item:getType() == "MetalAdapter" and destContainer:getType() ~= "campfire" and (destContainer:isStove() or destContainer:isMicrowave()) then
        local notCookable = destContainer:AddItem("UO.MetalAdapterCantCook")
        notCookable:getModData().UOMinutesToCook = item:getCookingTime()
        destContainer:Remove(item)
    end
end