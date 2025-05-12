---@class EventType
---@field Add fun(callback: function)
---@field Remove fun(callback: function)

---@class UsefulOccupations.Functions
---@field getModData fun(): UsefulOccupations.ModData
---@field initModData fun(): UsefulOccupations.ModData
-- Adds function that will be called every frequencyMs milliseconds
---@field processEveryMs fun(frequencyMs: integer, callback: function)
-- Adds an event that will be removed upon death
---@field addEvent fun(event: EventType, callback: function) : function
-- Need to clear events if a new player was created in the same world
---@field removeAllEvents fun()

local activeEvents = {}

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

	addEvent = function(eventTable, callback)
		if not eventTable or type(eventTable.Add) ~= "function" then
			error("Invalid event table passed to addEvent.")
		end

		eventTable.Add(callback)

		table.insert(activeEvents, { event = eventTable, callback = callback })

		return callback
	end,

	removeAllEvents = function()
		for _, entry in ipairs(activeEvents) do
			entry.event.Remove(entry.callback)
		end

		activeEvents = {}
	end,
}

return Functions
