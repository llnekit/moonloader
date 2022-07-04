local sampev = require 'samp.events'

local inventoryWait = 250 	-- �������� ��� �������������� � ��������� (� ��)
local dialogWait = 500 		-- �������� ��� �������������� � ��������� (� ��)
local sellDialogWait = 400 	-- �������� ��� �������������� � ��������� ��� ����������� (� ��)
local startCommand = "fgo" 	-- ������� ���������
local stopCommand = "fstop" -- ������� ���������
local sellCommand = "fsell" -- ������� �����������
local changePressWayCommand = "fcpw" -- ������� ����� ������� ������� �� ������ N

local errorEcholotEnitFail = "������: ������ �� ������ � ���������"
local errorEcholotClickFail = "������: ������ ��� ��������� � ������ ������. ������� �����..."
local errorFisherWrongDialog = "������: ����������� ������ �� ��� ���������"
local echolotInintMessage = "����������� �������..."
local echolotInintMessageSuccess = "������ ������� ���������������"
local errorFishNotFound = "������: � ������ ������ ����������� ����"
local errorBaitNotFound = "������: � ��� ����������� ����������� �������"
local errorFishingTackleNotFound = "������: � ��� ����������� ����������� ��������� ��� �������"
local fisherSuccesThrow = "������ ������� ���������"
local fisherStoped = "������ ����������"
local errorCantWork = "������: ������ �� ����� ���������� ������"
local pressWayChanged = "������� ������ ������� �� ������� N"

function toChat(message)
	sampAddChatMessage("{FFFFFF}[{9933FF}FisherMan{FFFFFF}]: "..message, -1)
end

--========================================== ECHOLOT ==========================================--

-- ������ �������, ������ ID ���������� �������� � ������ � ������� ���������
local echolot = {pageTextDrawId = -1, slotTextDrawId = -1}

-- ���� �� ������ 
function echolot.click()
	wait(inventoryWait*2)
	sampSendClickTextdraw(echolot.pageTextDrawId)
	wait(inventoryWait*2)
	
	-- �������� �� ��, ��� � ������ ������ ��������� ������ 
	mode, roX, _, _, _, _, _ = sampTextdrawGetModelRotationZoomVehColor(echolot.slotTextDrawId)
	_, outlinecolo = sampTextdrawGetOutlineColor(echolot.slotTextDrawId)
	if mode == 18875 and roX == 263 and outlinecolo == 4284874850 then
		sampSendClickTextdraw(echolot.slotTextDrawId)
		wait(inventoryWait)
		sampSendClickTextdraw(2302)
	else -- ���� ��� ��������� - �������������� ������
		toChat(errorEcholotClickFail)
		echolot.pageTextDrawId = -1 
		echolot.slotTextDrawId = -1
		if not echolot.init() then
			return false
		end
		sampSendClickTextdraw(echolot.slotTextDrawId)
		wait(inventoryWait)
		sampSendClickTextdraw(2302)
	end
	
	return true
	
end
-- ����� ������� � ���������
function echolot.findInInventory()
	for pageNum = 2107, 2110 do
		wait(inventoryWait)
		sampSendClickTextdraw(pageNum)
		wait(inventoryWait)
		for id = 2142, 2207 do
			if sampTextdrawIsExists(id) then
				mode, roX, _, _, _, _, _ = sampTextdrawGetModelRotationZoomVehColor(id)
				_, outlinecolo = sampTextdrawGetOutlineColor(id)

				if mode == 18875 and roX == 263 and outlinecolo == 4284874850 then
					echolot.pageTextDrawId = pageNum
					echolot.slotTextDrawId = id
					return true
				end
			end
		end
	end
	
	return false
end
-- ������������� �������
function echolot.init()
	wait(inventoryWait)
	sampSendChat("/invent")
	wait(inventoryWait)
	-- ���� ������ ������ � ��������� - ���������� true
	if not echolot.findInInventory() then
		toChat(errorEcholotEnitFail)
		return false
	end
	return true
end
-- ������������� �������
function echolot.use()
	-- ���� ������ �� ���������������
	if echolot.pageTextDrawId == -1 or echolot.slotTextDrawId == -1 then
		toChat(echolotInintMessage)
		if not echolot.init() then
			return false
		else  -- ���� ������������� ������ ������� - ������� �� ����
			toChat(echolotInintMessageSuccess)
			-- ���� ������� �������� �� ������
			if echolot.click() then
				return true
			end
		end
	else -- ���� ��� ��� ��������������� - ������� �� ����
		sampSendChat("/invent")
		wait(inventoryWait*2)
		-- ���� ������� �������� �� ������
		if echolot.click() then
			return true
		end
	end
	return false
end

--=============================================================================================--

--======================================== AUTOFISHING ========================================--

local fisher = {
	-- ������ ��� � ������� � ���, ���������� �� �������
	-- ��������� ���������:
	-- baitList = 
	-- {
	--    {name = "����1", baits = {"�������1", "�������2", "�������3"}}
	--    {name = "����2", baits = {"�������1", "�������2", "�������3"}},
	-- }
	baitList = {}
}
-- �������� ��� �� ������ ������
function fisher.checkDialog(id)
	if sampGetCurrentDialogId() == tonumber(id) then 
		return true
	end
	toChat(errorFisherWrongDialog)
	
	if id == 0 then 
		toChat("�� ������� ������� ������ �������. �������� �������...")
		sampCloseCurrentDialogWithButton(0)
		autoFishing:run()
	end
	
	if id == 25285 then 
		toChat("�� ������� ������� ������ �� �������� (/fishrod). �������� �������...")
		sampCloseCurrentDialogWithButton(0)
		autoFishing:run()
	end
	
	if id == 25286 then 
		toChat("�� ������� ������� ������ � ��������. �������� �������...")
		sampCloseCurrentDialogWithButton(0)
		autoFishing:run()
	end

	return false
end
-- ������� ������� � ����� � ����� ������
function fisher.parseEcholotDialog()
	-- ��������� ������ �� ������ � �����
	wait(dialogWait)
	if not fisher.checkDialog(0) then
		return false
	end
	
	local str = sampGetDialogText() -- �������� ���� ����� �������
	
	local counter = 1
	
	for line in str:gmatch('[^\n]+') do -- �������� ������� ����� �� �������� ������
		local num, fishName, f1, f2, f3 = line:match("{73B461}(%d+). {cccccc}(%W*){ffffff} ����� �� {73B461}(%W*)%s+/%s+(%W*)%s+/%s+(%W*)")
		if num then
			fisher.baitList[counter] = {name = fishName, baits = {f1, f2, f3}}
			counter = counter + 1
		end
		
		
	end

	if #fisher.baitList == 0 then 
		toChat(errorFishNotFound)
		sampCloseCurrentDialogWithButton(1)
		return false
	end
	
	
	
	-- ��������� ������
	sampCloseCurrentDialogWithButton(1)
	return true
	
end
-- ����� �������
function fisher.choseBait()
	wait(dialogWait)
	sampSendChat("/fishrod")
	wait(dialogWait)
	if fisher.checkDialog(25285) then
	
		local str = sampGetDialogText() -- �������� ���� ����� �������
		
		-- �������� ������� ������������� �������
		local currentBait = str:match("�������	(%W+)%s+{")
		
		-- ���� ������� �����������
		if currentBait then 
			-- ���� ������������� ������� ��������
			for i = 1, #fisher.baitList, 1 do 
				for j = 1, 3, 1 do
					if fisher.baitList[i].baits[j] == currentBait then 
						return true
					end
				end
			end
		end
		-- ��������� � ������ � ������� �������
		sampSendDialogResponse(25285, 1, 6, -1)
		
		-- ������ ������ � �������� � �������� �
		if not fisher.parseBaitDialog() then -- ���� �� ���������� - �������
			return false
		end
		
		wait(dialogWait)
		sampCloseCurrentDialogWithButton(0) -- ������������ �����
		wait(dialogWait)
		--toChat("�����")
		return true
	end
	
	return false
	
end
-- ������� ������� � ��������
function fisher.parseBaitDialog ()
	-- ��������� ������ �� ������ � ��������
	wait(dialogWait)
	if not fisher.checkDialog(25286) then
		return false
	end
	
	local str = sampGetDialogText() -- �������� ���� ����� �������

	local counter = 0
	
	for line in str:gmatch('[^\n]+') do -- �������� ������� ����� �� �������� ������
		local baitName, baitQuantity = line:match("%{......%}(%W+)	%{......%}(%d+)%{......%}")
		if baitName then 
			for i = 1, #fisher.baitList do 
				for j = 1, 3 do
					if fisher.baitList[i].baits[j] == baitName and tonumber(baitQuantity) ~= 0 then
						sampSendDialogResponse(25286, 1, counter - 1, -1)
						return true
					end
				end
			end
		end
		counter = counter + 1
	end
	
	
	-- ��������� ������
	toChat(errorBaitNotFound)
	fisher.showNeedBaits()
	sampCloseCurrentDialogWithButton(0)
	wait(dialogWait)
	sampCloseCurrentDialogWithButton(0)
	return false
end
-- ������� � ��� ������������� �������
function fisher.showNeedBaits()
	for i = 1, #fisher.baitList do 
		local tmp = ""
		for j = 1, 3 do
			if not fisher.baitList[i].baits[j]:find("�����������") and fisher.baitList[i].baits[j] ~= " " then 
				if tmp == "" then 
					tmp = fisher.baitList[i].baits[j]
				else
					tmp = tmp..", "..fisher.baitList[i].baits[j]
				end
			end
			
		end
		toChat("��������� ������� ��� "..fisher.baitList[i].name..": "..tmp)
	end
end
-- ����������� ������
function fisher.throwFishRod ()
	if not fisher.checkDialog(25285) then 
		return false
	end
	
	local str = sampGetDialogText() -- �������� ���� ����� �������
	
	if str:find("�����������") then 
		toChat(errorFishingTackleNotFound)
		wait(dialogWait)
		sampCloseCurrentDialogWithButton(0)
		return false
	end
	wait(dialogWait*2)
	-- ���������� ������
	sampSendDialogResponse(25285, 1, 7, -1)
	
	
	wait(dialogWait)
	-- ��������� ������ � ���������� � �������
	sampCloseCurrentDialogWithButton(0)
	return true
end

-- �����������
function fisher.autoSell()
	local regx = ""
	local mainDialog = -1

	if sampGetCurrentDialogId() == 25296 then  -- ���������
		mainDialog = 25290
		regx = "%{......%}(%W+)	%{......%}(%d+) ������ �����%{......%}	%{......%}(%d+) ��."
	elseif sampGetCurrentDialogId() == 25291 then -- ����
		mainDialog = 25291
		regx = "%{......%}���� '(%W+)'	%{......%}$(%d+)%{......%}	%{......%}(%d+) ��."
	end
	if mainDialog ~= -1 then 
		lua_thread.create(function ()
			wait(sellDialogWait)
			if sampGetCurrentDialogId() == 25296 then
				wait(sellDialogWait)
				sampSendDialogResponse(25296, 1, 0, -1)
				wait(sellDialogWait)
			end
			
			local str = sampGetDialogText() -- �������� ���� ����� �������
			local counter = 0
			
			for line in str:gmatch('[^\n]+') do -- �������� ������� ����� �� �������� ������
				local _, _, quan = line:match(regx)
				if quan ~= nil then
					if tonumber(quan) > 0 then
						wait(sellDialogWait)
						sampSendDialogResponse(mainDialog, 1, counter - 1, -1)
						wait(sellDialogWait)
						sampSetCurrentDialogEditboxText(quan)
						wait(sellDialogWait)
						sampCloseCurrentDialogWithButton(1)
						wait(sellDialogWait)
						sampCloseCurrentDialogWithButton(1)
						
						wait(sellDialogWait)
						setGameKeyState(21, 1)
						wait(0)
						setGameKeyState(21, 0)
						wait(3)
						wait(sellDialogWait)
						if sampGetCurrentDialogId() == 25296 then 
							sampSendDialogResponse(25296, 1, 0, -1)
							wait(sellDialogWait)
						end
						
					end
				end
				counter = counter + 1
			end
			
			sampCloseCurrentDialogWithButton(0)
			wait(sellDialogWait)
			sampCloseCurrentDialogWithButton(0)
		end)
	end
end

autoFishing = lua_thread.create_suspended(function ()
	fisher.baitList = {}
	-- ���� ������� ������������ ������
	if echolot.use() then
		print("������")
		-- ��������� ���������
		wait(inventoryWait)
		sampSendClickTextdraw(2111)
		-- ������ ������ � �����
		if fisher.parseEcholotDialog() then -- ���� ������� � ���� ����
			-- �������� ������ �������
			if fisher.choseBait() then
				-- ���������� ������
				if fisher.throwFishRod() then
					toChat(fisherSuccesThrow)
				end
			end
		end
	end
end)

--=============================================================================================--

local sriptIsActive = false

function sampev.onServerMessage (color, text)
	-- ���� ���������� ���������, ���������� ��������, ��� ���� ��� �������
	if text:find("��� ��������� ������������!") or text:find("��� �������� ����������") or text:find("��� ���� ��� �������") then 
		toChat(errorCantWork)
		autoFishing:terminate()
		sriptIsActive = false
	end

	if fishing:status() == "yielded" then
		if text:match('�������� �� �������') then 
			fishing:terminate()
		end
		
		-- ���� ������ �������
		if scriptIsActive then
			-- ���� ������ ���������������
			if echolot.pageTextDrawId ~= -1 and echolot.slotTextDrawId ~= -1 then
				if text:find("�� �������") then 
					autoFishing:run()
				end
			end
		end
	end
end

-- ���� ���� ������� - ������� ���������� ����� stateKey
local pressWithStateKey = true

function pressNButton()
	if pressWithStateKey then
		for i = 1, 4, 1 do 
			setGameKeyState(10, 1)
			wait(0)
			setGameKeyState(10, 0)
			wait(3)
		end
	else
		local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local data = allocateMemory(68)
		sampStorePlayerOnfootData(myId, data)
		setStructElement(data, 36, 1, 128, false)
		sampSendOnfootData(data)
		freeMemory(data)
	end
end


fishing = lua_thread.create_suspended(function ()
			local isPecks = false
			
			while true do
				wait(0)
				
				pressNButton()
				
				if sampTextdrawIsExists(2063) and not isPecks then 
					isPecks = true
				end
				
				if isPecks and not sampTextdrawIsExists(2063) then
					return
				end
				
			end
		end)

function sampev.onDisplayGameText(style, time, text)
	if text:find("PRESS N") then
		fishing:run()
	end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	-- ����������� �����
	sampRegisterChatCommand(startCommand, function()
		autoFishing:terminate()
		scriptIsActive = true
		autoFishing:run()
	end)
	
	-- ����������� ����
	sampRegisterChatCommand(stopCommand, function()
		autoFishing:terminate()
		toChat(fisherStoped)
		scriptIsActive = false
	end)
	
	-- �����������
	sampRegisterChatCommand(sellCommand, function()
		fisher.autoSell()
	end)
	
	-- ��������� ������� ������� �� N
	sampRegisterChatCommand(changePressWayCommand, function()
		pressWithStateKey = not pressWithStateKey
		toChat(pressWayChanged)
		if pressWithStateKey then
			toChat("������� ������ - ��� ������")
		else
			toChat("������� ������ - ��� �����")
		end
	end)
	
end

