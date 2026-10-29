--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local oldTrapSystem = TrapSystem.initObjectModData

---@diagnostic disable-next-line: duplicate-set-field
function TrapSystem.initObjectModData(isoObject, trapDef, north, player)
	oldTrapSystem(isoObject, trapDef, north, player)

	local modData = isoObject:getModData()

	modData.trappingSkill = player:getPerkLevel(Perks.Trapping) * 4
end
