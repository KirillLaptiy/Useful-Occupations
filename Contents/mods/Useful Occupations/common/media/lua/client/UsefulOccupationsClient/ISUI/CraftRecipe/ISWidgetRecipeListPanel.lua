--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

-- Hidden recipes handler (HRH):
-- Handler used to hide craft recipes under certain conditions

table.insert(UsefulOccupations.DoFuncsOnCreatePlayer, function()
	local personalTraits = UsefulOccupations.PersonalTraits
	local engineerType = personalTraits.Engineer.type

	local hiddenRecipesByTraits = {
		-- MakeCrudeStoneAxe = engineerType,
		-- MakeStoneHammer = engineerType,
		-- MakeCrudeKnife = engineerType,
	}

	local visibleRecipesByTraits = {
		CraftHammerCrafted = engineerType,
	}

	---@diagnostic disable-next-line: duplicate-set-field
	function ISWidgetRecipeListPanel:setDataList(_recipeList)
		local currentRecipe = self.logic:getRecipe()
		local currentRecipeFound = false

		self.recipeListPanel:clear()

		for i = 0, _recipeList:size() - 1 do
			---@type CraftRecipe
			local craftRecipe = _recipeList:get(i)
			local craftRecipeName = craftRecipe:getScriptObjectName()

			local recipeAllowed = true

			local traitTypeToBeForbidden = hiddenRecipesByTraits[craftRecipeName]

			if traitTypeToBeForbidden then
				recipeAllowed = not self.player:HasTrait(traitTypeToBeForbidden)
			end

			local traitTypeToBeVisible = visibleRecipesByTraits[craftRecipeName]

			if traitTypeToBeVisible then
				recipeAllowed = self.player:HasTrait(traitTypeToBeVisible)
			end

			if recipeAllowed then
				local failed = false

				if _recipeList:get(i):getOnAddToMenu() then
					local func = _recipeList:get(i):getOnAddToMenu()
					local params =
						{ player = self.player, recipe = _recipeList:get(i), shouldShowAll = self.enabledShowAllFilter }

					failed = not callLuaBool(func, params)
				end

				if not failed then
					local listItem =
						self.recipeListPanel:addItem(_recipeList:get(i):getTranslationName(), _recipeList:get(i))

					if listItem.item == currentRecipe then
						-- restore selection
						self.recipeListPanel.selected = listItem.itemindex
						currentRecipeFound = true
					end
				end
			end
		end

		if not currentRecipeFound then
			self.recipeListPanel.selected = -1
		end
	end
end)
