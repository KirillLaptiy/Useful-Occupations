--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local traitType = UsefulOccupations.PersonalTraits.Doctor.type

---@diagnostic disable-next-line: duplicate-set-field
function ISHandcraftAction:performRecipe()
    if self.logic then
        if self.logic:performCurrentRecipe() then
            -- perform succeeded
            local items = ArrayList.new();
            self.logic:getCreatedOutputItems(items);

            local hasDoctorTrait = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType))


            for i = 0, items:size() - 1 do
                local item = items:get(i);

                if hasDoctorTrait and item:isFood() then
                    local usedItems = self.logic:getRecipeData():getAllConsumedItems()

                    for g = 0, usedItems:size() - 1 do
                        ---@type InventoryItem
                        local usedItem = usedItems:get(g)

                        if usedItem:isFood() then
                            ---@diagnostic disable-next-line: param-type-mismatch
                            UsefulOccupations.TraitsOnGameBoot.Doctor.setFoodData(item, usedItem)
                        end
                    end
                end

                Actions.addOrDropItem(self.character, item)
            end

            self.logic:getRecipeData():luaCallOnCreate(self.character);
            self.logic:getRecipeData():processDestroyAndUsedItems(self.character); -- todo handle syncing items and inventory stuff here

            if items:size() == 1 then
                local resItem = items:get(0)
                local modData = resItem:getModData()
                local usedItems = self.logic:getRecipeData():getAllConsumedItems()
                for i = 0, usedItems:size() - 1 do
                    local item = usedItems:get(i)
                    if modData[item:getFullType()] == nil then
                        modData[item:getFullType()] = 0
                    end
                    modData[item:getFullType()] = modData[item:getFullType()] + 1
                end
            end
        end
    end
end
