--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UOPlayerMovementMultipliers.SpeedType

---@class UOPlayerMovementMultipliers.SpeedTypes
---@field walk UOPlayerMovementMultipliers.SpeedType
---@field walkSneak UOPlayerMovementMultipliers.SpeedType
---@field run UOPlayerMovementMultipliers.SpeedType
---@field runSneak UOPlayerMovementMultipliers.SpeedType
---@field sprint UOPlayerMovementMultipliers.SpeedType
---@field climbWall UOPlayerMovementMultipliers.SpeedType
---@field climbWindow UOPlayerMovementMultipliers.SpeedType
---@field climbFenceWalk UOPlayerMovementMultipliers.SpeedType
---@field climbFenceRun UOPlayerMovementMultipliers.SpeedType
---@field climbFenceSprint UOPlayerMovementMultipliers.SpeedType
---@field turn UOPlayerMovementMultipliers.SpeedType
---@field turn180 UOPlayerMovementMultipliers.SpeedType
---@field strafeWalk UOPlayerMovementMultipliers.SpeedType
---@field strafeAimIdle UOPlayerMovementMultipliers.SpeedType
---@field stomp UOPlayerMovementMultipliers.SpeedType
---@field combat UOPlayerMovementMultipliers.SpeedType
---@field shove UOPlayerMovementMultipliers.SpeedType
---@field bumpFall UOPlayerMovementMultipliers.SpeedType
---@field scramble UOPlayerMovementMultipliers.SpeedType
---@field notScramble UOPlayerMovementMultipliers.SpeedType

---@class UOPlayerMovementMultipliers.current
---@field walk number
---@field walkSneak number
---@field run number
---@field runSneak number
---@field sprint number
---@field climbWall number
---@field climbWindow number
---@field climbFenceWalk number
---@field climbFenceRun number
---@field climbFenceSprint number
---@field turn number
---@field turn180 number
---@field strafeWalk number
---@field strafeAimIdle number
---@field stomp number
---@field combat number
---@field shove number
---@field bumpFall number
---@field scramble number
---@field notScramble number

---@class UOPlayerMovementMultipliers.extra
---@field invincible number

-- Movement speed values
-- Sneak walk
local sneakWalkSS = UsefulOccupations.MovementSpeedValues.type_sneakLimpSpeedScale
local sneakWalkBT = UsefulOccupations.MovementSpeedValues.type_050
local sneakWalkLowBT = UsefulOccupations.MovementSpeedValues.type_070

-- Sneak run
local sneakRunBT = UsefulOccupations.MovementSpeedValues.type_050
local sneakRunSS = UsefulOccupations.MovementSpeedValues.type_092
local sneakRunLowBT = UsefulOccupations.MovementSpeedValues.type_050
local sneakRunLowSS = UsefulOccupations.MovementSpeedValues.type_104

-- Default walk
local defaultWalkBT = UsefulOccupations.MovementSpeedValues.type_020
local defaultWalkSS = UsefulOccupations.MovementSpeedValues.type_104

-- Default run
local defaultRunBT = UsefulOccupations.MovementSpeedValues.type_035
local defaultRunSS = UsefulOccupations.MovementSpeedValues.type_104

-- Default sprint
local defaultSprintBT = UsefulOccupations.MovementSpeedValues.type_015
local defaultSprintSS = UsefulOccupations.MovementSpeedValues.type_096

-- Climb wall
local climbWallBT = UsefulOccupations.MovementSpeedValues.type_020
local climbWallSS = UsefulOccupations.MovementSpeedValues.type_120

-- Climb window
local climbWindow_StartBOT = UsefulOccupations.MovementSpeedValues.type_020
local climbWindow_EndBT = UsefulOccupations.MovementSpeedValues.type_040
local climbWindow_ObstacleBT = UsefulOccupations.MovementSpeedValues.type_020
local climbWindow_StartSS = UsefulOccupations.MovementSpeedValues.type_096
local climbWindow_EndSS = UsefulOccupations.MovementSpeedValues.type_096
local climbWindow_ObstacleSS = UsefulOccupations.MovementSpeedValues.type_080

-- Climb fence
local climbFence_WalkBT = UsefulOccupations.MovementSpeedValues.type_005
local climbFence_WalkSS = UsefulOccupations.MovementSpeedValues.type_104
local climbFence_RunBT = UsefulOccupations.MovementSpeedValues.type_005
local climbFence_RunBOT = UsefulOccupations.MovementSpeedValues.type_035
local climbFence_RunSS = UsefulOccupations.MovementSpeedValues.type_080
local climbFence_SprintBT = UsefulOccupations.MovementSpeedValues.type_010
local climbFence_SprintSS = UsefulOccupations.MovementSpeedValues.type_080

-- Turn 180
-- Blend time
local turn_type_010BT = UsefulOccupations.MovementSpeedValues.type_010
local turn_type_030BT = UsefulOccupations.MovementSpeedValues.type_030

-- Blend out time
local turn_type_020BOT = UsefulOccupations.MovementSpeedValues.type_020
local turn_type_030BOT = UsefulOccupations.MovementSpeedValues.type_030

-- Speed scale
local turn_type_080SS = UsefulOccupations.MovementSpeedValues.type_080
local turn_type_104SS = UsefulOccupations.MovementSpeedValues.type_104

-- Strafe aim idle
local defaultTurnAimSpeed = UsefulOccupations.MovementSpeedValues.type_080

-- Stomp
local defaultStompSpeed = UsefulOccupations.MovementSpeedValues.type_128

-- Shove
local defaultShoveSpeed = UsefulOccupations.MovementSpeedValues.type_080

-- Bump fall
local bumpFallSS = UsefulOccupations.MovementSpeedValues.type_104

-- Getup
local fromScrambleSS = UsefulOccupations.MovementSpeedValues.type_080
local fromScrambleToWalkSS = UsefulOccupations.MovementSpeedValues.type_104
local notScrambleSS = UsefulOccupations.MovementSpeedValues.type_112

---@type UOPlayerMovementMultipliers.SpeedTypes
local speedTypes = {
	---@diagnostic disable-next-line: assign-type-mismatch
	walk = "walk",
	---@diagnostic disable-next-line: assign-type-mismatch
	walkSneak = "walkSneak",
	---@diagnostic disable-next-line: assign-type-mismatch
	run = "run",
	---@diagnostic disable-next-line: assign-type-mismatch
	runSneak = "runSneak",
	---@diagnostic disable-next-line: assign-type-mismatch
	sprint = "sprint",
	---@diagnostic disable-next-line: assign-type-mismatch
	climbWall = "climbWall",
	---@diagnostic disable-next-line: assign-type-mismatch
	climbWindow = "climbWindow",
	---@diagnostic disable-next-line: assign-type-mismatch
	climbFenceWalk = "climbFenceWalk",
	---@diagnostic disable-next-line: assign-type-mismatch
	climbFenceRun = "climbFenceRun",
	---@diagnostic disable-next-line: assign-type-mismatch
	climbFenceSprint = "climbFenceSprint",
	---@diagnostic disable-next-line: assign-type-mismatch
	turn = "turn",
	---@diagnostic disable-next-line: assign-type-mismatch
	turn180 = "turn180",
	---@diagnostic disable-next-line: assign-type-mismatch
	strafeWalk = "strafeWalk",
	---@diagnostic disable-next-line: assign-type-mismatch
	strafeAimIdle = "strafeAimIdle",
	---@diagnostic disable-next-line: assign-type-mismatch
	stomp = "stomp",
	---@diagnostic disable-next-line: assign-type-mismatch
	combat = "combat",
	---@diagnostic disable-next-line: assign-type-mismatch
	shove = "shove",
	---@diagnostic disable-next-line: assign-type-mismatch
	bumpFall = "bumpFall",
	---@diagnostic disable-next-line: assign-type-mismatch
	scramble = "scramble",
	---@diagnostic disable-next-line: assign-type-mismatch
	notScramble = "notScramble",
}

---@class UOPlayerMovementMultipliers.SetTypes
local setTypes = {
	walk = "setWalkSpeedMult",
	walkSneak = "setSneakWalkSpeedMult",
	run = "setRunSpeedMult",
	runSneak = "setSneakRunSpeedMult",
	sprint = "setSprintSpeedMult",
	climbWall = "setClimbWallSpeedMult",
	climbWindow = "setClimbWindowSpeedMult",
	climbFenceWalk = "setClimbFenceWalkSpeedMult",
	climbFenceRun = "setClimbFenceRunSpeedMult",
	climbFenceSprint = "setClimbFenceSprintSpeedMult",
	turn = "setTurnSpeedMult",
	turn180 = "setTurn180SpeedMult",
	strafeWalk = "setStrafeSpeedMult",
	strafeAimIdle = "setStrafeAimIdleMult",
	stomp = "setStompSpeedMult",
	combat = "setWeaponSwingSpeedMult",
	shove = "setShoveSpeedMult",
	bumpFall = "setBumpFallSpeedMult",
	scramble = "setScrambleGetUpSpeedMult",
	notScramble = "setNotScrambleGetUpSpeedMult",
}

---@type UOPlayerMovementMultipliers.current
local currentMults = {
	walk = 1,
	walkSneak = 1,
	run = 1,
	runSneak = 1,
	sprint = 1,
	climbWall = 1,
	climbWindow = 1,
	climbFenceWalk = 1,
	climbFenceRun = 1,
	climbFenceSprint = 1,
	turn = 1,
	turn180 = 1,
	strafeWalk = 1,
	strafeAimIdle = 1,
	stomp = 1,
	combat = 1,
	shove = 1,
	bumpFall = 1,
	scramble = 1,
	notScramble = 1,
}

---@type UOPlayerMovementMultipliers.extra
local extraMults = {
	invincible = 1,
}

---@class UOPlayerMovementHandler
UOPlayerMovementHandler = {}

---@class UOPlayerMovementHandler.setMethods
local setMethods = {}

---@class UOPlayerMovementHandler.utilMethods
local utilMethods = {}

---@class UOPlayerMovementHandler.instance
local instance = {}

---@type IsoPlayer
local player

local isPretendingZombie = false

-- Climb wall
local climbOverWallState = ClimbOverWallState.instance()
local newChanceApplied = false
local climbWallChance = nil
local climbWallStruggleChance = nil
local needUpdateStruggleChance = false

-- Set methods
---@param totalMult number
setMethods.setWalkSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("defaultWalkBT", defaultWalkBT / totalMult)
	player:setVariable("defaultWalkSS", defaultWalkSS * totalMult)
end

---@param totalMult number
setMethods.setSneakWalkSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	local sneakLimpSpeedScale = player:getVariableString(sneakWalkSS)

	player:setVariable("sneakWalkBT", sneakWalkBT / totalMult)
	player:setVariable("sneakWalkSS", sneakLimpSpeedScale * totalMult)
	player:setVariable("sneakWalkLowBT", sneakWalkLowBT / totalMult)
	player:setVariable("sneakWalkLowSS", sneakLimpSpeedScale * totalMult)
end

---@param totalMult number
setMethods.setSneakRunSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("sneakRunBT", sneakRunBT / totalMult)
	player:setVariable("sneakRunSS", sneakRunSS * totalMult)
	player:setVariable("sneakRunLowBT", sneakRunLowBT / totalMult)
	player:setVariable("sneakRunLowSS", sneakRunLowSS * totalMult)
end

---@param totalMult number
setMethods.setRunSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("defaultRunBT", defaultRunBT / totalMult)
	player:setVariable("defaultRunSS", defaultRunSS * totalMult)
end

---@param totalMult number
setMethods.setSprintSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("defaultSprintBT", defaultSprintBT / totalMult)
	player:setVariable("defaultSprintSS", defaultSprintSS * totalMult)
end

---@param totalMult number
setMethods.setClimbWallSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("climbWallBT", climbWallBT / totalMult)
	player:setVariable("climbWallSS", climbWallSS * totalMult)
end

---@param totalMult number
setMethods.setClimbWindowSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("climbWindow_StartBOT", climbWindow_StartBOT / totalMult)
	player:setVariable("climbWindow_EndBT", climbWindow_EndBT / totalMult)
	player:setVariable("climbWindow_ObstacleBT", climbWindow_ObstacleBT / totalMult)
	player:setVariable("climbWindow_StartSS", climbWindow_StartSS * totalMult)
	player:setVariable("climbWindow_EndSS", climbWindow_EndSS * totalMult)
	player:setVariable("climbWindow_ObstacleSS", climbWindow_ObstacleSS * totalMult)
end

---@param totalMult number
setMethods.setClimbFenceWalkSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("climbFence_WalkBT", climbFence_WalkBT / totalMult)
	player:setVariable("climbFence_WalkSS", climbFence_WalkSS * totalMult)
end

---@param totalMult number
setMethods.setClimbFenceRunSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("climbFence_RunBT", climbFence_RunBT / totalMult)
	player:setVariable("climbFence_RunBOT", climbFence_RunBOT / totalMult)
	player:setVariable("climbFence_RunSS", climbFence_RunSS * totalMult)
end

---@param totalMult number
setMethods.setClimbFenceSprintSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("climbFence_SprintBT", climbFence_SprintBT / totalMult)
	player:setVariable("climbFence_SprintSS", climbFence_SprintSS * totalMult)
end

---@param totalMult number
setMethods.setTurnSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	if totalMult > 1 and isPretendingZombie == true then
		totalMult = 1
	end

	player:setTurnDelta(totalMult)
end

---@param totalMult number
setMethods.setTurn180SpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("turn_type_010BT", turn_type_010BT / totalMult)
	player:setVariable("turn_type_030BT", turn_type_030BT / totalMult)
	player:setVariable("turn_type_020BOT", turn_type_020BOT / totalMult)
	player:setVariable("turn_type_030BOT", turn_type_030BOT / totalMult)
	player:setVariable("turn_type_080SS", turn_type_080SS * totalMult)
	player:setVariable("turn_type_104SS", turn_type_104SS * totalMult)
end

---@param totalMult number
setMethods.setStrafeSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	-- In vanilla the speed in combat stance is capped at level 6
	-- So we are lifting the restriction
	local defaultStrafeWalkSpeed = 0.72 + (0.08 * player:getPerkLevel(Perks.Nimble))

	player:setVariable("strafeDefaultSS", defaultStrafeWalkSpeed * totalMult)
end

---@param totalMult number
setMethods.setStrafeAimIdleMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("TurnAimSpeed", defaultTurnAimSpeed * totalMult)
end

---@param totalMult number
setMethods.setStompSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	elseif totalMult > 1.5 then
		totalMult = 1.5
	end

	player:setVariable("StompDefaultSS", defaultStompSpeed * totalMult)
end

---@param totalMult number
setMethods.setWeaponSwingSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	local combatSpeed = player:calculateCombatSpeed()
	player:setVariable("UOCombatSpeed", combatSpeed * totalMult)
end

---@param totalMult number
setMethods.setShoveSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("ShoveDefaultSS", defaultShoveSpeed * totalMult)
end

---@param totalMult number
setMethods.setBumpFallSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("BumpFallSS", bumpFallSS * totalMult)
end

---@param totalMult number
setMethods.setScrambleGetUpSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("ScrambleGetUpSS", fromScrambleSS * totalMult)
	player:setVariable("ScrambleToWalkGetUpSS", fromScrambleToWalkSS * totalMult)
end

---@param totalMult number
setMethods.setNotScrambleGetUpSpeedMult = function(totalMult)
	if totalMult < 0.15 then
		totalMult = 0.15
	end

	player:setVariable("NotScrambleGetUpSS", notScrambleSS * totalMult)
end

-- Util methods
-- Call to apply new speed
-- If we don't do this, then speed won't be applied before player will stop
utilMethods.applyNewSpeed = function()
	local isSprinting = player:isSprinting()

	player:setBlockMovement(true)

	UsefulOccupations.Functions.processAfterDelay(5, function()
		player:setBlockMovement(false)

		if isSprinting then
			UsefulOccupations.Functions.processAfterDelay(5, function()
				player:setForceSprint(true)
			end)
		end
	end)
end

---@param isUpdatingExtraMult boolean
utilMethods.updateAllMults = function(isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.walk, currentMults.walk, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.walkSneak, currentMults.walkSneak, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.run, currentMults.run, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.runSneak, currentMults.runSneak, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.sprint, currentMults.sprint, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.climbWall, currentMults.climbWall, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.climbWindow, currentMults.climbWindow, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.climbFenceWalk, currentMults.climbFenceWalk, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.climbFenceRun, currentMults.climbFenceRun, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.climbFenceSprint, currentMults.climbFenceSprint, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.turn, currentMults.turn, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.turn180, currentMults.turn180, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.strafeWalk, currentMults.strafeWalk, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.strafeAimIdle, currentMults.strafeAimIdle, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.stomp, currentMults.stomp, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.combat, currentMults.combat, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.shove, currentMults.shove, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.bumpFall, currentMults.bumpFall, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.scramble, currentMults.scramble, false, isUpdatingExtraMult)
	instance.setSpeedMult(speedTypes.notScramble, currentMults.notScramble, false, isUpdatingExtraMult)

	utilMethods.applyNewSpeed()
end

---@param multiplier number
---@return number
utilMethods.calculateTotalMult = function(multiplier)
	return multiplier * extraMults.invincible
end

utilMethods.updateClimbWallChance = function()
	local willClimb = ZombRand(100) < climbWallChance
	player:setVariable("ClimbFenceOutcome", willClimb and "success" or "fail")
	player:setClimbOverWallSuccess(willClimb)

	if needUpdateStruggleChance then
		local willStruggle = ZombRand(100) < climbWallStruggleChance
		player:setVariable("ClimbFenceStruggle", willStruggle)
	end
end

-- Some values require constant updating to work correctly
utilMethods.updateRequiredValues = function()
	-- Updating can sprint
	if player:isAllowSprint() == false then
		player:setForceSprint(false)
	end

	-- Update climb wall chance and struggle chance
	if climbWallChance ~= nil then
		local isPlayerClimbingWall = player:isCurrentState(climbOverWallState)

		if isPlayerClimbingWall == true and newChanceApplied == false then
			newChanceApplied = true
			utilMethods.updateClimbWallChance()
		elseif isPlayerClimbingWall == false then
			newChanceApplied = false
		end
	end
end

---@return UOPlayerMovementMultipliers.SpeedTypes
instance.getSpeedTypes = function()
	return speedTypes
end

---@param speedType UOPlayerMovementMultipliers.SpeedType
---@param multiplier number
---@param needApply boolean
---@param isUpdatingExtraMult boolean
instance.setSpeedMult = function(speedType, multiplier, needApply, isUpdatingExtraMult)
	local totalMult = utilMethods.calculateTotalMult(multiplier)

	setMethods[setTypes[speedType]](totalMult)

	if needApply == true then
		utilMethods.applyNewSpeed()
	end

	if isUpdatingExtraMult == false then
		currentMults[speedType] = multiplier
	end
end

---@param multiplier number
instance.setInvincibleMult = function(multiplier)
	if extraMults.invincible == multiplier then
		return
	end

	extraMults.invincible = multiplier

	utilMethods.updateAllMults(true)
end

---@param climbChance number
---@param struggleChance number
---@param updateStruggleChance boolean
instance.setClimbWallChance = function(climbChance, struggleChance, updateStruggleChance)
	climbWallChance = climbChance
	climbWallStruggleChance = struggleChance
	needUpdateStruggleChance = updateStruggleChance
end

instance.resetClimbWallChance = function()
	climbWallChance = nil
	climbWallStruggleChance = nil
	needUpdateStruggleChance = false
end

---@param value boolean
instance.setIsPretendingZombie = function(value)
	isPretendingZombie = value
	instance.setSpeedMult(speedTypes.turn, currentMults.turn, false, true)
end

function UOPlayerMovementHandler:getInstance()
	-- Similar to the OnCreatePlayer event call, need to get player
	if player == nil or player ~= getPlayer() then
		player = getPlayer()
		utilMethods.updateAllMults(false)
		UsefulOccupations.Functions.processEveryMs(10, utilMethods.updateRequiredValues)
	end

	return instance
end

Events.OnCreatePlayer.Add(function(_, createdPlayer)
	if player == nil or player ~= createdPlayer then
		player = createdPlayer
		utilMethods.updateAllMults(false)
		UsefulOccupations.Functions.processEveryMs(30, utilMethods.updateRequiredValues)
	end
end)

-- Update weapon swing speed
Events.OnWeaponSwing.Add(function()
	instance.setSpeedMult(speedTypes.combat, currentMults.combat, false, false)
end)
