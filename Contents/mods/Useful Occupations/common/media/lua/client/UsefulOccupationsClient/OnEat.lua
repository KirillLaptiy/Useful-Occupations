--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class UO_ON_EAT
UO_ON_EAT = {}

local gelAffectPerks = {
	Strength = true,
	Fitness = true,
	Sprinting = true,
	Nimble = true,
	Lightfoot = true,
	Sneak = true,
}

local stimulantGelEffect = function()
	local player = getPlayer()
	local xp = player:getXp()
	local modData = UsefulOccupations.Functions.getModData()

	---@param perk PerkFactory.Perk
	---@param amount number
	local function gelEffect(_, perk, amount)
		if modData.gelEffectTime == 0 then
			return
		end

		if gelAffectPerks[perk:toString()] then
			xp:AddXP(perk, amount * 0.5, false, false, false)
		end
	end

	local function timeEffect()
		modData.gelEffectTime = modData.gelEffectTime - 1

		if modData.gelEffectTime == 0 then
			Events.EveryOneMinute.Remove(timeEffect)
			Events.AddXP.Remove(gelEffect)
		end
	end

	Events.EveryOneMinute.Add(timeEffect)
	Events.AddXP.Add(gelEffect)
end

---@param character IsoPlayer
UO_ON_EAT.EnergyDrink = function(_, character, _)
	local stats = character:getStats()

	stats:set(CharacterStat.ENDURANCE, stats:get(CharacterStat.ENDURANCE) + 0.15)
	stats:set(CharacterStat.FATIGUE, stats:get(CharacterStat.FATIGUE) - 0.15)
end

UO_ON_EAT.StimulantGel = function(_, _, _)
	local modData = UsefulOccupations.Functions.getModData()

	-- prevent double gel effect
	if modData.gelEffectTime > 0 then
		modData.gelEffectTime = modData.gelEffectTime + 360
		return
	end

	modData.gelEffectTime = modData.gelEffectTime + 360

	stimulantGelEffect()
end

table.insert(UsefulOccupations.DoFuncsOnCreatePlayer, function(_, _)
	local modData = UsefulOccupations.Functions.getModData()

	if modData.gelEffectTime > 0 then
		stimulantGelEffect()
	end
end)
