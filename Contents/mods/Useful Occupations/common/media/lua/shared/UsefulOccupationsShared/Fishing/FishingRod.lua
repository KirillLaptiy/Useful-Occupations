--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local FishingRod = Fishing.FishingRod

local fishingRodOld = FishingRod.new

local scoutSkillsType

-- Scout receives fishing lvl boost
function FishingRod:new(player, joypad)
	---@diagnostic disable-next-line: redundant-parameter
	local o = fishingRodOld(self, player, joypad)

	if player:HasTrait(scoutSkillsType) then
		o.skillLevel = o.skillLevel * 4
	end

	return o
end

-- Init values
Events.OnGameStart.Add(function()
	scoutSkillsType = UsefulOccupations.PersonalTraits.ScoutSkills.type
end)
