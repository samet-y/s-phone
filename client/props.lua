local spawnedProps = {}

-- Request and wait for a model to load, with timeout
local function LoadModel(model)
    local hash = GetHashKey(model)
    if HasModelLoaded(hash) then return hash end

    RequestModel(hash)
    local timeout = 50 -- 5 seconds max
    while not HasModelLoaded(hash) and timeout > 0 do
        Wait(100)
        timeout = timeout - 1
    end

    if not HasModelLoaded(hash) then
        print("[s-phone] ^1ERROR: Failed to load prop model: " .. model .. "^0")
        return nil
    end

    return hash
end

-- Spawn all phone props from config
function SpawnPhoneProps()
    -- Clean up any existing props first
    DeletePhoneProps()

    local hash = LoadModel(Config.PropModel)
    if not hash then return end

    for _, phone in ipairs(Config.Phones) do
        local pos = phone.propPos or phone.coords
        local heading = phone.propHeading or 0.0

        local prop = CreateObject(hash, pos.x, pos.y, pos.z, false, true, false)
        if prop and DoesEntityExist(prop) then
            SetEntityHeading(prop, heading)
            FreezeEntityPosition(prop, true)
            SetEntityCollision(prop, false, false)
            SetEntityInvincible(prop, true)

            spawnedProps[phone.id] = prop
        else
            print("[s-phone] ^1ERROR: Failed to spawn prop for: " .. phone.id .. "^0")
        end
    end

    -- Release the model from memory
    SetModelAsNoLongerNeeded(hash)
end

-- Delete all spawned phone props
function DeletePhoneProps()
    for id, prop in pairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    spawnedProps = {}
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeletePhoneProps()
    end
end)
