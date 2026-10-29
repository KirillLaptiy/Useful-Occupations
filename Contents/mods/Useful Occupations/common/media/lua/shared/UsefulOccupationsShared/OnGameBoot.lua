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

local funcs = UsefulOccupations.Functions

local scoutSkillsType = UsefulOccupations.PersonalTraits.ScoutSkills.type
local enduranceSecretType = UsefulOccupations.PersonalTraits.EnduranceSecret.type
local engineerType = UsefulOccupations.PersonalTraits.Engineer.type

local reduceActionsTimeByTraits = require("UsefulOccupationsShared/ReduceActionsTimeByTraits")

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

-- Set trait params
---@param trait CharacterTraitDefinition
---@param traitData UsefulOccupations.AnyTrait
local setTraitParams = function(trait, traitData)
	-- Add trait's xp boosts
	for _, xpBoost in pairs(traitData.xpBoosts) do
		trait:addXPBoost(xpBoost.perk, xpBoost.level)
	end

	-- Add trait's free recipes
	for _, freeRecipe in pairs(traitData.freeRecipes) do
		---@diagnostic disable-next-line: param-type-mismatch
		trait:getGrantedRecipes():add(freeRecipe)
	end
end

local addUsefulTraits = function()
	-- Clear vanilla traits
	-- CharacterTraitDefinition.Reset()

	-- Add personal traits
	---@param traitData UsefulOccupations.PersonalTrait
	for _, traitData in pairs(UsefulOccupations.PersonalTraits) do
		-- Table to save vanilla mutual exclusives before new trait will added
		local vanillaMutualExclusives = {}

		-- Get vanilla mutual exclusives
		local traits = CharacterTraitDefinition.getTraits()

		local vanillaMEType = traitData.type

		-- Also effect decoration traits as their vanilla variants
		for _, trait in pairs(UsefulOccupations.DecorationTraits) do
			if vanillaMEType == trait.originalTraitType then
				vanillaMEType = trait.decorationTraitType
			end
		end

		for i = 0, traits:size() - 1 do
			---@type CharacterTraitDefinition
			---@diagnostic disable-next-line: assign-type-mismatch
			local vanillaTrait = traits:get(i)

			if vanillaTrait:getType() == vanillaMEType then
				local mutualExclusives = vanillaTrait:getMutuallyExclusiveTraits()

				for h = 0, mutualExclusives:size() - 1 do
					table.insert(vanillaMutualExclusives, mutualExclusives:get(h))
				end
			end
		end

		local characterTrait = funcs.tryGetTraitByStr(traitData.type)

		if characterTrait == nil then
			characterTrait = CharacterTrait.register(UsefulOccupations.ModModule .. traitData.type)
		end

		-- Add trait
		local trait = CharacterTraitDefinition.addCharacterTraitDefinition(characterTrait, traitData.name, 0,
			traitData.desc, true, false)

		-- Set params
		setTraitParams(trait, traitData)

		-- Set mutual exclusives
		-- Set vanilla mutual exclusives
		---@param vanillaMExclusive string
		for _, vanillaMExclusive in pairs(vanillaMutualExclusives) do
			CharacterTraitDefinition.setMutualExclusive(characterTrait, funcs.getTraitByStr(vanillaMExclusive))
		end

		-- Set trait data mutual exclusives
		---@param mExclusive string
		for _, mExclusive in pairs(traitData.mutualExclusives) do
			CharacterTraitDefinition.setMutualExclusive(characterTrait, funcs.getTraitByStr(mExclusive))
		end

		-- Set description
		---@diagnostic disable-next-line: param-type-mismatch
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end

	-- Set mutual exclusives for profession (by one of the profession's trait)
	local traits = CharacterTraitDefinition.getTraits()

	for i = 1, traits:size() do
		---@type CharacterTraitDefinition
		---@diagnostic disable-next-line: assign-type-mismatch
		local trait = traits:get(i - 1)

		local traitForbidden = isTraitForbidden(trait:getXpBoosts())

		if traitForbidden and not trait:isFree() then
			local traitType = trait:getType()

			local scoutSkills = funcs.getTraitByStr(scoutSkillsType)
			local enduranceSecret = funcs.getTraitByStr(enduranceSecretType)
			local engineer = funcs.getTraitByStr(engineerType)

			CharacterTraitDefinition.setMutualExclusive(scoutSkills, traitType)
			CharacterTraitDefinition.setMutualExclusive(enduranceSecret, traitType)
			CharacterTraitDefinition.setMutualExclusive(engineer, traitType)
		end
	end

	-- Sort traits
	-- CharacterTraitDefinition.sortList()
end

UOOnGameBoot.addUsefulProfessions = function()
	-- Clear vanilla professions
	CharacterProfessionDefinition.reset()

	-- Add professions
	---@param professionData UsefulOccupations.Profession
	for _, professionData in pairs(UsefulOccupations.Professions) do
		local characterProfession = CharacterProfession.register(UsefulOccupations.ModModule .. professionData.type)

		local profession = CharacterProfessionDefinition.addCharacterProfessionDefinition(
			characterProfession,
			professionData.name,
			professionData.points,
			professionData.desc,
			professionData.iconPath
		)

		-- Add profession's personal traits
		for _, trait in pairs(professionData.traits) do
			local personalTrait = funcs.getTraitByStr(trait.type)
			profession:addGrantedTrait(personalTrait)
		end

		-- Add profession's xp boosts
		for _, xpBoost in pairs(professionData.xpBoosts) do
			profession:addXPBoost(xpBoost.perk, xpBoost.level)
		end
	end
end

Events.OnGameBoot.Add(function()
	-- Adds traits and professions
	addUsefulTraits()

	UOOnGameBoot.addUsefulProfessions()

	-- Reduce timed actions time
	reduceActionsTimeByTraits()
end)

