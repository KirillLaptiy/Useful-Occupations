
ContextMenuCode = ContextMenuCode or {}

---@param context any
---@param entity ISBuildIsoEntity
---@param character IsoPlayer
---@param param any
function ContextMenuCode.UO_EnableMoonshine(context, entity, character, param)
    ---@type IsoSprite
    local sprite = entity:getSprite():getName();
    local newSprite = "crafted_04_32";

    if not sprite then return; end
    if sprite == "crafted_04_35" then
        newSprite = "crafted_04_34";
    elseif sprite == "crafted_04_34" then
        newSprite = "crafted_04_35";
    elseif sprite == "crafted_04_32" then
        newSprite = "crafted_04_33";
    end

    print(12333123123)

	-- if luautils.walkAdj(character, entity:getSquare(), false) then
	-- 	ISTimedActionQueue.add(ISOpenCloseLid:new(character, entity, entity:getSquare(), newSprite));
	-- end
end