--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class TraitsOnGameBoot.Doctor
UsefulOccupations.TraitsOnGameBoot.Doctor = {}

local hungModifier
local hungModifierPerLvl

-- Doctor cooks food better
---@param food Food
---@param usedFood Food
UsefulOccupations.TraitsOnGameBoot.Doctor.setFoodData = function(food, usedFood)
	local levelEffect = 1 + getPlayer():getPerkLevel(Perks.Cooking) * hungModifierPerLvl

	local modifier = hungModifier * levelEffect

	local hungChange = usedFood:getHungChange() * modifier
	local calories = usedFood:getCalories() * modifier
	local carbohydrates = usedFood:getCarbohydrates() * modifier
	local lipids = usedFood:getLipids() * modifier
	local proteins = usedFood:getProteins() * modifier
	local cookingTime = usedFood:getCookingTime() * modifier
	local minutesToBurn = usedFood:getMinutesToBurn() * modifier * 2
	local unhappyChange = usedFood:getUnhappyChange() * modifier
	local thirstChange = usedFood:getThirstChange() * modifier
	local stressChange = usedFood:getStressChange() * modifier
	local enduranceChange = usedFood:getEndChange() * modifier
	local fatigueChange = usedFood:getFatigueChange() * modifier
	local boredomChange = usedFood:getBoredomChange() * modifier

	if unhappyChange > 0 then
		unhappyChange = -unhappyChange
	end

	if stressChange > 0 then
		stressChange = -stressChange
	end

	if fatigueChange > 0 then
		fatigueChange = -fatigueChange
	end

	if enduranceChange > 0 then
		enduranceChange = -enduranceChange
	end

	if thirstChange > 0 then
		thirstChange = 0
	end

	if boredomChange > 0 then
		boredomChange = -boredomChange
	end

	food:setHungChange(food:getHungChange() + hungChange)
	food:setCalories(food:getCalories() + calories)
	food:setCarbohydrates(food:getCarbohydrates() + carbohydrates)
	food:setLipids(food:getLipids() + lipids)
	food:setProteins(food:getProteins() + proteins)
	food:setCookingTime(food:getCookingTime() - cookingTime)
	food:setMinutesToBurn(food:getMinutesToBurn() + minutesToBurn)
	food:setUnhappyChange(food:getUnhappyChange() + unhappyChange)
	food:setThirstChange(food:getThirstChange() + thirstChange)
	food:setStressChange(food:getStressChange() + stressChange)
	food:setEndChange(food:getEndChange() + enduranceChange)
	food:setFatigueChange(food:getFatigueChange() + fatigueChange)
	food:setBoredomChange(food:getBoredomChange() + boredomChange)
	food:setGoodHot(false)
	food:setBadInMicrowave(false)
	food:setBadCold(false)
	food:setAge(0)

	food:updateAge()
	food:update()
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	local traitValues = UsefulOccupations.PersonalTraits.Doctor.values

	hungModifier = traitValues.hungModifier()
	hungModifierPerLvl = traitValues.hungModifierPerLvl()
end)
