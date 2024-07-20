print('Stag Productions V1.0.0 Loaded')

local QBCore = exports['qb-core']:GetCoreObject()
local taxi

local taxiSpawnLocation = Config.taxiSpawn
local taxiDutyLocation = Config.dutyToggle
local taxiReturnLocation = Config.taxiReturnLocation

CreateThread(function()
    local taxiBlip = AddBlipForCoord(taxiDutyLocation.x, taxiDutyLocation.y, taxiDutyLocation.z)
    SetBlipSprite(taxiBlip, 513)
    SetBlipDisplay(taxiBlip, 4)
    SetBlipScale(taxiBlip, 0.7)
    SetBlipAsShortRange(taxiBlip, true)
    SetBlipColour(taxiBlip, 29)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Taxi Depot')
    EndTextCommandSetBlipName(taxiBlip)
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("TaxiDutyZone", taxiDutyLocation, 2.0, 2.0, {
        name = "TaxiDutyZone",
        heading = 0,
        debugPoly = false,
        minZ = 27.6,
        maxZ = 30.6,
    }, {
        options = {
            {
                type = "client",
                event = "stag_taxijob:ToggleDuty",
                icon = "fas fa-clipboard",
                label = "Toggle Taxi Duty",
            },
        },
        distance = 2.5,
    })
end)

RegisterNetEvent('stag_taxijob:ToggleDuty', function()
    local job = QBCore.Functions.GetPlayerData().job.name
    if job == 'taxijob' then
    TriggerServerEvent('QBCore:ToggleDuty')
    else
        QBCore.Functions.Notify('Not a taxi driver', 'error', 5000)
    end

end)

local toggle = false
local function toggleOnOff()
    local onDuty = QBCore.Functions.GetPlayerData().job.onduty
    local job = QBCore.Functions.GetPlayerData().job.name
    toggle = not toggle
    CreateThread(function()
        while toggle do
            Wait(0)
            if job == 'taxijob' and onDuty then
                DrawMarker(39, taxiSpawnLocation.x, taxiSpawnLocation.y, taxiSpawnLocation.z + 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 100, 0, 50, false, true, 2, nil, nil, false)
            if IsControlJustPressed(0, 38) then
                print("You pressed E")
                SpawnTaxi()
            end
        end
    end
    end)
end

local CircleZone = CircleZone:Create(vector3(taxiSpawnLocation.x, taxiSpawnLocation.y, taxiSpawnLocation.z), 10.0, {
    name="circle_zone",
    debugPoly=false,
})

CircleZone:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside)
    if isPointInside then
        toggleOnOff()
        print("Player entered the circle zone")
    else
        toggleOnOff()
        print("Player left the circle zone")
    end
end)

local toggle2 = false
local function toggle2OnOff()
    local job = QBCore.Functions.GetPlayerData().job.name
    toggle2 = not toggle2
    CreateThread(function()
        while toggle2 do
            Wait(0)
            if job == 'taxijob' then
                DrawMarker(39, taxiReturnLocation.x, taxiReturnLocation.y, taxiReturnLocation.z + 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 50, false, true, 2, nil, nil, false)
            if IsControlJustPressed(0, 38) then
                print("You pressed E")
                ReturnTaxi()
            end
        end
    end
    end)
end

local CircleZone2 = CircleZone:Create(vector3(taxiReturnLocation.x, taxiReturnLocation.y, taxiReturnLocation.z), 10.0, {
    name="circle_zone2",
    debugPoly=false,
})
CircleZone2:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside)
    if isPointInside then
        toggle2OnOff()
        print("Player entered the circle zone")
    else
        toggle2OnOff()
        print("Player left the circle zone")
    end
end)

function SpawnTaxi()
    if taxi then
        QBCore.Functions.Notify("You already have a taxi.")
    else
        local playerPed = PlayerPedId()
        local vehicleModel = GetHashKey(Config.taxiModel)

        RequestModel(vehicleModel)
        while not HasModelLoaded(vehicleModel) do
            Citizen.Wait(0)
        end

        local spawnCoords = taxiSpawnLocation
        taxi = CreateVehicle(vehicleModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, GetEntityHeading(playerPed), true, false)
        TaskWarpPedIntoVehicle(playerPed, taxi, -1)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(taxi))
    end
end

function ReturnTaxi()
    if taxi then
        DeleteVehicle(taxi)
        taxi = nil
        QBCore.Functions.Notify("You have returned the bus.")
    else
        QBCore.Functions.Notify("You don't have a bus to return.")
    end
end


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
    end
end

RegisterNetEvent("stag_taxijob:client:chargeRider", function()
    local bill = exports['qb-input']:ShowInput({
        header = "Taxi Fare",
        submitText = "Charge",
        inputs = {
            {
                text = "Server ID(#)",
                name = "citizenid", 
                type = "text", 
                isRequired = true
            },
            {
                text = "   Bill Price (£)",
                name = "billprice", 
                type = "number",
                isRequired = false
            }
        }
    })
    if bill ~= nil then
        if bill.citizenid == nil or bill.billprice == nil then 
            return 
        end
        TriggerServerEvent("stag_taxijob:server:billPlayer", bill.citizenid, bill.billprice)
    end
end)

RegisterNetEvent('stag_taxijob:client:taxiAlert', function(coords, text)
    local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street1name = GetStreetNameFromHashKey(street1)
    local street2name = GetStreetNameFromHashKey(street2)
    QBCore.Functions.Notify({ text = text, caption = street1name .. ' ' .. street2name }, 'taxi')
    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
    local blipText = 'Taxi Alert'
    SetBlipSprite(blip, 198)
    SetBlipSprite(blip2, 161)
    SetBlipColour(blip, 2)
    SetBlipColour(blip2, 2)
    SetBlipDisplay(blip, 4)
    SetBlipDisplay(blip2, 8)
    SetBlipAlpha(blip, transG)
    SetBlipAlpha(blip2, transG)
    SetBlipScale(blip, 0.8)
    SetBlipScale(blip2, 2.0)
    SetBlipAsShortRange(blip, false)
    SetBlipAsShortRange(blip2, false)
    PulseBlip(blip2)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipText)
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        SetBlipAlpha(blip2, transG)
        if transG == 0 then
            RemoveBlip(blip)
            return
        end
    end
end)

RegisterCommand("taxifare", function()
    local job = QBCore.Functions.GetPlayerData().job.name
    if job == 'taxijob' then
        if IsPedInVehicle(PlayerPedId(), taxi, false) then
    TriggerEvent("stag_taxijob:client:chargeRider")
    else 
        QBCore.Functions.Notify('Not on duty or not in a bus', 'error', 5000)
    end
end
end, false)

RegisterCommand("calltaxi", function()
TriggerServerEvent('stag_taxijob:server:taxiAlert')
QBCore.Functions.Notify('Taxi Service Has Revieved Your Call', 'success', 5000)
end, false)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
end)