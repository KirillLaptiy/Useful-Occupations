----@class UsefulOccupations.DecorationTrait
----@field originalTrait UsefulOccupations.AnyTrait
----@field decorationTrait UsefulOccupations.AnyTrait

local initDecorationTraits = function()
	---@class UsefulOccupations.DecorationTraits
	local decorationTraits = {
		{
			originalTrait = UsefulOccupations.PersonalTraits.NightVision_Personal,
			decorationTrait = UsefulOccupations.Traits.NightVision,
		},
	}

	return decorationTraits
end

return initDecorationTraits
