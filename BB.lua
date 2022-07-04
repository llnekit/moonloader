

function BBB ()
	while true do
		wait(0)
		setVirtualKeyDown(18,true) -- alt = 18
		wait (1)
		setVirtualKeyDown(18,false)
		
		setVirtualKeyDown(13,true) -- shift = 16    alt = 18
		wait (1)
		setVirtualKeyDown(13,false) -- enter = 13

	end
end

BOB = lua_thread.create_suspended(BBB)


function main()
    while not isSampAvailable() do wait(0) end
	
	sampRegisterChatCommand("bbb", function () BOB:run() end)
	
	wait(-1)
end
