--- @param player IsoPlayer
UsefulOccupations.occupations.unemployed = function(player)
    local xp = player:getXp()

    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = Perks.fromIndex(i)

        -- to save start xp boost and not clear it later
        if not player:getModData().UsefulOccupations[perk] then
            player:getModData().UsefulOccupations[perk] = {}
            player:getModData().UsefulOccupations[perk].startXpBoost = xp:getPerkBoost(perk)
        end

        local perkLvl = player:getPerkLevel(perk)

        if perkLvl == 0 then
            xp:setPerkBoost(perk, 1)
        elseif perkLvl == 1 then
            xp:setPerkBoost(perk, 2)
        elseif perkLvl == 2 then
            xp:setPerkBoost(perk, 3)
        end
    end

    ---@param perk Perk
    Events.LevelPerk.Add(function(_, perk, _, _)
        local perkLvl = player:getPerkLevel(perk)

        if perkLvl == 0 then
            xp:setPerkBoost(perk, 1)
        elseif perkLvl == 1 then
            xp:setPerkBoost(perk, 2)
        elseif perkLvl == 2 then
            xp:setPerkBoost(perk, 3)
        elseif perkLvl == 3 then
            local startXpBoost = player:getModData().UsefulOccupations[perk].startXpBoost
            xp:setPerkBoost(perk, startXpBoost)
        end
    end)
end
