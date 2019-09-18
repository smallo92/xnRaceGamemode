--[[

    This is a now un-used tool,
    this tool is here in case we want images of tall the vehicles for some other use.

]]


local VehicleClasses2 = {
    ["Boats"] = {
        "dinghy",
        "jetmax",
        "seashark",
        "speeder",
        "squalo",
        "suntrap",
        "tropic",
    },
    ["Cycles"] = {
        "bmx",
        "cruiser",
        "tribike2",
        "scorcher",
        "tribike3",
        "tribike",
    },
    ["Helicopters"] = {
        "annihilator",
        "buzzard2",
        "cargobob",
        "frogger",
        "maverick",
        "polmav",
        "savage",
        "swift",
        "valkyrie",
    },
    ["Planes"] = {
        "cuban800",
        "dodo",
        "duster",
        "luxor",
        "stunt",
        "mammatus",
        "miljet",
        "shamal",
        "velum",
        "vestra",
    },
    ["Jets"] = {
        "besra",
        "hydra",
        "lazer",
    },
    ["Compacts"] = {
        "blista",
        "dilettante",
        "issi2",
        "panto",
        "prairie",
        "rhapsody",
    },
    ["Coupes"] = {
        "COGCABRIO",
        "exemplar",
        "f620",
        "felon2",
        "jackal",
        "oracle",
        "sentinel",
    },
    ["Bikes"] = {
        "akuma",
        "bagger",
        "bati",
        "bati2",
        "blazer",
        "carbonrs",
        "daemon",
        "double",
        "enduro",
        "hakuchou",
        "innovation",
        "lectro",
        "nemesis",
        "pcj",
        "ruffian",
        "sanchez2",
        "sanchez",
        "sovereign",
        "thrust",
        "vader",
    },
    ["Mucle"] = {
        "blade",
        "buccanee",
        "dominator",
        "dukes",
        "gauntlet",
        "hotknife",
        "phoenix",
        "picador",
        "ratloader2",
        "ruiner",
        "sabregt",
        "slamvan",
        "stalion",
        "vigero",
    },
    ["OffRoad"] = {
        "baller",
        "bifta",
        "blazer",
        "bodhi2",
        "dubsta",
        "dloader",
        "dune",
        "guardian",
        "bfinjection",
        "insurgent2",
        "kalahari",
        "marshall",
        "mesa",
        "paradise",
        "patriot",
        "rebel2",
        "sanchez2",
        "sanchez",
        "sandking",
        "sandking2",
        "monster",
        "tornado4",
    },
    ["Sedans"] = {
        "asea",
        "asterope",
        "fugitive",
        "glendale",
        "premier",
        "primo",
        "schafter2",
        "stanier",
        "superd",
        "surge",
        "tailgater",
        "warrener",
        "washington",
    },
    ["Sports"] = {
        "ninef2",
        "alpha",
        "banshee",
        "banshee",
        "blista2",
        "CARBONIZ",
        "comet2",
        "coquette",
        "elegy2",
        "feltzer",
        "furoregt",
        "fusilade",
        "jester",
        "jester2",
        "khamelion",
        "kuruma",
        "kuruma2",
        "massacro",
        "massacro2",
        "rapidgt2",
        "sultan",
    },
    ["Classics"] = {
        "casco",
        "coquette2",
        "monroe",
        "pigalle",
        "btype",
        "stinger",
        "ztype",
    },
    ["Super"] = {
        "adder",
        "bullet",
        "cheetah",
        "entityxf",
        "infernus",
        "turismor",
        "vacca",
        "voltic",
        "zentorno",
    },
    ["SUV"] = {
        "baller",
        "baller2",
        "bjxl",
        "cavalcade2",
        "crusader",
        "dubsta",
        "granger",
        "gresley",
        "huntley",
        "landstalker",
        "mesa",
        "pranger",
        "RADI",
        "seminole",
        "serrano",
    },
    ["Utility"] = {
        "airtug",
        "caddy",
        "faggio2",
        "tractor2",
        "mower",
    },
    ["Vans"] = {
        "boxville4",
        "burrito2",
        "camper",
        "speedo2",
        "gburrito2",
        "journey",
        "pony",
        "rumpo",
        "surfer",
        "youga",
    },
    ["Industrial"] = {
        "guardian",
        "bulldozer",
        "dump",
        "flatbed",
        "mixer",
        "rubble",
        "tiptruck",
    }
}

local txds = {
    "lgm_default",
    "lgm_dlc_apartments",
    "lgm_dlc_biker",
    "lgm_dlc_business",
    "lgm_dlc_business2",
    "lgm_dlc_executive1",
    "lgm_dlc_gunrunning",
    "lgm_dlc_heist",
    "lgm_dlc_importexport",
    "lgm_dlc_luxe",
    "lgm_dlc_pilot",
    "lgm_dlc_specialraces",
    "lgm_dlc_stunt",
    "lgm_dlc_valentines",
    "lgm_dlc_valentines2",
    "lgm_dlc_xmas2017",

    "sssa_default",
    "sssa_dlc_biker",
    "sssa_dlc_business",
    "sssa_dlc_business2",
    "sssa_dlc_christmas_2",
    "sssa_dlc_christmas_3",
    "sssa_dlc_executive_1",
    "sssa_dlc_halloween",
    "sssa_dlc_heist",
    "sssa_dlc_hipster",
    "sssa_dlc_mp_to_sp",
    "sssa_dlc_independence",
    "sssa_dlc_smuggler",
    "sssa_dlc_stunt",
    "sssa_dlc_valentines",
    "sssa_dlc_xmas2017",

    "lsc_default",
    "lsc_dlc_import_export",
    "lsc_jan2016",
    "lsc_lowrider2",

    "pandm_default",

    "candc_default",
    "candc_apartments",
    "candc_chopper",
    "candc_executive1",
    "candc_gunrunning",
    "candc_importexport",
    "candc_smuggler",
    "candc_truck",
    "candc_xmas2017",

    "dock_default",

    "elt_default",
    "elt_dlc_apartments",
    "elt_dlc_business",
    "elt_dlc_executive1",
    "elt_dlc_luxe",
    "elt_dlc_pilot",
    "elt_dlc_smuggler",
}

local function RequestTXD(txd)
    RequestStreamedTextureDict(txd)
    return HasStreamedTextureDictLoaded(txd)
end

RegisterCommand("plsnocrash", function()
    local modelstotxds = {}
    local vt = {}

    print("\n-------------------------------------------\nStarting Texture Search\n")

    for cn,cl in pairs(VehicleClasses2) do
        for i,veh in ipairs(cl) do
            vt[#vt+1] = string.lower(veh)
        end
        print("\tLoaded Class "..cn)
        Citizen.Wait(1)
    end

    for _,txd in ipairs(txds) do
        print("Using TXD "..txd)
        while not RequestTXD(txd) do Citizen.Wait(0) end
        Citizen.Wait(5)
        for _,vehModel in ipairs(vt) do
            if not modelstotxds[vehModel] then
                if GetTextureResolution(txd, vehModel) ~= vec(4,4,0) then
                    modelstotxds[vehModel] = txd
                    print("\tFound "..vehModel.." in "..txd)
                end
                Citizen.Wait(2)
            end
        end
        SetStreamedTextureDictAsNoLongerNeeded(txd)
    end

    print("\nFinished Texture Search\n-------------------------------------------\nListing Unknowns\n")

    for i,vm in ipairs(vt) do
        if not modelstotxds[vm] then print("\tTXD not found for "..GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vm))).." ("..vm..")") end
    end

    print("\nDONE\n-------------------------------------------\n")

    print(string.format("xnRace.VehicleImages = json.decode(%q)",json.encode(modelstotxds)))
end)

RegisterCommand("DriftMyRide", function()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if not IsEntityDead(veh) and IsEntityAVehicle(veh) then
        SetVehicleHandlingFloat(veh,"CHandlingData","fMass",1500.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fInitialDragCoeff",15.5)
        SetVehicleHandlingFloat(veh,"CHandlingData","fPercentSubmerged",85.0)
        SetVehicleHandlingVector(veh,"CHandlingData","vecCentreOfMassOffset",vec(0,0,0))
        SetVehicleHandlingVector(veh,"CHandlingData","vecInertiaMultiplier",vec(1.2,1.2,1.6))
        SetVehicleHandlingFloat(veh,"CHandlingData","fDriveBiasFront",0.0)
        --SetVehicleHandlingInt(veh,"CHandlingData","nInitialDriveGears",6)
        SetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveForce",1.9)
        SetVehicleHandlingFloat(veh,"CHandlingData","fDriveInertia",1.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fClutchChangeRateScaleUpShift",1.6)
        SetVehicleHandlingFloat(veh,"CHandlingData","fClutchChangeRateScaleDownShift",1.6)
        SetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel",230.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fBrakeForce",4.85)
        SetVehicleHandlingFloat(veh,"CHandlingData","fBrakeBiasFront",0.67)
        SetVehicleHandlingFloat(veh,"CHandlingData","fHandBrakeForce",3.5)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSteeringLock",52.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fTractionCurveMax",0.95)
        SetVehicleHandlingFloat(veh,"CHandlingData","fTractionCurveMin",1.3)
        SetVehicleHandlingFloat(veh,"CHandlingData","fTractionCurveLateral",24.5)
        SetVehicleHandlingFloat(veh,"CHandlingData","fTractionSpringDeltaMax",0.15)
        SetVehicleHandlingFloat(veh,"CHandlingData","fLowSpeedTractionLossMult",1.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fCamberStiffnesss",0.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fTractionBiasFront",0.45)
        SetVehicleHandlingFloat(veh,"CHandlingData","fTractionLossMult",1.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionForce",2.5)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionCompDamp",2.6)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionReboundDamp",3.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionUpperLimit",0.1)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionLowerLimit",-0.1)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionRaise",-0.0)
        SetVehicleHandlingFloat(veh,"CHandlingData","fSuspensionBiasFront",0.5)

        print("You just got drifted!")
    else
        print("You are not currently in a vehicle or it is a broken vehicle.")
    end
end)
