local bettercoop = RegisterMod("BetterCoop", 1);

-- (0,0 in top left of screen)
local MIN_X = 75
local MIN_Y = 160
local MAX_X = 555
local MAX_Y = 400

-- Cross-callback state
local starting_room_idx = 0

local function onNewLevel(_)
  -- Only spawn on the first starting room
  if Game():GetLevel():GetStage() ~= LevelStage.STAGE1_1 then
    return nil
  end

  -- Save idx of starting room for manually overwriting item pool here
  starting_room_idx = Game():GetLevel():GetCurrentRoomIndex()

  local blue_id = Isaac.GetItemIdByName("Blue")
  local green_id = Isaac.GetItemIdByName("Green")
  local red_id = Isaac.GetItemIdByName("Red")
  local purple_id = Isaac.GetItemIdByName("Purple")

  local blue_pos = Vector(MIN_X, MIN_Y)
  local green_pos = Vector(MAX_X, MIN_Y)
  local red_pos = Vector(MIN_X, MAX_Y)
  local purple_pos = Vector(MAX_X, MAX_Y)

  Isaac.Spawn(
    EntityType.ENTITY_PICKUP,
    PickupVariant.PICKUP_COLLECTIBLE,
    blue_id,
    blue_pos,
    Vector(0,0),
    nil
  )

  Isaac.Spawn(
    EntityType.ENTITY_PICKUP,
    PickupVariant.PICKUP_COLLECTIBLE,
    green_id,
    green_pos,
    Vector(0,0),
    nil
  )

  Isaac.Spawn(
    EntityType.ENTITY_PICKUP,
    PickupVariant.PICKUP_COLLECTIBLE,
    red_id,
    red_pos,
    Vector(0,0),
    nil
  )

  Isaac.Spawn(
    EntityType.ENTITY_PICKUP,
    PickupVariant.PICKUP_COLLECTIBLE,
    purple_id,
    purple_pos,
    Vector(0,0),
    nil
  )

end

local function onPreGetCollectible(_)
  -- If we aren't in the first floor starting room, short circuit
  if Game():GetLevel():GetStage() == LevelStage.STAGE1_1 and
     Game():GetLevel():GetCurrentRoomIndex() ~= starting_room_idx then
    return nil
  elseif Game():GetLevel():GetStage() ~= LevelStage.STAGE1_1 then
    return nil
  end

  -- Force rerolls in first starting room to always be colors
  item_names = {"Blue", "Green", "Red", "Purple", "Yellow", "White", "Gray"}
  return Isaac.GetItemIdByName(item_names[math.random(#item_names)])
end


bettercoop:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onNewLevel)
bettercoop:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, onPreGetCollectible)
