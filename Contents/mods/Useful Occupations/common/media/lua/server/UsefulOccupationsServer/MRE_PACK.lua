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
---@field originalName string
---@field modData table

UORECIPES = {}

local SEALED_TAG = "UO_MREKit"

local invalidSetNames = {
	setRegistry_id = true,
	setRecordedMediaIndex = true,
	setContainer = true,
	setUsingPlayer = true,
	setName = true,
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

---@param craftRecipeData CraftRecipeData
function UORECIPES.SEAL_MRE(craftRecipeData, _)
	---@type InventoryContainer
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
		local item = MREPackItems:get(i)

		local getSet = findGetSetPairs(item)

		table.insert(
			SealedMREModData.MREItems,
			(function()
				local data = {
					type = item:getType(),
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
	local MRE_SEALED = craftRecipeData:getFirstInputItemWithTag(SEALED_TAG)

	local modData = MRE_SEALED:getModData()

	if not modData.MREItems then
		return
	end

	---@param storedItem UORECIPES.SavedMREItemData
	for _, storedItem in ipairs(modData.MREItems) do
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

		item:setName(storedItem.originalName)
	end
end
