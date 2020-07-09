local configPed = {}
local configMission = {}
local MissionDone = {}
local sync = false
local MenuOpen = false

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(0)
	end
end)

-- Anti dump
Citizen.CreateThread(function()
    TriggerServerEvent("RS_MISSION:GetConfig")
    TriggerServerEvent("RS_GetMissionStatus")
end)
RegisterNetEvent("RS_MISSION:GetConfig")
AddEventHandler("RS_MISSION:GetConfig", function(confPed, confMission)
    configPed = confPed
    configMission = confMission
    sync = true
end)
RegisterNetEvent("RS_GetMissionStatus")
AddEventHandler("RS_GetMissionStatus", function(done)
    MissionDone = done
end)

RMenu.Add('mission', 'main', RageUI.CreateMenu("MISSION", " "))
RMenu:Get('mission', 'main'):SetSubtitle("~b~Menu de mission")
RMenu:Get('mission', 'main').EnableMouse = false
RMenu:Get('mission', 'main').Closed = function()
    MenuOpen = false
end;


-- Spawn PNJ + Création zone
Citizen.CreateThread(function()
    while not sync do Wait(100) end
    StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
    for _,v in pairs(configPed) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do Wait(100) end
        local ped = CreatePed(5, v.ped, v.coords, v.heading, 0, 0)
        SetEntityHeading(ped, v.heading)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        if v.legal then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, 525)
            SetBlipScale(blip, 0.50)
            SetBlipColour(blip, 26)
            SetBlipCategory(blip, 7)
            SetBlipDisplay(blip, 8)
            SetBlipAsShortRange(blip, 1)

            BeginTextCommandSetBlipName('STRING')
		    AddTextComponentSubstringPlayerName("~b~Mission Citoyen")
		    EndTextCommandSetBlipName(blip)
        end
    end

    while true do
        Citizen.Wait(1)
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        for _,v in pairs(configPed) do
            local dst = GetDistanceBetweenCoords(pCoords, v.coords)
            if dst <= 2.0 then
                ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour ouvrir le menu de mission")
                if IsControlJustReleased(1, 38) then
                    MenuOpen = true
                    OpenMenu(v.id)

                end
            end
        end
    end
end)



function OpenMenu(id)
    RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
    while MenuOpen do
        Citizen.Wait(1)
        if RageUI.Visible(RMenu:Get('mission', 'main')) then
            RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()
                for _,v in pairs(configMission) do
                    if v.ped == id then
                        local done = false
                        for _,i in pairs(MissionDone) do
                            if v.id == i then
                                done = true
                            end
                        end
                        if not done then
                            RageUI.Button(v.Titre.." | ~b~"..v.prix.."~w~$ - ~g~DISPONIBLE", v.Desc, {}, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    if v.type == "transport" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        MenuOpen = false
                                        missionTransport(v.vehicule, v.start, v.headingStart, v.stop, v.prix, v.LongText, v.id)
                                    elseif v.type == "voleVehicule" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        MenuOpen = false
                                        VoleDeVehicule(v.LongText, v.vehicule, v.possibleSpawn, v.stop, v.prix, v.id) 
                                    elseif v.type == "braquo" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        MenuOpen = false
                                        braquo(v)
                                    end
                                end
                            end)
                        else
                            RageUI.Button(v.Titre.." - ~r~INDISPONIBLE", nil, { RightBadge = RageUI.BadgeStyle.Tick }, true, function(Hovered, Active, Selected)end)
                        end
                    end
                end
            end, function()
            ---Panels
            end)
        end
    end
end

function StartMusicEvent(event)
	PrepareMusicEvent(event)
	return TriggerMusicEvent(event) == 1
end


function SpawnVeh(vehicle, start, heading)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do Wait(100) end

    local veh = CreateVehicle(vehicle, start, heading, 1, 0) 
    AddBlipForEntity(veh)
    SetEntityAsMissionEntity(veh, 1, 1)
    SetVehicleNumberPlateText(veh, "MISSION")
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
end

function SpawnVehNotIn(vehicle, start, heading)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do Wait(100) end

    local veh = CreateVehicle(vehicle, start, heading, 1, 0) 
    AddBlipForEntity(veh)
    SetEntityAsMissionEntity(veh, 1, 1)
    SetVehicleNumberPlateText(veh, "MISSION")
    --TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
end

function delVeh()
    Citizen.CreateThread(function()
        local entity = GetVehiclePedIsIn(GetPlayerPed(-1), true)
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
    end)
end


displayDoneMission = false
gain = 0
str = "Mission terminé!"

local rt = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

Citizen.CreateThread(function()
	while true do
		if displayDoneMission then
			StartScreenEffect("SuccessTrevor",  2500,  false)
			curMsg = "SHOW_MISSION_PASSED_MESSAGE"
			SetAudioFlag("AvoidMissionCompleteDelay", true)
			PlayMissionCompleteAudio("FRANKLIN_BIG_01")
			Citizen.Wait(3000)
			StopScreenEffect()
			curMsg = "TRANSITION_OUT"
			PushScaleformMovieFunction(rt, "TRANSITION_OUT")
			PopScaleformMovieFunction()
			Citizen.Wait(2000)
			displayDoneMission = false
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		if(HasScaleformMovieLoaded(rt) and displayDoneMission)then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()

			if (curMsg == "SHOW_MISSION_PASSED_MESSAGE") then
			
			PushScaleformMovieFunction(rt, curMsg)
 
            ---BeginScaleformMovieMethod(rt, 'SHOW_SHARD_WASTED_MP_MESSAGE')
            PushScaleformMovieMethodParameterString(str)
            PushScaleformMovieMethodParameterString("Gain: "..gain.."$")
            EndScaleformMovieMethod()
			--BeginTextComponent("STRING")
			--AddTextComponentString(str)
			--EndTextComponent()
			--BeginTextComponent("STRING")
			--AddTextComponentString("Gain: "..gain.."$")
			--EndTextComponent()

			PushScaleformMovieFunctionParameterInt(145)
			PushScaleformMovieFunctionParameterBool(false)
			PushScaleformMovieFunctionParameterInt(1)
			PushScaleformMovieFunctionParameterBool(true)
			PushScaleformMovieFunctionParameterInt(69)

			PopScaleformMovieFunctionVoid()

			Citizen.InvokeNative(0x61bb1d9b3a95d802, 1)
			end
			
			DrawScaleformMovieFullscreen(rt, 255, 255, 255, 255)
		end
    end
end)

ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType)
	AddTextEntry('MissionAdvNotif', msg)
	BeginTextCommandThefeedPost('MissionAdvNotif')
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	--EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

ShowHelpNotification = function(msg)
	AddTextEntry('MissionHelpNotif', msg)
	DisplayHelpTextThisFrame('MissionHelpNotif', false)
end

ShowNotification = function(msg)
	AddTextEntry('MissionSImpleNotif', msg)
	BeginTextCommandThefeedPost('MissionSImpleNotif')
	EndTextCommandThefeedPostTicker(0, 0)
end

function ShowHelp(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, true, -1)
end

function ShowFloatingHelp(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    ShowHelp(text, 2)
end


