
local flag = true

function prokrutka_jopi()
	if sampTextdrawIsExists(2091) then
	
		local MAX_GOOD_SLOTS = 7
		local all_slots = {2111, 2113, 2115, 2117, 2119, 2121, 2123, 2125, 2127, 2129, 2131, 2133, 2135, 2137, 2139, 2141}
		local good_slots_models_id = {19057, 1314}
		local keys_num = {2118, 2138, 2126} -- ��� ��������� Id ��������� ����������� �� ����
		local keys_value = {}
		for i = 1, #keys_num do 
			keys_value[i] = sampTextdrawGetString(keys_num[i]) -- ��� ������������ ����� � ����������� �� Id �� ������� �������
		end
		--sampTextdrawGetModelRotationZoomVehColor
		while tonumber(sampTextdrawGetString(2104)) > 0 do -- ���� ���-�� ������� ������ 0
			wait(1000)
			sampSendClickTextdraw(2091) -- ������-������
			wait(12000)
			
			-- ��� ����� ���� ��� ���������, ���� flag = true
			if flag then
				
				local gcount = 0
				for i = 1, #all_slots do 
					local model_id, _, _, _, _, _, _ = sampTextdrawGetModelRotationZoomVehColor(all_slots[i])
					for j = 1, #good_slots_models_id do 
						if (model_id == good_slots_models_id[j]) then 
							gcount = gcount + 1
						end
					end
				end
				if (gcount >= 7) then 
					flag = false
				else
					sampSendClickTextdraw(2105)
					wait(1000)
					if sampIsDialogActive() then 
						if sampGetCurrentDialogId() == 9237 then
							local str = sampGetDialogText();
							if (str:find("0")) then 
								sampCloseCurrentDialogWithButton(1)
							else
								sampCloseCurrentDialogWithButton(0)
							end
						end
					end
				end
			end
			
			for j = 1, #keys_num do 
				if sampTextdrawGetString(keys_num[j]) ~= keys_value[j] then -- ��� ��� �������� �� ������������ ����� ����������� ������ � ������������ � ����
					flag = true
				end -- � �� �������� ��� ��� ��������� ��� ����� Gold ���, ��� ��� ������ ��� ����� ����������
			end
			
			if sampTextdrawIsExists(2091) ~= true then return end -- ���� ����� ������� ������� - ������ ���� �����������
		end
	end
end

function cheats()
	
	
	while true do
		wait(0)
		while isKeyDown(82) do 
			setVirtualKeyDown(72,true)
			wait (10)
			setVirtualKeyDown(72,false)
			
			setVirtualKeyDown(13,true)
			wait (10)
			setVirtualKeyDown(13,false)
		end
	end
	
end

Krutelka = lua_thread.create_suspended (prokrutka_jopi)
aboba = lua_thread.create_suspended (cheats)


function main()
    while not isSampAvailable() do wait(0) end
	
	
	sampRegisterChatCommand('rulet', function () Krutelka:run() end)
	sampRegisterChatCommand('drovosek', drov)
	
	
	while true do
		wait(0)
		if isKeyDown(17) and isKeyDown(16) and isKeyDown(186) then
			sampSendChat("/anim 55");
			while isKeyDown(186) do 
				wait(0)
				setVirtualKeyDown(1,true)
				wait (10)
				setVirtualKeyDown(1,false)
			end
			wait (1)
			setVirtualKeyDown(70,true) 
			wait(10) 
			setVirtualKeyDown(70,false) 
			
		end
	end
	
	wait(-1)
end


function drov (param)
	if tonumber(param) == 1 then aboba:run() end
	if tonumber(param) == 2 then aboba:terminate() end
	
end