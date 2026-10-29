--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UORECIPES.SavedMREItemData
---@field type string
---@field module string
---@field originalName string
---@field modData table
---@field fluids string?

UORECIPES = {}

local SAFE_STATS_MAP = {
	["getAge"] = "setAge",
	["getOffAge"] = "setOffAge",
	["getOffAgeMax"] = "setOffAgeMax",
	["getOffString"] = "setOffString",
	["getUnhappyChange"] = "setUnhappyChange",
	["getBoredomChange"] = "setBoredomChange",
	["getStressChange"] = "setStressChange",
	["getFatigueChange"] = "setFatigueChange",
	["getFoodSicknessChange"] = "setFoodSicknessChange",
	["getReduceInfectionPower"] = "setReduceInfectionPower",
	["getMinutesToCook"] = "setMinutesToCook",
	["getCookingTime"] = "setCookingTime",
	["getBurntString"] = "setBurntString",
	["getUnCookedString"] = "setUnCookedString",
	["getWetness"] = "setWetness",
	["getAlcoholPower"] = "setAlcoholPower",
	["getHungerChange"] = "setHungerChange",
	["getThirstChange"] = "setThirstChange",
	["getCalories"] = "setCalories",
	["getProteins"] = "setProteins",
	["getLipids"] = "setLipids",
	["getCarbohydrates"] = "setCarbohydrates",

	["getCondition"] = "setCondition",
	["getConditionMax"] = "setConditionMax",
	["getCurrentUses"] = "setCurrentUses",
	["getCurrentUsesFloat"] = "setCurrentUsesFloat",
	["getUses"] = "setUses",
	["getMaxUses"] = "setMaxUses",
	["getSharpness"] = "setSharpness",
	["getHeadCondition"] = "setHeadCondition",
	["getHeadConditionMax"] = "setHeadConditionMax",
	["getTimesRepaired"] = "setTimesRepaired",
	["getTimesHeadRepaired"] = "setTimesHeadRepaired",
	["getCurrentAmmoCount"] = "setCurrentAmmoCount",

	["getCount"] = "setCount",
	["getWeight"] = "setWeight",
	["getActualWeight"] = "setActualWeight",
	["getItemCapacity"] = "setItemCapacity",
	["getMaxCapacity"] = "setMaxCapacity",
	["getColorRed"] = "setColorRed",
	["getColorGreen"] = "setColorGreen",
	["getColorBlue"] = "setColorBlue",

	["isContainsClip"] = "setContainsClip",
	["isCooked"] = "setCooked",
	["isBurnt"] = "setBurnt",
	["IsRotten"] = "setRotten",
	["isAlcoholic"] = "setAlcoholic",
	["isWet"] = "setWet",
	["isBroken"] = "setBroken",
	["isDull"] = "setDull",
	["isActivated"] = "setActivated",
	["isFavorite"] = "setFavorite",
}

-- MOD DATA CAN'T RECEIVE FLUID, SO WE NEED TO SERIALIZE IT TO STRING
---@param fluidContainer FluidContainer
---@return string
local function serializeFluids(fluidContainer)
	if not fluidContainer then return "" end

	local result = {}

	local allFluids = Fluid.getAllFluids()

	if allFluids then
		for i = 0, allFluids:size() - 1 do
			local fluid = allFluids:get(i)
			local amount = fluidContainer:getSpecificFluidAmount(fluid)

			if amount and amount > 0 then
				table.insert(result, fluid:getFluidTypeString() .. ":" .. tostring(amount))
			end
		end
	end

	return table.concat(result, ";")
end

-- Prevent ability to put containers in the mre
---@param mre ItemContainer
---@param item InventoryItem
function UORECIPES.UO_MRE_AcceptItem(mre, item)
	if item:IsInventoryContainer() and not item:isFluidContainer() then
		return false
	end

	return true
end

-- MRE PACKS
---@param craftRecipeData CraftRecipeData
function UORECIPES.SEAL_MRE(craftRecipeData, _)
	---@type InventoryContainer
	---@diagnostic disable-next-line: assign-type-mismatch
	local MREPack = craftRecipeData:getAllConsumedItems():get(0)

	local MREPackItems = MREPack:getInventory():getItems()

	---@type InventoryItem
	local SealedMRE = craftRecipeData:getFirstCreatedItem()

	local SealedMREModData = SealedMRE:getModData()

	SealedMREModData.MREItems = {}

	-- The sealed MRE has the same weight as the unsealed one
	SealedMRE:setActualWeight(MREPack:getWeight() + MREPack:getContentsWeight())

	for i = 0, MREPackItems:size() - 1 do
		local item = MREPackItems:get(i)

		table.insert(
			SealedMREModData.MREItems,
			(function()
				local data = {
					type = item:getType(),
					module = item:getModule(),
					originalName = item:getDisplayName(),
					modData = item:getModData(),
					fluids = nil,
				}

				for getMethod, setMethod in pairs(SAFE_STATS_MAP) do
					if item[getMethod] then
						local ok, value = pcall(item[getMethod], item)
						if ok and value ~= nil then
							data[getMethod] = value
						end
					end
				end

				-- Saving fluid container data if the item is a fluid container
				local fluidContainer = item:getFluidContainer()
				if fluidContainer and fluidContainer:getAmount() > 0 then
					data.fluids = serializeFluids(fluidContainer)
				end

				return data
			end)()
		)
	end
end

---@param craftRecipeData CraftRecipeData
---@param character IsoPlayer
function UORECIPES.UNPACK_MRE(craftRecipeData, character)
	local MRE_SEALED = craftRecipeData:getAllInputItems():get(0)
	if not MRE_SEALED then return end

	local modData = MRE_SEALED:getModData()

	if not modData.MREItems then
		return
	end

	---@param storedItem UORECIPES.SavedMREItemData
	for _, storedItem in ipairs(modData.MREItems) do
		local fullType = storedItem.type
		if storedItem.module then
			fullType = storedItem.module .. "." .. storedItem.type
		end

		---@type InventoryItem
		local item = character:getInventory():AddItem(fullType)

		if item then
			for getMethod, setMethod in pairs(SAFE_STATS_MAP) do
				local value = storedItem[getMethod]
				if value ~= nil and item[setMethod] then
					pcall(item[setMethod], item, value)
				end
			end

			-- Restoring fluid container data if it was saved
			local fluidContainer = item:getFluidContainer()
			if fluidContainer then
				local fluidString = storedItem.fluids
				fluidContainer:Empty()

				---@diagnostic disable-next-line: param-type-mismatch
				for entry in string.gmatch(fluidString, "([^;]+)") do
					local fluidType, amountStr = entry:match("([^:]+):([%d%.]+)")

					if fluidType and amountStr then
						local amount = tonumber(amountStr)
						local fluid = Fluid.Get(fluidType)

						if fluidType and amount then
							fluidContainer:addFluid(fluid, amount)
						end
					end
				end
			end

			if storedItem.originalName then
				item:setName(storedItem.originalName)
			end

			if storedItem.modData then
				local itemModData = item:getModData()
				for k, v in pairs(storedItem.modData) do
					itemModData[k] = v
				end
			end
		end
	end
end

-- Breaks metal sheet molds
---@param craftRecipeData CraftRecipeData
---@param character IsoPlayer
function UORECIPES.TakeMetalSheetFromMold(craftRecipeData, character)
	-- Mold without metal sheet
	---@type InventoryItem
	---@diagnostic disable-next-line: assign-type-mismatch
	local createdItem = craftRecipeData:getAllCreatedItems():get(1)

	-- Remove weak mold
	if createdItem:getType() ~= "CementMold" then
		UsefulOccupations.Functions.processAfterDelay(10, function()
			character:getInventory():Remove(createdItem)
		end)
	end
end

-- Removes old propane tank
---@param craftRecipeData CraftRecipeData
---@param _ IsoPlayer
function UORECIPES.MakeInputFullByFlagNotFull(craftRecipeData, _)
	-- Propane tank
	---@type InventoryItem
	---@diagnostic disable-next-line: assign-type-mismatch
	local inputItem = craftRecipeData:getAllInputItemsWithFlag("NotFull"):get(0)

	-- Remove old propane tank
	UsefulOccupations.Functions.processAfterDelay(10, function()
		inputItem:setCurrentUses(inputItem:getMaxUses())
	end)
end

-- Makes created drainable items empty
---@param craftRecipeData CraftRecipeData
---@param _ IsoPlayer
function UORECIPES.MakeAllCreatedEmpty(craftRecipeData, _)
	local createdItems = craftRecipeData:getAllCreatedItems()

	UsefulOccupations.Functions.processAfterDelay(10, function()
		for i = 0, createdItems:size() - 1 do
			---@type InventoryItem
			---@diagnostic disable-next-line: assign-type-mismatch
			local createdItem = createdItems:get(i)

			if createdItem:IsDrainable() then
				createdItem:setCurrentUses(0)
			end
		end
	end)
end
