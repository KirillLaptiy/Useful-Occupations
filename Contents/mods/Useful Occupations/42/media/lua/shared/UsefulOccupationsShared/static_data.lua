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
UsefulOccupations.onstart = {}

---@class UsefulOccupations.Traits
UsefulOccupations.Traits = {
    NightVision = {
        type = "NightVision",
        name = getText("UI_trait_NightVision"),
        cost = 2,
        desc = getText("UI_trait_NightVisionDesc"),
    },
    Illiterate = {
        type = "Illiterate",
        name = getText("UI_trait_Illiterate"),
        cost = -8,
        desc = getText("UI_trait_IlliterateDesc"),
    },
}

---@class UsefulOccupations.PersonalTraits
UsefulOccupations.PersonalTraits = {
    startFastExp = {
        type = "startFastExp",
        name = getText("UI_trait_startFastExp"),
        desc = getText("UI_trait_startFastExp_desc"),
    },
    boyskaut = {
        type = "boyskaut",
        name = getText("UI_trait_boyskaut"),
        desc = getText("UI_trait_boyskaut_desc"),
    },
    Axeman = {
        type = "Axeman",
        name = getText("UI_trait_axeman"),
        desc = getText("UI_trait_axemandesc"),
    },
    Organized = {
        type = "Organized",
        name = getText("UI_trait_Packmule"),
        desc = getText("UI_trait_PackmuleDesc"),
    },
    NightVision_Personal = {
        type = "NightVision_Personal",
        name = getText("UI_trait_NightVision"),
        desc = getText("UI_trait_NightVisionDesc"),
    },
}

---@class UsefulOccupations.MutualExclusives
UsefulOccupations.MutualExclusives = {
    { UsefulOccupations.PersonalTraits.NightVision_Personal.type, UsefulOccupations.Traits.NightVision.type },
    { UsefulOccupations.PersonalTraits.boyskaut.type,             UsefulOccupations.Traits.Illiterate.type },
}

--- @class UsefulOccupations.Professions
UsefulOccupations.Professions = {
    unemployed = {
        type = "unemployed",
        name = getText("UI_prof_unemployed"),
        IconPath = "",
        points = 30,
        traits = { UsefulOccupations.PersonalTraits.startFastExp.type },
        decorationTraits = {},
        xpBoosts = {},
    },
    parkranger = {
        type = "parkranger",
        name = getText("UI_prof_parkranger"),
        IconPath = "profession_parkranger2",
        points = 0,
        traits = {
            UsefulOccupations.PersonalTraits.boyskaut.type,
            UsefulOccupations.PersonalTraits.NightVision_Personal.type,
            UsefulOccupations.PersonalTraits.Axeman.type,
            UsefulOccupations.PersonalTraits.Organized.type,
        },
        decorationTraits = {
            UsefulOccupations.Traits.NightVision.type,
        },
        xpBoosts = {
            { Perks.PlantScavenging, 4 },
            { Perks.Fishing,         4 },
            { Perks.Trapping,        4 },
        },
    },
}
