
local ID_RENDERED_PLAYER = 0
local id = PLAYER_HANDLE
render_objects = 
{
	{id = 348, name = 'Deagle'},
	{id = 356, name = 'M4'},
	{id = 349, name = 'ShotGun'},
	{id = 357, name = 'Cuntgun'},
	{id = 358, name = 'Sniper'},
	{id = 19315, name = 'ќлень пепега'},
	{id = 2680, name = ' лад'},
	{id = 924, name = 'ќсколок €щика'},
	{id = 2903, name = 'дроп'},
	{id = 18849, name = 'дроп'},
	--{id = 19341, name = 'яйца 1'},
	{id = 19343, name = 'яйца 2'},
	--{id = 19344, name = 'яйца 3'},
	--{id = 19345, name = 'яйца 4'},
	--{id = 19342, name = 'яйца 5'},
	
	
	{id = 859, name = 'SEMEN'}
	
	
}
local font = renderCreateFont("Arial", 15, 4)

function My_rend (dx1, dy1, dz1, dx2, dy2, dz2, name)
	local x1, y1 = convert3DCoordsToScreen(dx1,dy1,dz1)
	local x2, y2 = convert3DCoordsToScreen(dx2,dy2,dz2)
	distance = string.format("%.0f", getDistanceBetweenCoords3d(dx1,dy1,dz1, dx2, dy2, dz2))
	renderDrawBoxWithBorder(x1 -25, y1 - 25, 50, 50, 0x00000000, 5, 0xFFD00000) 
	renderFontDrawText(font, name, x1 - (string.len(name) * 6), y1 + 30, 0xFFEEDDD0)
	renderFontDrawText(font, distance, x1 - 7, y1 + 55, 0xFFFFFF00) 
	renderDrawLine(x2, y2, x1, y1, 3, 0xFFD00000) 
end



function Detect ()
	while true do 
		wait(0)
		
		for _, obj in pairs(getAllObjects()) do
			if (sampGetObjectHandleBySampId(obj) ~= -1) then
				local objmodel = getObjectModel(obj)
				
				
				-- if isObjectOnScreen(obj) then 
					-- local _, eX, eY, eZ = getObjectCoordinates(obj)
					-- local pX,pY,pZ = getCharCoordinates(PLAYER_PED)
					-- My_rend (eX, eY, eZ, pX, pY, pZ, obj)
				-- end
				for i = 1, #render_objects, 1 do 
					if objmodel == render_objects[i].id then
						if isObjectOnScreen(obj) then 
							local _, eX, eY, eZ = getObjectCoordinates(obj)
							local pX,pY,pZ = getCharCoordinates(PLAYER_PED)
							My_rend (eX, eY, eZ, pX, pY, pZ, render_objects[i].name)
						end
					end
				end
			end
		end
	end
end

-- as_action = require('moonloader').audiostream_state
-- aboba = loadAudioStream(getWorkingDirectory()..'\\jopa.mp3')
-- setAudioStreamVolume(aboba, 40)
	
	
-- search = {'Aventador', 'aventador', 'јвентадор', 'авентадор'}

-- require('samp.events').onServerMessage = function (color, text)
	-- for i = 1, #search do 
		-- if text:find(search[i], 1, true) then 
			-- setAudioStreamState(aboba, as_action.PLAY)
		-- end
	-- end
-- end


function Stream ()
	-- require('samp.events').onServerMessage = function (color, text)
		
		-- if text:find('['..ID_RENDERED_PLAYER..']', 1, true) then 
			-- setAudioStreamState(aboba, as_action.PLAY)
		-- end
		-- return {color, text}
	-- end
	local sX, sY = getScreenResolution()
	local _, me = sampGetPlayerIdByCharHandle(PLAYER_PED)
	while true do
	wait(0)
		for _, handle in ipairs(getAllChars()) do
			local _, id = sampGetPlayerIdByCharHandle(handle)
			if id == ID_RENDERED_PLAYER and isCharOnScreen(handle) then
				local pX,pY,pZ = getCharCoordinates(PLAYER_PED)
				local opX,opY,opZ = getCharCoordinates(handle)
				
				
				
				local x1, y1 = convert3DCoordsToScreen(opX,opY,opZ)
				local x2, y2 = convert3DCoordsToScreen(pX,pY,pZ)

				My_rend (opX, opY, opZ, pX, pY, pZ, sampGetPlayerNickname(id))
			end
		end
	end
end

Render = lua_thread.create_suspended(Detect)
Render_To_Player = lua_thread.create_suspended (Stream)

function SetSkin(param)
	local Model_ID = tonumber(param)
	if Model_ID < 0 or Model_ID == 74 or Model_ID > 311 then return end
	requestModel(Model_ID)
	loadAllModelsNow()
	setPlayerModel(PLAYER_HANDLE, Model_ID)
end

function main()
	
    while not isSampAvailable() do wait(0) end
	sampRegisterChatCommand("ss", Cheat)
	
	
	
	wait(-1)
end



function Cheat (param)
	
	local a = {}
	local counter = 1
	
	for strNumber in string.gmatch(param, "%d+") do
		a[counter] = tonumber(strNumber)
		counter = counter + 1
	end
	if(a[1] == 1) then Render:run() end
	if(a[1] == 2) then ID_RENDERED_PLAYER = a[2] Render_To_Player:run() end
	if(a[1] == 0) then
		if Render:status() == 'yielded' then Render:terminate() end
		if Render_To_Player:status() == 'yielded' then Render_To_Player:terminate() end
		ID_RENDERED_PLAYER = -1
	end
	if(a[1] >= 3) then SetSkin(a[1]) end
end