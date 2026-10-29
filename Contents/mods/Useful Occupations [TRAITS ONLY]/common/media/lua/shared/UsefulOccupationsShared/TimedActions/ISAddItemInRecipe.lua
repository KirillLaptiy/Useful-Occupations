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
function ISAddItemInRecipe:complete()
	local hasDoctorTrait = self.character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType))

	self.character:removeFromHands(self.baseItem)

	self.baseItem = self.recipe:addItem(self.baseItem, self.usedItem, self.character)

	---@type Food
	---@diagnostic disable-next-line: assign-type-mismatch
	local food = self.baseItem

	if hasDoctorTrait then
		---@diagnostic disable-next-line: param-type-mismatch
		UsefulOccupations.TraitsOnGameBoot.Doctor.setFoodData(food, self.usedItem)
	end

	ISAddItemInRecipe.checkName(self.baseItem, self.recipe)

	if not self.baseItem:isCustomName() and food:getFoodType() == "Beer" then
		---@diagnostic disable-next-line: undefined-global
		baseItem:setName(getText("ContextMenu_FoodType_Beer"))
	end

	ISAddItemInRecipe.checkTemperature(self.baseItem, self.usedItem, self.recipe)

	if isServer() then
		sendItemStats(self.baseItem)
	end

	return true
end
