--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local Fish = Fishing.Fish

local fishOld = Fish.new

local scoutSkillsType

-- Scout receives fishing lvl boost
function Fish:new(character, lure, fishingRod, x, y)
	---@diagnostic disable-next-line: redundant-parameter
	local o = fishOld(self, character, lure, fishingRod, x, y)

	if character:HasTrait(scoutSkillsType) then
		o.fishingLvl = o.fishingLvl * 4
	end

	return o
end

-- Init values
Events.OnGameStart.Add(function()
	scoutSkillsType = UsefulOccupations.PersonalTraits.ScoutSkills.type
end)
