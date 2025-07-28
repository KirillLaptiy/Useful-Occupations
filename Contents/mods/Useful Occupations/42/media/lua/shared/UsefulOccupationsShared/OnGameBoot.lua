-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

local addUsefulTraits = function()
	-- Clear vanilla traits
	TraitFactory.Reset()

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

	-- Add non-personal traits
	---@param traitData UsefulOccupations.Trait
	for _, traitData in pairs(UsefulOccupations.Traits) do
		local trait = TraitFactory.addTrait(traitData.type, traitData.name, traitData.cost, traitData.desc, false)
		setTraitParams(trait, traitData)
	end

	-- Add personal traits
	---@param traitData UsefulOccupations.PersonalTrait
	for _, traitData in pairs(UsefulOccupations.PersonalTraits) do
		local trait = TraitFactory.addTrait(traitData.type, traitData.name, 0, traitData.desc, true)
		setTraitParams(trait, traitData)
	end

	-- Add mutual exclusives
	---@param mutualExclusive UsefulOccupations.MutualExclusive
	for _, mutualExclusive in pairs(UsefulOccupations.MutualExclusives) do
		for _, value in pairs(mutualExclusive.values) do
			TraitFactory.setMutualExclusive(mutualExclusive.key.type, value.type)
		end
	end

	-- Sort traits
	TraitFactory.sortList()

	-- Set description for each trait
	local traitList = TraitFactory.getTraits()
	for i = 1, traitList:size() do
		local trait = traitList:get(i - 1)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end

local addUsefulProfessions = function()
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
	addUsefulProfessions()

	-- Reduce timed actions time
	reduceActionsTimeByTraits()

	-- Do traits on game boot
	for func in pairs(UsefulOccupations.DoTraitsOnGameBoot) do
		UsefulOccupations.DoTraitsOnGameBoot[func]()
	end
end)
