--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

OccupationsPrivateTraits = {
    unemployed = {
        type = "unemployed",
        name = getText("UI_trait_unemployed"),
        cost = 0,
        desc = getText("UI_trait_unemployed_desc"),
        prof = true
    }
}

for _, privateTrait in pairs(OccupationsPrivateTraits) do
    TraitFactory.addTrait(privateTrait.type, privateTrait.name, privateTrait.cost, privateTrait.desc, privateTrait.prof);
end
