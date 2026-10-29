-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

local traitType

local materials = {
	{ "AluminumScrap", 12 },
	{ "CopperScrap", 12 },
	{ "ElectricWire", 25 },
	{ "EngineParts", 25 },
	{ "IronBand", 25 },
	{ "IronBandSmall", 15 },
	{ "IronScrap", 12 },
	{ "MetalBar", 15 },
	{ "MetalPipe", 15 },
	{ "NutsBolts", 25 },
	{ "ScrapMetal", 12 },
	{ "Screws", 25 },
	{ "SheetMetal", 25 },
	{ "SmallSheetMetal", 15 },
	{ "SteelBar", 25 },
	{ "SteelBarHalf", 15 },
	{ "SteelBarQuarter", 12 },
	{ "SteelBlock", 25 },
	{ "SteelChunk", 15 },
	{ "SteelPiece", 12 },
	{ "Wire", 25 },
}

-- Mechanic gets more resources from burnt vehicle
---@diagnostic disable-next-line: duplicate-set-field
function ISRemoveBurntVehicle:complete()
	local totalXp = 5

	local metalWeldingLvl = self.character:getPerkLevel(Perks.MetalWelding)

	local rollingCount = math.max(5, metalWeldingLvl)

	-- Mechanic has more rolling counts
	if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType)) then
		local mechanicsLvl = self.character:getPerkLevel(Perks.Mechanics)
		rollingCount = metalWeldingLvl + mechanicsLvl
	end

	for _ = 1, rollingCount do
		for _, data in ipairs(materials) do
			local item, baseChance = data[1], data[2]

			for _ = 1, 2 do
				---@diagnostic disable-next-line: param-type-mismatch
				if self:checkAddItem(item, baseChance) then
					totalXp = totalXp + 1
				end
			end
		end
	end

	for _ = 1, 10 do
		self.item:Use(false, false, true)
	end

	addXp(self.character, Perks.MetalWelding, totalXp)

	if self.vehicle then
		self.vehicle:permanentlyRemove()
	else
		print("no such vehicle id=", self.vehicle:getId())
		return false
	end

	return true
end

-- Mechanic has 100% chance to get resources
---@diagnostic disable-next-line: duplicate-set-field
function ISRemoveBurntVehicle:checkAddItem(item, baseChance)
	if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType)) then
		self.vehicle:getSquare():AddWorldInventoryItem(item, ZombRandFloat(0, 0.9), ZombRandFloat(0, 0.9), 0)
		return true
	end

	local skillLevel = self.character:getPerkLevel(Perks.MetalWelding)

	if item == "EngineParts" then
		skillLevel = math.min(self.character:getPerkLevel(Perks.Mechanics), skillLevel)
	end

	if ZombRand(baseChance - skillLevel) == 0 then
		self.vehicle:getSquare():AddWorldInventoryItem(item, ZombRandFloat(0, 0.9), ZombRandFloat(0, 0.9), 0)
		return true
	elseif ZombRand(baseChance - self.character:getPerkLevel(Perks.MetalWelding)) == 0 then
		local itemType = nil

		if item == "AluminumScrap" then
			itemType = "AluminumFragments"
		elseif item == "EngineParts" then
			itemType = "IronScrap"
		elseif item == "IronBand" then
			itemType = "IronScrap "
		elseif item == "IronBandSmall" then
			itemType = "IronScrap"
		elseif item == "IronScrap" then
			itemType = "IronPiece"
		elseif item == "MetalBar" then
			itemType = "SteelRodHalf"
		elseif item == "MetalPipe" then
			itemType = "MetalPipe_Broken"
		elseif item == "SheetMetal" then
			itemType = "UnusableMetal"
		elseif item == "SmallSheetMetal" then
			itemType = "UnusableMetal"
		elseif item == "SteelBar" then
			itemType = "SteelBarHalf"
		elseif item == "SteelBarHalf" then
			itemType = "SteelBarQuarter"
		elseif item == "SteelBarQuarter" then
			itemType = "SteelScrap"
		elseif item == "SteelBlock" then
			itemType = "SteelScrap"
		elseif item == "SteelChunk" then
			itemType = "SteelScrap"
		elseif item == "SteelScrap" then
			itemType = "SteelPiece"
		end

		if itemType then
			self.vehicle:getSquare():AddWorldInventoryItem(itemType, ZombRandFloat(0, 0.9), ZombRandFloat(0, 0.9), 0)
		end
	end

	return false
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	local trait = UsefulOccupations.PersonalTraits.Mechanic

	traitType = trait.type
end)
