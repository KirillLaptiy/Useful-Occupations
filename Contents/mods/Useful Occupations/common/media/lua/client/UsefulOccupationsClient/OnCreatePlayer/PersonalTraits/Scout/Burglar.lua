-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

---@class DoTraitsOnCreatePlayer.Burglar
UsefulOccupations.DoTraitsOnCreatePlayer.Burglar = function(_)
	local traitName = UsefulOccupations.PersonalTraits.Burglar.type

	local oldCreateMenu = ISWorldObjectContextMenu.createMenu

	---@param playerObj IsoPlayer
	---@param door IsoDoor
	---@param needToBeLocked boolean
	---@param lockpick InventoryItem
	local lockpickDoor = function(_, playerObj, door, needToBeLocked, lockpick)
		if lockpick and luautils.walkAdjWindowOrDoor(playerObj, door:getSquare(), door) then
			ISInventoryPaneContextMenu.equipWeapon(lockpick, true, false, playerObj:getPlayerNum())
			ISTimedActionQueue.add(ISLockpickDoor:new(playerObj, door, needToBeLocked, lockpick))
		end
	end

	---@param playerObj IsoPlayer
	---@param window IsoWindow
	---@param needToBeLocked boolean
	---@param lockpick InventoryItem
	local lockpickWindow = function(_, playerObj, window, needToBeLocked, lockpick)
		if lockpick and luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
			if window:IsOpen() then playerObj:closeWindow(window) end
			ISInventoryPaneContextMenu.equipWeapon(lockpick, true, false, playerObj:getPlayerNum())
			ISTimedActionQueue.add(ISLockpickWindow:new(playerObj, window, needToBeLocked, lockpick))
		end
	end

	---@param playerObj IsoPlayer
	---@param part VehiclePart
	---@param door VehicleDoor
	---@param needToBeLocked boolean
	---@param lockpick InventoryItem
	local lockpickVehicleDoor = function(playerObj, part, door, needToBeLocked, lockpick)
		if lockpick and luautils.walkAdjWindowOrDoor(playerObj, part:getSquare(), door) then
			ISInventoryPaneContextMenu.equipWeapon(lockpick, true, false, playerObj:getPlayerNum())
			ISTimedActionQueue.add(ISLockpickVehicleDoor:new(playerObj, part, door, needToBeLocked, lockpick))
		end
	end

	---@param container ItemContainer
	---@return InventoryItem | nil
	local getValidLockpick = function(container)
		local lockpicks = ArrayList.new()

		-- lockpicks = container:getAllTag(UsefulOccupations.Functions.getItemTagByStr("lockpick"))

		local wloc = container:getAllType("WeakLockpick")
		local loc = container:getAllType("Lockpick")
		local sloc = container:getAllType("StrongLockpick")

		lockpicks:addAll(wloc)
		lockpicks:addAll(loc)
		lockpicks:addAll(sloc)

		for i = 0, lockpicks:size() - 1 do
			local lockpick = lockpicks:get(i)

			if lockpick and lockpick:getCondition() >= 1 then
				return lockpick
			end
		end

		return nil
	end

	---@param containers ArrayList
	---@return InventoryItem | nil
	local getLockpickFromContainers = function(containers)
		for i = 0, containers:size() - 1 do
			---@type ItemContainer
			---@diagnostic disable-next-line: undefined-field
			local container = containers:get(i):getItemContainer()

			if container then
				local lockpick = getValidLockpick(container)

				if lockpick then
					return lockpick
				end
			end
		end

		return nil
	end

	---@param playerObj IsoPlayer
	---@return InventoryItem | nil
	local tryGetLockpick = function(playerObj)
		local inventory = playerObj:getInventory()
		local backpacks = inventory:getAllCategory("Container")

		return getValidLockpick(inventory) or getLockpickFromContainers(backpacks)
	end

	---@param player IsoPlayer
	---@param door IsoDoor
	---@return boolean
	local hasDoorKey = function(player, door)
		local keyId = instanceof(door, "IsoDoor") and door:checkKeyId() or door:getKeyId()
		return player:getInventory():haveThisKeyId(keyId) and true or false
	end

	---@param message string
	local createErrorTooltip = function(option, message)
		local tooltip = ISInventoryPaneContextMenu.addToolTip()

		option.toolTip = tooltip
		tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getText(message)
		option.notAvailable = true
	end

	-- Add context options to lockpick and relock doors and windows
	---@diagnostic disable-next-line: duplicate-set-field
	ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
		-- Create menu with default options
		local context = oldCreateMenu(player, worldobjects, x, y, test)

		if not context then return end

		-- Add new context options
		local playerObj = getSpecificPlayer(player)
		local fetch = ISWorldObjectContextMenu.fetchVars

		if not playerObj:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitName)) then
			return context
		end

		---@type IsoDoor
		local door = fetch.door
		---@type IsoWindow
		local window = fetch.window

		local lockpick = tryGetLockpick(playerObj)

		local doorOpt = context:getOptionFromName(getText("ContextMenu_Door_option"))
		local windowOpt = context:getOptionFromName(getText("ContextMenu_Window"))

		if door and not hasDoorKey(playerObj, door) then
			local target = doorOpt and doorOpt.subOption and context:getSubMenu(doorOpt.subOption)

			local isLocked = door:isLockedByKey()

			local lockOption = target:addOption(
				isLocked and getText("ContextMenu_PickLock") or getText("ContextMenu_Relock"),
				worldobjects,
				lockpickDoor,
				playerObj,
				door,
				not isLocked,
				lockpick
			)

			if not lockpick then
				createErrorTooltip(lockOption, "ContextMenu_Need_Lockpick")
			end
		end

		--TODO: закончить с окном
		if window and not window:isSmashed() then
			local target = windowOpt and windowOpt.subOption and context:getSubMenu(windowOpt.subOption)

			local isLocked = window:isPermaLocked() or window:isLocked()

			local lockOption = target:addOption(
				isLocked and getText("ContextMenu_PickLock") or getText("ContextMenu_Relock"),
				worldobjects,
				lockpickWindow,
				playerObj,
				window,
				not isLocked,
				lockpick
			)

			if not lockpick then
				createErrorTooltip(lockOption, "ContextMenu_Need_Lockpick")
			end
		end

		return context
	end

	-- Add radial option to lockpick and relock vehicle door
	local oldShowVehicleRadialMenu = ISVehicleMenu.showRadialMenuOutside

	---@param playerObj IsoPlayer
	---@diagnostic disable-next-line: duplicate-set-field
	function ISVehicleMenu.showRadialMenuOutside(playerObj)
		oldShowVehicleRadialMenu(playerObj)

		-- Try to get vehicle to interact with
		---@type BaseVehicle
		local vehicle = ISVehicleMenu.getVehicleToInteractWith(playerObj)

		if not vehicle then
			return
		end

		-- Try to get lockpick in player inventory
		local lockpick = tryGetLockpick(playerObj)

		if not lockpick then
			return
		end

		---@type number
		local playerIndex = playerObj:getPlayerNum()

		local menu = getPlayerRadialMenu(playerIndex)

		if menu == nil then
			return
		end

		if menu:isReallyVisible() then
			if menu.joyfocus then
				setJoypadFocus(playerIndex, nil)
			end

			menu:undisplay()

			return
		end

		---@type VehiclePart
		local part = vehicle:getUseablePart(playerObj)

		if part and part:getDoor() and part:getInventoryItem() then
			local vehicleDoor = part:getDoor()

			if vehicleDoor:isOpen() then
				return
			end

			local hasVehicleKey = vehicle:canUnlockDoor(part, playerObj) or vehicle:canLockDoor(part, playerObj)

			if not hasVehicleKey then
				if vehicleDoor:isLocked() then
					menu:addSlice(
						getText("ContextMenu_PickLock"),
						getTexture("media/ui/vehicles/vehicle_lockdoors.png"),
						lockpickVehicleDoor,
						playerObj,
						part,
						vehicleDoor,
						false,
						lockpick
					)
				else
					menu:addSlice(
						getText("ContextMenu_Relock"),
						getTexture("media/ui/vehicles/vehicle_lockdoors.png"),
						lockpickVehicleDoor,
						playerObj,
						part,
						vehicleDoor,
						true,
						lockpick
					)
				end
			end
		end
	end

	-- The window breaks without glass
	UsefulOccupations.Functions.addEvent(Events.OnWeaponHitThumpable, function(_, _, object)
		if not instanceof(object, "IsoWindow") then
			return
		end

		UsefulOccupations.Functions.processAfterDelay(1, function()
			---@diagnostic disable-next-line: undefined-field
			object:removeBrokenGlass()
		end)
	end)
end
