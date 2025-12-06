--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- TODO: добавить все partItemTypes
-- TODO: добавить починку багажника
-- Добавить починку с помощью файла D:\SteamLibrary\steamapps\common\ProjectZomboid\media\scripts\generated\vehicles\vehiclesfixing.txt
-- Там нужно для инвентори айтема добавить фиксинг рецепт
-- Не менять шанс и эффективность визуальной починки, там зашито в джаву

---@class DoTraitsOnCreatePlayer.Mechanic
---@param _ IsoPlayer
UsefulOccupations.DoTraitsOnCreatePlayer.Mechanic = function(_)
	local partItemTypes = {
		DoorFrontLeft = { "UO.SpecialFrontDoor" },
		DoorFrontRight = { "UO.SpecialFrontDoor" },
		DoorRearLeft = { "UO.SpecialRearDoor" },
		DoorRearRight = { "UO.SpecialRearDoor" },
		Engine = {},
	}

	local carbonEnginePartsType = "EngineSpecialParts"

	local oldDoPartContextMenu = ISVehicleMechanics.doPartContextMenu

	-- Copy of original onRepair but with carbon engine parts
	---@param playerObj IsoPlayer
	---@param part VehiclePart
	---@param action ISRepairEngine | ISTakeEngineParts
	local processEngineAction = function(playerObj, part, action)
		if playerObj:getVehicle() then
			ISVehicleMenu.onExit(playerObj)
		end

		local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
		local item = typeToItem["Base.Wrench"][1]

		ISVehiclePartMenu.toPlayerInventory(playerObj, item)

		local parts = playerObj:getInventory():getFirstTypeRecurse(carbonEnginePartsType)

		ISVehiclePartMenu.toPlayerInventory(playerObj, parts)

		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))

		local engineCover = nil
		local doorPart = part:getVehicle():getPartById("EngineDoor")

		if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() and not doorPart:getDoor():isOpen() then
			engineCover = doorPart
		end

		local time = 300

		if engineCover then
			-- The hood is magically unlocked if any door/window is broken/open/uninstalled.
			-- If the player can get in the vehicle, they can pop the hood, no key required.
			if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(engineCover, playerObj) then
				ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, engineCover))
			end

			ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
			ISTimedActionQueue.add(action:new(playerObj, part, item, time))
			ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
		else
			ISTimedActionQueue.add(action:new(playerObj, part, item, time))
		end
	end

	---@param playerObj IsoPlayer
	---@param part VehiclePart
	---@param option any
	local doRepairEngineOptTooltip = function(playerObj, part, option)
		local tooltip = ISToolTip:new()

		local mechanicsLvl = playerObj:getPerkLevel(Perks.Mechanics)
		local engineRepairLvl = part:getVehicle():getScript():getEngineRepairLevel()

		local wrench = ISVehicleMechanics:getWrench(playerObj)

		tooltip:initialise()
		tooltip:setVisible(false)
		tooltip.description = getText("Tooltip_craft_Needs") .. " : <LINE>"
		option.toolTip = tooltip

		local rgb = ISVehicleMechanics.ghs
		if part:getCondition() >= 100 then
			tooltip.description = tooltip.description
				.. " "
				.. ISVehicleMechanics.bhs
				.. " "
				.. getText("Tooltip_Vehicle_EngineCondition", part:getCondition())
				.. " <LINE>"
		end

		rgb = ISVehicleMechanics.ghs

		if mechanicsLvl < engineRepairLvl then
			rgb = ISVehicleMechanics.bhs
		end

		tooltip.description = tooltip.description
			.. " "
			.. rgb
			.. getText("IGUI_perks_Mechanics")
			.. " "
			.. mechanicsLvl
			.. "/"
			.. engineRepairLvl
			.. " <LINE>"
		rgb = ISVehicleMechanics.ghs

		if not wrench then
			tooltip.description = tooltip.description
				.. " "
				.. ISVehicleMechanics.bhs
				.. getItemDisplayName("Base.Wrench")
				.. " 0/1 <LINE>"
		else
			tooltip.description = tooltip.description
				.. " "
				.. ISVehicleMechanics.ghs
				.. getItemDisplayName("Base.Wrench")
				.. " 1/1 <LINE>"
		end

		if not playerObj:getInventory():contains(carbonEnginePartsType) then
			tooltip.description = tooltip.description
				.. " "
				.. ISVehicleMechanics.bhs
				.. getItemDisplayName("UO" .. carbonEnginePartsType)
				.. " 0/1 <LINE>"
		else
			tooltip.description = tooltip.description
				.. " "
				.. ISVehicleMechanics.ghs
				.. getItemDisplayName("UO" .. carbonEnginePartsType)
				.. " <LINE>"
		end
	end

	---@param part VehiclePart
	---@param x any
	---@param y any
	---@diagnostic disable-next-line: duplicate-set-field
	function ISVehicleMechanics:doPartContextMenu(part, x, y)
		oldDoPartContextMenu(self, part, x, y)

		local vehicle = part:getVehicle()

		-- if vehicle:getScriptName() ~= "VehicleBody" then
		-- 	return
		-- end

		if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
			return
		end

		local playerObj = getSpecificPlayer(self.playerNum)

		if
			playerObj:getVehicle() ~= nil
			---@diagnostic disable-next-line: deprecated
			and not (isDebugEnabled() or (isClient() and (isAdmin() or getAccessLevel() == "moderator")))
		then
			return
		end

		---@type ISContextMenu
		local context = self.context

		local installOptionName = getText("IGUI_Install")
		local takeEnginePartsOptName = getText("IGUI_TakeEngineParts")
		local repairEngineOptName = getText("IGUI_RepairEngine")

		-- Finds old options
		local installOption = context:getOptionFromName(installOptionName)
		local takeEnginePartsOpt = context:getOptionFromName(takeEnginePartsOptName)
		local repairEngineOpt = context:getOptionFromName(repairEngineOptName)

		local wrench = ISVehicleMechanics:getWrench(self.chr)

		print(part:getId())

		for type, items in pairs(partItemTypes) do
			if part:getId() == type then
				-- Install parts option
				if installOption then
					-- Deletes old install option
					context:removeOptionByName(installOptionName)

					-- Creates new install option
					installOption = self.context:addOption(installOptionName, playerObj, nil)

					if not ISVehicleMechanics.cheat and not vehicle:canInstallPart(playerObj, part) then
						installOption.notAvailable = true
						---@diagnostic disable-next-line: param-type-mismatch
						self:doMenuTooltip(part, installOption, "install", nil)
					else
						local subMenu = ISContextMenu:getNew(self.context)
						self.context:addSubMenu(installOption, subMenu)

						local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())

						for _, item in ipairs(items) do
							local scriptItem = getItem(item)
							local name = scriptItem and getItemName(item)
							local itemOpt = subMenu:addOption(name, playerObj, nil)

							itemOpt.iconTexture = scriptItem and scriptItem:getNormalTexture()

							---@diagnostic disable-next-line: param-type-mismatch
							self:doMenuTooltip(part, itemOpt, "install", item)

							if not typeToItem[item] then
								itemOpt.notAvailable = true
							else
								-- display every item the player possesses
								local subMenuItem = ISContextMenu:getNew(subMenu)
								self.context:addSubMenu(itemOpt, subMenuItem)

								for _, v in ipairs(typeToItem[item]) do
									local itemInstallOpt = subMenuItem:addOption(
										v:getDisplayName() .. " (" .. v:getCondition() .. "%)",
										playerObj,
										ISVehiclePartMenu.onInstallPart,
										part,
										v
									)

									itemInstallOpt.itemForTexture = v
									---@diagnostic disable-next-line: param-type-mismatch
									self:doMenuTooltip(part, itemInstallOpt, "install", item)
								end
							end
						end
					end
				end

				-- Take engine parts option
				if takeEnginePartsOpt then
					context:removeOptionByName(takeEnginePartsOptName)

					-- Creates new take engine parts option
					takeEnginePartsOpt = self.context:addOption(
						takeEnginePartsOptName,
						playerObj,
						processEngineAction,
						part,
						ISTakeEngineParts
					)

					---@diagnostic disable-next-line: param-type-mismatch
					self:doMenuTooltip(part, takeEnginePartsOpt, "takeengineparts", nil)

					if
						part:getCondition() <= 10
						or playerObj:getPerkLevel(Perks.Mechanics) < vehicle:getScript():getEngineRepairLevel()
						or not wrench
					then
						takeEnginePartsOpt.notAvailable = true
					end
				end

				-- Repair engine option
				if repairEngineOpt then
					context:removeOptionByName(repairEngineOptName)

					-- Creates new repair engine option
					repairEngineOpt = self.context:addOption(
						repairEngineOptName,
						playerObj,
						processEngineAction,
						part,
						ISRepairEngine
					)

					doRepairEngineOptTooltip(playerObj, part, repairEngineOpt)

					if
						part:getCondition() >= 100
						or playerObj:getInventory():getNumberOfItem(carbonEnginePartsType, false, true) == 0
						or playerObj:getPerkLevel(Perks.Mechanics) < vehicle:getScript():getEngineRepairLevel()
						or not wrench
					then
						repairEngineOpt.notAvailable = true
					end
				end
			end
		end
	end
end
