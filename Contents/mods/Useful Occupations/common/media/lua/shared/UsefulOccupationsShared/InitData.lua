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

-- Traits on game start
---@class UsefulOccupations.DoTraitsOnCreatePlayer
---@field ScoutSkills DoTraitsOnCreatePlayer.ScoutSkills
---@field Wunderkind DoTraitsOnCreatePlayer.Wunderkind
---@field Inconspicuous DoTraitsOnCreatePlayer.Inconspicuous
---@field Burglar DoTraitsOnCreatePlayer.Burglar
---@field Graceful DoTraitsOnCreatePlayer.Graceful
---@field Organized DoTraitsOnCreatePlayer.Organized
---@field EnduranceSecret DoTraitsOnCreatePlayer.EnduranceSecret
---@field Invincible DoTraitsOnCreatePlayer.Invincible
---@field Desensitized DoTraitsOnCreatePlayer.Desensitized
---@field Marksman DoTraitsOnCreatePlayer.Marksman
---@field TrainedFighter DoTraitsOnCreatePlayer.TrainedFighter
---@field Mechanic DoTraitsOnCreatePlayer.Mechanic

-- Functions on game start
---@class UsefulOccupations.DoFuncsOnCreatePlayer

-- Traits on game boot
---@class UsefulOccupations.TraitsOnGameBoot
---@field Mechanic TraitsOnGameBoot.Mechanic
---@field Doctor TraitsOnGameBoot.Doctor

-- Traits that affect inventory item stats
---@class UsefulOccupations.InventoryItemsStatsHandler
---@field Marksman InventoryItemsStatsHandler.Marksman
---@field Graceful InventoryItemsStatsHandler.Graceful
---@field TrainedFighter InventoryItemsStatsHandler.TrainedFighter

--- Main data
---@class UsefulOccupations
---@field DoTraitsOnCreatePlayer UsefulOccupations.DoTraitsOnCreatePlayer
---@field DoFuncsOnCreatePlayer UsefulOccupations.DoFuncsOnCreatePlayer
---@field TraitsOnGameBoot UsefulOccupations.TraitsOnGameBoot
---@field InventoryItemsStatsHandler UsefulOccupations.InventoryItemsStatsHandler
---@field MovementSpeedValues UsefulOccupations.MovementSpeedValues
---@field ModData UsefulOccupations.ModData
---@field Traits UsefulOccupations.Traits
---@field PersonalTraits UsefulOccupations.PersonalTraits
---@field DecorationTraits UsefulOccupations.DecorationTraits
---@field MutualExclusives UsefulOccupations.MutualExclusives
---@field Professions UsefulOccupations.Professions
---@field Functions UsefulOccupations.Functions

---@type UsefulOccupations
---@diagnostic disable-next-line: missing-fields
UsefulOccupations = {
	---@diagnostic disable-next-line: missing-fields
	DoTraitsOnCreatePlayer = {},
	DoFuncsOnCreatePlayer = {},
	---@diagnostic disable-next-line: missing-fields
	TraitsOnGameBoot = {},
	---@diagnostic disable-next-line: missing-fields
	InventoryItemsStatsHandler = {},
	MovementSpeedValues = require("UsefulOccupationsShared/Data/MovementSpeedValues"),
	ModData = require("UsefulOccupationsShared/Data/ModData"),
	Traits = require("UsefulOccupationsShared/Data/Traits"),
	PersonalTraits = require("UsefulOccupationsShared/Data/PersonalTraits"),
	Functions = require("UsefulOccupationsShared/Data/Functions"),
}

---@type UsefulOccupations.DecorationTraits
UsefulOccupations.DecorationTraits = require("UsefulOccupationsShared/Data/DecorationTraits")()

---@type UsefulOccupations.MutualExclusives
UsefulOccupations.MutualExclusives = require("UsefulOccupationsShared/Data/MutualExclusives")()

---@type UsefulOccupations.Professions
UsefulOccupations.Professions = require("UsefulOccupationsShared/Data/Professions")()

return UsefulOccupations
