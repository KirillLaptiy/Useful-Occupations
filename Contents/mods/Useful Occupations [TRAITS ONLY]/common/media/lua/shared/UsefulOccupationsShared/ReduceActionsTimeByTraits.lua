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

	-- Mechanic
	local Mechanic = UsefulOccupations.PersonalTraits.Mechanic
	local mechanicValues = Mechanic.values

	-- Doctor
	local Doctor = UsefulOccupations.PersonalTraits.Doctor
	local doctorValues = Doctor.values

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

			if character:hasTrait(UsefulOccupations.Functions.getTraitByStr(trait.type)) then
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

	-- Engineer's handcrafting time reducting percent
	---@param o ISHandcraftAction
	local getEngineerHandcraftTRP = function(o)
		---@type IsoPlayer
		local character = o.character

		---@type CraftRecipe
		local craftRecipe = o.craftRecipe

		if craftRecipe:getCategory() == "Packing" then
			return 0
		end

		local reducePercent = engineerValues.craftRecipesTRP()

		local skillsCount = craftRecipe:getRequiredSkillCount()

		-- If recipe have required skills than use it, if no, than use blacksmith as default
		if skillsCount > 0 then
			for i = 0, skillsCount - 1 do
				local requiredSkill = craftRecipe:getRequiredSkill(i)

				local perk = requiredSkill:getPerk()
				local perkLvl = character:getPerkLevel(perk)

				reducePercent = reducePercent + (engineerValues.craftRecipesTRPPerLvl() * perkLvl)
			end
		else
			local perkLvl = character:getPerkLevel(Perks.Blacksmith)
			reducePercent = reducePercent + (engineerValues.craftRecipesTRPPerLvl() * perkLvl)
		end

		return math.max(0, math.min(100, reducePercent))
	end

	-- Builder's funiture scrapping time reduction percent
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

		return builderValues.scrappingTPR() + (builderValues.scrappingTPRPerLvl() * (woodworkLvl + metalWeldingLvl))
	end

	-- Mechanic's burnt vehicles scrapping time reduction percent
	---@param o ISRemoveBurntVehicle
	local getMechanicScrapTRP = function(o)
		---@type IsoPlayer
		local character = o.character

		local metalWeldingLvl = character:getPerkLevel(Perks.MetalWelding)
		local mechanicsLvl = character:getPerkLevel(Perks.Mechanics)

		return mechanicValues.scrappingTPR() + (mechanicValues.scrappingTPRPerLvl() * (metalWeldingLvl + mechanicsLvl))
	end

	-- Mechanic's install and uninstall vehicle parts time reduction percent
	---@param o ISRemoveBurntVehicle
	local getMechanicInstallTRP = function(o)
		---@type IsoPlayer
		local character = o.character

		local mechanicsLvl = character:getPerkLevel(Perks.Mechanics)

		return mechanicValues.installTPR() + (mechanicValues.installTPRPerLvl() * mechanicsLvl)
	end

	-- Doctor makes medicine actions faster
	local getDoctorMedicineTRP = function(o)
		---@type IsoPlayer
		local character = o.character

		local doctorLvl = character:getPerkLevel(Perks.Doctor)

		return doctorValues.medicineActionsTRP() + (doctorValues.medicineActionsTRPPerLvl() * doctorLvl)
	end

	-- Outdoorsman
	reduceActionTimeByTrait(ISWashYourself, outdoorsmanValues.washYourselfTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISWashClothing, outdoorsmanValues.washClothesTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISAddFuelAction, outdoorsmanValues.addCampfireFuelTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISRemoveCampfireAction, outdoorsmanValues.removeCampfireTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISPutOutCampfireAction, outdoorsmanValues.putOutCampfireTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISLightFromPetrol, outdoorsmanValues.lightFromPetrolTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISLightFromLiterature, outdoorsmanValues.lightFromLiteratureTRP(), Outdoorsman)
	reduceActionTimeByTrait(ISLightFromKindle, outdoorsmanValues.lightFromKindleTRP(), Outdoorsman)

	-- Dextrous
	reduceActionTimeByTrait(ISInventoryTransferAction, Dextrous.values.inventoryTransferTRP(), Dextrous)

	-- Engineer
	reduceActionTimeByTrait(ISHandcraftAction, getEngineerHandcraftTRP, Engineer)

	-- Builder
	reduceActionTimeByTrait(ISMoveablesAction, getBuilderScrapTRP, Builder)

	-- Mechanic
	reduceActionTimeByTrait(ISRemoveBurntVehicle, getMechanicScrapTRP, Mechanic)
	reduceActionTimeByTrait(ISInstallVehiclePart, getMechanicInstallTRP, Mechanic)
	reduceActionTimeByTrait(ISUninstallVehiclePart, getMechanicInstallTRP, Mechanic)
	reduceActionTimeByTrait(ISConfigHeadlight, getMechanicInstallTRP, Mechanic)
	reduceActionTimeByTrait(ISTakeEngineParts, getMechanicInstallTRP, Mechanic)
	reduceActionTimeByTrait(ISRepairLightbar, getMechanicInstallTRP, Mechanic)
	reduceActionTimeByTrait(ISRepairEngine, getMechanicInstallTRP, Mechanic)
	reduceActionTimeByTrait(ISFixVehiclePartAction, getMechanicInstallTRP, Mechanic)

	-- Doctor
	reduceActionTimeByTrait(ISStitch, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISSplint, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISRemoveGlass, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISRemoveBullet, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISPlantainCataplasm, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISGarlicCataplasm, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISDisinfect, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISComfreyCataplasm, getDoctorMedicineTRP, Doctor)
	reduceActionTimeByTrait(ISCleanBurn, getDoctorMedicineTRP, Doctor)
end

return reduceActionsTimeByTraits
