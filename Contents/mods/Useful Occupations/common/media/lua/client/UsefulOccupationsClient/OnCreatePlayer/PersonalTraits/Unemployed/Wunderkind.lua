--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Wunderkind
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Wunderkind = function(player)
	local lastLevelForXpBoost = UsefulOccupations.PersonalTraits.Wunderkind.values.lastLevelForXpBoost()

	local xp = player:getXp()
	local modData = UsefulOccupations.Functions.getModData()

	-- Add xp boost for all perks when create player
	for i = 0, Perks.getMaxIndex() - 1 do
		local perk = Perks.fromIndex(i)

		if player:getPerkLevel(perk) < lastLevelForXpBoost then
			xp:setPerkBoost(perk, 3)
		end
	end

	-- Clear xp boost when perk level reaches last level for xp boost
	--- @param perk PerkFactory.Perk
	--- @param perkLvl integer
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perkLvl == lastLevelForXpBoost then
			local startXpBoost = modData[perk:getName()].startXpBoost
			xp:setPerkBoost(perk, startXpBoost)
		end
	end)
end
