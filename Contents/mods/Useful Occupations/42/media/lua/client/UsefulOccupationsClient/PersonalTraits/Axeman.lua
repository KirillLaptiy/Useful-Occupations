---@diagnostic disable: duplicate-set-field
--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- Ranger cuts trees twice as hard

-- Проверить при трейдинге

--- @class UsefulOccupations.Axeman
--- @field axe HandWeapon
local Axeman = {}
Axeman.axe = nil
Axeman.isTreeDamageIncreased = false

--- @param item HandWeapon
Axeman.getTreeDamage = function(item)
    ---@diagnostic disable-next-line: undefined-field
    return math.floor(item:getTreeDamage() / item:getSharpnessMultiplier())
end

-- Increase tree damage after join if axe is equipped right now
Axeman.setTreeDamageOnStart = function()
    local player = getPlayer()

    if not UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Axeman.type) or not player:getUseHandWeapon():getTreeDamage() then
        Events.OnPlayerUpdate.Remove(Axeman.setTreeDamageOnStart)
        return
    end

    if not player:getUseHandWeapon():getType() == "BareHands" and player:isAiming() then
        Axeman.increaseTreeDamage(player:getUseHandWeapon())
    end
end

-- Methods to modify tree damage
Axeman.increaseTreeDamage = function(item)
    Axeman.axe = item

    local newTreeDamage = Axeman.getTreeDamage(Axeman.axe) * 2

    Axeman.axe:setTreeDamage(newTreeDamage)

    Axeman.isTreeDamageIncreased = true

    Events.OnPlayerUpdate.Remove(Axeman.setTreeDamageOnStart)
end

Axeman.decreaseTreeDamage = function(item)
    local newTreeDamage = Axeman.getTreeDamage(item) / 2

    item:setTreeDamage(newTreeDamage)

    Axeman.axe = nil
end

-- Change tree damage when equip / unequip primary weapon
--- @param item HandWeapon
Events.OnEquipPrimary.Add(function(_, item)
    if UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Axeman.type) then
        Events.OnPlayerUpdate.Remove(Axeman.setTreeDamageOnStart)

        if Axeman.axe then
            Axeman.decreaseTreeDamage(Axeman.axe)
        end

        if item then
            local treeDamage = item:getTreeDamage()

            if treeDamage then
                Axeman.increaseTreeDamage(item)
            end
        end
    end
end)

Events.OnPlayerUpdate.Add(Axeman.setTreeDamageOnStart)

-- Chop tree timed action
local startChopTreeAction = ISChopTreeAction.start

function ISChopTreeAction:start()
    startChopTreeAction(self)

    if UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Axeman.type) and not Axeman.isTreeDamageIncreased then
        Axeman.increaseTreeDamage(self.axe)
    end
end

-- When chopping trees, the Ranger's accumulation of pain is reduced by 2 times
function ISChopTreeAction:animEvent(event, _)
    if not isClient() then
        if event == 'ChopTree' then
            self.tree:WeaponHit(self.character, self.axe)

            local modifier = 1

            if UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Axeman.type) then modifier = 0.5 end

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

        if UsefulOccupations.isContaneTrait(UsefulOccupations.PersonalTraits.Axeman.type) then
            use = use / 2
        end

        self.character:getStats():setEndurance(self.character:getStats():getEndurance() - use)
    end
end
