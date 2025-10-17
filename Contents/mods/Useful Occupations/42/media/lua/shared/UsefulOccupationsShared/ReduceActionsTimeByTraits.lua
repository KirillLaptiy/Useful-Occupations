--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local reduceActionsTimeByTraits = function()
	-- Outdoorsman
	local Outdoorsman = UsefulOccupations.PersonalTraits.Outdoorsman
	local outdoorsmanValues = Outdoorsman.values

	-- Dextrous
	local Dextrous = UsefulOccupations.PersonalTraits.Dextrous

	-- Engineer
	local Engineer = UsefulOccupations.PersonalTraits.Engineer
	local engineerValues = Engineer.values

	-- Builder
	local Builder = UsefulOccupations.PersonalTraits.Builder
	local builderValues = Builder.values

	---@param actionClass table
	---@param timeReduction number | function
	---@param trait any
	local function reduceActionTimeByTrait(actionClass, timeReduction, trait)
		local originalNew = actionClass.new

		---@diagnostic disable-next-line: duplicate-set-field
		function actionClass:new(...)
			local o = originalNew(self, ...)

			---@type IsoGameCharacter
			local character = select(1, ...)

			if not o or o.maxTime <= 100 or character:isTimedActionInstant() then
				return o
			end

			if character:HasTrait(trait.type) then
				local newTime

				if type(timeReduction) == "function" then
					local reduction = timeReduction(o)
					newTime = o.maxTime * (1 - (reduction / 100))
				else
					newTime = o.maxTime * (1 - (timeReduction / 100))
				end

				if newTime < 100 then
					newTime = 100
				end

				o.maxTime = newTime
			end

			return o
		end
	end

	---@param o ISHandcraftAction
	local getEngineerHandcraftTRP = function(o)
		---@type IsoPlayer
		local character = o.character

		---@type CraftRecipe
		local craftRecipe = o.craftRecipe

		if craftRecipe:getCategory() == "Packing" then
			return 0
		end

		local skillsCount = craftRecipe:getRequiredSkillCount()

		local reducePercent = engineerValues.craftRecipesTRP

		for i = 0, skillsCount - 1 do
			local requiredSkill = craftRecipe:getRequiredSkill(i)

			local perk = requiredSkill:getPerk()
			local perkLvl = character:getPerkLevel(perk)

			reducePercent = reducePercent + (engineerValues.craftRecipesTRPPerLvl * perkLvl)
		end

		return math.max(0, math.min(100, reducePercent))
	end

	---@param o ISMoveablesAction
	local getBuilderScrapTRP = function(o)
		---@type IsoPlayer
		local character = o.character

		-- Effect only in scrap mode
		if o.mode ~= "scrap" then
			return 0
		end

		local woodworkLvl = character:getPerkLevel(Perks.Woodwork)
		local metalWeldingLvl = character:getPerkLevel(Perks.MetalWelding)

		return builderValues.scrappingTPR + (builderValues.scrappingTPRPerLvl * (woodworkLvl + metalWeldingLvl))
	end

	-- Outdoorsman
	reduceActionTimeByTrait(ISWashYourself, outdoorsmanValues.washYourselfTRP, Outdoorsman)
	reduceActionTimeByTrait(ISWashClothing, outdoorsmanValues.washClothesTRP, Outdoorsman)
	reduceActionTimeByTrait(ISAddFuelAction, outdoorsmanValues.addCampfireFuelTRP, Outdoorsman)
	reduceActionTimeByTrait(ISRemoveCampfireAction, outdoorsmanValues.removeCampfireTRP, Outdoorsman)
	reduceActionTimeByTrait(ISPutOutCampfireAction, outdoorsmanValues.putOutCampfireTRP, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromPetrol, outdoorsmanValues.lightFromPetrolTRP, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromLiterature, outdoorsmanValues.lightFromLiteratureTRP, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromKindle, outdoorsmanValues.lightFromKindleTRP, Outdoorsman)

	-- Dextrous
	reduceActionTimeByTrait(ISInventoryTransferAction, Dextrous.values.inventoryTransferTRP, Dextrous)

	-- Engineer
	reduceActionTimeByTrait(ISHandcraftAction, getEngineerHandcraftTRP, Engineer)

	-- Builder
	reduceActionTimeByTrait(ISMoveablesAction, getBuilderScrapTRP, Builder)
end

return reduceActionsTimeByTraits
