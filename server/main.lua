QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("fuel_can", function(source, item)
    local value = item.info.value
    TriggerClientEvent("gfx-stealfuel:InteractWithCar", source, ((value == nil or value == 0) and "steal" or "fill"), value, item.slot)
end)

RegisterServerEvent("gfx-stealfuel:InteractWithCar")
AddEventHandler("gfx-stealfuel:InteractWithCar", function(value, slot)
    local player = QBCore.Functions.GetPlayer(source)
    if player then
        local item = player.PlayerData.items[slot]
        if item.name == "fuel_can" then
            player.PlayerData.items[slot].info.value = value
            player.Functions.SetPlayerData("items", player.PlayerData.items)
        end
    end
end)