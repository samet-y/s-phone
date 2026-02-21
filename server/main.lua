local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Check if a job is in the allowed list
local function IsJobAllowed(job)
    for _, allowedJob in ipairs(Config.AllowedJobs) do
        if job == allowedJob then
            return true
        end
    end
    return false
end

-- Single event handles job check for ALL sheriff phones
RegisterServerEvent("s-phone:checkJob")
AddEventHandler("s-phone:checkJob", function(phoneId)
    local _source = source
    local user = VORPcore.getUser(_source)
    if not user then return end

    local character = user.getUsedCharacter
    if not character then return end

    if IsJobAllowed(character.job) then
        TriggerClientEvent('s-phone:jobApproved', _source, phoneId)
    else
        TriggerClientEvent("vorp:TipRight", _source, _U("nothave"), 4000)
    end
end)
