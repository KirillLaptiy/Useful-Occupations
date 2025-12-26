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

---@param player IsoGameCharacter
---@param weapon HandWeapon
local canSuperCrit = function(player, weapon)
	local isFirearmWeapon = weapon:isAimedFirearm()

	local canSuperCritMelee = player:HasTrait(trainedFighterType) and isFirearmWeapon == false

	local canSuperCritFirearm = player:HasTrait(marksmanType) and isFirearmWeapon == true

	return canSuperCritMelee or canSuperCritFirearm
end

-- Check in MP that when a player with a trait hits, zombies won't fall in one hit for other players.
Events.OnHitZombie.Add(function(zombie, attacker, _, weapon)
	-- Do super crit
	if weapon:getType() ~= "BareHands" and canSuperCrit(attacker, weapon) then
		local critChance = weapon:getCriticalChance()

		if ZombRand(100) < critChance and ZombRand(100) < critChance then
			zombie:setHealth(0)
		end
	end

	if attacker:HasTrait(trainedFighterType) then
		zombie:setAlwaysKnockedDown(true)
	end
end)

Events.OnWeaponHitCharacter.Add(function(attacker, target, _, damage)
	-- Trained fighter has increased stopm power
	if attacker:HasTrait(trainedFighterType) and attacker:isDoStomp() then
		target:setHealth(target:getHealth() - ((damage + 0.1) * 1.5))
	end
end)
