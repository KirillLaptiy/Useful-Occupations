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

---@type IsoPlayer
local player

---@param player IsoPlayer
---@param weapon HandWeapon
local canSuperCrit = function(player, weapon)
	local isFirearmWeapon = weapon:isAimedFirearm()

	local canSuperCritMelee = player:HasTrait(trainedFighterType) and isFirearmWeapon == false
	local canSuperCritFirearm = player:HasTrait(marksmanType) and isFirearmWeapon == true

	return canSuperCritMelee or canSuperCritFirearm
end

-- Проверить в МП, что когда хитует игрок с трейтом, то для остальных игроков зомби не будут падать с 1 удара
Events.OnHitZombie.Add(function(zombie, _, _, weapon)
	-- Do super crit
	if weapon:getType() ~= "BareHands" and canSuperCrit(player, weapon) then
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

Events.OnWeaponHitCharacter.Add(function(attacker, target, _, damage)
	-- Trained fighter has increased stopm power
	if attacker:HasTrait(trainedFighterType) and attacker:isDoStomp() then
		target:setHealth(target:getHealth() - (damage + 1) * 2)
	end
end)

Events.OnCreatePlayer.Add(function(_, createdPlayer)
	player = createdPlayer
end)
