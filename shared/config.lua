Config = {}

Config.defaultlang = 'en_lang'

-- Jobs allowed to use Sheriff station phones
Config.AllowedJobs = { "police" }

-- Interaction settings
Config.InteractDistance = 2.0        -- How close player must be to use phone
Config.InteractKey     = 0x760A9C6F -- G key
Config.CloseMenuKey    = 0x156F7119 -- Backspace key
Config.PromptHoldType  = 'hold'
Config.PromptTimedHash = "MEDIUM_TIMED_EVENT"

-- Ringtone settings (played via NUI audio)
Config.RingtoneURL    = "https://www.youtube.com/watch?v=N2jZmXePKV0"
Config.RingtoneVolume = 0.3

-- Animation settings
Config.AnimDict = "script_proc@robberies@coach@rhodes"
Config.AnimName = "waiting_01_alden"

-- Prop settings
Config.PropModel = "s_phonewall01x"

-- Phone locations
-- type: "public" = anyone can use, "sheriff" = job-restricted
-- propPos: exact position for the 3D prop (can differ slightly from interaction coords)
-- propHeading: rotation of the prop in degrees
Config.Phones = {
    {
        id           = "valentine",
        type         = "public",
        coords       = vector3(-187.7973, 626.8018, 114.0321),
        propPos      = vector3(-187.2786, 626.6577, 115.2119),
        propHeading  = 328.7,
        voiceChannel = 1.5,
        label        = "Valentine",
        menuTitle    = "menuTitle",
        promptLabel  = "info",
    },
    {
        id           = "blackwater",
        type         = "public",
        coords       = vector3(-869.7830, -1328.0912, 43.9500),
        propPos      = vector3(-870.4664, -1327.9792, 43.7846),
        propHeading  = 178.5,
        voiceChannel = 1.7,
        label        = "Blackwater",
        menuTitle    = "menuTitle",
        promptLabel  = "info",
    },
    {
        id           = "stdenis",
        type         = "public",
        coords       = vector3(2739.1714, -1395.1139, 46.1831),
        propPos      = vector3(2739.6072, -1394.9164, 46.4919),
        propHeading  = 335.7,
        voiceChannel = 1.9,
        label        = "StDenis",
        menuTitle    = "menuTitle",
        promptLabel  = "info",
    },
    {
        id           = "valentine_sheriff",
        type         = "sheriff",
        coords       = vector3(-273.2441, 803.2582, 119.3494),
        propPos      = vector3(-273.7502, 803.3834, 119.3659),
        propHeading  = 167.3,
        voiceChannel = 2.0,
        label        = "ValentineSheriff",
        menuTitle    = "menuTitlegov",
        promptLabel  = "infogoverment",
    },
    {
        id           = "blackwater_sheriff",
        type         = "sheriff",
        coords       = vector3(-756.2975, -1266.0258, 44.0477),
        propPos      = vector3(-756.8428, -1265.9797, 44.0624),
        propHeading  = 179.3,
        voiceChannel = 2.1,
        label        = "BlackwaterSheriff",
        menuTitle    = "menuTitlegov",
        promptLabel  = "infogoverment",
    },
    {
        id           = "stdenis_sheriff",
        type         = "sheriff",
        coords       = vector3(2492.6750, -1308.6676, 48.8658),
        propPos      = vector3(2493.0876, -1308.8438, 48.1851),
        propHeading  = 0.4,
        voiceChannel = 2.2,
        label        = "StDenisSheriff",
        menuTitle    = "menuTitlegov",
        promptLabel  = "infogoverment",
    },
}

-- Build lookup tables for quick access
Config.PhoneById = {}
for _, phone in ipairs(Config.Phones) do
    Config.PhoneById[phone.id] = phone
end
