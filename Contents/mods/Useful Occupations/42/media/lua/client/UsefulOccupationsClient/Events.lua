--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

UsefulOccupations = {}
UsefulOccupations.occupations = {}

--- @param player IsoPlayer
local checkPlayerOccupation = function(player)
    local occupation = player:getDescriptor():getProfession()

    if occupation == OccupationsPrivateTraits.unemployed.type then
        UsefulOccupations.occupations.unemployed(player)
    end
end

Events.OnGameStart.Add(function()
    local player = getPlayer()

    if not player:getModData().UsefulOccupations then
        player:getModData().UsefulOccupations = {}
    end

    checkPlayerOccupation(player)
end)
