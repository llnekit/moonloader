local sampev = require 'samp.events'

local sendingMessage = ""

function vrSendFunction()
	
	while true do
		wait(200)
		sampSendChat("/vr "..sendingMessage)
	end
end

function sampev.onServerMessage (color, text)
	local result, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if text:find(sendingMessage) and text:find(pid) then 
		vrSend:terminate()
	end
end
vrSend = lua_thread.create_suspended (vrSendFunction)

function re ()
	lua_thread.create(function ()
		wait(math.random(2000, 8000))
		sampDisconnectWithReason(quit)
		wait(math.random(7000, 16000))
		sampSetGamestate(1)
	end)
end

function main()
    while not isSampAvailable() do wait(0) end
	
	sampRegisterChatCommand('vr', function(param) sendingMessage = param; vrSend:run() end)				
	sampRegisterChatCommand('re', re)
	
	lua_thread.create(function ()
		while true do
			wait(10*60*1000)

			local text, prefix, color, pcolor = sampGetChatString(99)
			if (text == "Сервер закрыл соединение." or text == "Wrong server password.") and color == 4289316068 then 
				re()
			end
			
		end
	end)
	
	wait(-1)
end
