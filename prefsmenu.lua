-- This menu on 1 hand, part of xnRace but also an experiment to see if client side (kvp) natives work good enough...

xnRace = xnRace or {}

local retrivedPrefs = json.decode(GetResourceKvpString("preferences") or "[]")
if retrivedPrefs ~= json.decode("[]") then
    xnRace.Prefs = retrivedPrefs
else
    xnRace.Prefs = {
        -- Put all preferences here
        defaultRadio = 256,
        colour1 = "RANDOM",
        colour2 = "RANDOM",
    }
    SetResourceKvp("xnRace:preferences", json.encode(xnRace.Prefs))
end

local colours = {
	{"Black", 12},
	{"Gray", 13},
	{"Light Gray", 14},
	{"Ice White", 131},
	{"Blue", 83},
	{"Dark Blue", 82},
	{"Midnight Blue", 84},
	{"Midnight Purple", 149},
	{"Schafter Purple", 148},
	{"Red", 39},
	{"Dark Red", 40},
	{"Orange", 41},
	{"Yellow", 42},
	{"Lime Green", 55},
	{"Green", 128},
	{"Frost Green", 151},
	{"Foliage Green", 155},
	{"Olive Darb", 152},
	{"Dark Earth", 153},
	{"Desert Tan", 154},
}

local radioStations_selected = xnRace.Prefs.defaultRadio or 17
local radioStations_current = xnRace.Prefs.defaultRadio or 17
local radioStations = {
    -- Native radio names because why not...
    [0] = GetLabelText("RADIO_01_CLASS_ROCK"),
    GetLabelText("RADIO_02_POP"),
    GetLabelText("RADIO_04_PUNK"),
    GetLabelText("RADIO_05_TALK_01"),
    GetLabelText("RADIO_06_COUNTRY"),
    GetLabelText("RADIO_07_DANCE_01"),
    GetLabelText("RADIO_08_MEXICAN"),
    GetLabelText("RADIO_09_HIPHOP_OLD"),
    GetLabelText("RADIO_12_REGGAE"),
    GetLabelText("RADIO_13_JAZZ"),
    GetLabelText("RADIO_14_DANCE_02"),
    GetLabelText("RADIO_15_MOTOWN"),
    GetLabelText("RADIO_20_THELAB"),
    GetLabelText("RADIO_16_SILVERLAKE"),
    GetLabelText("RADIO_18_90S_ROCK"),
    GetLabelText("RADIO_11_TALK_02"),

    GetLabelText("RADIO_OFF"),
    GetLabelText("FMMC_VEH_RAND"),
}

local function SavePrefs()
    SetResourceKvp("preferences", json.encode(xnRace.Prefs))
end

Citizen.CreateThread(function()
    WarMenu.CreateMenu('xnRace:Pref', 'Preferences')
	WarMenu.SetSubTitle('xnRace:Pref', "main menu")
    WarMenu.SetMenuWidth('xnRace:Pref', 0.5)

	while true do
		if WarMenu.IsMenuOpened('xnRace:Pref') then
            if WarMenu.ComboBox("Default Radio Station", radioStations,radioStations_current,radioStations_current,function(current,selected)
                radioStations_current = current or 0
                radioStations_selected = selected or 0

                --if radioStations_current >= 16 and radioStations_current < 255 then
                    --radioStations_current = 255
                --end
            end) then
                xnRace.Prefs.defaultRadio = radioStations_selected
                SavePrefs()
            end


            if WarMenu.Button("Print Preferences") then print(json.encode(xnRace.Prefs)) end
        WarMenu.Display()

        elseif IsControlJustReleased(0, 167) then
            WarMenu.OpenMenu("xnRace:Pref")
        end

		Citizen.Wait(0)
	end
end)
