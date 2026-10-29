--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local personalTraits = UsefulOccupations.PersonalTraits

-- Outdoorsman
local outdoorsmanType = personalTraits.Outdoorsman.type
local outdoorsmanBuildingTPR = personalTraits.Outdoorsman.values.buildingTPR()

-- Builder
local builderType = personalTraits.Builder.type
local builderValues = personalTraits.Builder.values

local originalISBuildIsoEntity = ISBuildIsoEntity.new

local validOutdoorsmanCrafts = {
	Campfire = "Campfire",
	Tarp_Shelter = "Tarp_Shelter",
	LeanTo_Shelter = "LeanTo_Shelter",
	Leather_Shelter = "Leather_Shelter",
}

local validBuilderOutdoorsCrafts = {
	RainCollector = "RainCollector",
	RainCollector_Tarp = "RainCollector_Tarp",
	RainCollectorRound = "RainCollectorRound",
	RainCollectorRound_Tarp = "RainCollectorRound_Tarp",
}

---@param character IsoGameCharacter
---@param craftRecipe CraftRecipe
---@return boolean
local validBuilderConditions = function(character, craftRecipe)
	local category = craftRecipe:getCategory()

	if character:hasTrait(UsefulOccupations.Functions.getTraitByStr(builderType)) then
		if category == "Outdoors" then
			if validBuilderOutdoorsCrafts[craftRecipe:getName()] then
				return true
			end
		else
			return true
		end
	end

	return false
end

---@param character IsoPlayer
---@param craftRecipe CraftRecipe
local getBuilderTPR = function(character, craftRecipe)
	if craftRecipe:getCategory() == "Packing" then
		return 0
	end

	local skillsCount = craftRecipe:getRequiredSkillCount()

	local reducePercent = builderValues.buildingTPR()

	for i = 0, skillsCount - 1 do
		local requiredSkill = craftRecipe:getRequiredSkill(i)

		local perk = requiredSkill:getPerk()
		local perkLvl = character:getPerkLevel(perk)

		reducePercent = reducePercent + (builderValues.buildingTPRPerLvl() * perkLvl)
	end

	return math.max(0, math.min(100, reducePercent))
end

---@param character IsoPlayer
---@param craftRecipe CraftRecipe
local getBuilderHealthMult = function(character, craftRecipe)
	local healthBonusPercent = builderValues.buildingBHP()

	local skillsCount = craftRecipe:getRequiredSkillCount()

	for i = 0, skillsCount - 1 do
		local requiredSkill = craftRecipe:getRequiredSkill(i)

		local perk = requiredSkill:getPerk()
		local perkLvl = character:getPerkLevel(perk)

		healthBonusPercent = healthBonusPercent + (builderValues.buildingBHPPerLvl() * perkLvl)
	end

	local healthMult = 1 + (healthBonusPercent / 100)

	return healthMult
end

---@param character IsoPlayer
---@param craftRecipe CraftRecipe
local getBuilderCapacityMult = function(character, craftRecipe)
	local capacityBonusPercent = builderValues.buildingCapBonus()

	local skillsCount = craftRecipe:getRequiredSkillCount()

	for i = 0, skillsCount - 1 do
		local requiredSkill = craftRecipe:getRequiredSkill(i)

		local perk = requiredSkill:getPerk()
		local perkLvl = character:getPerkLevel(perk)

		capacityBonusPercent = capacityBonusPercent + (builderValues.buildingCapBonusPerLvl() * perkLvl)
	end

	local capacityMult = 1 + (capacityBonusPercent / 100)

	return capacityMult
end

local oldBuildIsoEntity = ISBuildIsoEntity.setInfo

-- Bonus health, capacity
---@diagnostic disable-next-line: duplicate-set-field
function ISBuildIsoEntity:setInfo(square, north, sprite, openSprite)
	oldBuildIsoEntity(self, square, north, sprite, openSprite)

	if not square or not self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(builderType)) then return end

	-- HEALTH
	local thump = square:getThumpable(north)
	if not thump then return end

	---@diagnostic disable-next-line: param-type-mismatch
	local builderHealthMult = getBuilderHealthMult(self.character, self.craftRecipe)

	thump:setMaxHealth(thump:getMaxHealth() * builderHealthMult)
	thump:setHealth(thump:getMaxHealth())

	-- CAPACITY
	local container = thump:getContainer()
	local fluidContainer = thump:getFluidContainer()
	---@diagnostic disable-next-line: param-type-mismatch
	local capacityMult = getBuilderCapacityMult(self.character, self.craftRecipe)

	if container then
		container:setCapacity(container:getCapacity() * capacityMult)
	end

	if fluidContainer then
		fluidContainer:setCapacity(fluidContainer:getCapacity() * capacityMult)
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function ISBuildIsoEntity:new(character, objectInfo, nSprite, containers, logic)
	local o = originalISBuildIsoEntity(self, character, objectInfo, nSprite, containers, logic)

	local newTime

	---@type CraftRecipe | false
	local craftRecipe = o.craftRecipe

	-- Outdoorsman builds campfire and tents faster
	if validOutdoorsmanCrafts[o.name] and character:hasTrait(UsefulOccupations.Functions.getTraitByStr(outdoorsmanType)) then
		newTime = o.maxTime * (1 - (outdoorsmanBuildingTPR / 100))
	end

	-- Builder builds all faster
	if craftRecipe and validBuilderConditions(character, craftRecipe) then
		local builderTPR = getBuilderTPR(character, craftRecipe)
		newTime = o.maxTime * (1 - (builderTPR / 100))
	end

	if newTime then
		if newTime < 100 then
			newTime = 100
		end

		o.maxTime = newTime
	end

	return o
end
