RegisterNetEvent('notificaBoosterRiscattato')
AddEventHandler('notificaBoosterRiscattato', function()

    lib.notify({
        id = 'notifica_boost1',
        title = 'Base Academy',
        description = 'Hai già riscattato la ricompensa!',
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'ban',
        iconColor = '#C53030'

    })
end)

RegisterNetEvent('notificaBoosterRiscattatoOra')
AddEventHandler('notificaBoosterRiscattatoOra', function()

    lib.notify({
        id = 'notifica_boost2',
        title = 'Base Academy',
        description = 'Hai riscattato la ricompensa!',
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'ban',
        iconColor = '#C53030'

    })
end)