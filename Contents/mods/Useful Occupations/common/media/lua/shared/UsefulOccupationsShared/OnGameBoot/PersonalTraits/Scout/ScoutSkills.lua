--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnGameBoot.ScoutSkills
UsefulOccupations.DoTraitsOnGameBoot.ScoutSkills = function()
	local Fish = Fishing.Fish
	local FishingRod = Fishing.FishingRod

	local fishOld = Fish.new
	local fishingRodOld = FishingRod.new

	local scoutSkillsType = UsefulOccupations.PersonalTraits.ScoutSkills.type

	function Fish:new(character, lure, fishingRod, x, y)
		---@diagnostic disable-next-line: redundant-parameter
		local o = fishOld(self, character, lure, fishingRod, x, y)

		if character:HasTrait(scoutSkillsType) then
			o.fishingLvl = o.fishingLvl * 4
		end

		return o
	end

	function FishingRod:new(player, joypad)
		---@diagnostic disable-next-line: redundant-parameter
		local o = fishingRodOld(self, player, joypad)

		if player:HasTrait(scoutSkillsType) then
			o.skillLevel = o.skillLevel * 4
		end

		return o
	end
end
