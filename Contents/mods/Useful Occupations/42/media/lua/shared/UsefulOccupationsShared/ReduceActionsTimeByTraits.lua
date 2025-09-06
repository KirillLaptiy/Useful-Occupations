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
					local reduction = math.max(0, math.min(100, timeReduction(...)))
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

	---@param character IsoPlayer
	---@param craftRecipe CraftRecipe
	local getHandcraftPercentReduction = function(character, craftRecipe)
		if craftRecipe:getCategory() == "Packing" then
			return 0
		end

		local skillsCount = craftRecipe:getRequiredSkillCount()

		local reducePercent = engineerValues.craftRecipesSPR

		for i = 0, skillsCount - 1 do
			local requiredSkill = craftRecipe:getRequiredSkill(i)

			local perk = requiredSkill:getPerk()
			local perkLvl = character:getPerkLevel(perk)

			reducePercent = reducePercent + (engineerValues.craftRecipesSPRPerLvl * perkLvl)
		end

		print(reducePercent)

		return reducePercent
	end

	-- Outdoorsman
	reduceActionTimeByTrait(ISWashYourself, outdoorsmanValues.washYourselfSPR, Outdoorsman)
	reduceActionTimeByTrait(ISWashClothing, outdoorsmanValues.washClothesSPR, Outdoorsman)
	reduceActionTimeByTrait(ISAddFuelAction, outdoorsmanValues.addCampfireFuelSPR, Outdoorsman)
	reduceActionTimeByTrait(ISRemoveCampfireAction, outdoorsmanValues.removeCampfireSPR, Outdoorsman)
	reduceActionTimeByTrait(ISPutOutCampfireAction, outdoorsmanValues.putOutCampfireSPR, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromPetrol, outdoorsmanValues.lightFromPetrolSPR, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromLiterature, outdoorsmanValues.lightFromLiteratureSPR, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromKindle, outdoorsmanValues.lightFromKindleSPR, Outdoorsman)

	-- Dextrous
	reduceActionTimeByTrait(ISInventoryTransferAction, Dextrous.values.transferAdditionalMultiplier, Dextrous)

	-- Engineer
	reduceActionTimeByTrait(ISHandcraftAction, getHandcraftPercentReduction, Engineer)
end

return reduceActionsTimeByTraits
