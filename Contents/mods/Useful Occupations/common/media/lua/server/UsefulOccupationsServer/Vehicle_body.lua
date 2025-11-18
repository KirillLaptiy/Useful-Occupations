--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

UOBuildRecipeCode = {}
UOBuildRecipeCode.VehicleBody = {}

local vehicleString = "Base.CarLightsBulletinSheriff"

function UOBuildRecipeCode.VehicleBody.OnCreate(params)
	---@type IsoThumpable
	local thumpable = params.thumpable
	local grid = thumpable:getSquare()

	thumpable:removeFromSquare()
	thumpable:removeFromWorld()

	---@type IsoPlayer
	local player = params.character

	local vehicle = addVehicle(vehicleString, grid:getX(), grid:getY(), grid:getZ())
	local vehicleId = vehicle:getId()

	sendClientCommand(player, "vehicle", "getKey", { vehicle = vehicleId })

	for i = 0, vehicle:getPartCount() - 1 do
		local part = vehicle:getPartByIndex(i)

		if part then
            print(part:getItemType())
			---@diagnostic disable-next-line: param-type-mismatch
			part:setInventoryItem(nil)

			if part:getId() == "Engine" then
				part:setCondition(0)
			else
				part:setCondition(100)
			end
		end
	end
end

---@param x integer
---@param y integer
---@param z integer
local isNearBuilding = function(x, y, z)
	for newY = -2, 2 do
		for newX = -2, 2 do
			local newSquare = getSquare(x + newX, y + newY, z)

			if newSquare and (newSquare:getBuilding() or newSquare:getRoofHideBuilding()) then
				return true
			end
		end
	end
end

function UOBuildRecipeCode.VehicleBody.OnIsValid(params)
	---@type IsoGridSquare
	local square = params.square
	return not isNearBuilding(square:getX(), square:getY(), square:getZ())
end
