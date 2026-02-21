-- Wait for character selection then start phone system
RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function(charid)
    SpawnPhoneProps()
    InitPhonePrompts()
end)

-- Single thread handles ALL phone locations
function InitPhonePrompts()
    local PromptGroup = VORPutils.Prompts:SetupPromptGroup()
    local prompt = PromptGroup:RegisterPrompt(
        _U("openDirectory"),
        Config.InteractKey, 1, 1, true,
        Config.PromptHoldType,
        { timedeventhash = Config.PromptTimedHash }
    )

    Citizen.CreateThread(function()
        while true do
            local sleep = true
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, phone in ipairs(Config.Phones) do
                local dist = #(playerCoords - phone.coords)
                if dist < Config.InteractDistance then
                    sleep = false
                    PromptGroup:ShowGroup(_U(phone.promptLabel))

                    if prompt:HasCompleted() then
                        if phone.type == "sheriff" then
                            TriggerServerEvent('s-phone:checkJob', phone.id)
                        else
                            OpenPhoneMenu(phone)
                        end
                    end
                    break
                end
            end

            Wait(sleep and 1500 or 5)
        end
    end)
end

-- Server confirms job check passed, open sheriff menu
RegisterNetEvent("s-phone:jobApproved")
AddEventHandler("s-phone:jobApproved", function(phoneId)
    local phone = Config.PhoneById[phoneId]
    if phone then
        OpenPhoneMenu(phone)
    end
end)
