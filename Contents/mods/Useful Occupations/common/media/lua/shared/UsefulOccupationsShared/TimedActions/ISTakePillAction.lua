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
	local traits = player:getTraits()

	traits:remove("HardOfHearing")
	traits:remove("ShortSighted")
	traits:remove("KeenHearing")
	traits:remove("EagleEyed")
	traits:remove("NightVision")

	if modData.hasHardOfHearing then
		traits:add("HardOfHearing")
	end

	if modData.hasShortSighted then
		traits:add("ShortSighted")
	end

	if modData.hasKeenHearing then
		traits:add("KeenHearing")
	end

	if modData.hasEagleEyed then
		traits:add("EagleEyed")
	end

	if modData.hasNightVision then
		traits:add("NightVision")
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
		local traits = self.character:getTraits()
		local modData = UsefulOccupations.Functions.getModData()

		if modData.SPTraitsSaved == false then
			modData.SPTraitsSaved = true
			modData.hasHardOfHearing = traits:contains("HardOfHearing")
			modData.hasShortSighted = traits:contains("ShortSighted")
			modData.hasKeenHearing = traits:contains("KeenHearing")
			modData.hasEagleEyed = traits:contains("EagleEyed")
			modData.hasNightVision = traits:contains("NightVision")
		end

		-- Clear old effect
		Events.EveryTenMinutes.Remove(everyTenMinutes)
		modData.SPActiveTime = 0
		endPills(self.character, modData)

		traits:remove("HardOfHearing")
		traits:remove("ShortSighted")

		if self.item:getType() == "StimulantDropsPlus" then
			modData.SPStrength = 1
			modData.SPActiveTime = modData.SPActiveTime + 1440

			traits:add("KeenHearing")
			traits:add("EagleEyed")
			traits:add("NightVision")
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
