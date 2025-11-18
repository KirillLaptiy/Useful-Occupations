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
			originalTrait = UsefulOccupations.PersonalTraits.NightVision_Personal,
			decorationTrait = UsefulOccupations.Traits.NightVision,
		},
	}

	return decorationTraits
end

return initDecorationTraits
