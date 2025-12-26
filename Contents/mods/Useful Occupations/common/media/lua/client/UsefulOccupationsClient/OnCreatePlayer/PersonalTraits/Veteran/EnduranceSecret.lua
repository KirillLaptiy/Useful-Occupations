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
	local lastEndurance = stats:getEndurance()
	local enduranceSpendReduce = spendMainReduce + (spendPerkReduce * player:getPerkLevel(targetPerk))
	local enduranceState = nil

	-- Every 0.5 second check player endurance
	UsefulOccupations.Functions.processEveryMs(500, function()
		local currentEndurance = stats:getEndurance()

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

		stats:setEndurance(currentEndurance + enduranceToRefill)

		lastEndurance = stats:getEndurance()
	end)

	-- Update target perk effect
	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function(_, perk, perkLvl, _)
		if perk == targetPerk then
			enduranceSpendReduce = spendMainReduce + (spendPerkReduce * perkLvl)
		end
	end)
end