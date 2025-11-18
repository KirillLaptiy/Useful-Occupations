--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local initMutualExclusives = function()
	---@class UsefulOccupations.MutualExclusives
	local mutualExclusives = {
		---@class UsefulOccupations.MutualExclusive
		NightVision_Personal = {
			key = UsefulOccupations.PersonalTraits.NightVision_Personal,
			values = { UsefulOccupations.Traits.NightVision },
		},
		---@class UsefulOccupations.MutualExclusive
		ScoutSkills = {
			key = UsefulOccupations.PersonalTraits.ScoutSkills,
			values = { UsefulOccupations.Traits.Illiterate, UsefulOccupations.Traits.Herbalist },
		},
	}

	return mutualExclusives
end

return initMutualExclusives
