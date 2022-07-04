-- время указывать в милисекундах
local waitTime = 0
local event = require 'lib.samp.events'
local bool = false

function event.onShowTextDraw(id, data)
	if id == 2067 and data.text == 'your progress' and not bool then
		bool = true
		lua_thread.create(ballon, id)
	end
end

function ballon(id)
	while not sampTextdrawIsExists(id) do wait(0) end
	while sampTextdrawIsExists(id) do
		setGameKeyState(21, 255)
		setGameKeyState(16, 255)
		setGameKeyState(9, 255)
		wait(waitTime)
		setGameKeyState(21, 0)
		wait(waitTime)
		setGameKeyState(16, 0)
		wait(waitTime)
		setGameKeyState(9, 0)
	end
	bool = false
end