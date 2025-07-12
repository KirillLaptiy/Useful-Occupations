--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

--TODO: отключать навык при беге / спринте / беге в полуприсяде (только если зомби не спринтер)

-- для перка ветерана на боевой таран и отталкивание
-- player:getSpottedList() возвращает конус зрения игрока
-- local enemies = player:getSpottedList()

-- print(enemies:size())

-- for i = 0, enemies:size() - 1 do
-- 	---@type IsoZombie
-- 	local enemy = enemies:get(i)

-- 	if enemy:isZombie() then
-- 		local distance = enemy:DistTo(player)
-- 		print(distance)

-- 		if distance <= 2 then
-- 			nearbyzombies = true
-- 			break
-- 		end
-- 	end
-- end

---@class DoTraitsOnCreatePlayer.Inconspicuous
---@param player IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Inconspicuous = function(player)
	---@type number
	local defaultDistanceToForfeit = UsefulOccupations.PersonalTraits.Inconspicuous.values.distanceToForfeit
	---@type number
	local decreaseDistanceByLvl = UsefulOccupations.PersonalTraits.Inconspicuous.values.decreaseDistanceByLvl
	---@type Perk
	local decreaseDistancePerk = UsefulOccupations.PersonalTraits.Inconspicuous.values.decreaseDistancePerk
	---@type number
	local stunDurationAfterForfeit = UsefulOccupations.PersonalTraits.Inconspicuous.values.stunDurationAfterForfeit

	-- local isPlayerRunning = true

	local getDistanceToForfeit = function()
		return defaultDistanceToForfeit - (decreaseDistanceByLvl * player:getPerkLevel(decreaseDistancePerk))
	end

	---@param zombie IsoZombie
	local removeZombieStun = function(zombie)
		UsefulOccupations.Functions.processAfterDelay(stunDurationAfterForfeit, function()
			zombie:setUseless(false)
		end)
	end

	local getDistanceBetween = function(firstObj, secondObj)
		local x1, y1 = firstObj:getX(), firstObj:getY()
		local x2, y2 = secondObj:getX(), secondObj:getY()

		local dx = x1 - x2
		local dy = y1 - y2

		local distance = math.sqrt(dx * dx + dy * dy)
		return distance
	end

	local distanceToForfeit = getDistanceToForfeit()

	---@param zombie IsoZombie
	UsefulOccupations.Functions.addEvent(Events.OnZombieUpdate, function(zombie)
		if zombie:getTarget() ~= player or player:isDriving() then
			return
		end

		local distance = getDistanceBetween(player, zombie)

		if player:isBehind(zombie) or not zombie:CanSee(player) or distance > distanceToForfeit then
			zombie:setUseless(true)
			---@diagnostic disable-next-line: param-type-mismatch
			zombie:setTarget(nil)

			-- zombie:setCanWalk(false) -- проверить
			-- zombie:setKnifeDeath(true) -- не работает, возможно дать взломщику возможность убивать зомби с помощью zombie:die() без ножа или же ваншотить сзади

			removeZombieStun(zombie)
		end
	end)

	UsefulOccupations.Functions.addEvent(Events.LevelPerk, function()
		distanceToForfeit = getDistanceToForfeit()
	end)

	-- UsefulOccupations.Functions.addEvent(Events.OnPlayerUpdate, function()
	-- 	isPlayerRunning = not player:isRunning() and not player:isSprinting()
	-- end)
end
