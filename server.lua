--General
RegisterCommand("hud", function(source)
    TriggerClientEvent("ToggleHUD", source)
end, false)
RegisterCommand('clearchat', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "hud.clearchat") then
        DiscordChatLogs(GetPlayerName(source), rawCommand)
        TriggerClientEvent('chat:clear', -1)
        message(Config.General.AnnouncerTitle, "Chat has been cleared.")
    else
        TriggerClientEvent("HUD-AccessDenied", source)
    end
end, false)

-- Priorities
CountyStatus = 0 -- 0 for available, 1 for inprogress, 2 for on hold, 3 for cooldown
CityStatus = 0 -- 0 for available, 1 for inprogress, 2 for on hold, 3 for cooldown
CountyCooldown = 0
CityCooldown = 0
CountyNotes = ""
CityNotes = ""
AOP = Config.AOP.DefaultAOP

RegisterCommand("available", function(source, args, rawCommand) --/available (LS or BC)
    if IsPlayerAceAllowed(source, "hud.priority") then 
        DiscordPrioLogs(GetPlayerName(source), rawCommand)
        if string.upper(args[1]) == "LS" then 
            CityStatus = 0
            message(Config.Priority.AnnouncerTitle, Config.Priority.CityPrefix..Config.Priority.AvailableAnnouncement)
        elseif string.upper(args[1]) == "BC" then 
            CountyStatus = 0
            message(Config.Priority.AnnouncerTitle, Config.Priority.CountyPrefix..Config.Priority.AvailableAnnouncement)
        else
            TriggerClientEvent("Priority-Error", source)
        end
    else
        TriggerClientEvent("HUD-AccessDenied", source)
    end
end, false)
RegisterCommand("inprogress", function(source, args, rawCommand) --/inprogress (LS or BC)
    if IsPlayerAceAllowed(source, "hud.priority") then 
        DiscordPrioLogs(GetPlayerName(source), rawCommand)
        if string.upper(args[1]) == "LS" then 
            CityStatus = 1
            message(Config.Priority.AnnouncerTitle, Config.Priority.CityPrefix..Config.Priority.InProgressAnnouncement)
        elseif string.upper(args[1]) == "BC" then 
            CountyStatus = 1
            message(Config.Priority.AnnouncerTitle, Config.Priority.CountyPrefix..Config.Priority.InProgressAnnouncement)
        else
            TriggerClientEvent("Priority-Error", source)
        end
    else
        TriggerClientEvent("HUD-AccessDenied", source)
    end
end, false)
RegisterCommand("onhold", function(source, args, rawCommand) --/onhold (LS or BC)
    if IsPlayerAceAllowed(source, "hud.priority") then 
        DiscordPrioLogs(GetPlayerName(source), rawCommand)
        if string.upper(args[1]) == "LS" then 
            CityStatus = 2
            message(Config.Priority.AnnouncerTitle, Config.Priority.CityPrefix..Config.Priority.OnHoldAnnouncement)
        elseif string.upper(args[1]) == "BC" then 
            CountyStatus = 2
            message(Config.Priority.AnnouncerTitle, Config.Priority.CountyPrefix..Config.Priority.OnHoldAnnouncement)
        else
            TriggerClientEvent("Priority-Error", source)
        end
    else
        TriggerClientEvent("HUD-AccessDenied", source)
    end
end, false)
RegisterCommand("cooldown", function(source, args, rawCommand) -- /cooldown (time in mins) (LS or BC)
    if IsPlayerAceAllowed(source, "hud.priority") then 
        DiscordPrioLogs(GetPlayerName(source), rawCommand)
        if args[2] then
            local time = tonumber(args[1])
            if string.upper(args[2]) == "LS" then 
                CityStatus = 3
                CityCooldown = time
                message(Config.Priority.AnnouncerTitle, Config.Priority.CityPrefix..Config.Priority.CooldownAnnouncement)
            elseif string.upper(args[2]) == "BC" then 
                CountyStatus = 3
                CountyCooldown = time
                message(Config.Priority.AnnouncerTitle, Config.Priority.CountyPrefix..Config.Priority.CooldownAnnouncement)
            else
                TriggerClientEvent("Cooldown-Error", source)
            end
        else
            TriggerClientEvent("Cooldown-Error", source)
        end
    else
        TriggerClientEvent("HUD-AccessDenied", source)
    end
end, false)
RegisterCommand("setnotes", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "hud.priority") then 
        DiscordPrioLogs(GetPlayerName(source), rawCommand)
        if string.upper(args[1]) == "LS" then 
            CityNotes = ""
            for i=2,#args,1 do 
                CityNotes = CityNotes..args[i].." "
            end
            CityNotes = string.sub(CityNotes,1,#CityNotes-1)
            message(Config.Priority.AnnouncerTitle, "^7^*Los Santos Priority Notes - ^r^3"..CityNotes)
        elseif string.upper(args[1]) == "BC" then 
            CountyNotes = ""
            for i=2,#args,1 do 
                CountyNotes = CountyNotes..args[i].." "
            end
            CountyNotes = string.sub(CountyNotes,1,#CountyNotes-1)
            message(Config.Priority.AnnouncerTitle, "^7^*Blaine County Priority Notes - ^r^3"..CountyNotes)
        end
    else
        TriggerClientEvent("HUD-AccessDenied", source)
    end
end, false)
RegisterCommand("shownotes", function(source, args)
    if not args[1] then
        TriggerClientEvent("chat:addMessage", source, {
            multiline = true,
            args = {"^1^*Error", "^3Please specify a location. Either BC (Blaine County) or LS (Los Santos)."}
        })
    elseif string.upper(args[1]) == "LS" then 
        TriggerClientEvent("ShowCityNotes", source, CityNotes)
    elseif string.upper(args[1]) == "BC" then 
        TriggerClientEvent("ShowCountyNotes", source, CountyNotes)
    end
end, false)

Citizen.CreateThread(function()
    while true do 
        Wait(1)
        TriggerClientEvent("City-Status", -1, CityStatus)
        TriggerClientEvent("County-Status", -1, CountyStatus)
        if CityStatus == 3 then 
            TriggerClientEvent("City-Cooldown", -1, CityCooldown)
        end
        if CountyStatus == 3 then 
            TriggerClientEvent("County-Cooldown", -1, CountyCooldown)
        end
        if Config.AOP.enable then 
            TriggerClientEvent("HUD-AOP", -1, AOP)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Wait(60000)
        if CityStatus == 3 then 
            CityCooldown = CityCooldown - 1
            if CityCooldown == 0 then 
                CityStatus = 0
                message(Config.Priority.AnnouncerTitle, Config.Priority.CityPrefix..Config.Priority.AvailableAnnouncement)
            end
        end
        if CountyStatus == 3 then 
            CountyCooldown = CountyCooldown - 1
            if CountyCooldown == 0 then 
                CountyStatus = 0
                message(Config.Priority.AnnouncerTitle, Config.Priority.CountyPrefix..Config.Priority.AvailableAnnouncement)
            end
        end
    end
end)

--AOP
AOP = Config.AOP.DefaultAOP
if Config.AOP.enable then 
    RegisterCommand("aop", function(source, args, rawCommand)
        if IsPlayerAceAllowed(source, "hud.aop") then
            DiscordPrioLogs(GetPlayerName(source), rawCommand)
            if #args>1 then
                AOP = ""
                for i=1,#args,1 do 
                    AOP = AOP..args[i].." "
                end
                AOP = string.sub(AOP,1,#AOP-1)
            else 
                AOP = args[1]
            end
            TriggerClientEvent("HUD-AOP", -1, AOP)
            message(Config.General.AnnouncerTitle,"^3The AOP has been changed to " .. AOP ..".")
        else
            TriggerClientEvent("HUD-AccessDenied", source)
        end
    end, false)
end

