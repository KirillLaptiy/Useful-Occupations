--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

UsefulOccupations.PersonalTraitsOnStart.Wunderkind = function()
    local player = getPlayer()
    local xp = player:getXp()

    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = Perks.fromIndex(i)
        if player:getPerkLevel(perk) < 3 then xp:setPerkBoost(perk, 3) end
    end

    --- @param perk Perk
    Events.LevelPerk.Add(function(_, perk, perkLvl, _)
        if perkLvl == 3 then
            local startXpBoost = player:getModData().UsefulOccupations[perk:getName()].startXpBoost
            xp:setPerkBoost(perk, startXpBoost)
        end
    end)
end

ISReadABook.checkMultiplier = function(self)
    -- get all our info in the map
    local trainedStuff = SkillBook[self.item:getSkillTrained()];
    if trainedStuff then
        -- every 10% we add 10% of the max multiplier
        local readPercent = (self.item:getAlreadyReadPages() / self.item:getNumberOfPages()) * 100;
        if readPercent > 100 then
            readPercent = 100;
        end
        -- apply the multiplier to the skill
        local multiplier = (math.floor(readPercent / 10) * (self.maxMultiplier / 10))

        if UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Wunderkind.type) then
            multiplier = multiplier * 2
        end

        local maxLevel = self.item:getMaxLevelTrained()

        if UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Wunderkind.type) then
            maxLevel = 10
        end

        if multiplier > self.character:getXp():getMultiplier(trainedStuff.perk) then
            self.character:getXp():addXpMultiplier(trainedStuff.perk, multiplier, self.item:getLvlSkillTrained(),
                maxLevel);
        end
    end
end
