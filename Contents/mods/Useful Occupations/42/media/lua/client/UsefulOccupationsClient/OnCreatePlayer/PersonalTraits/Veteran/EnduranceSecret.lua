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
	local enduranceStates = {
		recovery = "recovery",
		spend = "spend",
	}

	local stats = player:getStats()

	local enduranceState = nil

	local lastEndurance = stats:getEndurance()

	-- Every 0.5 second check player endurance
	-- Recover 80% from spend endurance or x2 from rest endurance
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

		-- Recover 80% from spent endurance
		if enduranceState == enduranceStates.spend then
			enduranceToRefill = spentEndurance * 0.8

		-- Recover x2 endurance while rest
		elseif enduranceState == enduranceStates.recovery then
			enduranceToRefill = -spentEndurance * 2
		end

		stats:setEndurance(currentEndurance + enduranceToRefill)

		lastEndurance = stats:getEndurance()

		print(stats:getEndurance())
	end)
end
