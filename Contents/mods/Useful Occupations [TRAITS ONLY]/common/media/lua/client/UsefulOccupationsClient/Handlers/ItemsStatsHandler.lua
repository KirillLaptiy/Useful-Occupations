--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UOItemsStatsHandler.itemValues
---@field stompPower number
---@field hitChance number
---@field criticalChance number
---@field aimingTime number
---@field maxRange number
---@field minAngle number
---@field maxAngle number
---@field minDamage number
---@field maxDamage number
---@field conditionLowerChance number
---@field actualWeight number
---@field runSpeedModifier number
---@field combatSpeedModifier number
---@field invincibleSharpness number
---@field invincibleHeadCondition number
---@field invincibleConditionLowerChance number

---@class UOItemsStatsHandler
UOItemsStatsHandler = {}

---@type UsefulOccupations.Functions
local funcs
---@type UsefulOccupations.PersonalTraits
local personalTraits

local itemValues = {
	"stompPower",
	"hitChance",
	"criticalChance",
	"aimingTime",
	"maxRange",
	"minAngle",
	"maxAngle",
	"minDamage",
	"maxDamage",
	"conditionLowerChance",
	"actualWeight",
	"runSpeedModifier",
	"combatSpeedModifier",
}

---@type IsoPlayer
local player

---@type ItemContainer
local inventory

local isWeaponUnbreakable = false

---@param item HandWeapon
---@param itemdata UOItemsStatsHandler.itemValues
local updateWeaponUnbreakable = function(item, itemdata)
	if itemdata.invincibleSharpness == nil then
		itemdata.invincibleSharpness = item:getSharpness()
	end

	if itemdata.invincibleHeadCondition == nil then
		itemdata.invincibleHeadCondition = item:getHeadCondition()
	end

	if itemdata.invincibleConditionLowerChance == nil then
		itemdata.invincibleConditionLowerChance = item:getConditionLowerChance()
	end

	if isWeaponUnbreakable and item:isEquipped() then
		item:setConditionLowerChance(math.huge)
		item:setSharpness(itemdata.invincibleSharpness >= 0.2 and itemdata.invincibleSharpness or 0.2)
		item:setHeadCondition(itemdata.invincibleHeadCondition >= 2 and itemdata.invincibleHeadCondition or 2)
	else
		itemdata.invincibleSharpness = nil
		itemdata.invincibleHeadCondition = nil

		if itemdata.invincibleConditionLowerChance ~= nil then
			item:setConditionLowerChance(itemdata.invincibleConditionLowerChance)
			itemdata.invincibleConditionLowerChance = nil
		end
	end
end

---@param item HandWeapon
---@param itemdata table
local updateFirearm = function(item, itemdata)
	if player:hasTrait(funcs.getTraitByStr(personalTraits.Marksman.type)) then
		UsefulOccupations.InventoryItemsStatsHandler.Marksman(item, itemdata)
	end
end

---@param item HandWeapon
---@param itemdata table
local updateMelee = function(item, itemdata)
	if player:hasTrait(funcs.getTraitByStr(personalTraits.TrainedFighter.type)) then
		UsefulOccupations.InventoryItemsStatsHandler.TrainedFighter(item, itemdata)
	end
end

---@param item Clothing
---@param itemdata table
local updateClothing = function(item, itemdata)
	if player:hasTrait(funcs.getTraitByStr(personalTraits.Graceful.type)) then
		UsefulOccupations.InventoryItemsStatsHandler.Graceful(item, itemdata)
	end
end

---@param item InventoryContainer
---@param itemdata table
local updateInvContainer = function(item, itemdata)
	if player:hasTrait(funcs.getTraitByStr(personalTraits.Graceful.type)) then
		UsefulOccupations.InventoryItemsStatsHandler.Graceful(item, itemdata)
	end
end

local updateInventoryItemsStats = function()
	-- Requires a 1ms delay to get the correct item equip state
	UsefulOccupations.Functions.processAfterDelay(1, function()
		local items = inventory:getItems()

		for i = 0, items:size() - 1 do
			---@type InventoryItem
			---@diagnostic disable-next-line: assign-type-mismatch
			local item = items:get(i)

			---@type UOItemsStatsHandler.itemValues
			local itemdata = item:getModData()

			local isWeapon = item:IsWeapon()

			for _, value in ipairs(itemValues) do
				local getType = "get" .. value:gsub("^%l", string.upper)
				local setType = "set" .. value:gsub("^%l", string.upper)

				if type(item[getType]) == "function" then
					if itemdata[value] == nil then
						itemdata[value] = item[getType](item)
					elseif type(item[setType]) == "function" and item:isEquipped() == false then
						item[setType](item, itemdata[value])
					end
				end
			end

			if item:isEquipped() == true then
				-- Weapon effect
				if isWeapon then
					---@diagnostic disable-next-line: undefined-field
					if item:isAimedFirearm() then
						---@diagnostic disable-next-line: param-type-mismatch
						updateFirearm(item, itemdata)
					else
						---@diagnostic disable-next-line: param-type-mismatch
						updateMelee(item, itemdata)
					end

					-- Clothing effect
				elseif item:IsClothing() then
					---@diagnostic disable-next-line: param-type-mismatch
					updateClothing(item, itemdata)

					-- Backpack effect
				elseif item:IsInventoryContainer() then
					---@diagnostic disable-next-line: param-type-mismatch
					updateInvContainer(item, itemdata)
				end
			end

			if isWeapon then
				---@diagnostic disable-next-line: param-type-mismatch
				updateWeaponUnbreakable(item, itemdata)
			end
		end
	end)
end

---@param unbreakable boolean
function UOItemsStatsHandler:updateWeaponUnbreakable(unbreakable)
	isWeaponUnbreakable = unbreakable
	updateInventoryItemsStats()
end

function UOItemsStatsHandler:updateInventoryItemsStats()
	updateInventoryItemsStats()
end

-- Do on create player
table.insert(UsefulOccupations.DoFuncsOnCreatePlayer, function(_, createdPlayer)
	player = createdPlayer
	inventory = player:getInventory()
	funcs = UsefulOccupations.Functions
	personalTraits = UsefulOccupations.PersonalTraits

	updateInventoryItemsStats()
end)

Events.OnEquipPrimary.Add(updateInventoryItemsStats)
Events.OnEquipSecondary.Add(updateInventoryItemsStats)
Events.OnClothingUpdated.Add(updateInventoryItemsStats)
