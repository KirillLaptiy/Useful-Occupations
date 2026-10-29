--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.EnduranceSecret
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.EnduranceSecret = function(player)
	local spendMainReduce = UsefulOccupations.PersonalTraits.EnduranceSecret.values.spendMainReduce() / 100
	local enduranceRestBonus = UsefulOccupations.PersonalTraits.EnduranceSecret.values.enduranceRestBonus() / 100
	local targetPerk = Perks.Fitness
	local spendPerkReduce = UsefulOccupations.PersonalTraits.EnduranceSecret.values.spendPerkReduce() / 100

	local enduranceStates = {
		recovery = "recovery",
		spend = "spend",
	}

	local stats = player:getStats()
	local lastEndurance = stats:get(CharacterStat.ENDURANCE)
	local enduranceSpendReduce = spendMainReduce + (spendPerkReduce * player:getPerkLevel(targetPerk))
	local enduranceState = nil

	-- Every 0.5 second check player endurance
	UsefulOccupations.Functions.processEveryMs(500, function()
		local currentEndurance = stats:get(CharacterStat.ENDURANCE)

		local spentEndurance = lastEndurance - currentEndurance

		if spentEndurance > 0 then
			enduranceState = enduranceStates.spend
		elseif spentEndurance < 0 then
			enduranceState = enduranceStates.recovery
		else
			enduranceState = nil
		end

		if enduranceState == nil then
			return
		end

		local enduranceToRefill = 0

		-- Recover spent endurance
		if enduranceState == enduranceStates.spend then
			enduranceToRefill = spentEndurance * enduranceSpendReduce

		-- Recover endurance while rest
		elseif enduranceState == enduranceStates.recovery then
			enduranceToRefill = -spentEndurance * (1 + enduranceRestBonus)
		end

		stats:set(CharacterStat.ENDURANCE, currentEndurance + enduranceToRefill)

		lastEndurance = stats:get(CharacterStat.ENDURANCE)
	end)

	-- Update target perk effect
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			enduranceSpendReduce = spendMainReduce + (spendPerkReduce * perkLvl)
		end
	end)
end