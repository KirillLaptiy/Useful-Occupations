--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local funcs = UsefulOccupations.Functions

local scoutStartKitStr = "UO.ScoutStartKit"
local spmStartKitStr = "UO.SPMStartKit"

local opts = SandboxOptions:getInstance()

local getSandboxValue = function(value)
	local option = opts:getOptionByName(value)

	if not option then
		error("OPTION WITH NAME" .. " " .. value .. " " .. "NOT FOUND")
	end

	return option:asConfigOption():getValueAsObject()
end

Events.OnCreatePlayer.Add(function(playerNum, player)
	local professions = UsefulOccupations.Professions

	-- Call only 1 time
	if not UsefulOccupations.Functions.getModData() then
		-- Init mod data
		local modData = UsefulOccupations.Functions.initModData()

		-- Init perks mod data
		for i = 0, Perks.getMaxIndex() - 1 do
			local perk = Perks.fromIndex(i)
			local perkName = perk:getName()

			modData[perkName] = {}
			modData[perkName].startXpBoost = player:getXp():getPerkBoost(perk)
		end

		-- Add vanilla traits from they decorations
		for _, trait in pairs(UsefulOccupations.DecorationTraits) do
			local characterTrait = funcs.getTraitByStr(trait.originalTraitType)
			local characterDecTrait = funcs.getTraitByStr(trait.decorationTraitType)

			if player:hasTrait(characterTrait) then
				player:getCharacterTraits():remove(characterTrait)

				-- Avoids double trait cases (like fit and stout traits)
				if not player:hasTrait(characterDecTrait) then
					player:getCharacterTraits():add(characterDecTrait)
				end
			end
		end
	end

	-- Call every join
	-- Updating mod data keys if moddata was changed
	local modData = UsefulOccupations.Functions.getModData()

	-- Add new mod data if main data updated
	for key, value in pairs(UsefulOccupations.ModData) do
		modData[key] = modData[key] or value
	end

	-- Remove old mod data if main data updated
	for key in pairs(modData) do
		if UsefulOccupations.ModData[key] == nil then
			modData[key] = nil
		end
	end

	-- Call every join
	-- Do personal traits when player created
	for func in pairs(UsefulOccupations.DoTraitsOnCreatePlayer) do
		local traitName = tostring(func)

		---@diagnostic disable-next-line: param-type-mismatch
		if player:hasTrait(UsefulOccupations.Functions.tryGetTraitByStr(traitName)) then
			UsefulOccupations.DoTraitsOnCreatePlayer[func](player)
		end
	end

	-- Call every join
	-- Do OnCreatePlayer functions when player created
	-- Need to correct init mod data, when other OnCreatePlayer functions calls before this one
	for func in pairs(UsefulOccupations.DoFuncsOnCreatePlayer) do
		UsefulOccupations.DoFuncsOnCreatePlayer[func](playerNum, player)
	end

	-- Give start profession items
	local profession = player:getDescriptor():getCharacterProfession():getName():lower()
	local inventory = player:getInventory()

	local scoutKitEnabled = getSandboxValue(scoutStartKitStr)
	local spmKitEnabled = getSandboxValue(spmStartKitStr)

	-- Scout
	if scoutKitEnabled and profession == professions.Scout.type and modData.gotScoutKit == false then
		inventory:AddItem("UO.Lockpick")
		modData.gotScoutKit = true
	end

	-- SPM
	if spmKitEnabled and profession == professions.SPM.type and modData.gotSPMKit == false then
		local toolbox = inventory:AddItem("Base.Toolbox")
		---@diagnostic disable-next-line: undefined-field
		local container = toolbox:getItemContainer()

		container:AddItems("Base.SmallSaw", 1)
		container:AddItems("Base.Screwdriver", 1)
		container:AddItems("Base.Needle", 1)
		container:AddItems("Base.TinOpener", 1)
		container:AddItems("Base.Scissors", 1)
		container:AddItems("Base.PillsVitamins", 1)
		container:AddItems("Base.PillsSleepingTablets", 1)

		modData.gotSPMKit = true
	end
end)
