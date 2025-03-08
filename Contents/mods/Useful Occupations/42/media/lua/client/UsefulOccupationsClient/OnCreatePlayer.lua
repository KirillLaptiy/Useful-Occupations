--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

Events.OnCreatePlayer.Add(function(_, player)
    if player:getModData().UsefulOccupations then return end

    -- Init mod data
    player:getModData().UsefulOccupations = {}

    -- Add decoration traits
    local professionType = player:getDescriptor():getProfession()

    for _, trait in pairs(UsefulOccupations.Professions[professionType].decorationTraits) do
        player:getTraits():add(trait)
    end
end)
