-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

---@class DoTraitsOnGameBoot.Mechanic
UsefulOccupations.DoTraitsOnGameBoot.Mechanic = function()
	local traitType = UsefulOccupations.PersonalTraits.Mechanic.type
	local traitValues = UsefulOccupations.PersonalTraits.Mechanic.values

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
		if self.character:HasTrait(traitType) then
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
		if self.character:HasTrait(traitType) then
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
				self.vehicle
					:getSquare()
					:AddWorldInventoryItem(itemType, ZombRandFloat(0, 0.9), ZombRandFloat(0, 0.9), 0)
			end
		end

		return false
	end

	-- Mechanic repairs vehicle more productive
	---@param player IsoPlayer
	local getBonusRepairPercent = function(player)
		local metalWeldingLvl = player:getPerkLevel(Perks.MetalWelding) * traitValues.repairBonusPercentPerLvl
		local mechanicsLvl = player:getPerkLevel(Perks.Mechanics) * traitValues.repairBonusPercentPerLvl

		return traitValues.repairBonusPercent + metalWeldingLvl + mechanicsLvl
	end

	---@diagnostic disable-next-line: duplicate-set-field
	function ISFixVehiclePartAction:complete()
		FixingManager.fixItem(self.item, self.character, self.fixing, self.fixer)

		if self.character:HasTrait(traitType) then
			local mechanicBonusMult = 1 + (getBonusRepairPercent(self.character) / 100)
			self.item:setCondition(self.item:getCondition() * mechanicBonusMult)
		end

		self.vehiclePart:setCondition(self.item:getCondition())
		self.vehiclePart:doInventoryItemStats(self.item, self.vehiclePart:getMechanicSkillInstaller())

		if self.vehiclePart:isContainer() and not self.vehiclePart:getItemContainer() then
			-- Changing condition might change capacity.
			-- This limits content amount to max capacity.
			---@diagnostic disable-next-line: undefined-global
			self.vehiclePart:setContainerContentAmount(part:getContainerContentAmount())
		end

		self.vehiclePart:getVehicle():updatePartStats()
		self.vehiclePart:getVehicle():updateBulletStats()
		self.vehiclePart:getVehicle():transmitPartItem(self.vehiclePart)

		return true
	end

	---@diagnostic disable-next-line: duplicate-set-field
	function ISRepairLightbar:complete()
		local skill = self.character:getPerkLevel(Perks.Mechanics) - self.vehicle:getScript():getEngineRepairLevel()
		local giveXP = self.character:getMechanicsItem(self.part:getVehicle():getMechanicalID() .. "2") == nil

		if self.vehicle then
			if not self.part then
				---@diagnostic disable-next-line: undefined-global
				noise("no such part Ligthbar")
				return false
			end

			local condPerPart = 15 + skill

			if self.character:HasTrait(traitType) then
				local mechanicBonusMult = 1 + (getBonusRepairPercent(self.character) / 100)
				condPerPart = condPerPart * mechanicBonusMult
			end

			self.part:setCondition(self.part:getCondition() + condPerPart)
			if self.part:getCondition() >= 100 then
				self.part:setCondition(100)
			end

			if giveXP then
				addXp(self.character, Perks.Mechanics, 5)
			end

			self.character:getInventory():Remove(self.item)

			if isServer() then
				sendRemoveItemFromContainer(self.character:getInventory(), self.item)
			end

			self.vehicle:transmitPartCondition(self.part)

			self.character:sendObjectChange("mechanicActionDone", { success = true })
			self.character:addMechanicsItem(
				self.item:getID() .. self.vehicle:getMechanicalID() .. "1",
				self.part,
				getGameTime():getCalender():getTimeInMillis()
			)
		else
			print("no such vehicle id=", self.vehicle)
		end

		self.character:addMechanicsItem(
			self.part:getVehicle():getMechanicalID() .. "2",
			self.part,
			getGameTime():getCalender():getTimeInMillis()
		)

		return true
	end
end
