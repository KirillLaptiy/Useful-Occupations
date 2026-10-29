--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local Fish = Fishing.Fish

local fishOld_new = Fish.new
local fishOld_update = Fish.update
local fishOld_getFishByLure = Fish.getFishByLure
local fishOld_createFish = Fish.createFish
local fishOld_getFish = Fish.getFish

local scoutSkillsType

---------------------------------------------------------------------
-- Buffs config
---------------------------------------------------------------------
---@class ScoutSkills_FishingCFG
local CFG = {
	multiCatchChancePerLvl = { 10, 8, 6, 4, 2, 1 },
	noTrashChancePerLvl     = 9,
	sizeSmall               = 5,
	sizeMedium              = 25,
	sizeBig                 = 70,
	qualityMultPerLvl       = 1,
}

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------
local function isScout(character)
	return character:hasTrait(UsefulOccupations.Functions.getTraitByStr(scoutSkillsType))
end

function Fish:getFishByLure()
	if not isScout(self.character) then
		return fishOld_getFishByLure(self)
	end

	setGameSpeed(1)
	getGameTime():setMultiplier(1)

	local noTrashChance = math.min(CFG.noTrashChancePerLvl, CFG.noTrashChancePerLvl * self.fishingLvl)

	if ZombRandFloat(0.0, 1.0) >= noTrashChance then
		return Fishing.trashItems[ZombRand(#Fishing.trashItems) + 1], true
	end

	local item = nil
	local fishes = {}
	local baitFactorSum = 0

	for _, fishConfig in ipairs(Fishing.fishes) do
		if (self.isRiver and fishConfig.isRiver) or (not self.isRiver and fishConfig.isLake) then
			if fishConfig.lure[self.lure] ~= nil then
				table.insert(fishes, fishConfig)
				baitFactorSum = baitFactorSum + fishConfig.lure[self.lure]
			end
		end
	end

	local sum = 0
	local fishNumber = ZombRandFloat(0.0, baitFactorSum)

	for _, fishConfig in ipairs(fishes) do
		sum = sum + fishConfig.lure[self.lure]
		if sum >= fishNumber then
			item = fishConfig
			break
		end
	end

	if item == nil then
		if self.lure ~= nil then
			print("No fish for lure :" .. self.lure)
		end
		return Fishing.trashItems[ZombRand(#Fishing.trashItems) + 1], true
	end

	return item, false
end

---------------------------------------------------------------------
-- New fish size chances and more delicious fish
---------------------------------------------------------------------
function Fish:createFish(fishConfig)
	if not isScout(self.character) then
		return fishOld_createFish(self, fishConfig)
	end

	local utils = Fishing.Utils
	local origChances = utils.getFishSizeChancesBySkillLevel
	utils.getFishSizeChancesBySkillLevel = function()
		return CFG.sizeSmall, CFG.sizeMedium, CFG.sizeBig
	end

	local ok, item = pcall(fishOld_createFish, self, fishConfig)
	utils.getFishSizeChancesBySkillLevel = origChances

	if not ok then error(item) end

	---@type Food
	---@diagnostic disable-next-line: assign-type-mismatch
	local fishItem = item

	local m = self.fishingLvl * CFG.qualityMultPerLvl
	fishItem:setCalories(fishItem:getCalories() * m)
	fishItem:setLipids(fishItem:getLipids() * m)
	fishItem:setCarbohydrates(fishItem:getCarbohydrates() * m)
	fishItem:setProteins(fishItem:getProteins() * m)
	fishItem:setBaseHunger(fishItem:getBaseHunger() * m)
	fishItem:setHungChange(fishItem:getBaseHunger())

	return item
end

---------------------------------------------------------------------
-- DOUBLE FISH
---------------------------------------------------------------------
function Fish:getFish()
	fishOld_getFish(self)

	if isScout(self.character) and self.fishItem ~= nil then
		local lvl = self.fishingLvl
		local extra = 0

		for _, chancePerLvl in ipairs(CFG.multiCatchChancePerLvl) do
			if ZombRand(100) >= lvl * chancePerLvl then break end
			extra = extra + 1
		end

		local inv = self.character:getInventory()
		for _ = 1, extra do
			inv:AddItem(self.fishItem:createCloneItem())
		end
	end
end

---------------------------------------------------------------------
-- Init values
---------------------------------------------------------------------
Events.OnGameStart.Add(function()
	scoutSkillsType = UsefulOccupations.PersonalTraits.ScoutSkills.type
end)
