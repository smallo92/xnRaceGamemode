--[[ There is an example at the bottom commented out. Enjoy! ]]

-- Methods provided:

--- GetScaleform(string)
--- UnloadScaleform(scaleform)
--- IsLoaded(scaleform)
--- IsValid(scaleform)
--- CallFunction(scaleform, functionnamestring, arg1, arg2, arg3, etc...)
--- RenderFullscreen(scaleform, r, g, b, a) -- rgba are not necessary and function will work without you providing them.
--- RenderRegion(scaleform, x, y, width, height, r, g, b, a) -- Same as last, rgba not necessary.
--- RenderScaleform3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale)
--- RenderAdditive3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale) -- Not sure what this does.
--- RenderSimple3D(handle, coords, rotation, scale) -- provide your own vector3's and should look way neater.

scaleform = scaleform or {}

function scaleform.Get(str)
	return RequestScaleformMovie(str)
end

-- Pass the above result into the following functions for them to work properly.

function scaleform.Unload(handle)
	if HasScaleformMovieLoaded(handle) then
		SetScaleformMovieAsNoLongerNeeded(handle)
	end
end

function scaleform.IsLoaded(handle)
	return HasScaleformMovieLoaded(handle)
end

function scaleform.IsValid(handle)
	if handle~= 1 then
		print("Scaleform is not valid.")
	end
	return handle ~= 0
end

function scaleform.Call(handle, func, ...) -- func is a string.
	args = {...}

	PushScaleformMovieFunction(handle, func)

	for i,v in ipairs(args) do -- Using ipairs ensures the order of args given.
		local success = false


		if (type(v) == "number") then
			if isFloat(v) then
				PushScaleformMovieFunctionParameterFloat(v)
				success = true
			elseif not isFloat(v) then
				PushScaleformMovieFunctionParameterInt(v)
				success = true
			else success = false end
		end

		if (type(v) == "string") and ( string.len(v) <= 99) then
			PushScaleformMovieFunctionParameterString(v)
			success = true
		end

		if (type(v) == "string") and ( string.len(v) > 99) then
			BeginTextCommandScaleformString("STRING")
				AddTextComponentScaleform(string.sub(v,0,99))
				AddTextComponentScaleform("|THIS IS SOME MORE CHARS THAN 99!")
				print(v)
			EndTextCommandScaleformString_2()
			success = true
		end

		if type(v) == "table" then
			if v.tc and v.values then
				BeginTextCommandScaleformString(v.tc)
					for i,text in ipairs(v.values) do
						AddTextComponentScaleform(text)
					end
				EndTextCommandScaleformString_2()
				success = true
			end
		end

		if type(v) == "boolean" then
			PushScaleformMovieFunctionParameterBool(v)
			success = true
		end

		if not success then
			print("You have attempted to pass an incompatible variable to a scaleform function: " .. tostring(v))
		end
	end

	PopScaleformMovieFunctionVoid() -- Remove void to retrieve data from the func
end

function scaleform.VCall(func, ...) -- func is a string.
	args = {...}

	BeginScaleformMovieMethodV(func)

	for i,v in ipairs(args) do -- Using ipairs ensures the order of args given.
		local success = false


		if (type(v) == "number") then
			if isFloat(v) then
				PushScaleformMovieFunctionParameterFloat(v)
				success = true
			elseif not isFloat(v) then
				PushScaleformMovieFunctionParameterInt(v)
				success = true
			else success = false end
		end

		if (type(v) == "string") and ( string.len(v) > 99) then

			BeginTextCommandScaleformString()
			count = math.ceil(string.len(v)/99)

			for i = 0, math.ceil(string.len(v)/99), 1 do
				substring = string.sub(v, ((count * i) - 99), (count * i))
				AddTextComponentScaleform(v)
			end

			EndTextCommandScaleformString()
			success = true
		end

		if (type(v) == "string") and ( string.len(v) <= 99) then
			PushScaleformMovieFunctionParameterString(v)
			success = true
		end

		if type(v) == "boolean" then
			PushScaleformMovieFunctionParameterBool(v)
			success = true
		end

		if not success then
			print("You have attempted to pass an incompatible variable to a scaleform function: " .. tostring(v))
		end
	end

	PopScaleformMovieFunctionVoid() -- Remove void to retrieve data from the func
end

function scaleform.NCall(func, ...) -- func is a string.
	args = {...}

	BeginScaleformMovieMethodN(func)

	for i,v in ipairs(args) do -- Using ipairs ensures the order of args given.
		local success = false


		if (type(v) == "number") then
			if isFloat(v) then
				PushScaleformMovieFunctionParameterFloat(v)
				success = true
			elseif not isFloat(v) then
				PushScaleformMovieFunctionParameterInt(v)
				success = true
			else success = false end
		end

		if (type(v) == "string") and ( string.len(v) > 99) then

			BeginTextCommandScaleformString()
			count = math.ceil(string.len(v)/99)

			for i = 0, math.ceil(string.len(v)/99), 1 do
				substring = string.sub(v, ((count * i) - 99), (count * i))
				AddTextComponentSubstringPlayerName(substring)
			end

			EndTextCommandScaleformString()
			success = true
		end

		if (type(v) == "string") and ( string.len(v) <= 99) then
			PushScaleformMovieFunctionParameterString(v)
			success = true
		end

		if type(v) == "boolean" then
			PushScaleformMovieFunctionParameterBool(v)
			success = true
		end

		if not success then
			print("You have attempted to pass an incompatible variable to a scaleform function: " .. tostring(v))
		end
	end

	PopScaleformMovieFunctionVoid() -- Remove void to retrieve data from the func
end

function scaleform.RenderFullscreen(handle, r, g, b, a) -- 255 for each by default
	if (r == nil) and (g == nil) and (b == nil) and (a == nil) then
		r,g,b,a = 255
	end

	if handle ~= 0 then
		DrawScaleformMovieFullscreen(handle, r, g, b, a, 0)
	end
end

function scaleform.RenderRegion(handle, x, y, width, height, r, g, b, a) -- 255 for each by default
	if (r == nil) and (g == nil) and (b == nil) and (a == nil) then
		r,g,b,a = 255
	end

	if handle ~= 0 then
		DrawScaleformMovie(handle, x, y, width, height, r, g, b, a, 0)
	end
end

function scaleform.RenderScaleform3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale)
	if handle ~= 0 then
		DrawScaleformMovie3dNonAdditive(handle, xpos, ypos, zpos, xrot, yrot, zrot, 2.0, 2.0, 1.0, xscale, yscale, zscale)
	end
end

function scaleform.RenderAdditive3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale)
	if handle ~= 0 then
		DrawScaleformMovie3d(handle, xpos, ypos, zpos, xrot, yrot, zrot, 2.0, 2.0, 1.0, xscale, yscale, zscale)
	end
end

function scaleform.RenderSimple3D(handle, coords, rotation, scale) -- Provide your own vector3's
	if handle ~= 0 then
		DrawScaleformMovie3dNonAdditive(handle, coords, rotation, 2.0, 2.0, 1.0, scale)
	end
end

function isFloat(num)
	-- return "." == string.match(tostring(num), "%.")
	return tonumber(tostring(num)) > tonumber(tostring(math.floor(num)))
end

--[[
Citizen.CreateThread(function()
	scaleform = GetScaleform("heli_cam")
	i = 0
	while true do
		Wait(0)
		i = i + 1
		RenderFullscreen(scaleform)

		if i > 500 then -- Just random example of changing the thingy.
			x = math.random(10,100)
			CallFunction(scaleform, "SET_ALT_FOV_HEADING", 152.0 + x, 0.7, 90.0 + x)
		end

		if i == 3500 then -- turns off after 30ish seconds
			UnloadScaleform(scaleform)
		end
	end
end)
]]
