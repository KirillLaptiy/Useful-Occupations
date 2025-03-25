--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UsefulOccupations
UsefulOccupations = {}

---@class UsefulOccupations.PersonalTraitsOnStart
UsefulOccupations.PersonalTraitsOnStart = {}

--- @param traitName String
--- @return boolean
UsefulOccupations.isContaneTrait = function(traitName)
    return getPlayer():getTraits():contains(traitName)
end

---@class UsefulOccupations.Traits
UsefulOccupations.Traits = {
    NightVision = {
        type = "NightVision",
        name = getText("UI_trait_NightVision"),
        cost = 2,
        desc = getText("UI_trait_NightVisionDesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    Illiterate = {
        type = "Illiterate",
        name = getText("UI_trait_Illiterate"),
        cost = -8,
        desc = getText("UI_trait_IlliterateDesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    Herbalist = {
        type = "Herbalist",
        name = getText("UI_trait_Herbalist"),
        cost = 4,
        desc = getText("UI_trait_HerbalistDesc"),
        xpBoosts = {
            { Perks.PlantScavenging, 1 }
        },
        freeRecipes = {
            "Herbalist",
            "MakePlantainPoultice",
            "MakeComfreyPoultice",
            "MakeWildGarlicPoultice",
            "Black Sage Growing Season",
            "Broadleaf Plantain Growing Season",
            "Comfrey Growing Season",
            "Common Mallow Growing Season",
            "Wild Garlic Growing Season",
        },
    },
}

---@class UsefulOccupations.PersonalTraits
UsefulOccupations.PersonalTraits = {
    Wunderkind = {
        type = "Wunderkind",
        name = getText("UI_trait_wunderkind"),
        desc = getText("UI_trait_wunderkind_desc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    ScoutSkills = {
        type = "ScoutSkills",
        name = getText("UI_trait_scoutskills"),
        desc = getText("UI_trait_scoutskills_desc"),
        xpBoosts = {},
        freeRecipes = {
            "Herbalist",
            "MakePlantainPoultice",
            "MakeComfreyPoultice",
            "MakeWildGarlicPoultice",
            "Black Sage Growing Season",
            "Broadleaf Plantain Growing Season",
            "Comfrey Growing Season",
            "Common Mallow Growing Season",
            "Wild Garlic Growing Season",
        },
    },
    Axeman = {
        type = "Axeman",
        name = getText("UI_trait_axeman"),
        desc = getText("UI_trait_axemandesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    Organized = {
        type = "Organized",
        name = getText("UI_trait_Packmule"),
        desc = getText("UI_trait_PackmuleDesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    NightVision_Personal = {
        type = "NightVision_Personal",
        name = getText("UI_trait_NightVision"),
        desc = getText("UI_trait_NightVisionDesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    Outdoorsman = {
        type = "Outdoorsman",
        name = getText("UI_trait_outdoorsman"),
        desc = getText("UI_trait_outdoorsmandesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
    Burglar = {
        type = "Burglar",
        name = getText("UI_prof_Burglar"),
        desc = getText("UI_trait_BurglarDesc"),
        xpBoosts = {},
        freeRecipes = {},
    },
}

---@class UsefulOccupations.MutualExclusives
UsefulOccupations.MutualExclusives = {
    { UsefulOccupations.PersonalTraits.NightVision_Personal.type, UsefulOccupations.Traits.NightVision.type },
    { UsefulOccupations.PersonalTraits.ScoutSkills.type,          UsefulOccupations.Traits.Illiterate.type },
    { UsefulOccupations.PersonalTraits.ScoutSkills.type,          UsefulOccupations.Traits.Herbalist.type },
}

---@class UsefulOccupations.Professions
UsefulOccupations.Professions = {
    unemployed = {
        type = "unemployed",
        name = getText("UI_prof_unemployed"),
        IconPath = "useful_occupations_unemployed",
        points = 30,
        traits = { UsefulOccupations.PersonalTraits.Wunderkind.type },
        decorationTraits = {},
        xpBoosts = {},
    },
    parkranger = {
        type = "parkranger",
        name = getText("UI_prof_parkranger"),
        IconPath = "profession_parkranger2",
        points = 0,
        traits = {
            UsefulOccupations.PersonalTraits.ScoutSkills.type,
            UsefulOccupations.PersonalTraits.NightVision_Personal.type,
            UsefulOccupations.PersonalTraits.Outdoorsman.type,
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
    burglar = {
        type = "burglar",
        name = getText("UI_prof_Burglar"),
        IconPath = "useful_occupations_burglar",
        points = 0,
        traits = {
            UsefulOccupations.PersonalTraits.Burglar.type,
        },
        decorationTraits = {},
        xpBoosts = {
            { Perks.PlantScavenging, 4 },
            { Perks.Fishing,         4 },
            { Perks.Trapping,        4 },
        },
    },
}
