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
	local painReduction = UsefulOccupations.PersonalTraits.Desensitized.values.painReduction
	local maxPain = UsefulOccupations.PersonalTraits.Desensitized.values.maxPain
	local maxFatigue = UsefulOccupations.PersonalTraits.Desensitized.values.maxFatigue / 100

	local modData = UsefulOccupations.Functions.getModData()

	local stats = player:getStats()
	local bodyDamage = player:getBodyDamage()

	UsefulOccupations.Functions.processEveryMs(30, function()
		-- Don't reduce pain and fatigue when "Invincible" on cooldown
		if modData.invincibleState == "onCooldown" then
			return
		end

		bodyDamage:setPainReduction(painReduction)

		if stats:getPain() > maxPain then
			stats:setPain(maxPain)
		end

		if stats:getFatigue() > maxFatigue then
			stats:setFatigue(maxFatigue)
		end
	end)
end
