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

	if character:HasTrait(builderType) then
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

---@diagnostic disable
function ISBuildIsoEntity:setInfo(square, north, sprite, openSprite)
	if self.objectInfo:getScript():isProp() then
		local props = ISMoveableSpriteProps.new(IsoObject.new(square, sprite):getSprite())
		props.rawWeight = 10
		props:placeMoveableInternal(square, instanceItem("Base.Plank"), sprite)
		return
	end

	-- get correct thumpable
	local thumpable
	if openSprite then
		thumpable = IsoThumpable.new(getCell(), square, sprite, openSprite, north, self)
	else
		thumpable = IsoThumpable.new(getCell(), square, sprite, north, self)
	end

	-- set property flags
	local spriteType = thumpable:getType()
	local thumpableProps = thumpable:getProperties()
	self.blockAllTheSquare = thumpableProps and thumpableProps:Is("BlocksPlacement") -- need to consider prop IsHigh and IsLow here
	self.canPassThrough = thumpableProps
		and not (
			thumpableProps:Is(IsoFlagType.solid)
			or thumpableProps:Is(IsoFlagType.solidtrans)
			or thumpableProps:Is(IsoFlagType.doorN)
			or thumpableProps:Is(IsoFlagType.doorW)
			or thumpableProps:Is(IsoFlagType.WallN)
			or thumpableProps:Is(IsoFlagType.WallNTrans)
			or thumpableProps:Is(IsoFlagType.WallW)
			or thumpableProps:Is(IsoFlagType.WallWTrans)
			or thumpableProps:Is(IsoFlagType.WallNW)
		)
	self.hoppable = thumpableProps
		and (
			thumpableProps:Is(IsoFlagType.HoppableN)
			or thumpableProps:Is(IsoFlagType.HoppableW)
			or thumpableProps:Is(IsoFlagType.TallHoppableN)
			or thumpableProps:Is(IsoFlagType.TallHoppableW)
		)
	self.isStairs = spriteType
		and (
			spriteType == IsoObjectType.stairsTW
			or spriteType == IsoObjectType.stairsTN
			or spriteType == IsoObjectType.stairsMW
			or spriteType == IsoObjectType.stairsMN
			or spriteType == IsoObjectType.stairsBW
			or spriteType == IsoObjectType.stairsBN
		)
	self.isDoorFrame = spriteType and (spriteType == IsoObjectType.doorFrN or spriteType == IsoObjectType.doorFrW)
	self.isDoor = spriteType and (spriteType == IsoObjectType.doorN or spriteType == IsoObjectType.doorW)
	self.isFloor = thumpableProps and thumpableProps:Is(IsoFlagType.solidfloor)
	if self.isDoor then -- set thumpDmg override for doors
		self.thumpDmg = 5
	end
	self.canBarricade = (
		(spriteType and (spriteType == IsoObjectType.doorN or spriteType == IsoObjectType.doorW))
		or (
			thumpableProps
			and (
				thumpableProps:Is(IsoFlagType.WindowN)
				or thumpableProps:Is(IsoFlagType.WindowW)
				or thumpableProps:Is(IsoFlagType.windowN)
				or thumpableProps:Is(IsoFlagType.windowW)
			)
		)
	)
		and thumpableProps
		and not (thumpableProps:Is("DoubleDoor") or thumpableProps:Is("GarageDoor"))

	buildUtil.setInfo(thumpable, self)

	if self.isDoor and self.modData["keyId"] ~= nil then
		thumpable:setKeyId(self.modData["keyId"])
	end

	local playerObj
	if isServer() then
		playerObj = self.character
	else
		playerObj = getSpecificPlayer(self.player)
	end
	local craftRecipe = self.objectInfo:getRecipe():getCraftRecipe()
	local perk = craftRecipe:getHighestRelevantSkill(playerObj)
	local perkLevel = playerObj:getPerkLevel(perk)

	-- Use at least the minimum required perk level in cheat mode, to avoid zero-health thumpables.
	if playerObj:isBuildCheat() then
		for i = 1, craftRecipe:getRequiredSkillCount() do
			local requiredSkill = craftRecipe:getRequiredSkill(i - 1)
			if (requiredSkill:getPerk() ~= nil) and (requiredSkill:getLevel() > perkLevel) then
				perkLevel = requiredSkill:getLevel()
			end
		end
	end

	local bonusHealth = self.objectInfo:getScript():getBonusHealth()
	local skillBonus = craftRecipe:getHighestRelevantSkillLevel(playerObj)
		* self.objectInfo:getScript():getSkillBaseHealth()
	local baseHealth = math.max(self.objectInfo:getScript():getHealth(), 0)

	-- MULTIPLY BONUS HEALTH
	local bonusHealthMultiplier = getSandboxOptions():getOptionByName("ConstructionBonusPoints"):getValue()
	if bonusHealthMultiplier == 1 then
		bonusHealth = bonusHealth * 0.5
	end
	if bonusHealthMultiplier == 2 then
		bonusHealth = bonusHealth * 0.7
	end
	if bonusHealthMultiplier == 4 then
		bonusHealth = bonusHealth * 1.3
	end
	if bonusHealthMultiplier == 5 then
		bonusHealth = bonusHealth * 1.5
	end

	local totalHealth = baseHealth + bonusHealth + skillBonus

	if self.craftRecipe and self.character:HasTrait(builderType) then
		local builderHealthMult = getBuilderHealthMult(self.character, self.craftRecipe)

		if builderHealthMult then
			totalHealth = totalHealth * builderHealthMult
		end
	end

	thumpable:setMaxHealth(totalHealth)
	thumpable:setHealth(thumpable:getMaxHealth())

	thumpable:setBreakSound(self.objectInfo:getScript():getBreakSound())

	if thumpableProps and thumpableProps:Is("IsStackable") then
		local props = ISMoveableSpriteProps.new(thumpable:getSprite())
		local offsetY = props:getTotalTableHeight(square)
		thumpable:setRenderYOffset(offsetY)
	end

	if self.objectInfo:getScript() and self.objectInfo:getScript():getParent() then
		local gameEntityScript = self.objectInfo:getScript():getParent()
		local isFirstTimeCreated = true
		GameEntityFactory.CreateIsoObjectEntity(thumpable, gameEntityScript, isFirstTimeCreated)
		--gameEntityScript:InstanceComponents(thumpable);
	else
		print("ISBuildIsoEntity -> Cannot instance components, script missing.")
	end

	local replacedObjectIndex = -1
	if self.previousStageObject and self.previousStageObject:getSquare() == square then
		replacedObjectIndex =
			self.previousStageObject:getSquare():transmitRemoveItemFromSquare(self.previousStageObject)
		self.previousStageObject = nil
	end

	-- lightsource properties
	if self.objectInfo:getScript():getLightRadius() then
		local script = self.objectInfo:getScript()

		-- get our FaceScript (not FaceInfo!)
		local index = self.nSprite -- W and E
		if index == 2 then
			index = 0
		end -- N
		if index == 4 then
			index = 2
		end -- S
		local face = script:getFace(index)
		-- to build a lamp on pillar for ex. we need to check the torch used to add it's battery remaining values in the thumpable, we need to find what items has been used for it
		local consumedItems = self.buildPanelLogic:getAllConsumedItems()
		local torchUsed = nil
		if consumedItems then
			for i = 0, consumedItems:size() - 1 do
				-- we can either have a full type (Base.Torch) or a list of tags
				local item = consumedItems:get(i)
				if script:getLightsourceItem() and item:getFullType() == script:getLightsourceItem() then
					torchUsed = item
					break
				end
				if script:getLightsourceTagItem() then
					for j = 0, script:getLightsourceTagItem():size() - 1 do
						local tag = script:getLightsourceTagItem():get(j)
						if item:getTags():contains(tag) then
							torchUsed = item
							break
						end
					end
				end
			end
		end

		if not torchUsed and self.character:isBuildCheat() and self.objectInfo:getScript():getDebugItem() then
			torchUsed = instanceItem(self.objectInfo:getScript():getDebugItem())
		end

		if torchUsed then
			thumpable:createLightSource(
				script:getLightRadius(),
				face:getLightsourceOffsetX(),
				face:getLightsourceOffsetY(),
				face:getLightsourceOffsetZ(),
				0,
				script:getLightsourceFuel(),
				torchUsed,
				playerObj
			)
		end
	end

	square:AddSpecialObject(thumpable, replacedObjectIndex)
	buildUtil.checkCorner(square:getX(), square:getY(), square:getZ(), north, thumpable, self)

	-- This is so any containers that are in a tile are flagged as "already explored" so they don't spawn loot in them
	thumpable:setExplored(true)

	local result = nil
	if self.objectInfo:getScript():getOnCreate() then
		local facing = self:getFace():getFaceName()
		local func = self.objectInfo:getScript():getOnCreate()
		result = BaseCraftingLogic.callLuaObject(func, {
			thumpable = thumpable,
			craftRecipeData = self.buildPanelLogic:getRecipeData(),
			character = playerObj,
			facing = facing,
		})
	end

	square:RecalcAllWithNeighbours(true)
	if result ~= nil then
		-- object transmitted somewhere in OnCreate function, don't send again
		-- can be used when you have to transmit not just one object
		if result.objectAlreadyTransmitted then
			return
		end

		-- transmitted object is not just isoThumpable,
		-- replace it to make sure client will get correct instance of the object
		if result.replaceObject and result.object ~= nil then
			result.object:transmitCompleteItemToClients()
		end
		return
	end

	local container = thumpable:getContainer()
	local fluidContainer = thumpable:getFluidContainer()

	if self.craftRecipe and container or fluidContainer and self.character:HasTrait(builderType) then
		local capacityMult = getBuilderCapacityMult(self.character, self.craftRecipe)

		if container then
			container:setCapacity(container:getCapacity() * capacityMult)
		else
			fluidContainer:setCapacity(fluidContainer:getCapacity() * capacityMult)
		end
	end

	thumpable:transmitCompleteItemToClients()
end
---@diagnostic enable

---@diagnostic disable-next-line: duplicate-set-field
function ISBuildIsoEntity:new(character, objectInfo, nSprite, containers, logic)
	local o = originalISBuildIsoEntity(self, character, objectInfo, nSprite, containers, logic)

	local newTime

	---@type CraftRecipe | false
	local craftRecipe = o.craftRecipe

	-- Outdoorsman builds campfire and tents faster
	if validOutdoorsmanCrafts[o.name] and character:HasTrait(outdoorsmanType) then
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
