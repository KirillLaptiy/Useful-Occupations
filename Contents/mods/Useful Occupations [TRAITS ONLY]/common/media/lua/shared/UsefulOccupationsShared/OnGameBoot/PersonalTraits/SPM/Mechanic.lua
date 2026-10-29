-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

---@class TraitsOnGameBoot.Mechanic
UsefulOccupations.TraitsOnGameBoot.Mechanic = {}

local traitValues

---@param player IsoPlayer
UsefulOccupations.TraitsOnGameBoot.Mechanic.getBonusRepairPercent = function(player)
	local metalWeldingLvl = player:getPerkLevel(Perks.MetalWelding) * traitValues.repairBonusPercentPerLvl()
	local mechanicsLvl = player:getPerkLevel(Perks.Mechanics) * traitValues.repairBonusPercentPerLvl()

	return traitValues.repairBonusPercent() + metalWeldingLvl + mechanicsLvl
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	traitValues = UsefulOccupations.PersonalTraits.Mechanic.values
end)