--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Organized
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Organized = function(player)
	local strengthBonusCarrying = UsefulOccupations.PersonalTraits.Organized.values.strengthBonusCarrying
	player:setMaxWeightBase(strengthBonusCarrying)
end
