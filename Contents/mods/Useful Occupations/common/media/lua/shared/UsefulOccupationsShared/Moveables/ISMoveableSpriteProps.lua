--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local traitType

-- Items whose quantity should not increase after scrap
local invalidItems = {
	["Base.Hinge"] = true,
	["Base.Doorknob"] = true,
}

-- Builder gets more resources by scrap furniture
---@diagnostic disable-next-line: duplicate-set-field
function ISMoveableSpriteProps:getScrapItemsList(_character)
	local materials = {}
	local items = { usable = {}, unusable = {} }

	if self.material then
		table.insert(materials, self.material)
	end
	if self.material2 then
		table.insert(materials, self.material2)
	end
	if self.material3 then
		table.insert(materials, self.material3)
	end

	if #materials <= 0 then
		return
	end

	local scrapDef, chance, addedAmount

	for _, mat in ipairs(materials) do
		scrapDef = ISMoveableDefinitions:getInstance().getScrapDefinition(mat)
		---@diagnostic disable-next-line: param-type-mismatch
		chance = self:getChanceByDef(scrapDef, _character)
		addedAmount = 0
		if scrapDef and chance then
			local returnItems = scrapDef.returnItemsStatic or {}
			if (not returnItems) or #returnItems < 1 then
				returnItems = scrapDef.returnItems
			end

			if returnItems and #returnItems > 0 then
				local isBuilder = _character:hasTrait(UsefulOccupations.Functions.getTraitByStr(traitType))

				-- Builder gets more resources by scrap furniture
				if isBuilder then
					for _, v in ipairs(returnItems) do
						local maxAmount = v.maxAmount

						if not invalidItems[v.returnItem] then
							if maxAmount == 1 then
								maxAmount = maxAmount * 4
							elseif maxAmount < 4 then
								maxAmount = maxAmount * 2
							end
						end

						addedAmount = addedAmount
							+ self:addScrapItemToList(items.usable, v.returnItem, maxAmount, 100, 100, false)
					end
				else
					for _, v in ipairs(returnItems) do
						addedAmount = addedAmount
							+ self:addScrapItemToList(
								items.usable,
								v.returnItem,
								v.maxAmount,
								v.chancePerRoll,
								chance,
								true
							)
					end
				end
			end

			if addedAmount == 0 and scrapDef.unusableItem then
				local rolls = ZombRand(1, 3)

				for _ = 1, rolls do
					table.insert(items.unusable, scrapDef.unusableItem)
				end
			end
		end
	end

	return items
end

-- Needs to add planks limit when scrapping floor
---@diagnostic disable-next-line: duplicate-set-field
function ISMoveableSpriteProps:addScrapItemToList(_list, _item, _max, _chance, _skillMod, _doSizeMod)
	local added = 0

	if _item and _max and _chance then
		if _skillMod and _skillMod > 0 and _skillMod <= 100 then
			_chance = (_chance / 100) * _skillMod
		end

		local amount = _max --ZombRand(0,_max+1);

		---@diagnostic disable-next-line: undefined-field
		local object = self.object

		if _doSizeMod then
			if self.scrapSize == "Small" then
				amount = amount / 2 >= 1 and amount / 2 or 1
			elseif self.scrapSize == "Large" then
				amount = amount * 2
			end
		end

		print("_item " .. tostring(_item))

		-- kludge to prevent floors from providing more nails than used to make them
		if (_item == "Base.Nails" or _item == "Base.Plank") and object and object:isFloor() and amount > 1 then
			amount = 1
		end

		-- kludge so sandbag walls can be dismantled and give back the original 3 bags
		if _item == "Base.Sandbag" then
			amount = 3
		end

		if amount > 0 then
			for _ = 1, amount do
				-- just in case we need to do some funny stuff for crafting materials
				local newItem = _item
				local randNum = ZombRandFloat(0, 100)

				-- again I just want to give back the 3 sandbags with no funny business
				if randNum <= _chance or _item == "Base.Sandbag" then
					table.insert(_list, newItem)
					added = added + 1
				end
			end
		end
	end
	return added
end

-- Init sandbox values
Events.OnGameStart.Add(function()
	traitType = UsefulOccupations.PersonalTraits.Builder.type
end)
