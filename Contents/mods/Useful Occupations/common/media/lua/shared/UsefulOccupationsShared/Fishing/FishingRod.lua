local FishingRod = Fishing.FishingRod
local oldNew = FishingRod.new

function FishingRod:new(player, joypad)
	---@diagnostic disable-next-line: redundant-parameter
	local o = oldNew(self, player, joypad)

	o.skillLevel = o.skillLevel * 4

	return o
end
