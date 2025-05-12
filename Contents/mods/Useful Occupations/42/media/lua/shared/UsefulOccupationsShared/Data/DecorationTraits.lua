---@class UsefulOccupations.DecorationTrait
---@field originalTrait UsefulOccupations.AnyTrait
---@field decorationTrait UsefulOccupations.AnyTrait

local initDecorationTraits = function()
	---@type UsefulOccupations.DecorationTrait[]
	return {
		{
			originalTrait = UsefulOccupations.PersonalTraits.NightVision_Personal,
			decorationTrait = UsefulOccupations.Traits.NightVision,
		},
	}
end

return initDecorationTraits
