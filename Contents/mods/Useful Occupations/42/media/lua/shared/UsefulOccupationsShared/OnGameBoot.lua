--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local addUsefulTraits = function()
    -- Clear vanilla traits
    TraitFactory.Reset()

    -- Add non-personal traits
    for _, trait in pairs(UsefulOccupations.Traits) do
        TraitFactory.addTrait(trait.type, trait.name, trait.cost, trait.desc, false);
    end

    -- Add personal traits
    for _, trait in pairs(UsefulOccupations.PersonalTraits) do
        TraitFactory.addTrait(trait.type, trait.name, 0, trait.desc, true);
    end

    -- Add mutual exclusives
    for _, mutualExclusive in pairs(UsefulOccupations.MutualExclusives) do
        TraitFactory.setMutualExclusive(mutualExclusive[1], mutualExclusive[2])
    end
end

local addUsefulProfessions = function()
    -- Clear vanilla professions
    ProfessionFactory.Reset()

    for _, professionType in pairs(UsefulOccupations.Professions) do
        local profession = ProfessionFactory.addProfession(professionType.type, professionType.name,
            professionType.IconPath, professionType.points)

        for _, trait in pairs(professionType.traits) do
            profession:addFreeTrait(trait)
        end

        for _, xpBoost in pairs(professionType.xpBoosts) do
            profession:addXPBoost(xpBoost[1], xpBoost[2])
        end
    end

    -- Set description for each profession
    local profList = ProfessionFactory.getProfessions()
    for i = 1, profList:size() do
        local prof = profList:get(i - 1)
        BaseGameCharacterDetails.SetProfessionDescription(prof)
    end
end

Events.OnGameBoot.Add(function()
    addUsefulTraits()
    addUsefulProfessions()
end)
