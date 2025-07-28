-- для перка ветерана на боевой таран и отталкивание
-- player:getSpottedList() возвращает конус зрения игрока
-- local enemies = player:getSpottedList()

-- zombie:setCanWalk(true), setTarget(nil) попробовать использовать для навыка на уворот

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