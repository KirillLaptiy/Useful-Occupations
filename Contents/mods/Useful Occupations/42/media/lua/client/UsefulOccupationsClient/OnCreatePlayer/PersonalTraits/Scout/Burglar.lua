-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

-- TODO: проверить открытие двери на сервере

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
			-- ISInventoryPaneContextMenu.equipWeapon(lockpick, true, false, playerObj);

			ISTimedActionQueue.add(ISLockpickDoor:new(playerObj, door, needToBeLocked, playerObj:getPrimaryHandItem()))
		end
	end

	---@param lockpicks ArrayList
	local getValidLockpick = function(lockpicks)
		for i = 0, lockpicks:size() - 1 do
			local lockpick = lockpicks:get(i)

			if lockpick and lockpick:getCondition() >= 1 then
				return lockpick
			end
		end

		return nil
	end

	---@param containers ArrayList
	local getLockpickFromContainers = function(containers)
		for i = 0, containers:size() - 1 do
			---@type ItemContainer
			local container = containers:get(i):getItemContainer()

			if container then
				local lockpick = getValidLockpick(container:getAllType("Lockpick"))

				if lockpick then
					return lockpick
				end
			end
		end

		return nil
	end

	local createErrorTooltip = function(option)
		local tooltip = ISInventoryPaneContextMenu.addToolTip()

		option.toolTip = tooltip
		tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getText("ContextMenu_Need_Lockpick")
		option.notAvailable = true
	end

	---@diagnostic disable-next-line: duplicate-set-field
	ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
		-- Create menu with default options
		local context = oldCreateMenu(player, worldobjects, x, y, test)

		-- Add new context options
		local playerObj = getSpecificPlayer(player)
		local fetch = ISWorldObjectContextMenu.fetchVars

		if not fetch.door or not playerObj:HasTrait(traitName) then
			return context
		end

		---@type IsoDoor
		local door = fetch.door

		local inventory = playerObj:getInventory()
		local backpacks = inventory:getAllCategory("Container")

		local lockpick = getValidLockpick(inventory:getAllType("Lockpick")) or getLockpickFromContainers(backpacks)

		local pickLock =
			context:addGetUpOption(getText("PickLock"), worldobjects, lockpickDoor, playerObj, door, false, lockpick)
		local relock =
			context:addGetUpOption(getText("Relock"), worldobjects, lockpickDoor, playerObj, door, true, lockpick)

		if not lockpick then
			createErrorTooltip(pickLock)
			createErrorTooltip(relock)
		end

		return context
	end
end
