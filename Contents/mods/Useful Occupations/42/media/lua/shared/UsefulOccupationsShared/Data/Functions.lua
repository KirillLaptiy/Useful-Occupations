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

local activeEventList = {}
local activeEventSet = {}

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
		if activeEventSet[callback] then
			return callback
		end

		eventTable.Add(callback)

		table.insert(activeEventList, { event = eventTable, callback = callback })

		activeEventSet[callback] = true

		return callback
	end,

	removeAllEvents = function()
		for _, entry in ipairs(activeEventList) do
			entry.event.Remove(entry.callback)
		end

		activeEventList = {}
		activeEventSet = {}
	end,
}

return Functions
