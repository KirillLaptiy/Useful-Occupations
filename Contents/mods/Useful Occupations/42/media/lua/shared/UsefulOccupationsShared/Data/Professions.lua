---@class UsefulOccupations.Profession
---@field type string
---@field name string
---@field iconPath string
---@field points integer
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
			points = 30,

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
				{ perk = Perks.PlantScavenging, level = 3 },
				{ perk = Perks.Fishing, level = 3 },
				{ perk = Perks.Trapping, level = 3 },
				{ perk = Perks.Tracking, level = 3 },
				{ perk = Perks.Sprinting, level = 3 },
				{ perk = Perks.Lightfoot, level = 3 },
				{ perk = Perks.Sneak, level = 3 },
			},
		},
	}

	return professions
end

return initProfessions
