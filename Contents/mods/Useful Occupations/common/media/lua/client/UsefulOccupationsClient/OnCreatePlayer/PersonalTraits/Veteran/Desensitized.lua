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

	UsefulOccupations.Functions.processEveryMs(30, function()
		local bodyDamageRed = bodyDamage:getPainReduction()

		bodyDamage:setPainReduction(math.min(painReduction, bodyDamageRed))

		if stats:get(CharacterStat.PAIN) > maxPain then
			stats:set(CharacterStat.PAIN, maxPain)
		end

		if stats:get(CharacterStat.FATIGUE) > maxFatigue then
			stats:set(CharacterStat.FATIGUE, maxFatigue)
		end
	end)
end
