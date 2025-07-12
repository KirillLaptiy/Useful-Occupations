--[[
*
*              ^_^         Y U M M Y         ^_^
*
*                 ~ Deliciously Made by YUMMY ~
*
*                          :3  :3  :3
*
]]

---@diagnostic disable-next-line: duplicate-set-field
function CoopCharacterCreation:newPlayerMouse()
	if CoopCharacterCreation.instance then
		return
	end
	if UIManager.getSpeedControls() and not IsoPlayer.allPlayersDead() then
		setShowPausedMessage(false)
		UIManager.getSpeedControls():SetCurrentGameSpeed(0)
	end
	CoopCharacterCreation.setVisibleAllUI(false)
	local w = CoopCharacterCreation:new(nil, nil, 0)
	w:initialise()
	w:addToUIManager()
	if w.mapSpawnSelect:hasChoices() then
		w.mapSpawnSelect:fillList()
		w.mapSpawnSelect:setVisible(true)
	else
		w.mapSpawnSelect:useDefaultSpawnRegion()
		w.charCreationProfession:setVisible(true)
	end
end
