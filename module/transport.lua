

function missionTransport(vehicule, start, headingStart, stop, prix, LongText, id)
    ShowAdvancedNotification("MISSION", "TRANSPORT DE VEHICULE", LongText, "CHAR_MOLLY", 8)
    local blip = AddBlipForCoord(start)

    local pPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(pPed)
    local dst = GetDistanceBetweenCoords(start, pCoords, true)
    AddTextEntry("TRANSPORT_VEH", "Sort le véhicule")
    while dst > 2.5 do
        Wait(1)
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(start, pCoords, true) 
        ShowFloatingHelp("TRANSPORT_VEH", start)
        DrawMarker(36, start.x, start.y, start.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
    end
    local clicked = false
    while not clicked do
        Wait(1)
        DrawMarker(36, start.x, start.y, start.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
        ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour faire spawn le véhicule")
        if IsControlJustReleased(1, 38) then
            clicked = true
            SpawnVeh(vehicule, start, headingStart)
        end
    end
    RemoveBlip(blip)
    local dst = GetDistanceBetweenCoords(pCoords, stop, true)
    local blip = AddBlipForCoord(stop)
    SetBlipRoute(blip, 1)
 
    local SurZone = false
    while not SurZone do
        Wait(1)
        RageUI.Text({message = "Conduit le véhicule jusqu'au point de livraison."})
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(pCoords, stop, true)
        DrawMarker(1, stop.x, stop.y, stop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
        if dst <= 5.0 then
            if GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0) == "MISSION " then
                SurZone = true
            end
        end
    end

    RemoveBlip(blip)
    SetBlipRoute(blip, 0)
    TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
    Wait(2000)
    TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
    while IsPedSittingInAnyVehicle(GetPlayerPed(-1)) do Wait(1) end
    local OldVeh = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
    SetVehicleDoorsLocked(OldVeh, 1)
    SetVehicleDoorsLockedForAllPlayers(OldVeh, 1)
    ShowAdvancedNotification("MISSION", "TRANSPORT DE VEHICULE", "Mission terminé ! Tu à gagné: ~g~"..prix.."~r~$", "CHAR_MOLLY", 8)
    TriggerServerEvent("RS_MISSION:GetPay", prix)
    TriggerServerEvent("RS_MISSION:SetStatus", id)
    gain = prix
    displayDoneMission = true
    Wait(3500)
    delVeh()
    Wait(1500)
    SpawnVeh(GetHashKey("faggio3"), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)))
end