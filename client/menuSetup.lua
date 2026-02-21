local currentPhone = nil

-- Open the NUI phone interface for a given phone location
function OpenPhoneMenu(phone)
    currentPhone = phone
    SetInMenu(true)
    PlayPhoneAnim()

    -- Build call target data for NUI
    local targets = GetCallTargets(phone)
    local nuiTargets = {}
    for _, target in ipairs(targets) do
        nuiTargets[#nuiTargets + 1] = {
            id    = target.id,
            label = _U(target.label),
            desc  = _U(GetDescKey(target)),
        }
    end

    -- Send data to NUI
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openPhone",
        data = {
            phoneId     = phone.id,
            menuTitle   = _U(phone.menuTitle),
            callTargets = nuiTargets,
            locale = {
                incomingCalls = _U("incomingcalls"),
            },
        },
    })
end

-- Close the NUI and clean up
local function ClosePhoneNUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closePhone" })
    StopRingtone()
    StopPhoneAnim()
    LeaveCallChannel()
    SetInMenu(false)
    currentPhone = nil
end

-- NUI Callback: player selected a call target
RegisterNUICallback('selectTarget', function(data, cb)
    cb('ok')
    if not currentPhone then return end

    local targetPhone = Config.PhoneById[data.targetId]
    if not targetPhone then return end

    PlayRingtone()
    JoinCallChannel(targetPhone.voiceChannel)

    -- Update NUI to show in-call state
    SendNUIMessage({
        action     = "callStatus",
        connected  = true,
        targetName = _U(targetPhone.label),
    })
end)

-- NUI Callback: player wants to answer incoming call
RegisterNUICallback('answerIncoming', function(data, cb)
    cb('ok')
    if not currentPhone then return end

    JoinCallChannel(currentPhone.voiceChannel)

    SendNUIMessage({
        action     = "callStatus",
        connected  = true,
        targetName = _U("incomingcalls"),
    })
end)

-- NUI Callback: player hangs up
RegisterNUICallback('hangUp', function(data, cb)
    cb('ok')
    StopRingtone()
    LeaveCallChannel()

    -- Return to directory view
    SendNUIMessage({
        action    = "callStatus",
        connected = false,
    })
end)

-- NUI Callback: player closes phone (ESC or close button)
RegisterNUICallback('closePhone', function(data, cb)
    cb('ok')
    ClosePhoneNUI()
end)
