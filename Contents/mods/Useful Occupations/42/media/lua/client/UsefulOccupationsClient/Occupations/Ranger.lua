---@diagnostic disable: duplicate-set-field
--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Edited by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- Ranger cuts trees twice as hard
local function isRanger(player)
    return player:getDescriptor():getProfession() == UsefulOccupations.Professions.parkranger.type
end

function ISChopTreeAction:start()
    self.axe = self.character:getPrimaryHandItem()
    self.axe:setJobType(getText("ContextMenu_Chop_Tree"));
    self.axe:setJobDelta(0.0);

    if self.character:isTimedActionInstant() then
        self.tree:setHealth(1)
    end

    self:setActionAnim(CharacterActionAnims.Chop_tree);

    self:setOverrideHandModels(self.axe, nil)

    if isRanger(self.character) then
        self.tree:setHealth(self.tree:getHealth() / 2)
    end
end

function ISChopTreeAction:stop()
    self.axe:setJobDelta(0.0);

    if isRanger(self.character) then
        self.tree:setHealth(self.tree:getHealth() / 2)
    end

    ISBaseTimedAction.stop(self)
end

function ISChopTreeAction:perform()
    self.axe:setJobDelta(0.0);

    if isRanger(self.character) then
        self.tree:setHealth(self.tree:getHealth() / 2)
    end

    ISBaseTimedAction.perform(self)
end

-- When chopping trees, the Ranger's accumulation of pain is reduced by 2 times
function ISChopTreeAction:animEvent(event, _)
    if not isClient() then
        if event == 'ChopTree' then
            self.tree:WeaponHit(self.character, self.axe)

            local modifier = 1

            if isRanger(self.character) then modifier = 0.5 end

            self.character:addCombatMuscleStrain(self.axe, 1, modifier)

            self:useEndurance()

            if self.tree:getObjectIndex() == -1 then
                if isServer() then
                    self.netAction:forceComplete()
                else
                    self:forceComplete()
                end
            end
        end
    elseif event == 'ChopTree' then
        self.tree:WeaponHitEffects(self.character, self.axe)
    end
end

-- When chopping trees, the Ranger's endurance use is reduced by 2 times
function ISChopTreeAction:useEndurance()
    if self.axe:isUseEndurance() then
        local use = self.axe:getWeight() * self.axe:getFatigueMod(self.character) * self.character:getFatigueMod() *
            self.axe:getEnduranceMod() * 0.1

        local useChargeDelta = 1.0

        use = use * useChargeDelta * 0.041

        if self.axe:isTwoHandWeapon() and self.character:getSecondaryHandItem() ~= self.axe then
            use = use + self.axe:getWeight() / 1.5 / 10 / 20
        end

        if isRanger(self.character) then
            use = use / 2
        end

        self.character:getStats():setEndurance(self.character:getStats():getEndurance() - use)
    end
end
