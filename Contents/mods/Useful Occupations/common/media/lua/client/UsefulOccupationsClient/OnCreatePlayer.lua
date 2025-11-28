--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

Events.OnCreatePlayer.Add(function(_, player)
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
			if player:HasTrait(trait.decorationTrait.type) then
				player:getTraits():add(trait.originalTrait.type)
				player:getTraits():remove(trait.decorationTrait.type)
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

		if player:HasTrait(traitName) then
			UsefulOccupations.DoTraitsOnCreatePlayer[func](player)
		end
	end

	-- Give start profession items
	local profession = player:getDescriptor():getProfession()
	local inventory = player:getInventory()

	-- Scout
	-- Give the player a lockpick for the first time
	if profession == professions.Scout.type and modData.gotScoutKit == false then
		inventory:AddItem("UO.Lockpick")
		modData.gotScoutKit = true
	end

	-- SPM
	if profession == professions.SPM.type and modData.gotSPMKit == false then
		inventory:AddItem("Base.SmallSaw")
		modData.gotSPMKit = true
	end
end)
