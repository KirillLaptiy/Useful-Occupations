--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class DoTraitsOnCreatePlayer.Desensitized
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Desensitized = function(player)
	local painReduction = UsefulOccupations.PersonalTraits.Desensitized.values.painReduction()
	local maxPain = UsefulOccupations.PersonalTraits.Desensitized.values.maxPain()
	local maxFatigue = UsefulOccupations.PersonalTraits.Desensitized.values.maxFatigue() / 100

	local stats = player:getStats()
	local bodyDamage = player:getBodyDamage()

	local currentPainReduction = bodyDamage:getPainReduction()

	UsefulOccupations.Functions.processEveryMs(30, function()
		bodyDamage:setPainReduction(currentPainReduction + painReduction)

		currentPainReduction = bodyDamage:getPainReduction() - painReduction

		if currentPainReduction < 0 then
			currentPainReduction = 0
		end

		if stats:getPain() > maxPain then
			stats:setPain(maxPain)
		end

		if stats:getFatigue() > maxFatigue then
			stats:setFatigue(maxFatigue)
		end
	end)
end
