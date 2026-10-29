-- --[[
-- *
-- *              ^_^         Y U M M Y         ^_^
-- *
-- *                 ~ Deliciously Made by YUMMY ~
-- *
-- *                          :3  :3  :3
-- *
-- ]]

local stateNum = 1
local stateTimer = nil

--TODO: add dynamic influence by WalkSpeed and WalkInjury variables
local STEP_DATA = {
    ["sprint"] = { 302, 368, "hasGraceful" },
    ["run"] = { 300, 370, "hasGraceful" },
    ["walk"] = { 300, 370, "hasGraceful" },
    ["sneak_walk"] = { 300, 370, "hasGraceful" },
    ["sneak_run"] = { 300, 370, "hasGraceful" },
    ["strafe"] = { 302, 368, "silentStrafe" },
}

local function getFootstepType(player)
    if player:isSprinting() then
        return "sprint"
    elseif player:isStrafing() then
        return "strafe"
    elseif player:isSneaking() and player:isRunning() then
        return "sneak_run"
    elseif player:isSneaking() then
        return "sneak_walk"
    elseif player:isRunning() then
        return "run"
    else
        return "walk"
    end
end

Events.OnPlayerMove.Add(function(player)
    local currentType = getFootstepType(player)

    -- If player has positive variable don't do footsteps
    if player:getVariableBoolean(STEP_DATA[currentType][3]) then return end

    local now = getTimestampMs()
    stateTimer = stateTimer or now

    local walkSpeed = tonumber(player:getVariableString("WalkSpeed")) or 1
    -- local walkInjuryStr = player:getVariableString("WalkInjury")

    local interval = STEP_DATA[currentType][stateNum]

    if currentType == "strafe" then interval = interval / walkSpeed end

    if now - stateTimer >= interval then
        player:DoFootstepSound(currentType)
        stateNum = stateNum == 1 and 2 or 1
        stateTimer = now
    end
end)
