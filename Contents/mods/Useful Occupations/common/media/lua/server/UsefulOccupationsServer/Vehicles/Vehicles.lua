--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local oldVehicleCalc = VehicleUtils.calculateInstallationSuccess
local traitType = UsefulOccupations.PersonalTraits.Mechanic.type

---@param perks table
---@param chr IsoPlayer
---@param chrPerks table
---@diagnostic disable-next-line: duplicate-set-field
function VehicleUtils.calculateInstallationSuccess(perks, chr, chrPerks)
	if chr:HasTrait(traitType) then
		return 100, 0
	end

	return oldVehicleCalc(perks, chr, chrPerks)
end
