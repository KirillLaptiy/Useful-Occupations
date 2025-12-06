-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

---@class UOOnGameBoot
UOOnGameBoot = {}

local scoutSkillsType = UsefulOccupations.PersonalTraits.ScoutSkills.type
local enduranceSecretType = UsefulOccupations.PersonalTraits.EnduranceSecret.type
local engineerType = UsefulOccupations.PersonalTraits.Engineer.type

---@param xpHashMap HashMap
local isTraitForbidden = function(xpHashMap)
	-- Allowed all traits without xp boosts
	if xpHashMap:isEmpty() then
		return false
	end

	local s = tostring(xpHashMap):trim()

	s = s:sub(2, #s - 1)

	-- Forbidden all traits with positive xp boosts
	for _, value in s:gmatch("(%w+)%s*=%s*([%-]?%d+)") do
		value = tonumber(value)

		if value > 0 then
			return true
		end
	end

	return false
end

local addUsefulTraits = function()
	-- Clear vanilla traits
	-- TraitFactory.Reset()

	-- Set trait params
	---@param trait Trait
	---@param traitData UsefulOccupations.AnyTrait
	local setTraitParams = function(trait, traitData)
		-- Add trait's xp boosts
		for _, xpBoost in pairs(traitData.xpBoosts) do
			trait:addXPBoost(xpBoost.perk, xpBoost.level)
		end

		-- Add trait's free recipes
		for _, freeRecipe in pairs(traitData.freeRecipes) do
			trait:getFreeRecipes():add(freeRecipe)
		end
	end

	-- Add personal traits
	---@param traitData UsefulOccupations.PersonalTrait
	for _, traitData in pairs(UsefulOccupations.PersonalTraits) do
		-- Table to save vanilla mutual exclusives before new trait will added
		local vanillaMutualExclusives = {}

		-- Get vanilla mutual exclusives
		local traits = TraitFactory.getTraits()

		local vanillaMEType = traitData.type

		-- Also effect decoration traits as their vanilla variants
		for _, trait in pairs(UsefulOccupations.DecorationTraits) do
			if vanillaMEType == trait.originalTraitType then
				vanillaMEType = trait.decorationTraitType
			end
		end

		for i = 0, traits:size() - 1 do
			---@type Trait
			local vanillaTrait = traits:get(i)

			if vanillaTrait:getType() == vanillaMEType then
				local mutualExclusives = vanillaTrait:getMutuallyExclusiveTraits()

				for h = 0, mutualExclusives:size() - 1 do
					table.insert(vanillaMutualExclusives, mutualExclusives:get(h))
				end
			end
		end

		-- Add trait
		local trait = TraitFactory.addTrait(traitData.type, traitData.name, 0, traitData.desc, true)

		-- Set params
		setTraitParams(trait, traitData)

		-- Set mutual exclusives
		-- Set vanilla mutual exclusives
		for _, vanillaMExclusive in pairs(vanillaMutualExclusives) do
			TraitFactory.setMutualExclusive(traitData.type, vanillaMExclusive)
		end

		-- Set trait data mutual exclusives
		for _, mExclusive in pairs(traitData.mutualExclusives) do
			TraitFactory.setMutualExclusive(traitData.type, mExclusive)
		end

		-- Set description
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end

	-- Set mutual exclusives for profession (by one of the profession's trait)
	local traits = TraitFactory.getTraits()

	for i = 0, traits:size() - 1 do
		---@type Trait
		local trait = traits:get(i)

		local traitForbidden = isTraitForbidden(trait:getXPBoostMap())

		if traitForbidden and not trait:isFree() then
			local traitType = trait:getType()

			TraitFactory.setMutualExclusive(scoutSkillsType, traitType)
			TraitFactory.setMutualExclusive(enduranceSecretType, traitType)
			TraitFactory.setMutualExclusive(engineerType, traitType)
		end
	end

	-- Sort traits
	TraitFactory.sortList()
end

UOOnGameBoot.addUsefulProfessions = function()
	-- Clear vanilla professions
	ProfessionFactory.Reset()

	-- Add professions
	---@param professionData UsefulOccupations.Profession
	for _, professionData in pairs(UsefulOccupations.Professions) do
		local profession = ProfessionFactory.addProfession(
			professionData.type,
			professionData.name,
			professionData.iconPath,
			professionData.points
		)

		-- Add profession's personal traits
		for _, trait in pairs(professionData.traits) do
			profession:addFreeTrait(trait.type)
		end

		-- Add profession's xp boosts
		for _, xpBoost in pairs(professionData.xpBoosts) do
			profession:addXPBoost(xpBoost.perk, xpBoost.level)
		end
	end

	-- Set description for each profession
	local profList = ProfessionFactory.getProfessions()
	for i = 1, profList:size() do
		local prof = profList:get(i - 1)
		BaseGameCharacterDetails.SetProfessionDescription(prof)
	end
end

local reduceActionsTimeByTraits = require("UsefulOccupationsShared/ReduceActionsTimeByTraits")

Events.OnGameBoot.Add(function()
	-- Adds traits and professions
	addUsefulTraits()

	UOOnGameBoot.addUsefulProfessions()

	-- Reduce timed actions time
	reduceActionsTimeByTraits()
end)
