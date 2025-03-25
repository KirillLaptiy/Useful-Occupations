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
    -- Only run one time
    if not player:getModData().UsefulOccupations then
        -- Init mod data

        -- Main mod data
        player:getModData().UsefulOccupations = {}

        -- Traits mod data
        for i = 0, Perks.getMaxIndex() - 1 do
            local perk = Perks.fromIndex(i)
            local perkName = perk:getName()

            player:getModData().UsefulOccupations[perkName] = {}
            player:getModData().UsefulOccupations[perkName].startXpBoost = player:getXp():getPerkBoost(perk)
        end

        -- Add vanilla traits from they decoration's
        local professionType = player:getDescriptor():getProfession()

        for _, trait in pairs(UsefulOccupations.Professions[professionType].decorationTraits) do
            player:getTraits():add(trait)
        end
    end

    -- Run personal traits when player created
    for func in pairs(UsefulOccupations.PersonalTraitsOnStart) do
        if UsefulOccupations.isContaneTrait(tostring(func)) then
            UsefulOccupations.PersonalTraitsOnStart[func]()
        end
    end
end)
