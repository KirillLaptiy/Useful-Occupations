--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@param directory IsoDirections
local chooseSprite = function(directory)
	local spriteManager = IsoSpriteManager.instance
	local var3 = "fixtures_doors_01_"
	local sprite

	print(directory)

	if directory == "N" then
		sprite = spriteManager:getSprite(var3 .. "19")
	elseif directory == "S" then
		sprite = spriteManager:getSprite(var3 .. "18")
	elseif directory == "E" then
		sprite = spriteManager:getSprite(var3 .. "17")
	elseif directory == "W" then
		sprite = spriteManager:getSprite(var3 .. "16")
	end

	print(var3 .. "16")
	print(sprite)

	return sprite
end

Events.OnGameStart.Add(function()
	local oldCreateMenu = ISWorldObjectContextMenu.createMenu

	---@param playerObj IsoPlayer
	---@param obj IsoDoor
	---@param needToBeBarricaded boolean
	local addDoorBarricade = function(_, playerObj, obj, needToBeBarricaded)
		if luautils.walkAdjWindowOrDoor(playerObj, obj:getSquare(), obj) then
			local spriteManager = IsoSpriteManager.instance

			local sprite = chooseSprite(obj:getDir())

			-- -- obj:setSprite(sprite)
			-- obj:setOverlaySprite("constructedobjects_01_55")

			-- -- obj:setOpenSprite(sprite)
			-- obj:setHealth(math.huge)

			-- obj:setSprite("fixtures_doors_01_17")
			-- obj:setOpenSprite(sprite)

			obj:setSprite("uo_tiles_3")
		end
	end

	---@param playerObj IsoPlayer
	---@param obj IsoWindow
	---@param needToBeBarricaded boolean
	local addWindowBarricade = function(_, playerObj, obj, needToBeBarricaded)
		if luautils.walkAdjWindowOrDoor(playerObj, obj:getSquare(), obj) then
			-- local sqr = obj:getSquare()
			-- local cell = obj:getCell()
			-- local isNorth = obj:isNorth()
			-- local spriteManager = IsoSpriteManager.instance

			-- local cool = spriteManager:getSprite("location_shop_mall_01_18")

			-- local sprite = spriteManager:getSprite("carpentry_01_8")
			-- local openSprite = spriteManager:getSprite("carpentry_01_10")
			-- local smashedSprite = spriteManager:getSprite("carpentry_01_12")

			-- -- sprite:getProperties():Set(IsoFlagType.makeWindowInvincible)
			-- -- openSprite:getProperties():Set(IsoFlagType.makeWindowInvincible)
			-- sprite:AddProperties(cool)
			-- openSprite:AddProperties(cool)
			-- -- sprite:getProperties():Set(IsoFlagType.CantClimb)
			-- -- openSprite:getProperties():Set(IsoFlagType.CantClimb)

			-- sqr:RemoveTileObject(obj)

			-- -- Создаём новое окно
			-- local newWindow = IsoWindow.new(cell, sqr, sprite, isNorth)
			-- newWindow:setOpenSprite(openSprite)
			-- newWindow:setSmashedSprite(smashedSprite)

			-- -- Добавляем обратно в клетку и в мир
			-- sqr:AddSpecialObject(newWindow)

			obj:setOverlaySprite("uo_tiles_2")

			-- obj:getOverlaySprite():getProperties():Set(IsoFlagType.makeWindowInvincible)

			-- print(obj:getChildSprites())
		end
	end

	local addProcessAlarmOptions = function(context, worldobjects, playerObj, obj)
		local buildingAlarmOpt = context:addOption("Barricades")
		local buildingAlarmMenu = context:getNew(context)

		context:addSubMenu(buildingAlarmOpt, buildingAlarmMenu)

		buildingAlarmMenu:addOption(getText("Add cool barricade"), worldobjects, addDoorBarricade, playerObj, obj, true)

		buildingAlarmMenu:addOption(
			getText("Remove cool barricade"),
			worldobjects,
			addWindowBarricade,
			playerObj,
			obj,
			false
		)
	end

	-- Add context options to lockpick and relock doors and windows
	---@diagnostic disable-next-line: duplicate-set-field
	ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
		-- Create menu with default options
		local context = oldCreateMenu(player, worldobjects, x, y, test)

		-- Add new context options
		local playerObj = getSpecificPlayer(player)
		local fetch = ISWorldObjectContextMenu.fetchVars

		for i, f in ipairs(fetch) do
			print(f)
		end

		---@type IsoThumpable
		local thump = fetch.thump

		---@type IsoDoor
		local door = fetch.door

		---@type IsoWindow
		local window = fetch.window

		if door then
			addProcessAlarmOptions(context, worldobjects, playerObj, door)
		end

		if window then
			print("WINDOW!")
			local properties = window:getSprite():getProperties()

			window:getDurabilityComponent()

			print(properties:getFlagsList())
			print(properties:getPropertyNames())
			addProcessAlarmOptions(context, worldobjects, playerObj, window)
		end

		if thump then
			print("THUMP!")
			print(thump:getSprite():getProperties():getFlagsList())
		end

		return context
	end
end)
