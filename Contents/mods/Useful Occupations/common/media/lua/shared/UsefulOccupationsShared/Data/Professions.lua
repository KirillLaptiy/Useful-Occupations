--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UsefulOccupations.Profession
---@field type string
---@field name string
---@field iconPath string
---@field points integer
---@field desc string
---@field traits UsefulOccupations.AnyTrait[]
---@field xpBoosts UsefulOccupations.XpBoost[]

local initProfessions = function()
	---@class UsefulOccupations.Professions
	local professions = {
		---@class Profession.Unemployed
		Unemployed = {
			type = "unemployed",
			name = getText("UI_prof_unemployed"),
			iconPath = "useful_occupations_unemployed",
			points = 40,
			desc = getText("UI_prof_unemployed_desc"),

			---@class Profession.Unemployed.traits
			traits = {
				UsefulOccupations.PersonalTraits.Wunderkind,
			},

			---@class Profession.Unemployed.xpBoosts
			xpBoosts = {},
		},

		---@class Profession.Scout
		Scout = {
			type = "parkranger",
			name = getText("UI_prof_parkranger"),
			iconPath = "useful_occupations_parkranger",
			points = 0,
			desc = getText("UI_prof_scout_desc"),

			---@class Profession.Scout.traits
			traits = {
				UsefulOccupations.PersonalTraits.ScoutSkills,
				UsefulOccupations.PersonalTraits.NightVision_Personal,
				UsefulOccupations.PersonalTraits.Outdoorsman,
				UsefulOccupations.PersonalTraits.Axeman,
				UsefulOccupations.PersonalTraits.Organized,
				UsefulOccupations.PersonalTraits.Burglar,
				UsefulOccupations.PersonalTraits.Graceful,
				UsefulOccupations.PersonalTraits.Inconspicuous,
				UsefulOccupations.PersonalTraits.Dextrous,
				UsefulOccupations.PersonalTraits.Gymnast,
			},

			---@class Profession.Scout.xpBoosts
			xpBoosts = {
				{ perk = Perks.Strength, level = -2 },
				{ perk = Perks.Fitness, level = -2 },
			},
		},

		---@class Profession.Veteran
		Veteran = {
			type = "veteran",
			name = getText("UI_prof_Veteran"),
			iconPath = "useful_occupations_veteran",
			points = 0,
			desc = getText("UI_prof_veteran_desc"),

			---@class Profession.Veteran.traits
			traits = {
				UsefulOccupations.PersonalTraits.Marksman,
				UsefulOccupations.PersonalTraits.Stout_Personal,
				UsefulOccupations.PersonalTraits.Fit_Personal,
				UsefulOccupations.PersonalTraits.NightOwl,
				UsefulOccupations.PersonalTraits.Desensitized,
				UsefulOccupations.PersonalTraits.EnduranceSecret,
				UsefulOccupations.PersonalTraits.Invincible,
				UsefulOccupations.PersonalTraits.TrainedFighter,
			},

			---@class Profession.Veteran.xpBoosts
			xpBoosts = {},
		},

		---@class Profession.SPM
		SPM = {
			type = "spm",
			name = getText("UI_prof_spm"),
			iconPath = "useful_occupations_spm",
			points = 0,
			desc = getText("UI_prof_spm_desc"),

			---@class Profession.SPM.traits
			traits = {
				UsefulOccupations.PersonalTraits.Engineer,
				UsefulOccupations.PersonalTraits.Builder,
				UsefulOccupations.PersonalTraits.Mechanic,
				UsefulOccupations.PersonalTraits.Doctor,
			},

			---@class Profession.SPM.xpBoosts
			xpBoosts = {
				{ perk = Perks.Strength, level = -2 },
				{ perk = Perks.Fitness, level = -2 },
			},
		},
	}

	return professions
end

return initProfessions
