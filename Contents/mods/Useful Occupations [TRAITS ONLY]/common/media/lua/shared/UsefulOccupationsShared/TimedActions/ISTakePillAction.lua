--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local oldTakePill = ISTakePillAction.complete

---@param player IsoPlayer
---@param modData UsefulOccupations.ModData
local endPills = function(player, modData)
	local traits = player:getCharacterTraits()

	traits:remove(UsefulOccupations.Functions.getTraitByStr("HardOfHearing"))
	traits:remove(UsefulOccupations.Functions.getTraitByStr("ShortSighted"))
	traits:remove(UsefulOccupations.Functions.getTraitByStr("KeenHearing"))
	traits:remove(UsefulOccupations.Functions.getTraitByStr("EagleEyed"))
	traits:remove(UsefulOccupations.Functions.getTraitByStr("NightVision"))

	if modData.hasHardOfHearing then
		traits:add(UsefulOccupations.Functions.getTraitByStr("HardOfHearing"))
	end

	if modData.hasShortSighted then
		traits:add(UsefulOccupations.Functions.getTraitByStr("ShortSighted"))
	end

	if modData.hasKeenHearing then
		traits:add(UsefulOccupations.Functions.getTraitByStr("KeenHearing"))
	end

	if modData.hasEagleEyed then
		traits:add(UsefulOccupations.Functions.getTraitByStr("EagleEyed"))
	end

	if modData.hasNightVision then
		traits:add(UsefulOccupations.Functions.getTraitByStr("NightVision"))
	end
end

local function everyTenMinutes()
	local modData = UsefulOccupations.Functions.getModData()
	modData.SPActiveTime = math.max(0, modData.SPActiveTime - 10)

	if modData.SPActiveTime == 0 then
		Events.EveryTenMinutes.Remove(everyTenMinutes)
		endPills(getPlayer(), modData)
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function ISTakePillAction:complete()
	if self.item:hasTag("UOPills") then
		local traits = self.character:getCharacterTraits()
		local modData = UsefulOccupations.Functions.getModData()

		if modData.SPTraitsSaved == false then
			modData.SPTraitsSaved = true
			modData.hasHardOfHearing = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr("HardOfHearing"))
			modData.hasShortSighted = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr("ShortSighted"))
			modData.hasKeenHearing = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr("KeenHearing"))
			modData.hasEagleEyed = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr("EagleEyed"))
			modData.hasNightVision = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr("NightVision"))
		end

		-- Clear old effect
		Events.EveryTenMinutes.Remove(everyTenMinutes)
		modData.SPActiveTime = 0
		endPills(self.character, modData)

		traits:remove(UsefulOccupations.Functions.getTraitByStr("HardOfHearing"))
		traits:remove(UsefulOccupations.Functions.getTraitByStr("ShortSighted"))

		if self.item:getType() == "StimulantDropsPlus" then
			modData.SPStrength = 1
			modData.SPActiveTime = modData.SPActiveTime + 1440

			traits:add(UsefulOccupations.Functions.getTraitByStr("KeenHearing"))
			traits:add(UsefulOccupations.Functions.getTraitByStr("EagleEyed"))
			traits:add(UsefulOccupations.Functions.getTraitByStr("NightVision"))
		else
			modData.SPStrength = 0
			modData.SPActiveTime = modData.SPActiveTime + 720
		end

		Events.EveryTenMinutes.Add(everyTenMinutes)
	else
		oldTakePill(self)
	end

	return true
end

table.insert(UsefulOccupations.DoFuncsOnCreatePlayer, function(_, _)
	local modData = UsefulOccupations.Functions.getModData()

	if modData.SPActiveTime > 0 then
		Events.EveryTenMinutes.Add(everyTenMinutes)
	end
end)
