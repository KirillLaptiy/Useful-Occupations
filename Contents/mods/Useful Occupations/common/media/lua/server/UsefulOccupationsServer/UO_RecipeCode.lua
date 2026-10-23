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

UORECIPES = {}

local SEALED_TAG = "uo_mrekit"

local invalidSetNames = {
	setRegistry_id = true,
	setRecordedMediaIndex = true,
	setContainer = true,
	setUsingPlayer = true,
	setName = true,
	setTextureColorMask = true,
}

---@param obj table
---@return table getSetPairs
local function findGetSetPairs(obj)
	local pairsTable = {}
	local mt = getmetatable(obj)
	local index = mt and rawget(mt, "__index") or {}

	for k, v in pairs(index) do
		if type(v) == "function" and k:sub(1, 3) == "get" then
			local suffix = k:sub(4)
			local setName = "set" .. suffix

			if type(index[setName]) == "function" and not invalidSetNames[setName] then
				pairsTable[k] = setName
			end
		end
	end

	return pairsTable
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
		---@type InventoryItem
		---@diagnostic disable-next-line: assign-type-mismatch
		local item = MREPackItems:get(i)

		local getSet = findGetSetPairs(item)

		table.insert(
			SealedMREModData.MREItems,
			(function()
				local data = {
					type = item:getType(),
					module = item:getModule(),
					originalName = item:getDisplayName(),
					modData = item:getModData(),
				}

				for getMethod, _ in pairs(getSet) do
					local func = item[getMethod]

					if type(func) == "function" then
						local ok, value = pcall(func, item)

						if ok then
							data[getMethod] = value
						end
					end
				end

				return data
			end)()
		)
	end
end

---@param craftRecipeData CraftRecipeData
---@param character IsoPlayer
function UORECIPES.UNPACK_MRE(craftRecipeData, character)
	local MRE_SEALED = craftRecipeData:getFirstInputItemWithTag(UsefulOccupations.Functions.getItemTagByStr(SEALED_TAG))

	local modData = MRE_SEALED:getModData()

	if not modData.MREItems then
		return
	end

	---@param storedItem UORECIPES.SavedMREItemData
	for _, storedItem in ipairs(modData.MREItems) do
		if storedItem.module then
			storedItem.type = storedItem.module .. "." .. storedItem.type
		end

		---@type InventoryItem
		---@diagnostic disable-next-line: assign-type-mismatch
		local item = character:getInventory():AddItem(storedItem.type)

		local getSet = findGetSetPairs(item)

		for k, v in pairs(storedItem.modData or {}) do
			item:getModData()[k] = v
		end

		for getMethod, setMethod in pairs(getSet) do
			local value = storedItem[getMethod]

			if value ~= nil then
				item[setMethod](item, value)
			end
		end

		if storedItem.originalName then
			item:setName(storedItem.originalName)
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
