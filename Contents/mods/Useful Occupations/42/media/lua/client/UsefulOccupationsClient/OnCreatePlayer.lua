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
	local currentModData = UsefulOccupations.Functions.getModData()

	for key, value in pairs(UsefulOccupations.ModData) do
		if currentModData[key] == nil then
			currentModData[key] = value
		end
	end

	for key, _ in pairs(currentModData) do
		if UsefulOccupations.ModData[key] == nil then
			currentModData[key] = nil
		end
	end

	-- Call every join
	-- Set inconspicuous default walk type
	player:setVariable("inconspicuousWalkType", "bob")

	-- Do personal traits when player created
	for func in pairs(UsefulOccupations.DoTraitsOnCreatePlayer) do
		local traitName = tostring(func)

		if player:HasTrait(traitName) then
			UsefulOccupations.DoTraitsOnCreatePlayer[func](player)
		end
	end
end)
