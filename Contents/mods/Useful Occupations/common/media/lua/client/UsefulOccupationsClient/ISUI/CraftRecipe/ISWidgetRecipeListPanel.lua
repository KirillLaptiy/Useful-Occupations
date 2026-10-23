--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- Hidden recipes handler (HRH):
-- Handler used to hide craft recipes under certain conditions

Events.OnGameStart.Add(function()
	local funcs = UsefulOccupations.Functions

	local personalTraits = UsefulOccupations.PersonalTraits

	local engineerType = personalTraits.Engineer.type
	local doctorType = personalTraits.Doctor.type
	local scoutSkillsType = personalTraits.ScoutSkills.type
	local burglarType = personalTraits.Burglar.type
	local mechanicType = personalTraits.Mechanic.type

	-- Recipes that will be visible only if character has corresponding trait
	local visibleRecipesByTraits = {
		UO_MakeMetalPiece1 = engineerType,
		UO_MakeMetalPiece4 = engineerType,
		UO_MakeMetalPiece8 = engineerType,
		UO_MakeScrapMetal = engineerType,
		UO_MakeIronScrap = engineerType,
		UO_MakeBrassScrap = engineerType,
		UO_MakeSteelScrap = engineerType,
		UO_MakeSilverScrap = engineerType,
		UO_MakeGoldScrap = engineerType,
		UO_MakeAluminumFragments = engineerType,
		UO_MakeAluminumScrap = engineerType,
		UO_MakeCopperScrap = engineerType,
		UO_MakeWire = engineerType,
		UO_MakeBarbedWire = engineerType,
		UO_MakeNails = engineerType,
		UO_MakePaperclip = engineerType,
		UO_MakeAluminum = engineerType,
		UO_MakeScrews = engineerType,
		UO_MakeNutsBolts = engineerType,
		UO_MakeJarLid = engineerType,
		UO_MakeAmmoMaterial = engineerType,
		UO_MakeElectronicsScrap = engineerType,
		UO_MakePlastic = engineerType,
		UO_MakeElectricWire = engineerType,
		UO_MakeGunPartsCarbon = engineerType,
		UO_MakeGunParts = engineerType,
		UO_MakeLeatherStrips = engineerType,
		UO_MakeScotchtape = engineerType,
		UO_MakeBattery = engineerType,
		UO_MakeDuctTape = engineerType,
		UO_MakeLogPot = engineerType,
		UO_TakeCharcoalFromPot = engineerType,
		UO_MakeOxidizerRawPot = engineerType,
		UO_TakeOxidizerFromPot = engineerType,
		UO_MakePrimerCap = engineerType,
		UO_MakeHomemadePowder = engineerType,
		UO_MakeAmplifier = engineerType,
		UO_MakeBark = engineerType,
		UO_MakeBarkPot = engineerType,
		UO_TakeResinFromPot = engineerType,
		UO_MakeGarbagebag = engineerType,
		UO_MakeSawBladeInStoneRaw = engineerType,
		UO_TakeSawBlade = engineerType,
		UO_MakeMetalPinInStoneRaw = engineerType,
		UO_TakeMetalPin = engineerType,
		UO_MakeScrewdriverTipInStoneRaw = engineerType,
		UO_TakeScrewdriverTip = engineerType,
		UO_MakeSmallSheetMetal2 = engineerType,
		UO_MakeMetalSheetMold = engineerType,
		UO_TakeMetalSheetFromMold = engineerType,
		UO_MakeMetalBar = engineerType,
		UO_MakeMetalPipe = engineerType,
		UO_MakeFiberMaterialPot = engineerType,
		UO_TakeCarbonFiberFromPot = engineerType,
		UO_MakeCarbonMesh = engineerType,
		UO_MakeCarbonMetal = doctorType,
		UO_MakeGunPowder = doctorType,
		UO_RefillPropaneTank = doctorType,
		UO_MakeTirePiece = doctorType,
		UO_MakeRope = scoutSkillsType,
		UO_MakeTarp = scoutSkillsType,
		UO_MakeTwine = scoutSkillsType,
		UO_MakeStoneBlankSaw = engineerType,
		UO_MakeStoneBlankScrewdriver = engineerType,
		UO_MakeStoneBlankPin = engineerType,
		UO_MakeFlint = engineerType,
		UO_MakeWeakLockpickBurglar = burglarType,
		UO_MakeWeakLockpickEngineer = engineerType,
		UO_MakeLockpickBurglar = burglarType,
		UO_MakeLockpickEngineer = engineerType,
		UO_MakeHandleFromSmall = engineerType,
		UO_MakeHandle = engineerType,
		UO_MakeSmallHandle = engineerType,
		UO_MakeSmallHandleFromBig = engineerType,
		UO_MakeScrewdriver = engineerType,
		UO_MakeSaw = engineerType,
		UO_MakePliers = engineerType,
		UO_MakeChisel = engineerType,
		UO_MakeFlintLighter = engineerType,
		UO_MakeLighter = engineerType,
		UO_MakeLighterFluid = engineerType,
		UO_MakeJack = engineerType,
		UO_MakeWrench = engineerType,
		UO_MakeLugWrench = engineerType,
		UO_MakePipeWrench = engineerType,
		UO_MakeCaliper = engineerType,
		UO_MakeBoreGauge = engineerType,
		UO_MakeMetalShears = engineerType,
		UO_MakeHandDrill = engineerType,
		UO_MakeBlowTorch = engineerType,
		UO_MakeSolderingIron = engineerType,
		UO_MakeWhetstone = engineerType,
		UO_MakeMasonsTrowel = engineerType,
		UO_MakeScalpel = engineerType,
		UO_MakeHandShovel = engineerType,
		UO_MakeHandTorch = engineerType,
		UO_MakeGunLight = engineerType,
		UO_MakeTorch = engineerType,
		UO_MakeTinOpener = engineerType,
		UO_MakePetrolCan = engineerType,
		UO_MakeWeldingMask = engineerType,
		UO_MakeNeedle = engineerType,
		UO_MakeScissors = engineerType,
		UO_MakeStrongLockpick = engineerType,
		UO_MakeBucketEmpty = engineerType,
		UO_MakePencil = engineerType,
		UO_MakeWalkieTalkie3 = engineerType,
		UO_MakeGardeningSprayEmpty = engineerType,
		UO_MakePropaneTank = engineerType,
		UO_MakeSyringe = engineerType,
		UO_MakeHat_GasMask = engineerType,
		UO_MakeRespiratorFilters = engineerType,
		UO_MakeGasmaskFilter = engineerType,
		UO_MakeWristWatch_Left_DigitalBlack = engineerType,
		UO_MakeDumbBell = engineerType,
		UO_MakeBarBell = engineerType,
		UO_MakeCarBatteryCharger = engineerType,
		UO_MakeAlarmController = engineerType,
		UO_MakeSutureNeedle = engineerType,
		UO_MakeSutureNeedleHolder = engineerType,
		UO_MakeVacuumSealer = engineerType,
		UO_MakeMREBag10 = engineerType,
		UO_MakeEngineParts = mechanicType,
		UO_MakeEngineSpecialParts = mechanicType,
		UO_MakeCarBattery1 = mechanicType,
		UO_MakeCarBattery2 = mechanicType,
		UO_MakeCarBattery3 = mechanicType,
		UO_MakeSpecialBattery = mechanicType,
		UO_MakeModernCarMuffler1 = mechanicType,
		UO_MakeModernCarMuffler2 = mechanicType,
		UO_MakeModernCarMuffler3 = mechanicType,
		UO_MakeSpecialSilencer = mechanicType,
		UO_MakeModernSuspension1 = mechanicType,
		UO_MakeModernSuspension2 = mechanicType,
		UO_MakeModernSuspension3 = mechanicType,
		UO_MakeSpecialSuspension = mechanicType,
		UO_MakeModernBrake1 = mechanicType,
		UO_MakeModernBrake2 = mechanicType,
		UO_MakeModernBrake3 = mechanicType,
		UO_MakeSpecialBrake = mechanicType,
		UO_MakeEngineDoor1 = mechanicType,
		UO_MakeEngineDoor2 = mechanicType,
		UO_MakeEngineDoor3 = mechanicType,
		UO_MakeSpecialHood = mechanicType,
		UO_MakeModernTire1 = mechanicType,
		UO_MakeModernTire2 = mechanicType,
		UO_MakeModernTire3 = mechanicType,
		UO_MakeSpecialTire = mechanicType,
		UO_MakeNormalCarSeat1 = mechanicType,
		UO_MakeNormalCarSeat2 = mechanicType,
		UO_MakeNormalCarSeat3 = mechanicType,
		UO_MakeSpecialSeat = mechanicType,
		UO_MakeFrontCarDoor1 = mechanicType,
		UO_MakeFrontCarDoor2 = mechanicType,
		UO_MakeFrontCarDoor3 = mechanicType,
		UO_MakeSpecialFrontDoor = mechanicType,
		UO_MakeRearCarDoor1 = mechanicType,
		UO_MakeRearCarDoor2 = mechanicType,
		UO_MakeRearCarDoor3 = mechanicType,
		UO_MakeSpecialRearDoor = mechanicType,
		UO_MakeRearWindshield1 = mechanicType,
		UO_MakeRearWindshield2 = mechanicType,
		UO_MakeRearWindshield3 = mechanicType,
		UO_MakeSpecialRearWindow = mechanicType,
		UO_MakeWindshield1 = mechanicType,
		UO_MakeWindshield2 = mechanicType,
		UO_MakeWindshield3 = mechanicType,
		UO_MakeSpecialWindshield = mechanicType,
		UO_MakeFrontWindow1 = mechanicType,
		UO_MakeFrontWindow2 = mechanicType,
		UO_MakeFrontWindow3 = mechanicType,
		UO_MakeRearWindow1 = mechanicType,
		UO_MakeRearWindow2 = mechanicType,
		UO_MakeRearWindow3 = mechanicType,
		UO_MakeSpecialWindow = mechanicType,
		UO_MakeSmallGasTank1 = mechanicType,
		UO_MakeSmallGasTank2 = mechanicType,
		UO_MakeSmallGasTank3 = mechanicType,
		UO_MakeNormalGasTank1 = mechanicType,
		UO_MakeNormalGasTank2 = mechanicType,
		UO_MakeNormalGasTank3 = mechanicType,
		UO_MakeBigGasTank1 = mechanicType,
		UO_MakeBigGasTank2 = mechanicType,
		UO_MakeBigGasTank3 = mechanicType,
		UO_MakeSpecialFuelTank = mechanicType,
		UO_MakePot = engineerType,
		UO_MakeSaucepan = engineerType,
		UO_MakeRoastingPan = engineerType,
		UO_MakeMuffinTray = engineerType,
		UO_MakePan = engineerType,
		UO_MakeGridlePan = engineerType,
		UO_MakeBakingPan = engineerType,
		UO_MakeSpatula = engineerType,
		UO_MakeBowl2 = engineerType,
		UO_MakeBakingTray = engineerType,
		UO_MakeMugl4 = engineerType,
		UO_MakeKitchenKnife = engineerType,
		UO_MakeKnifeBlade = engineerType,
		UO_MakeAxeBlade = engineerType,
		UO_MakeLargeTip = engineerType,
		UO_MakeSmallTip = engineerType,
		UO_MakeSmallTipFromBig = engineerType,
		UO_MakeStoneDust = engineerType,
		UO_MakeWoodMold = engineerType,
		UO_MakeResinMoldRaw = engineerType,
		UO_MakeClayMoldRaw = engineerType,
		UO_MakeCementMoldRaw = engineerType,
		UO_SewBag_Schoolbag = doctorType,
		UO_SewBag_NormalHikingBag = doctorType,
		UO_SewBag_ALICEpack = doctorType,
		UO_SewAmmoStraps = doctorType,
		UO_SewAmmoStrap_Shells = doctorType,
		UO_SewAmmoStrap_Bullets = doctorType,
		UO_SewHolsterSimple = doctorType,
		UO_SewHolsterDouble = doctorType,
		UO_SewClothArmorPlate = engineerType,
		UO_SewMetalArmorPlate = engineerType,
		UO_SewCarbonArmorPlate = engineerType,
		UO_SewVest_BulletCivilian = engineerType,
		UO_MakeSpearCrafted = engineerType,
		UO_MakeAxeCrafted = engineerType,
		UO_MakeHammerCrafted = engineerType,
		UO_MakeKnifeCrafted = engineerType,
		UO_MakeBaseballBat = engineerType,
		UO_MakeWoodenMallet = engineerType,
		UO_Make308Bullets = engineerType,
		UO_MakeBullets38 = engineerType,
		UO_MakeBullets44 = engineerType,
		UO_MakeBullets45 = engineerType,
		UO_Make556Bullets = engineerType,
		UO_MakeBullets9mm = engineerType,
		UO_MakeShotgunShells = engineerType,
		UO_MakeEMPGrenade = engineerType,
		UO_MakeSmokeBomb = engineerType,
		UO_MakeFlameTrap = engineerType,
		UO_MakeAerosolbomb = engineerType,
		UO_MakePipeBomb = engineerType,
		UO_MakeAssaultRifle2 = engineerType,
		UO_MakeVarmintRifle = engineerType,
		UO_MakeHuntingRifle = engineerType,
		UO_MakeDoubleBarrelShotgun = engineerType,
		UO_MakeShotgun = engineerType,
		UO_MakePistol3 = engineerType,
		UO_MakePistol2 = engineerType,
		UO_MakePistol = engineerType,
		UO_MakeRevolver_Short = engineerType,
		UO_MakeRevolver = engineerType,
		UO_MakeRevolver_Long = engineerType,
		UO_MakeAssaultRifle = engineerType,
		UO_MakeNightstick = engineerType,
		UO_MakeHuntingKnife = engineerType,
		UO_MakeAxe = engineerType,
		UO_MakeSpearFightingKnife = engineerType,
		UO_MakeSledgehammer = engineerType,
		UO_MakeHammer = engineerType,
		UO_MakeMetalBat = engineerType,
		UO_MakeCrowbar = engineerType,
		UO_MakeCarbonAxe = engineerType,
		UO_MakeCarbonBat = engineerType,
		UO_MakeCarbonHammer = engineerType,
		UO_MakeCarbonKatana = engineerType,
		UO_MakeCarbonKnife = engineerType,
		UO_MakeCarbonSpear = engineerType,
		UO_MakeCarbonHatchet = engineerType,
		UO_MakeMechanismBase = engineerType,
		UO_MakeMechanismHandle = engineerType,
		UO_MakeMechanismClamp = engineerType,
		UO_MakeHacksawBlade = engineerType,
		UO_MakeRotationAxis = engineerType,
		UO_MakeGearMechanism = engineerType,
		UO_MakeWorkpieceFixator = engineerType,
		UO_MakeHandMetalMechanism = engineerType,
		UO_MakeStimulantDrops = doctorType,
		UO_MakeStimulantDropsPlus = doctorType,
		UO_MakePillsBeta = doctorType,
		UO_MakePillsVitamins = doctorType,
		UO_MakeBandage = doctorType,
		UO_MakeCottonBalls = doctorType,
		UO_MakeDisinfectant = doctorType,
		UO_MakePillsAntiDep = doctorType,
		UO_MakeBandaid4 = doctorType,
		UO_MakePillsSleepingTablets = doctorType,
		UO_MakeAlcoholWipes = doctorType,
		UO_MakePills = doctorType,
		UO_MakeAntibiotics = doctorType,
		UO_MakeEnergyDrink = doctorType,
		UO_MakeStimulantGel = doctorType,
		UO_MakeHerbalTea = doctorType,
		UO_MakeCigaretteSingle8 = doctorType,
		UO_WriteMagazine_StrongLockpicks = burglarType,
	}

	---@param _recipeCollection CraftRecipeListNodeCollection
	---@diagnostic disable-next-line: duplicate-set-field
	function ISWidgetRecipeListPanel:setDataList(_recipeCollection)
		local currentRecipe = self.logic:getRecipe()
		local currentRecipeFound = false

		local _recipeList = _recipeCollection:getAllRecipes()

		self.recipeListPanel:clear()

		for i = 0, _recipeList:size() - 1 do
			local craftRecipe = _recipeList:get(i)
			local craftRecipeName = craftRecipe:getScriptObjectName()

			local recipeAllowed = true

			local traitTypeToBeVisible = visibleRecipesByTraits[craftRecipeName]

			if traitTypeToBeVisible then
				recipeAllowed = self.player:hasTrait(funcs.getTraitByStr(traitTypeToBeVisible))
			end

			if recipeAllowed then
				local func = craftRecipe:getOnAddToMenu()
				local failed = false

				if func then
					local params =
					{ player = self.player, recipe = _recipeList:get(i), shouldShowAll = self.enabledShowAllFilter }

					failed = not callLuaBool(func, params)
				end

				if not failed then
					local listItem =
						self.recipeListPanel:addItem(craftRecipe:getTranslationName(), craftRecipe)

					if listItem.item == currentRecipe then
						-- restore selection
						self.recipeListPanel.selected = listItem.itemindex
						currentRecipeFound = true
					end
				end
			end
		end

		if not currentRecipeFound then
			self.recipeListPanel.selected = -1
		end
	end
end)
