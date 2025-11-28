--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local empGrenadeType = "EMPGrenade"

local engineerValues = UsefulOccupations.PersonalTraits.Engineer.values

local empStunTime = 20
local empStunHRadis = 6
local empStunVRadis = 1

-- Adds zombie's stun time
---@param square IsoGridSquare
local addZombiesStunTime = function(square)
	local movingObjects = square:getMovingObjects()

	local stunTime = empStunTime * 1000

	for h = 0, movingObjects:size() - 1 do
		---@type IsoZombie
		local obj = movingObjects:get(h)

		if obj:isZombie() then
			local modData = obj:getModData()
			modData.EMPStunDuration = (modData.EMPStunDuration or 0) + stunTime
		end
	end
end

-- Call every 100 ms for each zombie
-- Stuns zombie and remove stun
Events.OnZombieUpdate.Add(function(zombie)
	local modData = zombie:getModData()

	if modData.EMPStunDuration == nil then
		return
	end

	local now = getTimestampMs()

	modData.EMPLastCall = modData.EMPLastCall or now

	if now - modData.EMPLastCall >= 100 then
		modData.EMPLastCall = now

		modData.EMPStunDuration = math.max(0, (modData.EMPStunDuration or 0) - 100)

		if modData.EMPStunDuration > 0 then
			zombie:setUseless(true)
			---@diagnostic disable-next-line: param-type-mismatch
			zombie:setTarget(nil)
			zombie:setMoving(false)
		else
			modData.EMPStunDuration = nil
			zombie:setUseless(false)
		end
	end
end)

-- Call when EMP-grenade explodes
-- Calculates the stun radius
Events.OnThrowableExplode.Add(function(throwable, square)
	if throwable:getItem():getType() ~= empGrenadeType then
		return
	end

	local x = square:getX()
	local y = square:getY()
	local z = square:getZ()

	for dz = -empStunVRadis, empStunVRadis do
		for dx = -empStunHRadis, empStunHRadis do
			for dy = -empStunHRadis, empStunHRadis do
				local sq = getSquare(x + dx, y + dy, z + dz)

				if sq then
					addZombiesStunTime(sq)
				end
			end
		end
	end
end)

-- Need to set values from sandbox settings
Events.OnCreatePlayer.Add(function(_, _)
	empStunTime = engineerValues.empStunTime()
	empStunHRadis = engineerValues.empStunHRadis()
	empStunVRadis = engineerValues.empStunVRadis()
end)
