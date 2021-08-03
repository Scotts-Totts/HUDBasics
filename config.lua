Config = {}

Config.General = {
    DisplayHUD = true,
    AnnouncerTitle = "^3^*[^6Announcer^3] ",

    Discord = {
        enable = true,
        x = .91,
        y = .02,
        size = .55,
        text = "~c~discord.gg/~g~ INSERT DISCORD NAME HERE ",
        commandtext = "^3Join our discord using the link: discord.gg/ INSERT DISCORD NAME HERE", --text returned when player does /discord
        CHATLOGS = "https://discord.com/api/webhooks/813265915394785290/iDQkzXa5JYapqTt8jn9xDqtWIc2xdmJdHWzqvkHbOHXzk8hK4zJn4-urIwKW33rx1KjM", --discord webhook for command logging
        PRIOLOGS = "https://discord.com/api/webhooks/782793382732890130/ispfqQQAEYYEfouBPpGR9cvHuArDGLGeQI8XpR7bKXj8sxZUhS4tEWsw4uzZlsuSSPb1", --discord webhook for priority command logging
    },
}

Config.Priority = {
    x = .17,
    y = .85,
    size = .5,
    AvailableDisplay = "~g~Available",
    InProgressDisplay = "~r~In Progress",
    OnHoldDisplay = "~b~On Hold",
    CooldownDisplay = "~o~ min Cooldown",
    CountyPrefix = "^0^*Blaine County - ^r",
    CityPrefix = "^0^*Los Santos - ^r",
    AnnouncerTitle = "^3^*[^6Priorities^3] ",
    AvailableAnnouncement = "^3Priorities are now available!",
    InProgressAnnouncement = "^3A priority is currently in progress. Unless you are the priority, avoid violent rps, running from police, and large police scenes. For more information on priorities read the rules in our discord!",
    OnHoldAnnouncement = "^3Priorities are currently on hold. During this time avoid violent rps, running from police, and large police scenes. For more information on priorities read the rules in our discord!",
    CooldownAnnouncement = "^3A priority has just been concluded. There will be a cooldown on priorities. During this time avoid violent rps, running from police, and large police scenes. For more information on priorities read the rules in our discord!",
}

Config.AOP = {
    enable = true, -- Boolean value to quickly enable or disable AOP display and command
    x = .17,
    y = .81,
    size = .69,
    prefix = "~b~AOP: ~s~~w~",
    DefaultAOP = "Statewide",
    SpawnLocations = { 
        {name = "Sandy Shores", coords = {x = 311.22, y = 3457.60, z = 36.15}, heading = 220.0},
        {name = "Paleto Bay", coords = {x = -760.03, y = 5532.11, z = 33.48}, heading = 50.0},
        {name = "Blaine County", coords = {x = 311.22, y = 3457.60, z = 36.15}, heading = 220.0},
        {name = "Los Santos", coords = {x = 206.27, y = -941.73, z = 30.69}, heading = 226.16},
        {name = "Mirror Park", coords = {x = 1018.83, y = -683.11, z = 56.7}, heading = 131.86},
        {name = "Statewide", coords = {x = 680.78, y = 660.29, z = 129.91}, heading = 165.51},
    },
}

Config.Postals = {
    enable = true,
    x = .17,
    y = .91,
    size = .5,
    prefix = "Nearest Postal: ~g~",
}

Config.Compass = {
    enable = true,
    x = .17,
    y = .94,
    size = .75,
    prefix = "~b~|~s~ {heading} ~b~|",
    Location = {
        prefix = "~b~",
    },
}
