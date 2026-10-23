--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local oldCreateMenu = ISWorldObjectContextMenu.createMenu

---@param container ItemContainer
---@return InventoryItem | nil
local getInventoryAlarmController = function(container)
	local alarmControllers = container:getAllType("AlarmController")

	for i = 0, alarmControllers:size() - 1 do
		---@type DrainableComboItem
		local alarmController = alarmControllers:get(i)

		if alarmController and alarmController:getCurrentUses() > 0 then
			return alarmController
		end
	end

	return nil
end

---@param containers ArrayList
---@return InventoryItem | nil
local getAlarmControllerFromContainers = function(containers)
	for i = 0, containers:size() - 1 do
		---@type ItemContainer
		local container = containers:get(i):getItemContainer()

		if container then
			local alarmController = getInventoryAlarmController(container)

			if alarmController and alarmController:getCurrentUses() > 0 then
				return alarmController
			end
		end
	end

	return nil
end

---@param playerObj IsoPlayer
---@return InventoryItem | nil
local tryGetAlarmController = function(playerObj)
	local inventory = playerObj:getInventory()
	local backpacks = inventory:getAllCategory("Container")

	return getInventoryAlarmController(inventory) or getAlarmControllerFromContainers(backpacks)
end

---@param playerObj IsoPlayer
---@param obj IsoDoor | IsoWindow
---@param isCheckingAlarm boolean
---@param needToBeAlarmed boolean
---@param alarmController InventoryItem
---@param buildingDef BuildingDef
local processBuildingAlarm = function(_, playerObj, obj, isCheckingAlarm, needToBeAlarmed, alarmController, buildingDef)
	if alarmController and luautils.walkAdjWindowOrDoor(playerObj, obj:getSquare(), obj) then
		ISInventoryPaneContextMenu.equipWeapon(alarmController, true, false, playerObj:getPlayerNum())
		ISTimedActionQueue.add(
			ISProcessAlarm:new(playerObj, obj, isCheckingAlarm, needToBeAlarmed, alarmController, buildingDef)
		)
	end
end

---@param message string
local createErrorTooltip = function(option, message)
	local tooltip = ISInventoryPaneContextMenu.addToolTip()

	option.toolTip = tooltip
	tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getText(message)
	option.notAvailable = true
end

local addProcessAlarmOptions = function(context, worldobjects, playerObj, obj, alarmController, buildingDef)
	local optText = obj:isWindow() and "ContextMenu_Window" or "ContextMenu_Door_option"
	local opt = context:getOptionFromName(getText(optText))
	local target = opt and opt.subOption and context:getSubMenu(opt.subOption)

	local buildingAlarmOpt = target:addOption(getText("ContextMenu_AlarmControl"))
	local buildingAlarmMenu = target:getNew(target)

	target:addSubMenu(buildingAlarmOpt, buildingAlarmMenu)

	local check = buildingAlarmMenu:addOption(
		getText("Check Alarm"),
		worldobjects,
		processBuildingAlarm,
		playerObj,
		obj,
		true,
		false,
		alarmController,
		buildingDef
	)

	local disable = buildingAlarmMenu:addOption(
		getText("ContextMenu_DisableAlarm"),
		worldobjects,
		processBuildingAlarm,
		playerObj,
		obj,
		false,
		false,
		alarmController,
		buildingDef
	)

	local enable = buildingAlarmMenu:addOption(
		getText("ContextMenu_EnableAlarm"),
		worldobjects,
		processBuildingAlarm,
		playerObj,
		obj,
		false,
		true,
		alarmController,
		buildingDef
	)

	if not alarmController then
		local text = "ContextMenu_Need_AlarmController"

		createErrorTooltip(check, text)
		createErrorTooltip(disable, text)
		createErrorTooltip(enable, text)
	end
end

---@param objSquare IsoGridSquare
---@return BuildingDef | nil
local getDoorOrWindowBuildingDef = function(objSquare)
	local x = objSquare:getX()
	local y = objSquare:getY()
	local z = objSquare:getZ()

	for dx = -1, 1 do
		for dy = -1, 1 do
			local sq = getSquare(x + dx, y + dy, z)

			if sq then
				local building = sq:getBuilding()

				if building then
					return building:getDef()
				end
			end
		end
	end

	return nil
end

-- Add context options to lockpick and relock doors and windows
---@diagnostic disable-next-line: duplicate-set-field
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
	-- Create menu with default options
	local context = oldCreateMenu(player, worldobjects, x, y, test)

	-- Add new context options
	local playerObj = getSpecificPlayer(player)
	local fetch = ISWorldObjectContextMenu.fetchVars

	---@type IsoDoor
	local door = fetch.door

	---@type IsoWindow
	local window = fetch.window

	local alarmController = tryGetAlarmController(playerObj)

	if door then
		local buildingDef = getDoorOrWindowBuildingDef(door:getSquare())

		if buildingDef then
			addProcessAlarmOptions(context, worldobjects, playerObj, door, alarmController, buildingDef)
		end
	end

	if window then
		local buildingDef = getDoorOrWindowBuildingDef(window:getSquare())

		if buildingDef then
			addProcessAlarmOptions(context, worldobjects, playerObj, window, alarmController, buildingDef)
		end
	end

	return context
end
