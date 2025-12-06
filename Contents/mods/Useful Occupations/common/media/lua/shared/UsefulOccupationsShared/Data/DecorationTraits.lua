--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

----@class UsefulOccupations.DecorationTrait
----@field originalTrait UsefulOccupations.AnyTrait
----@field decorationTrait UsefulOccupations.AnyTrait

local initDecorationTraits = function()
	---@class UsefulOccupations.DecorationTraits
	local decorationTraits = {
		{
			originalTraitType = UsefulOccupations.PersonalTraits.NightVision_Personal.type,
			decorationTraitType = "NightVision",
		},
		{
			originalTraitType = UsefulOccupations.PersonalTraits.Fit_Personal.type,
			decorationTraitType = "Fit",
		},
		{
			originalTraitType = UsefulOccupations.PersonalTraits.Stout_Personal.type,
			decorationTraitType = "Stout",
		},
	}

	return decorationTraits
end

return initDecorationTraits
