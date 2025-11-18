--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

local function readExistingStats(fileName)
	local stats = {
		Name = {},
		Gender = {},
		Professions = {},
		Traits = {},
	}

	local fileReader = getFileReader(fileName, false)
	if not fileReader then
		return stats
	end

	while true do
		local line = fileReader:readLine()
		if not line then
			break
		end

		if line:match("^%s*Player Stats%s*:") or line:match("^%s*$") then
			-- skip
		else
			local key, values = line:match("^(.-)%s*:%s*(.*)$")
			if key and values and values ~= "" then
				for name, count in values:gmatch("([^%[%],]+)%s*%[([0-9]+)%]") do
					name = name:gsub("^%s+", ""):gsub("%s+$", "") -- trim
					local n = tonumber(count) or 0

					stats[key] = stats[key] or {}
					stats[key][name] = n
				end
			end
		end
	end

	fileReader:close()
	return stats
end

local function writeStats(fileName, stats)
	local writer = getFileWriter(fileName, false, false)

	writer:write("Player Stats:\n")

	local function lineFromTable(title, t)
		local parts = {}
		for k, v in pairs(t) do
			table.insert(parts, string.format("%s[%d]", k, v))
		end
		return title .. ": " .. table.concat(parts, ", ") .. "\n"
	end

	writer:write(lineFromTable("Name", stats.Name))
	writer:write(lineFromTable("Gender", stats.Gender))
	writer:write(lineFromTable("Professions", stats.Professions))
	writer:write(lineFromTable("Traits", stats.Traits))

	writer:close()
end

local function SavePlayerStats()
	local player = getPlayer()

	local modData = player:getModData()

	if modData.UO_StatsSaved then
		return
	end

	local fileName = "PlayerStats.txt"
	local stats = readExistingStats(fileName)

	local name = player:getFullName():trim() or "Unknown"
	local gender = player:isFemale() and "Female" or "Male"
	local profession = player:getDescriptor():getProfession() or "None"

	stats.Name[name] = (stats.Name[name] or 0) + 1
	stats.Gender[gender] = (stats.Gender[gender] or 0) + 1
	stats.Professions[profession] = (stats.Professions[profession] or 0) + 1

	if not stats.Traits then
		stats.Traits = {}
	end

	local traits = player:getTraits()

	for i = 0, traits:size() - 1 do
		local trait = traits:get(i)
		stats.Traits[trait] = (stats.Traits[trait] or 0) + 1
	end

	writeStats(fileName, stats)

	modData.UO_StatsSaved = true
end

Events.OnCreatePlayer.Add(SavePlayerStats)
