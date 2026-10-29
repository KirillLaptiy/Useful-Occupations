--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@class EventType
---@field Add fun(callback: function)
---@field Remove fun(callback: function)

---@class UsefulOccupations.Functions
---@field getModData fun(): UsefulOccupations.ModData
---@field initModData fun(): UsefulOccupations.ModData
-- Adds function that will be called every frequencyMs milliseconds
---@field processEveryMs fun(frequencyMs: integer, callback: function)
-- Adds function that will be called after % milliseconds
---@field processAfterDelay fun(delayMs: integer, callback: function)
-- Adds an event that will be removed upon death
---@field addEvent fun(event: EventType, callback: function) : function
-- Need to clear events if a new player was created in the same world
---@field removeAllEvents fun()
---Need to clear mod data if a new player was created in the same world
---@field clearModData fun()
---@field getTraitByStr fun(str: string) : CharacterTrait
---@field getItemTagByStr fun(str: string) : ItemTag
---@field getItemBodyLocByStr fun(str: string) : ItemBodyLocation
---@field tryGetTraitByStr fun(str: string) : CharacterTrait | nil

local activeEventList = {}

---@type UsefulOccupations.Functions
local Functions = {
	getModData = function()
		return getPlayer():getModData().UsefulOccupationsModData
	end,

	initModData = function()
		getPlayer():getModData().UsefulOccupationsModData = UsefulOccupations.ModData
		return getPlayer():getModData().UsefulOccupationsModData
	end,

	processEveryMs = function(frequencyMs, callback)
		local lastCall = getTimestampMs()

		UsefulOccupations.Functions.addEvent(Events.OnTick, function(_)
			local now = getTimestampMs()

			if now - lastCall >= frequencyMs then
				lastCall = now
				callback()
			end
		end)
	end,

	processAfterDelay = function(delayMs, callback)
		local startCall = getTimestampMs()

		local function onTick()
			if getTimestampMs() - startCall >= delayMs then
				Events.OnTick.Remove(onTick)
				callback()
			end
		end

		UsefulOccupations.Functions.addEvent(Events.OnTick, onTick)
	end,

	addEvent = function(eventTable, callback)
		eventTable.Add(callback)

		table.insert(activeEventList, { event = eventTable, callback = callback })

		return callback
	end,

	removeAllEvents = function()
		for _, entry in ipairs(activeEventList) do
			entry.event.Remove(entry.callback)
		end

		activeEventList = {}
	end,

	clearModData = function()
		getPlayer():getModData().UsefulOccupationsModData = nil
	end,

	getTraitByStr = function(str)
		local trait = CharacterTrait.get(ResourceLocation.of(UsefulOccupations.ModModule .. str))
		trait = trait or CharacterTrait.get(ResourceLocation.of(str))

		if trait == nil then
			error("TRAIT BY STR:" .. str .. "NOT FOUND")
		end

		return trait
	end,

	getItemTagByStr = function(str)
		local tag = ItemTag.get(ResourceLocation.of(UsefulOccupations.ModModule .. str))
		tag = tag or ItemTag.register(UsefulOccupations.ModModule .. str)

		return tag
	end,

	getItemBodyLocByStr = function(str)
		local bodyLoc = ItemBodyLocation.get(ResourceLocation.of(UsefulOccupations.ModModule .. str))

		if bodyLoc == nil then
			error("ITEM BODY LOCATION BY STR:" .. str .. "NOT FOUND")
		end

		return bodyLoc
	end,

	---@param str string
	---@return CharacterTrait
	tryGetTraitByStr = function(str)
		local trait = CharacterTrait.get(ResourceLocation.of(UsefulOccupations.ModModule .. str))
		trait = trait or CharacterTrait.get(ResourceLocation.of(str))

		return trait
	end
}

return Functions
