-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

local traitName

---@diagnostic disable-next-line: duplicate-set-field
ISReadABook.checkMultiplier = function(self)
	local booksMultiplier = UsefulOccupations.PersonalTraits.Wunderkind.values.booksMultiplier()
	local lastBooksMultiplierLevel = UsefulOccupations.PersonalTraits.Wunderkind.values.lastBooksMultiplierLevel()

	-- get all our info in the map
	local trainedStuff = SkillBook[self.item:getSkillTrained()]
	if trainedStuff then
		-- every 10% we add 10% of the max multiplier
		local readPercent = (self.item:getAlreadyReadPages() / self.item:getNumberOfPages()) * 100
		if readPercent > 100 then
			readPercent = 100
		end
		-- apply the multiplier to the skill
		local multiplier = (math.floor(readPercent / 10) * (self.maxMultiplier / 10))

		if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitName)) then
			multiplier = multiplier * booksMultiplier
		end

		local maxLevel = self.item:getMaxLevelTrained()

		if self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitName)) then
			maxLevel = maxLevel + lastBooksMultiplierLevel
		end

		if maxLevel > 10 then
			maxLevel = 10
		end

		if multiplier > self.character:getXp():getMultiplier(trainedStuff.perk) then
			self.character
				:getXp()
				:addXpMultiplier(trainedStuff.perk, multiplier, self.item:getLvlSkillTrained(), maxLevel)
		end
	end
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	traitName = UsefulOccupations.PersonalTraits.Wunderkind.type
end)
