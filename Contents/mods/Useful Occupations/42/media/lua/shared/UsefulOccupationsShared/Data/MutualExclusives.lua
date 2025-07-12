----@class UsefulOccupations.MutualExclusive
----@field key UsefulOccupations.AnyTrait
----@field values UsefulOccupations.AnyTrait[]

local initMutualExclusives = function()
	---@class UsefulOccupations.MutualExclusives
	local mutualExclusives = {
		{
			key = UsefulOccupations.PersonalTraits.NightVision_Personal,
			values = { UsefulOccupations.Traits.NightVision },
		},
		{
			key = UsefulOccupations.PersonalTraits.ScoutSkills,
			values = { UsefulOccupations.Traits.Illiterate, UsefulOccupations.Traits.Herbalist },
		},
	}

	return mutualExclusives
end

return initMutualExclusives
