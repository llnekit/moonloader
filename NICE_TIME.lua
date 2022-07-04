
local hour = 0
local minute = 0

function Nice_Control ()
	
	while true do 
		wait(50)
		minute = minute + 1
		if(minute == 60) then hour = hour + 1 minute = 0 end
		if(hour == 24) then hour = 0 end
		
		print("HOUR: "..hour.."__MINUTE: "..minute)
	end
	hour = 0
	minute = 0
end


function Time_CC ()
	while true do 
		wait(0)
		setTimeOfDay(hour, minute)
	end
end

Nice_time = lua_thread.create_suspended(Nice_Control)
T_C = lua_thread.create_suspended(Time_CC)

function main()
    while not isSampAvailable() do wait(0) end
	
	sampRegisterChatCommand("nice",Nice)
	
	wait(-1)
end


function Nice (params)
	local jopa = tonumber(params)
	if(jopa == 1) then Nice_time:run() T_C:run() end
	if(jopa == 0) then Nice_time:terminate() T_C:terminate() end
end