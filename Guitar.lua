midiParser = require( "midi-parser" )
insp = require( "inspect" )


local DEF_PATH = getWorkingDirectory().."\\MIDI\\";

---- НОТЫ ----
local notes = {}
notes[0] = 178
notes[1] = 178
notes[2] = 202
notes[3] = 202
notes[4] = 186
notes[5] = 186
notes[6] = 210
notes[7] = 210
notes[8] = 194
notes[9] = 194
notes[10] = 255
notes[11] = 255


function playNote (noteNumber)
	local note = tonumber(noteNumber) % 12
	sampSendClickTextdraw(notes[note])
end

local defPressDelay = 100

function playPart (partTab)
	for i = 1, #partTab, 1 do
		if (partTab[i].type == "on") then
			playNote(partTab[i].number)
			
		end
		wait(partTab[i].time + defPressDelay)
	end
end

function PlaySong ()
	wait(0)
	
	local midi = midiParser( DEF_PATH.."g.mid" )
	
	local file = io.open(DEF_PATH.."cum.txt", "w")
	file:write(insp.inspect(midi))
	file:close()
	
	
	local tracks = midi['tracks']
	--local channels = 
	--local curChannel = 4
	-- local timeBase = midi.timebase
	-- local tempo = tracks[1]['messages'][2].tempo
	-- local timePerTick = 60000 / (timeBase * tempo)
	
	
	for i = 1, #tracks, 1 do 
		lua_thread.create(playPart, tracks[i]['messages'])
	end
	
	-- for i = 1, #tracks[curChannel]['messages'], 1 do
		-- if (tracks[curChannel]['messages'][i].type == "on") then
			-- playNote(tracks[curChannel]['messages'][i].number)
		-- else
			-- wait(tracks[curChannel]['messages'][i].time)
		-- end
		
	-- end
	
	
end

parse_and_play = lua_thread.create_suspended (PlaySong)

function main()
    while not isSampAvailable() do wait(0) end
	
	sampRegisterChatCommand('ggg', guitare)


	
	wait(-1)
end


function guitare()
	parse_and_play:run()
end


