function GetCardinalDirection() --Taken from Badger
	local camRot = Citizen.InvokeNative( 0x837765A25378F0BB, 0, Citizen.ResultAsVector() )
    local playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
    local tickDegree = playerHeadingDegrees - 180 / 2
    local tickDegreeRemainder = 9.0 - (tickDegree % 9.0)
   
    tickDegree = tickDegree + tickDegreeRemainder
    return tickDegree;
end

function degreesToIntercardinalDirection( dgr ) --Taken from Badger
	dgr = dgr % 360.0
	
	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
		return " E "
	elseif dgr >= 22.5 and dgr < 67.5 then
		return "SE"
	elseif dgr >= 67.5 and dgr < 112.5 then
		return " S "
	elseif dgr >= 112.5 and dgr < 157.5 then
		return "SW"
	elseif dgr >= 157.5 and dgr < 202.5 then
		return " W "
	elseif dgr >= 202.5 and dgr < 247.5 then
		return "NW"
	elseif dgr >= 247.5 and dgr < 292.5 then
		return " N "
	elseif dgr >= 292.5 and dgr < 337.5 then
		return "NE"
	end
end

--General HUD
RegisterNetEvent("ToggleHUD")
AddEventHandler("ToggleHUD", function()
    if Config.General.DisplayHUD then
        Config.General.DisplayHUD = false 
        DisplayRadar(false)
        DisplayHud(false)
        cmessage(Config.General.AnnouncerTitle, "^2HUD toggled off. Use /hud to turn back on.")
    else
        Config.General.DisplayHUD = true
        DisplayRadar(true)
        DisplayHud(true)
        cmessage(Config.General.AnnouncerTitle, "^2HUD toggled on. Use /hud to turn back off.")
    end
end)
TriggerEvent('chat:addSuggestion', '/hud', 'Toggle hud on or off')
local pos = GetEntityCoords(GetPlayerPed(-1))
streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x,pos.y,pos.z))
heading = degreesToIntercardinalDirection(GetCardinalDirection())
postal = exports.NearestPostal:getPostal()
DisablePlayerVehicleRewards(-1) --Disable players getting LEO guns after being arrestede
Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x,pos.y,pos.z))
        heading = degreesToIntercardinalDirection(GetCardinalDirection())
        postal = exports.NearestPostal:getPostal()
    end
end)
Citizen.CreateThread(function()
    Citizen.Wait(1500)
    while true do 
        Wait(5)
        if Config.General.DisplayHUD then
            ScreenText(Config.AOP.x, Config.AOP.y, Config.AOP.size, Config.AOP.prefix..clientAOP)
            ScreenText(Config.General.Discord.x,Config.General.Discord.y,Config.General.Discord.size, Config.General.Discord.text)
            ScreenText(Config.Postals.x, Config.Postals.y, Config.Postals.size, Config.Postals.prefix..postal)
            ScreenText(Config.Compass.x, Config.Compass.y, Config.Compass.size, Config.Compass.prefix:gsub("{heading}", heading))
            ScreenText(Config.Compass.x+.04, Config.Compass.y+.0060, Config.Compass.size-.25, Config.Compass.Location.prefix..streetName)
        end
    end
end)
RegisterCommand('discord', function()
    cmessage(Config.General.AnnouncerTitle, Config.General.Discord.commandtext)
end)
--Priorities
TriggerEvent('chat:addSuggestion', '/cooldown', 'Set priority to cooldown.', {
    {name = 'time', help = 'Time in minutes for the priority cooldown to last'},
    {name = 'BC or LS', help = 'Set the cooldown for either Blaine County or Los Santos. Input either BC or LS here.'}
})
TriggerEvent('chat:addSuggestion', '/available', 'Set priority to available.',{
    {name = 'BC or LS', help = 'Set the cooldown for either Blaine County or Los Santos. Input either BC or LS here.'}
})
TriggerEvent('chat:addSuggestion', '/inprogress', 'Set priority to in progress.',{
    {name = 'BC or LS', help = 'Set the cooldown for either Blaine County or Los Santos. Input either BC or LS here.'}
})
TriggerEvent('chat:addSuggestion', '/onhold', 'Set priorities to on hold.',{
    {name = 'BC or LS', help = 'Set the cooldown for either Blaine County or Los Santos. Input either BC or LS here.'}
})
TriggerEvent('chat:addSuggestion', '/setnotes',  'Set priority notes.', {
    {name = 'BC or LS', help = 'Set the priority notes for either Blaine County or Los Santos. Input either BC or LS here.'},
    {name = 'Notes', help = 'Enter any notes regarding who has the active priority and/or what the priority is.'}
})
TriggerEvent('chat:addSuggestion', '/shownotes', 'Show priority notes.', {
    {name = 'BC or LS', help = 'Show the priority notes for either Blaine County or Los Santos. Input either BC or LS here.'}
})
RegisterNetEvent("City-Status")
AddEventHandler("City-Status", function(status)
    CityStatus = status
end)
RegisterNetEvent("City-Cooldown")
AddEventHandler("City-Cooldown", function(time)
    CityCooldown = time
end)
RegisterNetEvent("County-Status")
AddEventHandler("County-Status", function(status)
    CountyStatus = status
end)
RegisterNetEvent("County-Cooldown")
AddEventHandler("County-Cooldown", function(time)
    CountyCooldown = time
end)
RegisterNetEvent("Cooldown-Error")
AddEventHandler("Cooldown-Error", function()
    cmessage(Config.Priority.AnnouncerTitle, "^3Error setting cooldown. Proper usage is /cooldown (time) (LS or BC). If issue persists report to staff.")
end)
RegisterNetEvent("Priority-Error")
AddEventHandler("Priority-Error", function()
    cmessage(Config.Priority.AnnouncerTitle, "^3Unable to detect location. Proper usage is /(priority setting) (LS or BC). If issue persists report to staff.")
end)
RegisterNetEvent("ShowCityNotes")
AddEventHandler("ShowCityNotes", function(notes)
    cmessage(Config.Priority.AnnouncerTitle, "^7^*Los Santos Priority Notes - ^r^3"..notes)
end)
RegisterNetEvent("ShowCountyNotes")
AddEventHandler("ShowCountyNotes", function(notes)
    cmessage(Config.Priority.AnnouncerTitle, "^7^*Blaine County Priority Notes - ^r^3"..notes)
end)
RegisterNetEvent("HUD-AccessDenied")
AddEventHandler("HUD-AccessDenied", function()
    cmessage(Config.General.AnnouncerTitle, "^1Access denied - insufficient permissions. If you believe this to be an issue contact staff.")
end)
Citizen.CreateThread(function() --City Priorities
    while true do 
        Wait(5)
        if Config.General.DisplayHUD then
            if CityStatus == 0 then 
                ScreenText(Config.Priority.x, Config.Priority.y, Config.Priority.size, "~w~City Priority: "..Config.Priority.AvailableDisplay)
            elseif CityStatus == 1 then 
                ScreenText(Config.Priority.x, Config.Priority.y, Config.Priority.size, "~w~City Priority: "..Config.Priority.InProgressDisplay)
            elseif CityStatus == 2 then 
                ScreenText(Config.Priority.x, Config.Priority.y, Config.Priority.size, "~w~City Priority: "..Config.Priority.OnHoldDisplay)
            elseif CityStatus == 3 then 
                ScreenText(Config.Priority.x, Config.Priority.y, Config.Priority.size, "~w~City Priority: "..CityCooldown..Config.Priority.CooldownDisplay)
            end
        end
    end
end)
Citizen.CreateThread(function() --County Priorities
    while true do 
        Wait(5)
        if Config.General.DisplayHUD then
            if CountyStatus == 0 then 
                ScreenText(Config.Priority.x, Config.Priority.y+.03, Config.Priority.size, "~w~County Priority: "..Config.Priority.AvailableDisplay)
            elseif CountyStatus == 1 then 
                ScreenText(Config.Priority.x, Config.Priority.y+.03, Config.Priority.size, "~w~County Priority: "..Config.Priority.InProgressDisplay)
            elseif CountyStatus == 2 then 
                ScreenText(Config.Priority.x, Config.Priority.y+.03, Config.Priority.size, "~w~County Priority: "..Config.Priority.OnHoldDisplay)
            elseif CountyStatus == 3 then 
                ScreenText(Config.Priority.x, Config.Priority.y+.03, Config.Priority.size, "~w~County Priority: "..CountyCooldown..Config.Priority.CooldownDisplay)
            end
        end
    end
end)
--AOP
clientAOP = ""
RegisterNetEvent("HUD-AOP")
AddEventHandler("HUD-AOP", function(aop)
    clientAOP = aop
end)
TriggerEvent('chat:addSuggestion', '/aop', 'Set the Area of Play.', {
    {name = 'location', help = 'Area to restrict AOP to.'},
})

AddEventHandler("playerSpawned", function()
    local targetEntity = GetPlayerPed(-1)
    for i=1, #Config.AOP.SpawnLocations, 1 do 
        if clientAOP == Config.AOP.SpawnLocations[i].name then 
            SetEntityCoords(targetEntity, Config.AOP.SpawnLocations[i].coords.x,Config.AOP.SpawnLocations[i].coords.y,Config.AOP.SpawnLocations[i].coords.z)
            SetEntityHeading(targetEntity,Config.AOP.SpawnLocations[i].heading)
            return
        end
    end
    SetEntityCoords(targetEntity, 206.27, -941.73, 30.69)
    SetEntityHeading(targetEntity, 226.16)
end)

