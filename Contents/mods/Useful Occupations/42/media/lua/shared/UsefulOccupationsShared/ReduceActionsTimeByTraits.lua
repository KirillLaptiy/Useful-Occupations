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
	---@param actionClass table
	---@param speedMultiplier number
	---@param trait any
	local function reduceActionTimeByTrait(actionClass, speedMultiplier, trait)
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
				local newTime = o.maxTime / speedMultiplier

				if newTime < 100 then
					newTime = 100
				end

				o.maxTime = newTime
			end

			return o
		end
	end

	-- Outdoorsman
	local Outdoorsman = UsefulOccupations.PersonalTraits.Outdoorsman

	reduceActionTimeByTrait(ISWashYourself, Outdoorsman.values.washYourselfSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISWashClothing, Outdoorsman.values.washClothesSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISAddFuelAction, Outdoorsman.values.addCampfireFuelSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISRemoveCampfireAction, Outdoorsman.values.removeCampfireSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISPutOutCampfireAction, Outdoorsman.values.putOutCampfireSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromPetrol, Outdoorsman.values.lightFromPetrolSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromLiterature, Outdoorsman.values.lightFromLiteratureSpeedMultiplier, Outdoorsman)
	reduceActionTimeByTrait(ISLightFromKindle, Outdoorsman.values.lightFromKindleSpeedMultiplier, Outdoorsman)

	-- Dextrous
	local Dextrous = UsefulOccupations.PersonalTraits.Dextrous

	reduceActionTimeByTrait(ISInventoryTransferAction, Dextrous.values.transferAdditionalMultiplier, Dextrous)
end

return reduceActionsTimeByTraits
