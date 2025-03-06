--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

Events.OnGameBoot.Add(function()
    -- Clear vanilla occupations
    ProfessionFactory.Reset()

    --- @type Profession
    local unemployed = ProfessionFactory.addProfession("unemployed", getText("UI_prof_unemployed"), "", 30)
    unemployed:addFreeTrait(OccupationsPrivateTraits.unemployed.type)

    -- Set description for each occupation
    local profList = ProfessionFactory.getProfessions()
    for i = 1, profList:size() do
        local prof = profList:get(i - 1)
        BaseGameCharacterDetails.SetProfessionDescription(prof)
    end
end)
