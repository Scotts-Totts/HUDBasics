function message(auth, msg)
    author = auth
    mess = msg
    TriggerClientEvent("chat:addMessage", -1, {
        multiline = true,
        args = {author, "^r"..mess}
    })
end
function cmessage(auth, msg)
    author = auth
    mess = msg
    TriggerEvent("chat:addMessage", {
        multiline = true,
        args = {author, "^r"..mess}
    })
end
function ScreenText(x, y, size, text)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(size, size)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function DiscordChatLogs(auth, text) 
    PerformHttpRequest(Config.General.Discord.CHATLOGS, function(err, text, headers) end, 'POST', json.encode({username = auth, content = "/"..text}), { ['Content-Type'] = 'application/json' })
end
function DiscordPrioLogs(auth, text) 
    PerformHttpRequest(Config.General.Discord.PRIOLOGS, function(err, text, headers) end, 'POST', json.encode({username = auth, content = "/"..text}), { ['Content-Type'] = 'application/json' })
end