--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@alias UsefulOccupations.AnyTrait UsefulOccupations.Trait | UsefulOccupations.PersonalTrait

-- Static data
---@class UsefulOccupations.XpBoost
---@field perk Perk
---@field level integer

---@class UsefulOccupations.MovementSpeedValue
---@field BlendTime integer,
---@field SpeedScale integer,

-- Data
---@class UsefulOccupations.MovementSpeedValues
---@field defaultWalk UsefulOccupations.MovementSpeedValue

---@class UsefulOccupations.ModData
---@field walkTime integer

---@class UsefulOccupations.DoTraitsOnStart
---@field ScoutSkills? function
---@field Wunderkind? function

---@class UsefulOccupations
---@field DoTraitsOnStart? UsefulOccupations.DoTraitsOnStart
---@field MovementSpeedValues UsefulOccupations.MovementSpeedValues
---@field ModData UsefulOccupations.ModData
---@field Traits UsefulOccupations.Traits
---@field PersonalTraits UsefulOccupations.PersonalTraits
---@field DecorationTraits? UsefulOccupations.DecorationTrait[]
---@field MutualExclusives? UsefulOccupations.MutualExclusive[]
---@field Professions? UsefulOccupations.Professions
---@field Functions UsefulOccupations.Functions

---@type UsefulOccupations
UsefulOccupations = {
	-- Initial data
	DoTraitsOnStart = {},

	MovementSpeedValues = {
		defaultWalk = {
			BlendTime = 0.20,
			SpeedScale = 1.04,
		},
	},

	ModData = {
		walkTime = 0,
	},

	Traits = require("UsefulOccupationsShared/Data/Traits"),
	PersonalTraits = require("UsefulOccupationsShared/Data/PersonalTraits"),
	Functions = require("UsefulOccupationsShared/Data/Functions"),
}

---@type UsefulOccupations.DecorationTrait[]
UsefulOccupations.DecorationTraits = require("UsefulOccupationsShared/Data/DecorationTraits")()

---@type UsefulOccupations.MutualExclusive[]
UsefulOccupations.MutualExclusives = require("UsefulOccupationsShared/Data/MutualExclusives")()

---@type UsefulOccupations.Professions
UsefulOccupations.Professions = require("UsefulOccupationsShared/Data/Professions")()

return UsefulOccupations
