local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("stag_taxijob:server:billPlayer", function(playerId, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local biller = Player
    local billed = QBCore.Functions.GetPlayer(tonumber(playerId))
    local amount = tonumber(amount)
    if biller.PlayerData.job.name == 'taxijob' then
        if billed ~= nil then
            if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                if amount and amount > 0 then
                billed.Functions.RemoveMoney('bank', amount)
                QBCore.Functions.Notify('You Charged A Customer', 'success', 5000)
                QBCore.Functions.Notify(billed.PlayerData.source,'You have been charged £' ..amount.. 'for your journey', 'success', 5000)
                exports['qb-banking']:AddMoney('taxijob', amount)
                else
                    QBCore.Functions.Notify(src, 'Must be a valid amount above 0', 'error', 5000)
                end
            else
                QBCore.Functions.Notify(src, 'You cannot bill yourself', 'error', 5000)
            end
        else
            QBCore.Functions.Notify(src, 'Player Not Online', 'error', 5000)
        end
    end
end)

RegisterNetEvent('stag_taxijob:server:taxiAlert', function(text)
	local src = source
	local ped = GetPlayerPed(src)
	local coords = GetEntityCoords(ped)
	local players = QBCore.Functions.GetQBPlayers()
	for _, v in pairs(players) do
		if v.PlayerData.job.name == 'taxijob' and v.PlayerData.job.onduty then
			TriggerClientEvent('stag_taxijob:client:taxiAlert', v.PlayerData.source, coords, text)
		end
	end
end)