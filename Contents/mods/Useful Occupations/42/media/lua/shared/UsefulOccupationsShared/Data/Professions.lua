---@class UsefulOccupations.Profession
---@field type string
---@field name string
---@field iconPath string
---@field points integer
---@field traits UsefulOccupations.AnyTrait[]
---@field xpBoosts UsefulOccupations.XpBoost[]

---@class UsefulOccupations.Professions
---@field unemployed UsefulOccupations.Profession
---@field parkranger UsefulOccupations.Profession
---@field burglar UsefulOccupations.Profession

local initProfessions = function()
	---@type UsefulOccupations.Professions
	return {
		unemployed = {
			type = "unemployed",
			name = getText("UI_prof_unemployed"),
			iconPath = "useful_occupations_unemployed",
			points = 30,
			traits = {
				UsefulOccupations.PersonalTraits.Wunderkind,
			},
			xpBoosts = {},
		},

		parkranger = {
			type = "parkranger",
			name = getText("UI_prof_parkranger"),
			iconPath = "profession_parkranger2",
			points = 0,
			traits = {
				UsefulOccupations.PersonalTraits.ScoutSkills,
				UsefulOccupations.PersonalTraits.NightVision_Personal,
				UsefulOccupations.PersonalTraits.Outdoorsman,
				UsefulOccupations.PersonalTraits.Axeman,
				UsefulOccupations.PersonalTraits.Organized,
			},
			xpBoosts = {
				{ perk = Perks.PlantScavenging, level = 4 },
				{ perk = Perks.Fishing, level = 4 },
				{ perk = Perks.Trapping, level = 4 },
				{ perk = Perks.Tracking, level = 4 },
			},
		},

		burglar = {
			type = "burglar",
			name = getText("UI_prof_Burglar"),
			iconPath = "useful_occupations_burglar",
			points = 0,
			traits = {
				UsefulOccupations.PersonalTraits.Burglar,
			},
			xpBoosts = {
				{ perk = Perks.Sprinting, level = 4 },
				{ perk = Perks.Lightfoot, level = 4 },
				{ perk = Perks.Nimble, level = 4 },
				{ perk = Perks.Sneak, level = 4 },
			},
		},
	}
end

return initProfessions
