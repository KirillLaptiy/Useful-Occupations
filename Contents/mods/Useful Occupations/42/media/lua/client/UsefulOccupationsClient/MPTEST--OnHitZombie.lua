--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local trainedFighterType = UsefulOccupations.PersonalTraits.TrainedFighter.type
local marksmanType = UsefulOccupations.PersonalTraits.Marksman.type

---@param player IsoPlayer
local canSuperCrit = function(player)
	return player:HasTrait(trainedFighterType) or player:HasTrait(marksmanType)
end

-- Проверить в МП, что когда хитует игрок с трейтом, то для остальных игроков зомби не будут падать с 1 удара
Events.OnHitZombie.Add(function(zombie, _, _, weapon)
	local player = getPlayer()

	-- Do super crit
	if canSuperCrit(player) and weapon:getType() ~= "BareHands" then
		local critChance = weapon:getCriticalChance()

		if ZombRand(100) < critChance and ZombRand(100) < critChance then
			zombie:setHealth(0)
		end
	end

	--FIXME возможно добавить процент успеха, если персонаж устал
	--FIXME возможно добавить процент успеха, если персонаж устал
	--FIXME возможно добавить процент успеха, если персонаж устал
	--FIXME возможно добавить процент успеха, если персонаж устал
	--FIXME возможно добавить процент успеха, если персонаж устал
	--FIXME возможно добавить процент успеха, если персонаж устал
	if player:HasTrait(trainedFighterType) then
		zombie:setAlwaysKnockedDown(true)
	end
end)
