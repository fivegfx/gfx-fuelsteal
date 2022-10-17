QBCore = exports['qb-core']:GetCoreObject()
local isDoing = false

RegisterNetEvent("gfx-stealfuel:InteractWithCar", function(fuelType, value, slot)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then return end
    value = value and value or 0
    local coords = GetEntityCoords(ped)
    local vehicle, distance = QBCore.Functions.GetClosestVehicle(coords)
    if vehicle and distance <= 2.5 then
        FillOrSteal(vehicle, fuelType, value, slot)
    end
end)

function FillOrSteal(vehicle, fuelType, value, slot)
    if isDoing then return end
    local ped = PlayerPedId()
    isDoing = true
    Animation(ped)
    CancelThread()
    local vehicleFuel = exports["LegacyFuel"]:GetFuel(vehicle)
    if vehicleFuel == 100 then
        fuelType = "steal"
    end
    SendNUIMessage({
        type = "display",
        value = vehicleFuel,
        bool = true
    })
    if fuelType == "steal" then
        local newFuel = 0
        for i = vehicleFuel, 0, -1 do
            Citizen.Wait(100)
            SendNUIMessage({
                type = "update",
                value = i,
            })
            if not isDoing then
                newFuel = i
                break
            end
        end
        exports["LegacyFuel"]:SetFuel(vehicle, newFuel)
        TriggerServerEvent("gfx-stealfuel:InteractWithCar", (vehicleFuel - newFuel), slot)
    else
        local limit = (value + vehicleFuel) >= 100 and 100 or (value + vehicleFuel)
        for i = vehicleFuel, limit do
            Citizen.Wait(100)
            SendNUIMessage({
                type = "update",
                value = i,
                vehicleFuel = vehicleFuel
            })
            if not isDoing then
                limit = i
                break
            end
        end
        exports["LegacyFuel"]:SetFuel(vehicle, limit + 0.0)
        TriggerServerEvent("gfx-stealfuel:InteractWithCar", math.abs(limit - value - vehicleFuel), slot)
    end
    SendNUIMessage({
        type = "display",
        value = vehicleFuel > 0 and 0 or value,
        vehicleFuel = vehicleFuel,
        bool = false
    })
    ClearPedTasks(ped)
    isDoing = false
end

function CancelThread()
    CreateThread(function()
        while isDoing do
            if IsControlJustReleased(0, Config.CancelKey) then
                isDoing = false
            end
            if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, false, false, false)
            end
            Citizen.Wait(0)
        end
    end)
end

function Animation(ped)
    LoadAnimDict("timetable@gardener@filling_can")
    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, false, false, false)
end

function LoadAnimDict(dict)
	if HasAnimDictLoaded(dict) then return end
	RequestAnimDict(dict)

	while not HasAnimDictLoaded(dict) do
		Wait(10)
	end
end