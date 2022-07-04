local sampev = require 'samp.events'

local inventoryWait = 250 	-- ожидание при взаимодействии с инвентарём (в мс)
local dialogWait = 500 		-- ожидание при взаимодействии с диалогами (в мс)
local sellDialogWait = 400 	-- ожидание при взаимодействии с диалогами при автопродаже (в мс)
local startCommand = "fgo" 	-- команда активации
local stopCommand = "fstop" -- команда остановки
local sellCommand = "fsell" -- команда автопродажи
local changePressWayCommand = "fcpw" -- команда смены способа нажатия на кнопку N

local errorEcholotEnitFail = "Ошибка: Эхолот не найден в инвентаре"
local errorEcholotClickFail = "Ошибка: Эхолот был перемещен в другую ячейку. Начинаю поиск..."
local errorFisherWrongDialog = "Ошибка: Необходимый диалог не был обнаружен"
local echolotInintMessage = "Инициазация Эхолота..."
local echolotInintMessageSuccess = "Эхолот успешно инициализирован"
local errorFishNotFound = "Ошибка: в данном водоёме отсутствует рыба"
local errorBaitNotFound = "Ошибка: у вас отсутствует необходимая наживка"
local errorFishingTackleNotFound = "Ошибка: у вас отсутствует необходимый инвентарь для рабалки"
local fisherSuccesThrow = "Удочка успешно заброшена"
local fisherStoped = "Скрипт остановлен"
local errorCantWork = "Ошибка: скрипт не может продолжить работу"
local pressWayChanged = "Изменен способ нажатия на клавишу N"

function toChat(message)
	sampAddChatMessage("{FFFFFF}[{9933FF}FisherMan{FFFFFF}]: "..message, -1)
end

--========================================== ECHOLOT ==========================================--

-- объект Эхлолот, хранит ID текстдрава страницы и ячейки в которой находится
local echolot = {pageTextDrawId = -1, slotTextDrawId = -1}

-- клик на Эхолот 
function echolot.click()
	wait(inventoryWait*2)
	sampSendClickTextdraw(echolot.pageTextDrawId)
	wait(inventoryWait*2)
	
	-- проверка на то, что в данной ячейке находится Эхолот 
	mode, roX, _, _, _, _, _ = sampTextdrawGetModelRotationZoomVehColor(echolot.slotTextDrawId)
	_, outlinecolo = sampTextdrawGetOutlineColor(echolot.slotTextDrawId)
	if mode == 18875 and roX == 263 and outlinecolo == 4284874850 then
		sampSendClickTextdraw(echolot.slotTextDrawId)
		wait(inventoryWait)
		sampSendClickTextdraw(2302)
	else -- если был перемещен - инициализируем заново
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
-- поиск Эхолота в инвентаре
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
-- инициализация Эхолота
function echolot.init()
	wait(inventoryWait)
	sampSendChat("/invent")
	wait(inventoryWait)
	-- если Эхолот найден в инвентаре - возвращаем true
	if not echolot.findInInventory() then
		toChat(errorEcholotEnitFail)
		return false
	end
	return true
end
-- использование Эхолота
function echolot.use()
	-- если Эхолот не инициализирован
	if echolot.pageTextDrawId == -1 or echolot.slotTextDrawId == -1 then
		toChat(echolotInintMessage)
		if not echolot.init() then
			return false
		else  -- если инициализация прошла успешно - кликаем на него
			toChat(echolotInintMessageSuccess)
			-- если удалось кликнуть на Эхолот
			if echolot.click() then
				return true
			end
		end
	else -- если уже был инициализирован - кликаем на него
		sampSendChat("/invent")
		wait(inventoryWait*2)
		-- если удалось кликнуть на Эхолот
		if echolot.click() then
			return true
		end
	end
	return false
end

--=============================================================================================--

--======================================== AUTOFISHING ========================================--

local fisher = {
	-- список рыб и наживок к ним, полученные из Эхолота
	-- Примерная структура:
	-- baitList = 
	-- {
	--    {name = "Рыба1", baits = {"Наживка1", "Наживка2", "Наживка3"}}
	--    {name = "Рыба2", baits = {"Наживка1", "Наживка2", "Наживка3"}},
	-- }
	baitList = {}
}
-- проверка тот ли диалог открыт
function fisher.checkDialog(id)
	if sampGetCurrentDialogId() == tonumber(id) then 
		return true
	end
	toChat(errorFisherWrongDialog)
	
	if id == 0 then 
		toChat("Не удалось открыть диалог Эхолота. Повторяю попытку...")
		sampCloseCurrentDialogWithButton(0)
		autoFishing:run()
	end
	
	if id == 25285 then 
		toChat("Не удалось открыть диалог со снастями (/fishrod). Повторяю попытку...")
		sampCloseCurrentDialogWithButton(0)
		autoFishing:run()
	end
	
	if id == 25286 then 
		toChat("Не удалось открыть диалог с наживкой. Повторяю попытку...")
		sampCloseCurrentDialogWithButton(0)
		autoFishing:run()
	end

	return false
end
-- парсинг диалога с рыбой в даном водоёме
function fisher.parseEcholotDialog()
	-- проверяем открыт ли диалог с рыбой
	wait(dialogWait)
	if not fisher.checkDialog(0) then
		return false
	end
	
	local str = sampGetDialogText() -- Получаем весь текст диалога
	
	local counter = 1
	
	for line in str:gmatch('[^\n]+') do -- начинаем парсить текст по переносу строки
		local num, fishName, f1, f2, f3 = line:match("{73B461}(%d+). {cccccc}(%W*){ffffff} клюёт на {73B461}(%W*)%s+/%s+(%W*)%s+/%s+(%W*)")
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
	
	
	
	-- закрываем диалог
	sampCloseCurrentDialogWithButton(1)
	return true
	
end
-- Выбор наживки
function fisher.choseBait()
	wait(dialogWait)
	sampSendChat("/fishrod")
	wait(dialogWait)
	if fisher.checkDialog(25285) then
	
		local str = sampGetDialogText() -- Получаем весь текст диалога
		
		-- получаем текущую установленную наживку
		local currentBait = str:match("Наживка	(%W+)%s+{")
		
		-- если наживка установлена
		if currentBait then 
			-- если установленная наживка подходит
			for i = 1, #fisher.baitList, 1 do 
				for j = 1, 3, 1 do
					if fisher.baitList[i].baits[j] == currentBait then 
						return true
					end
				end
			end
		end
		-- переходим в диалог с выбором наживки
		sampSendDialogResponse(25285, 1, 6, -1)
		
		-- парсим диалог с наживкой и выбираем её
		if not fisher.parseBaitDialog() then -- если не получилось - выходим
			return false
		end
		
		wait(dialogWait)
		sampCloseCurrentDialogWithButton(0) -- возвращаемся назад
		wait(dialogWait)
		--toChat("УСПЕХ")
		return true
	end
	
	return false
	
end
-- парсинг диалога с наживкой
function fisher.parseBaitDialog ()
	-- проверяем открыт ли диалог с наживкой
	wait(dialogWait)
	if not fisher.checkDialog(25286) then
		return false
	end
	
	local str = sampGetDialogText() -- Получаем весь текст диалога

	local counter = 0
	
	for line in str:gmatch('[^\n]+') do -- начинаем парсить текст по переносу строки
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
	
	
	-- закрываем диалог
	toChat(errorBaitNotFound)
	fisher.showNeedBaits()
	sampCloseCurrentDialogWithButton(0)
	wait(dialogWait)
	sampCloseCurrentDialogWithButton(0)
	return false
end
-- вывести в чат отсутствующую наживку
function fisher.showNeedBaits()
	for i = 1, #fisher.baitList do 
		local tmp = ""
		for j = 1, 3 do
			if not fisher.baitList[i].baits[j]:find("Отсутствует") and fisher.baitList[i].baits[j] ~= " " then 
				if tmp == "" then 
					tmp = fisher.baitList[i].baits[j]
				else
					tmp = tmp..", "..fisher.baitList[i].baits[j]
				end
			end
			
		end
		toChat("Возможная наживка для "..fisher.baitList[i].name..": "..tmp)
	end
end
-- забрасываем удочку
function fisher.throwFishRod ()
	if not fisher.checkDialog(25285) then 
		return false
	end
	
	local str = sampGetDialogText() -- Получаем весь текст диалога
	
	if str:find("Отсутствует") then 
		toChat(errorFishingTackleNotFound)
		wait(dialogWait)
		sampCloseCurrentDialogWithButton(0)
		return false
	end
	wait(dialogWait*2)
	-- закидываем удочку
	sampSendDialogResponse(25285, 1, 7, -1)
	
	
	wait(dialogWait)
	-- закрываем диалог с подсказкой о рыбалке
	sampCloseCurrentDialogWithButton(0)
	return true
end

-- автопродажа
function fisher.autoSell()
	local regx = ""
	local mainDialog = -1

	if sampGetCurrentDialogId() == 25296 then  -- артефакты
		mainDialog = 25290
		regx = "%{......%}(%W+)	%{......%}(%d+) Рыбных монет%{......%}	%{......%}(%d+) шт."
	elseif sampGetCurrentDialogId() == 25291 then -- рыба
		mainDialog = 25291
		regx = "%{......%}Рыба '(%W+)'	%{......%}$(%d+)%{......%}	%{......%}(%d+) шт."
	end
	if mainDialog ~= -1 then 
		lua_thread.create(function ()
			wait(sellDialogWait)
			if sampGetCurrentDialogId() == 25296 then
				wait(sellDialogWait)
				sampSendDialogResponse(25296, 1, 0, -1)
				wait(sellDialogWait)
			end
			
			local str = sampGetDialogText() -- Получаем весь текст диалога
			local counter = 0
			
			for line in str:gmatch('[^\n]+') do -- начинаем парсить текст по переносу строки
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
	-- если удалась использовать Эхолот
	if echolot.use() then
		print("Заюзал")
		-- Закрываем инвентарь
		wait(inventoryWait)
		sampSendClickTextdraw(2111)
		-- парсим диалог с рыбой
		if fisher.parseEcholotDialog() then -- Если удалось и рыба есть
			-- выбираем нужную наживку
			if fisher.choseBait() then
				-- закидываем удочку
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
	-- если заполнился инвентарь, оборвалась оснастка, нет мест для рыбалки
	if text:find("ваш инвентарь заблокирован!") or text:find("вся оснастка оборвалась") or text:find("нет мест для рыбалки") then 
		toChat(errorCantWork)
		autoFishing:terminate()
		sriptIsActive = false
	end

	if fishing:status() == "yielded" then
		if text:match('Подсечка не удалась') then 
			fishing:terminate()
		end
		
		-- если скрипт активен
		if scriptIsActive then
			-- если эхолот инициализирован
			if echolot.pageTextDrawId ~= -1 and echolot.slotTextDrawId ~= -1 then
				if text:find("Вы поймали") then 
					autoFishing:run()
				end
			end
		end
	end
end

-- если флаг включен - нажатие происходит через stateKey
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
	
	-- авторыбалка старт
	sampRegisterChatCommand(startCommand, function()
		autoFishing:terminate()
		scriptIsActive = true
		autoFishing:run()
	end)
	
	-- авторыбалка стоп
	sampRegisterChatCommand(stopCommand, function()
		autoFishing:terminate()
		toChat(fisherStoped)
		scriptIsActive = false
	end)
	
	-- автопродажа
	sampRegisterChatCommand(sellCommand, function()
		fisher.autoSell()
	end)
	
	-- изменение способа нажатия на N
	sampRegisterChatCommand(changePressWayCommand, function()
		pressWithStateKey = not pressWithStateKey
		toChat(pressWayChanged)
		if pressWithStateKey then
			toChat("Текущий способ - для берега")
		else
			toChat("Текущий способ - для лодки")
		end
	end)
	
end

