ESX = exports["es_extended"]:getSharedObject()

local function sendDiscordEmbed(webhookUrl, embedData)
    local embeds = {
        {
            ["title"] = embedData.title,
            ["description"] = embedData.description,
            ["color"] = embedData.color,
            ["fields"] = embedData.fields
        }
    }

    local data = {
        ["embeds"] = embeds
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end


RegisterCommand("boost", function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerName = GetPlayerName(_source)
    
    if playerName == nil then
        return
    end

    local playerIdentifiers = GetPlayerIdentifiers(_source)
    local discordId = nil

    for _, identifier in ipairs(playerIdentifiers) do
        if string.match(identifier, "^discord:") then
            discordId = string.sub(identifier, 9)
            break
        end
    end

    if discordId ~= nil then
                                                              --INSERT ID SERVER--
 PerformHttpRequest(string.format("https://discord.com/api/v9/guilds/%s/members/%s", Config.IdServer, discordId), function(statusCode, responseBody, headers)
 if statusCode == 200 then
                local discordData = json.decode(responseBody)
                if discordData.roles then
                    local isBooster = false
                    for _, role in ipairs(discordData.roles) do
                        if role == Config.IdRule then
                            isBooster = true
                            break
                        end
                    end

                    if isBooster then
                        print("Il giocatore " .. playerName .. " è un booster e ha eseguito il comando boost.")
                        MySQL.Async.fetchAll('SELECT boost FROM users WHERE identifier = @identifier', {
                            ['@identifier'] = xPlayer.identifier
                        }, function(result)
                            if result[1].boost == 0 then
                                MySQL.Async.execute('UPDATE users SET boost = 1 WHERE identifier = @identifier', {
                                    ['@identifier'] = xPlayer.identifier
                                }, function(rowsChanged)
                                    if rowsChanged > 0 then
                                        for _, reward in ipairs(Config.Rewards) do
                                            if reward.item == "cash" then
                                                xPlayer.addMoney(reward.amount)
                                            else
                                                exports.ox_inventory:AddItem(xPlayer.source, reward.item, reward.amount)
                                            end
                                        end                                                                               
                                        TriggerClientEvent('notificaBoosterRiscattatoOra', xPlayer.source)
                                        local embedData = {
                                            title = "Boost Riscattato",
                                            description = playerName .. " ha riscattato il boost!",
                                            color = 65280, -- Colore verde
                                            fields = {
                                                {name = "Giocatore", value = playerName, inline = true},
                                                {name = "ID Giocatore", value = _source, inline = true}
                                            }
                                        }
                                        sendDiscordEmbed(Config.Webhook, embedData)
                                    else
                                        print("Errore nell'aggiornamento del database per il giocatore " .. playerName)
                                    end
                                end)
                            else
                                TriggerClientEvent('notificaBoosterRiscattato', xPlayer.source)
                            end
                        end)
                    else
                        print("Il giocatore " .. playerName .. " non è un booster.")
                        TriggerClientEvent('notificaBooster', xPlayer.source)
                    
                        -- Invio dell'embed Discord
                        local embedData = {
                            title = "Boost non riscattato",
                            description = playerName .. " ha eseguito il comando booster ma non è un booster",
                            color = 16711680, -- Colore rosso
                            fields = {
                                {name = "Giocatore", value = playerName, inline = true},
                                {name = "ID Giocatore", value = _source, inline = true}
                            }
                        }
                        sendDiscordEmbed(Config.Webhook, embedData)
                    end
                else
                    print("Il giocatore " .. playerName .. " non ha ruoli Discord.")
                end
            else
                print("Errore nella richiesta HTTP: " .. tostring(statusCode))
            end                                     --TOKEN BOT DISCORD
        end, "GET", "", {["Authorization"] = "Bot " ..Config.Token})
    else
        print("Il giocatore " .. playerName .. " non è collegato a Discord.")
    end
end, false)