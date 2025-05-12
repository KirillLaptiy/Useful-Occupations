--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local originalISBuildIsoEntity = ISBuildIsoEntity.new

---@diagnostic disable-next-line: duplicate-set-field
function ISBuildIsoEntity:new(character, objectInfo, nSprite, containers, logic)
	local o = originalISBuildIsoEntity(self, character, objectInfo, nSprite, containers, logic)

	-- Outdoorsman builds campfire faster
	if o.name == "Campfire" and character:HasTrait(UsefulOccupations.PersonalTraits.Outdoorsman.type) then
		o.maxTime = o.maxTime / UsefulOccupations.PersonalTraits.Outdoorsman.values.buildCampfireSpeedMultiplier
	end

	return o
end
