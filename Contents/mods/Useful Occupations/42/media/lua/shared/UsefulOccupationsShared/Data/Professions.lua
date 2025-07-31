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

		---@class Profession.Veteran
		Veteran = {
			type = "veteran",
			name = getText("UI_prof_Veteran"),
			iconPath = "useful_occupations_veteran",
			points = 0,

			---@class Profession.Veteran.traits
			traits = {
				UsefulOccupations.PersonalTraits.Marksman,
				UsefulOccupations.PersonalTraits.Strong,
				UsefulOccupations.PersonalTraits.Athletic,
				UsefulOccupations.PersonalTraits.NightOwl,
				UsefulOccupations.PersonalTraits.Desensitized,
				UsefulOccupations.PersonalTraits.EnduranceSecret,
				UsefulOccupations.PersonalTraits.Invincible,
			},

			---@class Profession.Veteran.xpBoosts
			xpBoosts = {
				{ perk = Perks.Axe, level = 3 },
				{ perk = Perks.Blunt, level = 3 },
				{ perk = Perks.SmallBlunt, level = 3 },
				{ perk = Perks.LongBlade, level = 3 },
				{ perk = Perks.SmallBlade, level = 3 },
				{ perk = Perks.Spear, level = 3 },
				{ perk = Perks.Aiming, level = 3 },
				{ perk = Perks.Reloading, level = 3 },
				{ perk = Perks.Maintenance, level = 3 },
				{ perk = Perks.Nimble, level = 3 },
			},
		},
	}

	return professions
end

return initProfessions
