
local webhookBan = ''
local webhookUnban = ''

-- Functions
function getdc(targetIds)
    for k, v in pairs(targetIds) do
        if string.find(v, "discord:") then
            return string.gsub(v, "discord:", "")
        end
    end
end
function cwel(expiration)
    if expiration == false then
        return 'NIGDY'
    else
        return os.date('*t', expiration)
    end
end
function getdc2(playerIds)
    for k, v in pairs(playerIds) do
        if string.find(v, "discord:") then
            return string.gsub(v, "discord:", "")
        end
    end
end

-- EVENTS
AddEventHandler('txAdmin:events:playerBanned', function(data)
    local author = data.author
    local reason = data.reason
    local actionId = data.actionId
    local targetName = data.targetName
    local expiration = data.expiration
    local targetIds = data.targetIds
    local dc = getdc(targetIds)
    local date = cwel(expiration)

    local gejlon
    if type(date) == "string" then
        gejlon = date
    else
        gejlon = string.format("%02d-%02d-%d %02d:%02d:%02d", 
                                      date.day, date.month, date.year, 
                                      date.hour, date.min, date.sec)
    end

    local message = '<@'..dc..'>```Nick: '..targetName..'\nPowód: '..reason..'\nAdministrator: '..author..'\nKoniec bana: '..gejlon..'\nBAN ID: '..actionId..'```'
    
    PerformHttpRequest(webhookBan, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('txAdmin:events:actionRevoked', function(data)
    local actionId = data.actionId
    local actionType = data.actionType
    local playerName = data.playerName
    local playerIds = data.playerIds
    local dc = getdc2(playerIds)
    local revokedBy = data.revokedBy
    if actionType == 'ban' then
        local message = '<@'..dc..'>```Użytkownik został odbanowany.\nNick: '..playerName..'\nAdministrator: '..revokedBy..'\nBAN ID: '..actionId..'```'
        
        PerformHttpRequest(webhookUnban,function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end)
