ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CheckLicense(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

ESX.RegisterServerCallback('e_weaponshop:checkLicense', function(source, cb, type)
    CheckLicense(source, 'weapon_chasse', cb)
end)



RegisterNetEvent('doom:shop')
AddEventHandler('doom:shop', function(ITEM,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()
    local xBank = xPlayer.getAccount('bank').money

    if xMoney >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(ITEM, 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achats~w~ effectué !")
    elseif xBank >= price then 
        xPlayer.removeAccountMoney('bank', price)
        xPlayer.addInventoryItem(ITEM, 1)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez assez ~r~d\'argent")
    end
end)
