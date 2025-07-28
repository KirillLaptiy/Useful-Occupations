---@class UsefulOccupations.MovementSpeedValues
local movementSpeedValues = {
	---@class MovementSpeedValues.defaultWalk
	defaultWalk = {
		BlendTime = 0.20,
		SpeedScale = 1.04,
	},

	---@class MovementSpeedValues.sneakWalk
	sneakWalk = {
		BlendTime = 0.50,
		SpeedScale = "sneakLimpSpeedScale",
	},

	---@class MovementSpeedValues.sneakWalkLow
	sneakWalkLow = {
		BlendTime = 0.70,
		SpeedScale = "sneakLimpSpeedScale",
	},

	---@class MovementSpeedValues.sneakRun
	sneakRun = {
		BlendTime = 0.50,
		SpeedScale = 0.92,
	},

	---@class MovementSpeedValues.sneakRunLow
	sneakRunLow = {
		BlendTime = 0.50,
		SpeedScale = 1.04,
	},
}

return movementSpeedValues
