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
local oldNew = Fish.new

function Fish:new(character, lure, fishingRod, x, y)
	---@diagnostic disable-next-line: redundant-parameter
	local o = oldNew(self, character, lure, fishingRod, x, y)

	o.fishingLvl = o.fishingLvl * 4

	return o
end
