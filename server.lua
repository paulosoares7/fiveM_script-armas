local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

oC = {}
Tunnel.bindInterface("script-armas",oC)

--------------------------------------------------------------------------------
--------------------------------[ARMAS PARA CRAFT]------------------------------
--------------------------------------------------------------------------------

local weaponsList = {
    [1] = {
        weapon = 'ak47', -- nome da  -- descrição
        description = {
            amount = 1, -- quantidade a ser fabricada
            timeToCraft = 2000, -- tempo de fabricação em mseg
            type = "wbody|WEAPON_ASSAULTRIFLE", -- tipo de arma
            items = {
                ['plates'] = 'placa-metal', -- item 2, placa de metal
                ['springs'] = 'molas', -- item 3, molas
                ['parts'] = 'pecadearma', --item 1, peça de armas
                ['kitten'] = 'gatilho' -- item 4, gatilho
            },
            itemAmount = {
                ['plates'] = 5,-- quantidade necessárias de placas de metal
                ['springs'] = 2, -- quantidade necessárias de molas
                ['parts'] = 2, -- quantidade necessárias de peça de armas
                ['kitten'] = 1, -- quantidade necessárias de gatilho
        },
    }
    },
    [2] = {
        weapon = "tec9",
        description = {
            amount = 1,
            timeToCraft = 2000,
            type = "wbody|WEAPON_MACHINEPISTOL",
            items = {
                ['plates'] = "placa-metal",
                ['springs'] = "molas",
                ['parts'] = "pecadearma",
                ['kitten'] = "gatilho",
            },
            itemAmount = {
                ['plates'] = 4,
                ['springs'] = 1,
                ['parts'] = 3,
                ['kitten'] = 1,
            },
        },
    },
    [3] = {
        weapon = "m4spec",
        description = {
            amount = 1,
            timeToCraft = 2000,
            type = "wbody|WEAPON_SPECIALCARBINE",
            items = {
                ['plates'] = "placa-metal",
                ['springs'] = "molas",
                ['parts'] = "pecadearma",
                ['kitten'] = "gatilho",
            },
            itemAmount = {
                ['plates'] = 6,
                ['springs'] = 2,
                ['parts'] = 3,
                ['kitten'] = 1,
            },
        },
    },
    [4] = {
        weapon = "fiveseven",
        description = {
            amount = 1,
            timeToCraft = 2000,
            type =  "wbody|WEAPON_PISTOL_MK2",
            items = {
                ['plates'] = "placa-metal",
                ['springs'] = "molas",
                ['parts'] = "pecadearma",
                ['kitten'] = "gatilho",
            },
            itemAmount = {
                ['plates'] = 2,
                ['springs'] = 1,
                ['parts'] = 2,
                ['kitten'] = 1,
            },
        }
    },
    [5] = {
        weapon = "pistolhk",
        description = {
            amount = 1,
            timeToCraft = 2000,
            type =  "wbody|WEAPON_SNSPISTOL",
            items = {
                ['parts'] = "pecadearma",
                ['plates'] = "placa-metal",
                ['springs'] = "molas",
                ['kitten'] = "gatilho",
            },
            itemAmount = {
                ['parts'] = 2,
                ['plates'] = 1,
                ['springs'] = 2,
                ['kitten'] = 1,
            },
        },
    }
}
RegisterServerEvent('produce')

AddEventHandler('produce', function( data )
    
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        for k,v in pairs(weaponsList) do
            
            local description = v.description
            local timeout = description.timeToCraft
            
            local weapon_type = description.type
            local bagWeight = vRP.getInventoryWeight(user_id) + vRP.getItemWeight(weapon_type)
            local bagMaxWeight = vRP.getInventoryMaxWeight(user_id)

            local parts = description.itemAmount.parts
            local parts_inventory = vRP.getInventoryItemAmount(user_id, description.items.parts)

            local plates = description.itemAmount.plates
            local plates_inventory = vRP.getInventoryItemAmount(user_id, description.items.plates)

            local springs = description.itemAmount.springs
            local springs_inventory = vRP.getInventoryItemAmount(user_id, description.items.springs)

            local kitten = description.itemAmount.kitten
            local kitten_inventory = vRP.getInventoryItemAmount(user_id, description.items.kitten)

            if data == v.weapon then
                if bagWeight <= bagMaxWeight then
                    if parts_inventory >= parts then
                        if plates_inventory >= plates then
                            if springs_inventory >= springs then
                                if kitten_inventory >= kitten then
                                    vRP.tryGetInventoryItem(user_id, description.items.parts , description.amount)
                                    vRP.tryGetInventoryItem(user_id, description.items.plates , description.amount)
                                    vRP.tryGetInventoryItem(user_id, description.items.springs , description.amount)
                                    vRP.tryGetInventoryItem(user_id, description.items.kitten , description.amount)

                                    TriggerClientEvent('close-menu', source)
                                    vRPclient._playAnim(source, false, {{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}}, true)
                                    
                                    SetTimeout(timeout, function()
                                        -- pegar item do inventário
                                        vRP.giveInventoryItem(user_id, weapon_type,description.amount)
                                        vRPclient._stopAnim(source, false)
                                        TriggerClientEvent('Notify', source, 'sucesso', 'Fabricação de <strong> '..(v.weapon)..' </strong>Finalizada')
                                    end)
                                else
                                    TriggerClientEvent('close-menu', source)
                                    TriggerClientEvent('Notify', source, 'negado', 'Você precisa de ' ..(kitten- kitten_inventory).. 'x gatilhos')
                                end
                            else
                                TriggerClientEvent('close-menu', source)
                                TriggerClientEvent('Notify', source, 'negado', 'Você precisa de ' ..(springs- springs_inventory).. 'x molas')
                            end
                        else
                            TriggerClientEvent('close-menu', source)
                            TriggerClientEvent('Notify', source, 'negado', 'Você precisa de ' ..(plates- plates_inventory).. 'x placas de metal')
                        end
                    else
                        TriggerClientEvent('close-menu', source)
                        TriggerClientEvent('Notify', source, 'negado', 'Você precisa de ' ..(parts- parts_inventory).. 'x peça de arma')
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Espaço insuficiente na mochila')
                end
            end
        end
    end
end)