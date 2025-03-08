--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

--- @param player IsoPlayer
local checkPlayerProfession = function(player)
    local professionType = player:getDescriptor():getProfession()

    if UsefulOccupations.onstart[professionType] then
        UsefulOccupations.onstart[professionType](player)
    end
end

Events.OnGameStart.Add(function()
    local player = getPlayer()

    checkPlayerProfession(player)
end)
