local sampev = require 'samp.events'

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
end


function sampev.onDisplayGameText(style, time, text)
	if text:find('You are hungry!') or text:find('You are very hungry!') then
		sampSendChat('/jmeat')
	end
end
