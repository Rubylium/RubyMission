function VoleDeVehicule(LongText, vehicule, possibleSpawn, stop, prix, id)
    ShowAdvancedNotification("MISSION", "VOL DE VEHICULE", LongText, "CHAR_BEVERLY", 8)
    local i = math.random(1, #possibleSpawn)
    local spawn = possibleSpawn[i].pos
    local heading = possibleSpawn[i].heading

    local blip = AddBlipForCoord(spawn)
    SetBlipRoute(blip, 1)
    local pPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(pPed)
    local dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    while dst >= 100.0 do
        Wait(100)
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
        RageUI.Text({message = "Rend toi sur le lieu indiqué."})
    end
    AddTextEntry("VOLE_VEH_MISSION", "Vole le véhicule")
    SpawnVehNotIn(vehicule, spawn, heading)

    while dst >= 3.0 do
        Wait(1)
        ShowFloatingHelp("VOLE_VEH_MISSION", spawn)
        RageUI.Text({message = "Vole le véhicule."})
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    end

    RemoveBlip(blip)

    local blip = AddBlipForCoord(stop)
    SetBlipRoute(blip, 1)
    
    local dst = GetDistanceBetweenCoords(stop, pCoords, true)
    while dst >= 5.0 do
        Wait(1)
        RageUI.Text({message = "Ramène le véhicule."})
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(pCoords, stop, true)
        DrawMarker(1, stop.x, stop.y, stop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
    end

    ShowAdvancedNotification("MISSION", "VOL DE VEHICULE", "Mission terminé ! Tu à gagné: ~g~"..prix.."~r~$", "CHAR_BEVERLY", 8)
    RemoveBlip(blip)
    SetBlipRoute(blip, 0)
    TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
    Wait(2000)
    TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
    SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)

    TriggerServerEvent("RS_MISSION:GetPayBlack", prix)
    TriggerServerEvent("RS_MISSION:SetStatus", id)
    gain = prix
    displayDoneMission = true
    Wait(3500)
    delVeh()
end

