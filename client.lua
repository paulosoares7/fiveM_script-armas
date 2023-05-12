local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
-- oC = Tunnel.getInterface("script-armas")

local blips = {
    [1] = {
        blip_cds = {['x'] = 1405.82, ['y'] = 1137.63, ['z'] = 109.75},
        perm = 'mafia.permissao'
    },
    -- [2] = {
    --     blip_cds = {['x'] = XXXX, ['y'] = XXXX, ['z'] = XXXX},
    --     perm = 'fac02.permissao'
    -- },
}

-------------------------------------------------------------------------------------------------
--[ ABRIR E FECHAR MENU ]------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

local isActive = false
local onMenu = false

function handleOpenMenu()
    isActive = not isActive

    if isActive then
        SetNuiFocus(true, true)
        TransitionToBlurred(1000)
        SendNUIMessage({showMenu = true})
    else
        SetNuiFocus(false)
        TransitionFromBlurred(1000)
        SendNUIMessage({hideMenu = true})
    end
end

RegisterNetEvent('close-menu')

AddEventHandler('close-menu', function()
    handleOpenMenu()
    onMenu = false
end)
-------------------------------------------------------------------------------------------------
--[ AÇÃO DO USUÁRO ]-----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

RegisterNUICallback('ButtonClick', function( data )
    
    if data == 'produzir-ak47' then
        TriggerServerEvent('produce', 'ak47')

    elseif data == 'produzir-tec9' then
        TriggerServerEvent('produce', 'tec9')

    elseif data == 'produzir-m4spec' then
        TriggerServerEvent('produce', 'm4spec')

    elseif data == 'produzir-fiveseven' then
        TriggerServerEvent('produce', 'fiveseven')

    elseif data == 'produzir-pistolhk' then
        TriggerServerEvent('produce', 'pistolhk')

    elseif data == 'fechar-menu' then
        handleOpenMenu()
        onMenu = false
    end
end)
-------------------------------------------------------------------------------------------------
--[ THREAD ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local time = 700
        local ped = PlayerPedId()
        local cds = GetEntityCoords(ped)
        local x, y, z = table.unpack(cds)

        for k, v in pairs(blips) do

            local position = v.blip_cds
            local distance = #( vector3(x,y,z) - vector3(position.x,position.y, position.z))

            if distance < 6 then
                time = 5
                DrawMarker(23, position.x, position.y, position.z-0.97,0,0,0,0,0,0,0.7,0.7,0.5,214,29,0,100,0,0,0,0)
                if distance < 1.2 and onMenu == false then
                    DrawText3D(position.x, position.y, position.z, "Pressione [~r~E~w~] para acessar a ~r~BANCADA DE ARMAS~w~.")
                    if IsControlJustPressed(0, 38) then
                        handleOpenMenu()
                        onMenu = true
                    end
                end
            end
        end
        Wait(time)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end