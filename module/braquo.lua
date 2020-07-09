local CanDo = nil
RegisterNetEvent("BRAQUO:CanDo?")
AddEventHandler("BRAQUO:CanDo?", function(status)
    print("Sa revient")
    CanDo = status
end)


function braquo(data)
    CanDo = nil
    TriggerServerEvent("BRAQUO:CanDo?")
    while CanDo == nil do Wait(10) end
    if CanDo then
        TriggerServerEvent("BRAQUO:SetStatus")
        SetAudioFlag("LoadMPData", 1)
        DoScreenFadeOut(1000)
        Wait(1000)
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
        Wait(1000)
        SetEntityCoords(PlayerPedId(), 710.6415, -964.2544, 29.39534)
        SetEntityHeading(PlayerPedId(), 269.3122)
        SetGameplayCamRelativeHeading(0.0)
        StartMusicEvent("MP_MC_ASSAULT_ADV_START")
        StartMusicEvent("MP_MC_ASSAULT_ADV_SUSPENSE")
        DoScreenFadeIn(3500)
        TaskGoToCoordAnyMeans(PlayerPedId(), data.pedWalk, 1.0, 0, 0, 786603, 0xbf800000)
        Wait(3500)



        ShowAdvancedNotification("MISSION", "TRANSPORT DE VEHICULE", data.LongText, "CHAR_MOLLY", 8)
        local blip = AddBlipForCoord(data.spawnVeh)

        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(data.spawnVeh, pCoords, true)
        AddTextEntry("TRANSPORT_VEH", "Sort le véhicule")
        while dst > 2.5 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.spawnVeh, pCoords, true) 
            ShowFloatingHelp("TRANSPORT_VEH", data.spawnVeh)
            DrawMarker(36, data.spawnVeh.x, data.spawnVeh.y, data.spawnVeh.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
            RageUI.Text({message = "Sort le véhicule de braquage."})
        end
        local clicked = false
        while not clicked do
            Wait(1)
            DrawMarker(36, data.spawnVeh.x, data.spawnVeh.y, data.spawnVeh.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
            ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour faire spawn le véhicule")
            RageUI.Text({message = "Sort le véhicule de braquage."})
            if IsControlJustReleased(1, 38) then
                clicked = true
                SpawnVeh(data.vehicule, data.spawnVeh, data.headingStart)
            end
        end
        RemoveBlip(blip)

        local blip = AddBlipForCoord(data.stopVehicule)
        SetBlipRoute(blip, 1)
        local SurZone = false
        while not SurZone do
            Wait(1)
            RageUI.Text({message = "Conduit le véhicule jusqu'au point de braquage."})
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)
            local dst = GetDistanceBetweenCoords(pCoords, data.stopVehicule, true)
            DrawMarker(1, data.stopVehicule.x, data.stopVehicule.y, data.stopVehicule.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
            if dst <= 1.0 then
                if GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0) == "MISSION " then
                    SurZone = true
                end
            end
        end

        SetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0), data.stopVehicule.x, data.stopVehicule.y, data.stopVehicule.z, 0.0, 0.0, 0.0, 0.0)
        SetEntityHeading(GetVehiclePedIsIn(GetPlayerPed(-1), 0), data.headingStop)
        TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
        Wait(500)
        while IsPedInAnyVehicle(GetPlayerPed(-1), 0) do Wait(10) end
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
        while dst > 1.0 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
            DrawMarker(36, data.ChangementDeTenu.x, data.ChangementDeTenu.y, data.ChangementDeTenu.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
            RageUI.Text({message = "Vas à l'arrière du véhicule."})
        end
        local clicked = false
        while not clicked do
            Wait(1)
            ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour ouvrir le coffre")
            RageUI.Text({message = "Ouvre le coffre."})
            if IsControlJustReleased(1, 38) then
                clicked = true
            end
        end
        RemoveBlip(blip)
        NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(-1), 1))
        while not NetworkHasControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(-1), 1)) do Wait(10) end
        SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 5, 0, 0)



        local clicked = false
        while not clicked do
            Wait(1)
            ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour mettre sa cagoule")
            RageUI.Text({message = "Met ta cagoule et ton sac."})
            if IsControlJustReleased(1, 38) then
                clicked = true
            end
        end

        TriggerEvent("skinchanger:change", 'face', 0)
        TriggerEvent("skinchanger:change", 'mask_1', 35)
        TriggerEvent("skinchanger:change", 'glasses_1', 0)
        TriggerEvent("skinchanger:change", 'helmet_1', -1)
        TriggerEvent("skinchanger:change", 'bags_1', 40)
        PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)

        local EnCours = true
        local blips = {}
        for k,v in pairs(data.possibleVole) do
            local blip = AddBlipForCoord(v.pos)
            SetBlipSprite(blip, 615)
            SetBlipScale(blip, 0.45)
            table.insert(blips, blip)
        end
        for k,v in pairs(data.Caisse) do
            local blip = AddBlipForCoord(v.pos)
            SetBlipSprite(blip, 628)
            SetBlipScale(blip, 0.50)
            table.insert(blips, blip)
        end

        local money = 0
        local objets = 0
        while EnCours do
            Wait(1)
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)
            RageUI.Text({message = "Vole les objets et les caisses."})
            for k,v in pairs(data.possibleVole) do
                DrawMarker(29, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
                if dst <= 0.8 then
                    PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                    table.remove(data.possibleVole, k)
                    TriggerEvent("skinchanger:change", 'bags_1', 41)
                    local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
                    while dst > 1.0 do
                        Wait(1)
                        pCoords = GetEntityCoords(pPed)
                        dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
                        DrawMarker(36, data.ChangementDeTenu.x, data.ChangementDeTenu.y, data.ChangementDeTenu.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil,     nil, 0)
                        RageUI.Text({message = "Ton sac est rempli, dépose les objets dans le coffre."})
                    end

                    local randomPolice = math.random(1,10)
                    if randomPolice > 8 then
                        ShowNotification("~b~Une des caméra de la superette semble bouger ...")
                        TriggerServerEvent("BRAQUO:NotifPolice", GetEntityCoords(GetPlayerPed(-1)))
                    end

                    TriggerEvent("skinchanger:change", 'bags_1', 40)
                    objets = objets + math.random(2,6)
                    ShowNotification("Objets: ~b~"..objets)
                    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
                    for k,v in pairs(blips) do
                        RemoveBlip(v)
                    end
                    for k,v in pairs(data.possibleVole) do
                        local blip = AddBlipForCoord(v.pos)
                        SetBlipSprite(blip, 615)
                        SetBlipScale(blip, 0.55)
                        table.insert(blips, blip)
                    end
                    for k,v in pairs(data.Caisse) do
                        local blip = AddBlipForCoord(v.pos)
                        SetBlipSprite(blip, 628)
                        SetBlipScale(blip, 0.50)
                        table.insert(blips, blip)
                    end
                end
            end
            for k,v in pairs(data.Caisse) do
                DrawMarker(29, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
                if dst <= 0.8 then
                    table.remove(data.Caisse, k)
                    PlaySoundFrontend(-1, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
                    TriggerEvent("skinchanger:change", 'bags_1', 41)
                    local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
                    while dst > 1.0 do
                        Wait(1)
                        pCoords = GetEntityCoords(pPed)
                        dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
                        DrawMarker(36, data.ChangementDeTenu.x, data.ChangementDeTenu.y, data.ChangementDeTenu.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil,     nil, 0)
                        RageUI.Text({message = "Dépose les objets dans le coffre."})
                    end
                    
                    local randomPolice = math.random(1,10)
                    if randomPolice > 8 then
                        ShowNotification("~b~Une des caméra de la superette semble bouger ...")
                        TriggerServerEvent("BRAQUO:NotifPolice", GetEntityCoords(GetPlayerPed(-1)))
                    end

                    TriggerEvent("skinchanger:change", 'bags_1', 40)
                    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
                    local random = math.random(500, 1500)
                    money = money + random
                    ShowNotification("Gain: ~g~"..money.."~w~$")
                    for k,v in pairs(blips) do
                        RemoveBlip(v)
                    end
                    for k,v in pairs(data.possibleVole) do
                        local blip = AddBlipForCoord(v.pos)
                        SetBlipSprite(blip, 615)
                        SetBlipScale(blip, 0.55)
                        table.insert(blips, blip)
                    end
                    for k,v in pairs(data.Caisse) do
                        local blip = AddBlipForCoord(v.pos)
                        SetBlipSprite(blip, 628)
                        SetBlipScale(blip, 0.50)
                        table.insert(blips, blip)
                    end
                end
            end

            if #data.possibleVole + #data.Caisse == 0 then
                EnCours = false
                SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0)
            end

            ShowHelpNotification("Appuyer sur ~INPUT_VEH_DUCK~ pour stopper le braquage")
            if IsControlJustReleased(1, 73) then
                EnCours = false
                SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0)
            end
        end

        for k,v in pairs(blips) do
            RemoveBlip(v)
        end

        PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        DistantCopCarSirens(1)
        local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
        while dst <= 100.0 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
            RageUI.Text({message = "La police à été prévenu du braquage, dépèche toi de partir !"})
        end
        DistantCopCarSirens(0)
        RemoveBlip(blip)
        local blip = AddBlipForCoord(data.stop)
        SetBlipRoute(blip, 1)

        PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
        local dst = GetDistanceBetweenCoords(data.stop, pCoords, true)
        while dst > 3.0 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.stop, pCoords, true) 
            DrawMarker(36, data.stop.x, data.stop.y, data.stop.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
            RageUI.Text({message = "Parfait, maintenant rend toi au revendeur et vite !"})
        end
        SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
        local finalMoney = 0
        for i = 1,objets do
            finalMoney = finalMoney + math.random(300, 450)
        end
        finalMoney = finalMoney + money

        delVeh()
        DoScreenFadeOut(1000)
        Wait(1000)
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
        StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
        Wait(1000)
        SetEntityCoords(PlayerPedId(), 242.3744, 361.6154, 105.7382)
        SetEntityHeading(PlayerPedId(), 164.7872)
        SetGameplayCamRelativeHeading(0.0)

        local Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        ShakeCam(Camera,"HAND_SHAKE",0.3)
        SetCamActive(Camera, true)
        RenderScriptCams(true, true, 10, true, true)

        SetCamFov(Camera,50.0)
        SetCamCoord(Camera, 238.6872, 354.2765, 104.7547)
        PointCamAtEntity(Camera,GetPlayerPed(-1))
        DoScreenFadeIn(3500)
        local dir = vector3(240.7146, 356.4402, 105.5915)
        TaskGoToCoordAnyMeans(PlayerPedId(), dir, 1.0, 0, 0, 786603, 0xbf800000)

        Wait(1000)
        TriggerServerEvent("RS_MISSION:GetPayBlack", finalMoney)
        TriggerServerEvent("RS_MISSION:SetStatus", data.id)
        gain = finalMoney
        displayDoneMission = true
        RemoveBlip(blip)
        Wait(3000)
        RenderScriptCams(false, true, 4000, true, true)
        DestroyCam(Camera)
        
    else
        ShowNotification("~r~Désolé, un braquo à déja eu lieu il y à pas longtemps.")
    end
end


RegisterNetEvent("BRAQUO:NotifPolice")
AddEventHandler("BRAQUO:NotifPolice", function(coords)
    SetAudioFlag("LoadMPData", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_Kill_Player", "GTAO_FM_Events_Soundset", 0)
    ShowAdvancedNotification("LSPD", "ALERTE LSPD", "Braquage en de superette en cours! Point GPS Affiché pour 1min", "CHAR_CALL911", 8)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    Wait(60*1000)
    RemoveBlip(blip)
end)