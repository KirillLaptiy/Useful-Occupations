--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UsefulOccupations.ModData
local modData = {
	-- ScoutSkills
	walkTime = 0,

	-- Inconspicuous
	isPretendingZombie = false,

	-- Scout
	gotScoutKit = false,

	-- Invincible
	bodyPartsData = {},
	invincibleState = "ready",
	statsData = {},
	bodyDamageData = {},
	invincibleCooldownTime = 0,
	invincibleActiveTime = 0,

	-- SPM
	gotSPMKit = false,

	-- Items effects
	-- StimulantGel
	gelEffectTime = 0,

	-- StimulantDrops
	SPTraitsSaved = false,
	SPActiveTime = 0,
	SPStrength = 0,
	hasHardOfHearing = false,
	hasShortSighted = false,

	-- StimulantDropsPlus
	hasKeenHearing = false,
	hasEagleEyed = false,
	hasNightVision = false,
}

return modData
