---@class UsefulOccupations.MutualExclusive
---@field key UsefulOccupations.AnyTrait
---@field values UsefulOccupations.AnyTrait[]

local initMutualExclusives = function()
	---@type UsefulOccupations.MutualExclusive[]
	return {
		{
			key = UsefulOccupations.PersonalTraits.NightVision_Personal,
			values = { UsefulOccupations.Traits.NightVision },
		},
		{
			key = UsefulOccupations.PersonalTraits.ScoutSkills,
			values = { UsefulOccupations.Traits.Illiterate, UsefulOccupations.Traits.Herbalist },
		},
	}
end

return initMutualExclusives
