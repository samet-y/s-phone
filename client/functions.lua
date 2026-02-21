-- Initialize dependencies
VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
end)

-- State
local inMenu = false
local animPlaying = false

function IsInMenu()
    return inMenu
end

function SetInMenu(state)
    inMenu = state
end

-- Voice channel management
function JoinCallChannel(channel)
    exports['pma-voice']:setCallChannel(channel)
end

function LeaveCallChannel()
    exports['pma-voice']:setCallChannel(0)
end

-- Animation
function PlayPhoneAnim()
    if animPlaying then return end
    RequestAnimDict(Config.AnimDict)
    while not HasAnimDictLoaded(Config.AnimDict) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), Config.AnimDict, Config.AnimName, 8.0, 8.0, -1, 1, 0, true, 0, false, 0, false)
    animPlaying = true
end

function StopPhoneAnim()
    if not animPlaying then return end
    StopAnimTask(PlayerPedId(), Config.AnimDict, Config.AnimName)
    animPlaying = false
end

-- Ringtone via NUI
function PlayRingtone()
    SendNUIMessage({
        action = "playRingtone",
        url    = Config.RingtoneURL,
        volume = Config.RingtoneVolume,
    })
end

function StopRingtone()
    SendNUIMessage({ action = "stopRingtone" })
end

-- Get all phones of same type except the current one (for call targets)
function GetCallTargets(currentPhone)
    local targets = {}
    for _, phone in ipairs(Config.Phones) do
        if phone.type == currentPhone.type and phone.id ~= currentPhone.id then
            targets[#targets + 1] = phone
        end
    end
    return targets
end

-- Build description locale key from phone label
function GetDescKey(phone)
    local firstChar = phone.label:sub(1, 1):lower()
    local rest = phone.label:sub(2)
    return firstChar .. rest .. "_desc"
end
