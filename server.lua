xnRace = xnRace or {}
xnRace.STATE = -1
xnRace.AC = {}

local charset = {} do
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

local function tl(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function CoordTableToVec(t)
    if t["x"] and t["y"] and t["z"] then
        return {t["x"],t["y"],t["z"]}
    else
        return false
    end
end


local EventObfuscator = tostring(randomString(32))

function AddEvent(eventName, handler)
    RegisterServerEvent(EventObfuscator..":"..eventName)
    return AddEventHandler(EventObfuscator..":"..eventName, handler)
end

RegisterServerEvent("xnRace:getEventObfuscator")
AddEventHandler("xnRace:getEventObfuscator", function()
    local ply = source
    TriggerClientEvent("xnRace:passEventObfuscator", ply, EventObfuscator)
    TriggerEvent("playerLoadedIntoServer", ply)
end)

function SendObjectsToClient(client,mData)
    local objects = {}

    local missionName = mData["mission"]["gen"]["nm"]
    local saveMissionName = missionName:gsub("%s+", "_")
    local propData = mData["mission"]["prop"]

    for i=1,propData["no"] do
        local model = propData["model"][i]
        local x = propData["loc"][i]["x"]
        local y = propData["loc"][i]["y"]
        local z = propData["loc"][i]["z"]

        local rotx = propData["vRot"][i]["x"] + 0.0
        local roty = propData["vRot"][i]["y"] + 0.0
        local rotz = propData["vRot"][i]["z"] + 0.0
        local extradata

        if propData["prpclr"] and propData["prpclr"][i] ~= nil then
            table.insert(objects, {hash = model, x = x, y = y, z = z, rot = {x = rotx, y = roty, z = rotz}, prpclr=propData["prpclr"][i]})
        else
            table.insert(objects, {hash = model, x = x, y = y, z = z, rot = {x = rotx, y = roty, z = rotz}})
        end
    end
    TriggerClientEvent("xnRace:loadMapObjects",-1, missionName, objects)
end

local currentVotes = {}
local playersVoted = 0
AddEvent("networkVote", function(rawIndex)
    local votingPlayer = source
    local changedIndex = rawIndex + 1
    local newIndex = changedIndex

    for i=1,9 do -- 0,8 doesnt work for some fucked reason
        if not currentVotes[i] then currentVotes[i] = {} print("created votes for "..i) end
        if currentVotes[i][votingPlayer] then
            if i == changedIndex then
                newIndex = -1 -- Dont flash the BG, this players, vote hasnt changed.
            else
                currentVotes[i][votingPlayer] = nil
            end
        else
            if i == changedIndex then
                currentVotes[i][votingPlayer] = true
            end
        end
    end

    local numPlayersVoted = 0
    for index,votes in ipairs(currentVotes) do
        for player,didVote in pairs(votes) do
            if didVote then numPlayersVoted = numPlayersVoted + 1 end
        end
    end
    playersVoted = numPlayersVoted
    print(playersVoted)

    TriggerClientEvent("xnRace:displayVotes", -1, currentVotes, newIndex, GetNumPlayerIndices())
end)

local function GetMapType(type1,type2)

    local maptypes = {
        [0] = {
            [0] = 0,
            [7] = 15,
            [4] = 16,
        },
        [1] = 1,
        [8] = 8,
        [2] = {
            [0] = 10,
            [1] = 10,

            [6] = 21,
            [7] = 21,
            [18] = 21,
            [19] = 21,

            [2] = 13,
            [3] = 13,

            [4] = 14,
            [5] = 14,

            default = 2,
        },
        [3] = 3,
        [6] = 6,
    }

    local ftype = 0 -- Default

    if maptypes[type2][type1] then
        ftype = maptypes[type2][type1]
    elseif maptypes[type2] and type(maptypes[type2]) ~= "table" then
        ftype = maptypes[type2]
    elseif maptypes[type2].default then
        ftype = maptypes[type2].default
    end

    return ftype
end

function DoMapVote()
    Citizen.CreateThread(function()
        --Citizen.Wait(3000)
        local vo = {}
        local svo = {}
        while #vo ~= 6 do
            Citizen.Wait(0)
            local i = #vo + 1
            local randomMap = ""
            -- table.insert(vo, tostring(xnRace.RaceTable[math.random(1, #xnRace.RaceTable)][1]))
            if i == 1 then
                randomMap = "https://prod.cloud.rockstargames.com/ugc/gta5mission/4998/vyTABS5xR06--t_w6e9t0w/0_0_en.json" -- Stunt - Chiliad
                --randomMap = "https://prod.cloud.rockstargames.com/ugc/gta5mission/6861/raJFAGN0J0CWla3Tz8YnGg/0_0_en.json" -- Criminal Records
            else
    		    randomMap = xnRace.RaceTable[math.random(1, #xnRace.RaceTable)]
            end
            local missionUID = string.sub(randomMap, 59, -12)
            local doNextMap = false

            local mapdupe = false
            for _,option in ipairs(vo) do
                if option[3] == missionUID then
                    mapdupe = true
                end
            end

            if not mapdupe then
        		local missionName = "selection: "..i.." not found"
        		local missionDesc = "selection: "..i.." not found"
                local mData = {}
                PerformHttpRequest(randomMap, function(statusCode, data, headers)
                    if data then
                        mData = json.decode(data)
                        if mData then
                            missionName = mData["mission"]["gen"]["nm"]
                            missionDesc = mData["mission"]["gen"]["dec"]
                            doNextMap = true
                        else
                            print("No data from URL: "..randomMap)
                            TriggerClientEvent("chatMessage", -1, "^3SERVER^r", {0,0,0}, "BROKEN URL: "..randomMap)
                        end
                    end
                end, 'GET', '', { ["Content-Type"] = 'application/json' })
                while not doNextMap do Citizen.Wait(0) end

                local imgUrl = string.sub(randomMap, 0, -12).."2_0.jpg"
                --local mapType = mData["mission"]["race"]["type"]

                local t1 = mData["mission"]["race"]["type"]
                local t2 = mData["mission"]["gen"]["alttype"]
                local mapType = GetMapType(t1,t2)

                local loc = mData["meta"]["loc"]

                local itemDetails = {69, mData["mission"]["gen"]["ownerid"], {t1,t2}, tostring(loc[#loc])}

                vo[i] = {missionName,missionDesc,missionUID,mapType,imgUrl,itemDetails} -- math.random(1, #xnRace.RaceTable) can be used in place of i but we need to check if the item is already in the table
                svo[i] = {mData,randomMap} -- we only send what we need to the client!!
            end
        end
        TriggerClientEvent("xnRace:doMapVote", -1, vo, 30000, GetNumPlayerIndices())
        local numPlayersVoting = GetNumPlayerIndices()

        playersVoted = 0
        local dontContinueWithVote = true
        SetTimeout(29100, function()
            dontContinueWithVote = false
        end)

        while (playersVoted < numPlayersVoting) and dontContinueWithVote do Citizen.Wait(0) end
        Citizen.Wait(1000)
        TriggerClientEvent("xnRace:stopMapVote", -1)
        print("stop")

        local voteCounts = {}
        local highestVotedIndex = 0
        for option,vd in ipairs(currentVotes) do
            if vd then
                local votes = 0
                for player,didVote in pairs(vd) do
                    if didVote then -- If a player is in this list they should have voted but oh well...
                        votes = votes + 1
                    end
                end
                voteCounts[option] = votes
            end
        end
        for option,numVotes in ipairs(voteCounts) do
            if highestVotedIndex == 0 or numVotes > voteCounts[highestVotedIndex] then
                highestVotedIndex = option
            end
        end
        if highestVotedIndex == 0 or highestVotedIndex == 9 then highestVotedIndex = math.random(1,6) end
        xnRace.CURRENTMAP = svo[highestVotedIndex][1]
        SetMapName(vo[highestVotedIndex][1])

        PerformHttpRequest("https://discordapp.com/api/webhooks/467884627823034399/1Qe1LBYMSCqF5u-1wgwUhUTbBAFxoxu-xevs2mL_raGjX4fOEyryVucb2sTVfkL2lsXW", function(errorCode, resultData, resultHeaders) end, "POST",
        json.encode({
            ["content"] = tostring(svo[highestVotedIndex][2]),
            ["username"] = "Race Bot"
        }))

        SendObjectsToClient(-1, xnRace.CURRENTMAP)
        print("sentobjtoclient")
        DoRace(numPlayersVoting)
    end)
end

function DoRace(numPlayersRacing) Citizen.CreateThread(function()
    if not xnRace.CURRENTMAP then return end -- Dont do anything if we dont have a map loaded
    local instanceEvents = {}

    local loadedClients = {}
    instanceEvents[#instanceEvents+1] = AddEvent("clientMapLoaded", function()
        local source = source
        loadedClients[source] = true
        print("clientMapLoaded")

        local vt = {}
        local blockedClasses = xnRace.CURRENTMAP["meta"]["vehcl"]
        for i,cn in ipairs(blockedClasses) do
            blockedClasses[cn] = true
        end
        local allowedClasses = {}

        if blockedClasses[#blockedClasses] ~= "" then
            for cn,cl in pairs(xnRace.VehicleClasses) do
                if not blockedClasses[cn] then
                    allowedClasses[#allowedClasses+1] = cn
                end
            end

            for i,cl in ipairs(allowedClasses) do --ipairs({"Super","Sports"}) do
                if xnRace.VehicleClasses[cl] then
                    for i,veh in ipairs(xnRace.VehicleClasses[cl]) do
                    --for i,veh in ipairs(xnRace.VehicleClasses[allowedClasses[math.random(1,#allowedClasses)]]) do
                        vt[#vt+1] = {"Sample Text",veh,xnRace.VehicleImages[veh] or "@@IMG_NOT_FOUND"}
                    end
                end
            end

            local frontendCoords = {
                CoordTableToVec(xnRace.CURRENTMAP["mission"]["gen"]["start"]),
                xnRace.CURRENTMAP["mission"]["gen"]["camh"],
            }

            TriggerClientEvent("xnRace:chooseAVehicle", source, false, vt, xnRace.CURRENTMAP["mission"]["gen"]["nm"], frontendCoords)
        else
            TriggerClientEvent("xnRace:chooseAVehicle", source, true) -- Sending true here just makes the client ignore vehicle selection
        end
        --TriggerClientEvent("xnRace:updateVehicleColours", source, xnRace.DefaultColours)
    end)

    local readyClients = {}
    instanceEvents[#instanceEvents+1] = AddEvent("clientReady", function(vehicleData)
        local ply = source
        local clientReady = false
        print(loadedClients[ply])
        if loadedClients[ply] then
            -- vehdata validation here
            readyClients[ply] = vehicleData or {model=xnRace.CURRENTMAP["mission"]["gen"]["ivm"]}
            print(readyClients[ply])
            clientReady = true
        end
        if clientReady then print("clientReady") end
        TriggerClientEvent("xnRace:updateReadyStatus", -1, source, clientReady)
    end)
    local curPly = GetNumPlayerIndices()
    while tl(readyClients) < numPlayersRacing do Citizen.Wait(0) end
    print("allClientsReady")

    local tempindex = 0
    for ply,vehData in pairs(readyClients) do
        tempindex = tempindex + 1
        local mData = xnRace.CURRENTMAP
        local sd = {mData["mission"]["veh"]["loc"][tempindex],mData["mission"]["veh"]["head"][tempindex]}
        local vehicleData = {model=vehData.model,colour=vehData.colour}

        TriggerClientEvent("xnRace:spawnOnTrack", ply, sd, vehicleData, xnRace.CURRENTMAP["mission"]["gen"]["nm"])
    end

    local spawnedClients = {}
    instanceEvents[#instanceEvents+1] = AddEvent("clientSpawned", function()
        local source = source
        spawnedClients[source] = true
        print("clientSpawned")
    end)
    local curPly = GetNumPlayerIndices()
    while tl(spawnedClients) < numPlayersRacing do Citizen.Wait(0) end

    local err, firstCP, AllCP = CreateCheckpoints()
    if not err then
        xnRace.CHECKPOINTS = AllCP
        xnRace.PLAYERCHECKPOINTS = {}
        TriggerClientEvent("xnRace:checkpoints:response", -1, "firstCPS", firstCP)
        print("firstCheckPointsGiven"..json.encode(firstCP))
    end

    Citizen.Wait(3500)
    print("startingRace")

    TriggerClientEvent("xnRace:startRace", -1, "stunt")
    Citizen.Wait(2900)
    xnRace.AC.RaceHasStarted = true

    local finishedClients = {}
    local dnfTimeout = false
    local dnfTimeoutStarted = false
    instanceEvents[#instanceEvents+1] = AddEventHandler("clientFinished", function(ply) -- This is local event :P
        if tl(spawnedClients)/3 < #finishedClients then
            finishedClients[#finishedClients+1] = ply
        else
            finishedClients[#finishedClients+1] = ply
            if not dnfTimeoutStarted then
                SetTimeout(30000, function()
                    dnfTimeout = true
                end)
                dnfTimeoutStarted = true
            end
        end
        print("clientFinished")
    end)
    local curPly = GetNumPlayerIndices()
    while tl(finishedClients) < numPlayersRacing or dnfTimeout do Citizen.Wait(0) end
    print("everyone is finished")
    Citizen.Wait(2100)
    local clientsSentTo = {}
    for place,ply in ipairs(finishedClients) do
        TriggerClientEvent("xnRace:raceOverMessage", ply, tonumber(place), 1000, 20, GetPlayerName(finishedClients[1]))
        clientsSentTo[ply] = true
    end
    for ply,_ in pairs(spawnedClients) do
        if not clientsSentTo[ply] then
            TriggerClientEvent("xnRace:raceOverMessage", ply, false)
        end
    end
    TriggerClientEvent("chatMessage", -1, "^3SERVER^r", {0,0,0}, "Congratulations to ^5"..GetPlayerName(finishedClients[1]).."^r for winning the race!")

    Citizen.Wait(7000)

    for i,event in ipairs(instanceEvents) do
        RemoveEventHandler(event)
    end

    DoMapVote()
end) end

AddEvent("checkpoints:check", function(key)
    local ply = source
    if not xnRace.CURRENTMAP and xnRace.CHECKPOINTS then return end -- Dont do anything if we dont have a map loaded

    if not xnRace.PLAYERCHECKPOINTS[ply] then
        xnRace.PLAYERCHECKPOINTS[ply] = 1
    end

    local rCP = xnRace.PLAYERCHECKPOINTS[ply]
    if xnRace.CHECKPOINTS[rCP] then
        local cpd = xnRace.CHECKPOINTS[rCP]
        local verifToken = cpd[5]
        local isPossible = true --local isPossible = xnRace.AC.nextcptimerover(ply)

        if verifToken == key and isPossible then
            xnRace.PLAYERCHECKPOINTS[ply] = xnRace.PLAYERCHECKPOINTS[ply] + 1
            local newRCP = xnRace.PLAYERCHECKPOINTS[ply]

            if #xnRace.CHECKPOINTS == rCP then
                local finishCamCoords = false
                if xnRace.CURRENTMAP["mission"]["gen"]["camf"] then
                    finishCamCoords = {
                        CoordTableToVec(xnRace.CURRENTMAP["mission"]["gen"]["camf"]), -- Finish cam coords
                        CoordTableToVec(xnRace.CURRENTMAP["mission"]["gen"]["camfr"]), -- Finish cam rotation
                    }
                end
                TriggerClientEvent("xnRace:checkpoints:response", ply, "OK", {"FINISH", finishCamCoords})
                TriggerEvent("clientFinished", ply)
                print('Somebody finished the race')
            else
                TriggerClientEvent("xnRace:checkpoints:response", ply, "OK", {xnRace.CHECKPOINTS[newRCP+1] or false, xnRace.CHECKPOINTS[newRCP+2] or false}) -- tell em the next checkpoint
            end
        elseif xnRace.CHECKPOINTS[rCP+1][5] == key and isPossible then
            -- The player missed a checkpoint, do nothing
        else
            TriggerClientEvent("xnRace:checkpoints:response", ply, "1D10T_D3T3CT3D")
        end
    end
end)

function CreateCheckpoints()
    local noErr = true
    if not xnRace.CURRENTMAP then return false end -- Dont do anything if we dont have a map loaded

    local cps = {}
    local chp = xnRace.CURRENTMAP["mission"]["race"]["chp"] or false     -- Number of checkpoints
    local chh = xnRace.CURRENTMAP["mission"]["race"]["chh"] or false     -- Heading
    local chl = xnRace.CURRENTMAP["mission"]["race"]["chl"] or false     -- Location
    local chs = xnRace.CURRENTMAP["mission"]["race"]["chs"] or false     -- Scale
    local chr = xnRace.CURRENTMAP["mission"]["race"]["rndchk"] or false  -- IsRound

    if not chr then
        chr = {}
        for i=1,chp do
            chr[i] = false
        end
    end

    if chp and chh and chl then
        for i=1,chp do
            cps[#cps+1] = {
                CoordTableToVec(chl[i]),
                chh[i],
                chs and chs[i] or 1.0,
                chs and chr[i] or false,
                tostring(randomString(16)) -- Validation Key
            }
        end
    else noErr = false end

    return not noErr, {cps[1],cps[2],cps[3]}, cps
end

xnRace.LoadedPlayers = {} -- All players loaded into the server
AddEventHandler("playerLoadedIntoServer", function(ply) -- the client asks for the event obfuscator when it is loaded in so we "piggyback" off of that
    xnRace.LoadedPlayers[ply] = true
end)

AddEventHandler("playerDropped", function(ply)
    xnRace.LoadedPlayers[ply] = nil
end)


xnRace.Players = {} -- Main player table with all of our custom data (of which we have none atm)

-- Main loops
Citizen.CreateThread(function() -- Player Loading Loop
    while true do Citizen.Wait(0)
        while tl(xnRace.LoadedPlayers) < GetNumPlayerIndices() do Citizen.Wait(0) end -- wait for an unloaded player to exist

        for ply,unHandled in pairs(xnRace.LoadedPlayers) do
            if unHandled then
                xnRace.Players[ply] = true
                if xnRace.STATE < 1 then
                    TriggerClientEvent("xnRace:waitInLimbo", ply) -- tell the player to wait for the next instruction, we havent loaded / no race is on going
                end
            end
        end
    end
end)

Citizen.CreateThread(function() -- Main Logic/Magic loop
    while true do Citizen.Wait(0)
        --if xnRace.STATE == -1 then -- first server load
            while tl(xnRace.LoadedPlayers) < 1 do Citizen.Wait(0) end
            DoMapVote()
            xnRace.STATE = 0
            while tl(xnRace.LoadedPlayers) >= 1 do Citizen.Wait(0) end
        --end
    end
end)

RegisterCommand("test-hook", function(soruce, args) -- Going to use webhooks to tell us if a hacker is detected or something along those lines
    PerformHttpRequest("https://discordapp.com/api/webhooks/467884627823034399/1Qe1LBYMSCqF5u-1wgwUhUTbBAFxoxu-xevs2mL_raGjX4fOEyryVucb2sTVfkL2lsXW", function(errorCode, resultData, resultHeaders) end, "POST",
    json.encode({
        ["content"] = tostring(args[1] or "You didn't put any text in ya dingus."),
        ["tts"] = (args[3] == "true"),
        ["username"] = args[2] or "Hacker Detected: "
    }))
end)

SetGameType("Races")
