local zone = {
    vector3(-799.3827, -234.8503, 37.13017),
    vector3(401.568, -1630.958, 29.29193),
    vector3(-39.44632, -1113.494, 26.43793),
    vector3(77.63651, -392.8138, 40.41463),
    vector3(925.0929, -1567.446, 30.6461),
}



Citizen.CreateThread(function()
    AddTextEntry("RANGER_SCOOTER", "~INPUT_PICKUP~ pour ranger le scooter de mission")
    local attente = 500
    while true do
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        for k,v in pairs(zone) do
            local dst = GetDistanceBetweenCoords(v, pCoords, true)
            if dst <= 10.0 then
                attente = 1
                DrawMarker(32, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 170, 0, 0, 2, 1, nil, nil, 0) 
                if dst <= 3.0 then
                    ShowFloatingHelp("RANGER_SCOOTER", v)
                    if IsControlJustReleased(1, 38) then
                        RangerScooter()
                    end
                end
                break
            else
                attente = 500
            end
        end
        Citizen.Wait(attente)
    end
end)

function RangerScooter()
    Citizen.CreateThread(function()
        local entity = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local model = GetEntityModel(entity)
        if model == GetHashKey("faggio3") then
            NetworkRequestControlOfEntity(entity)
            local test = 0
            while test > 100 and not NetworkHasControlOfEntity(entity) do
                NetworkRequestControlOfEntity(entity)
                Wait(1)
                test = test + 1
            end

            SetEntityAsNoLongerNeeded(entity)
            SetEntityAsMissionEntity(entity, true, true)

            Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
        
            while DoesEntityExist(entity) do 
                SetEntityAsNoLongerNeeded(entity)
                DeleteEntity(entity)
                Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
                SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
                Wait(300)
            end 
        else
            ShowAdvancedNotification("MISSION", "INFO", "Ce n'est pas un scooter de mission", "CHAR_MOLLY", 8)
        end
    end)
end