local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local skup_window_state = imgui.ImBool(false)
local sell_window_state = imgui.ImBool(false)
local second_window_state = imgui.ImBool(false)
imgui.Process = false

local buy_comand = 'setbuy'
local sell_comand = 'setsell'

local script_name = '{FFFFFF}[{9933FF}BSH{FFFFFF}]: '
local script_version = '3.0'
--==========================================================Цвета и шрифт===========================================================================================
local fontsize = nil
function imgui.BeforeDrawFrame()
	if fontsize == nil then
		fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 17.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		end
end
function jopa()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col

	style.WindowRounding = 2
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 4.0
	style.FrameRounding = 3
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	style.WindowPadding = imgui.ImVec2(4.0, 4.0)
	style.FramePadding = imgui.ImVec2(3.5, 3.5)
	style.ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
	colors[clr.WindowBg]              = imgui.ImVec4(0.14, 0.12, 0.16, 1.00);
	colors[clr.ChildWindowBg]         = imgui.ImVec4(0.30, 0.20, 0.39, 0.00);
	colors[clr.PopupBg]               = imgui.ImVec4(0.05, 0.05, 0.10, 0.90);
	colors[clr.Border]                = imgui.ImVec4(0.89, 0.85, 0.92, 0.30);
	colors[clr.BorderShadow]          = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
	colors[clr.FrameBg]               = imgui.ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.FrameBgHovered]        = imgui.ImVec4(0.41, 0.19, 0.63, 0.68);
	colors[clr.FrameBgActive]         = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBg]               = imgui.ImVec4(0.41, 0.19, 0.63, 0.45);
	colors[clr.TitleBgCollapsed]      = imgui.ImVec4(0.41, 0.19, 0.63, 0.35);
	colors[clr.TitleBgActive]         = imgui.ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.MenuBarBg]             = imgui.ImVec4(0.30, 0.20, 0.39, 0.57);
	colors[clr.ScrollbarBg]           = imgui.ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.ScrollbarGrab]         = imgui.ImVec4(0.41, 0.19, 0.63, 0.31);
	colors[clr.ScrollbarGrabHovered]  = imgui.ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ScrollbarGrabActive]   = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ComboBg]               = imgui.ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.CheckMark]             = imgui.ImVec4(0.56, 0.61, 1.00, 1.00);
	colors[clr.SliderGrab]            = imgui.ImVec4(0.41, 0.19, 0.63, 0.24);
	colors[clr.SliderGrabActive]      = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.Button]                = imgui.ImVec4(0.41, 0.19, 0.63, 0.44);
	colors[clr.ButtonHovered]         = imgui.ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.ButtonActive]          = imgui.ImVec4(0.64, 0.33, 0.94, 1.00);
	colors[clr.Header]                = imgui.ImVec4(0.41, 0.19, 0.63, 0.76);
	colors[clr.HeaderHovered]         = imgui.ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.HeaderActive]          = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ResizeGrip]            = imgui.ImVec4(0.41, 0.19, 0.63, 0.20);
	colors[clr.ResizeGripHovered]     = imgui.ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ResizeGripActive]      = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.CloseButton]           = imgui.ImVec4(1.00, 1.00, 1.00, 0.75);
	colors[clr.CloseButtonHovered]    = imgui.ImVec4(0.88, 0.74, 1.00, 0.59);
	colors[clr.CloseButtonActive]     = imgui.ImVec4(0.88, 0.85, 0.92, 1.00);
	colors[clr.PlotLines]             = imgui.ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotLinesHovered]      = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotHistogram]         = imgui.ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotHistogramHovered]  = imgui.ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TextSelectedBg]        = imgui.ImVec4(0.41, 0.19, 0.63, 0.43);
	colors[clr.ModalWindowDarkening]  = imgui.ImVec4(0.20, 0.20, 0.20, 0.35);
	end
jopa()
--===============================================================================================================================================

local D_FOLDER_NAME = '\\BuySellHelper[BSH]\\'
local DEF_PATH = getWorkingDirectory()..D_FOLDER_NAME

local profiles = {}
local default_profile = {}
local sell_table = {}
local selected_profile = 1 -- выбранный профиль
profiles[selected_profile] = {}
profiles[selected_profile].tab = nil
profiles[selected_profile].name = ' '
local bad_symbols = { '\\', '/', ':', '*', '?', '\'', '<', '>', '|' }
local bad_serach_symbols = { '.', '%', '[', ']', '(', ')'}

function to_page (param, isSkup) 
	local page = tonumber(param)
	if page == nil then return end
	
	local s = tonumber(isSkup)
	if s == 1 then 
		sampSendDialogResponse(3040, 1, 0, ' ')
	else
		sampSendDialogResponse(3040, 1, 2, ' ')
	end
	
	for i = 1, page - 1, 1 do
		wait (300)
		if (i == 1) then
			sampSendDialogResponse(3050, 1, 19, -1)
		else
			sampSendDialogResponse(3050, 1, 20, -1)
		end
	end
end


function save_in_file (tab, name)

	if tab == nil then return end
	local file = 0
	if (name == 'default') then
		file = io.open(DEF_PATH..name, 'w')
	else
		file = io.open(DEF_PATH..name..'.profile', 'w')
	end
	for i = 1, #tab, 1 do 
		file:write(tab[i].name)
		file:write('\t\t')
		file:write(tostring(tab[i].page))
		file:write('\t')
		file:write(tostring(tab[i].number_in_list))
		file:write('\t')
		file:write(tostring(tab[i].quantity))
		file:write('\t')
		file:write(tostring(tab[i].price))
		file:write('\n')
	end
	file:close()
end

function save_sell_table_in_file ()
	local file = io.open(DEF_PATH..'sell', 'w')
	
	for i = 1, #sell_table, 1 do 
		file:write(sell_table[i].name)
		file:write('\t\t')
		file:write(tostring(sell_table[i].price))
		file:write('\n')
	end
	file:close()
end

function load_sell_table_from_file ()
	local file = io.open(DEF_PATH..'/sell', 'r')
	if not file then return end
	local start_pos = 0
	local end_pos = 0
	for line in file:lines() do 
		sell_table[#sell_table + 1] = {}
		end_pos = line:find('\t\t')
		sell_table[#sell_table].name = line:sub(start_pos, end_pos)
		
		start_pos = end_pos + 3
		end_pos = line:find('\t', start_pos)
		sell_table[#sell_table].price = tonumber(line:sub(start_pos, end_pos))
		start_pos = 0
		end_pos = 0
	end
	
	
	
	
	file:close()
	
end

function load_table_from_file (name)
	--wait (0)
	local tab
	tab = {}
	local file = io.open(DEF_PATH..name, 'r')
	
	local start_pos = 0
	local end_pos = 0
	for line in file:lines() do 
		tab[#tab + 1] = {}
		end_pos = line:find('\t\t')
		tab[#tab].name = line:sub(start_pos, end_pos)
		
		start_pos = end_pos + 3
		end_pos = line:find('\t', start_pos)
		tab[#tab].page = tonumber(line:sub(start_pos, end_pos))
		
		start_pos = end_pos + 1
		end_pos = line:find('\t', start_pos)
		tab[#tab].number_in_list = tonumber(line:sub(start_pos, end_pos))
		
		start_pos = end_pos + 1
		end_pos = line:find('\t', start_pos)
		tab[#tab].quantity = tonumber(line:sub(start_pos, end_pos))
		
		start_pos = end_pos + 1
		end_pos = line:find('\t', start_pos)
		tab[#tab].price = tonumber(line:sub(start_pos, end_pos))
		start_pos = 0
		end_pos = 0
	end
	file:close()
	return tab
end


function load_from_file()
	
	if not doesDirectoryExist(DEF_PATH) then
		createDirectory(DEF_PATH)
	end
	
	
	
	
	if not doesFileExist(DEF_PATH..'/default') then
		sampAddChatMessage(script_name..'{F90F0F}Не найдено профиля по умолчанию', -1)
		sampAddChatMessage(script_name..'{F90F0F}Вам необходимо создать его вручную', -1)
		sampAddChatMessage(script_name..'{F90F0F}Подробнее: CTRL + 8 или /'..buy_comand, -1)
	else
		default_profile = deepcopy(load_table_from_file('default'))
		
		
		local handle, name = findFirstFile(DEF_PATH..'/*.profile')
		if name ~= nil then 
			while true do
				wait (0)
				local tab = {}
				tab = deepcopy(load_table_from_file(name))
				profiles[#profiles].name = u8(string.sub(name, 1, name:find('.profile') - 1))
				profiles[#profiles].tab = tab
				name = findNextFile(handle)
				if name == nil then break end
				profiles[#profiles + 1] = {}
			end
		end
		
		
		
	end
	
	if not doesFileExist(DEF_PATH..'/sell') then
		sampAddChatMessage(script_name..'{F90F0F}Не найдено списка продажи', -1)
		sampAddChatMessage(script_name..'{F90F0F}Необходимо создать его вручную', -1)
		sampAddChatMessage(script_name..'{F90F0F}Подробнее: CTRL + 7 или /'..sell_comand, -1)
	else
		load_sell_table_from_file()
	end
	
	
end

function parse_dialog ()
	local tmp_tab = {}
	for i = 1, 100, 1 do -- Цикл который по страничкам бегает 
		local str = sampGetDialogText() -- Получаем весь текст диалога
		local iter_c = 1 -- счётчик каждой строки в тексте диалога
		for line in str:gmatch('[^\n]+') do -- начинаем парсить текст по переносу строки
			if (line:find('Название') == nil and line:find('Следующая') == nil and line:find('Предыдущая') == nil) then
				-- if выше - проверка на то, что строка в диалоге является навигацией ( короче не нужные нам )
				tmp_tab[#tmp_tab + 1] = {} 
				line = string.sub(line, line:find('}') + 1, line:find('\t'))
				-- выше string.sub удаляет форматирование строк Аризоны (у них весь тектс с цветом, т.е. эти штуки ->{FFFFFF}<-)
				tmp_tab[#tmp_tab].name = line -- ну и собсна сохраняем уже толлько ту часть, что нам нужна, без этого ->{FFFFFF}<-
				tmp_tab[#tmp_tab].page = i
				tmp_tab[#tmp_tab].number_in_list = iter_c
				tmp_tab[#tmp_tab].quantity = 0
				tmp_tab[#tmp_tab].price = 0
				iter_c = iter_c + 1
			end
		end
		if (str:find('Следующая') == nil) then break end -- Если строки на следующую страничку нету - выходим из цикла
		
		if (i == 1) then -- ниже клик по кнопке 'Следующая'
			sampSendDialogResponse(3050, 1, 19, -1) 
		else
			sampSendDialogResponse(3050, 1, 20, -1)
		end
		wait (1500) -- это чтобы за спам функциями не кикало
	end
	setVirtualKeyDown(27, true)
	setVirtualKeyDown(27, false)
	wait (400)
	setVirtualKeyDown(27, true)
	setVirtualKeyDown(27, false)
	return tmp_tab
end


local need_to_update = false
function create_default_profile ()
	
	if sampIsDialogActive() then 
		if sampGetCurrentDialogId() ~= 3050 then return end
		local sss = sampGetDialogText()
		if sss:find('В продаже') then
			local ttt = deepcopy(parse_dialog())
			local gavno = false
			for i = 1, #ttt, 1 do 
				for j = 1, #sell_table, 1 do 
					if sell_table[j].name == ttt[i].name then
						gavno = true
						break
					end
				end
				if not gavno then
					sell_table[#sell_table + 1] = {}
					sell_table[#sell_table].name = ttt[i].name
					sell_table[#sell_table].price = 0
				else
					gavno = false
				end
				
			end
			table.sort(sell_table, function (a, b) return (a.name < b.name) end )
			save_sell_table_in_file()
		else
			need_to_update = true
			default_profile = {}
			
			default_profile = deepcopy(parse_dialog())
			
			save_in_file(default_profile, 'default')
			
		end
	end
	
end



function Skup_Thread_function ()
	if sampIsDialogActive() then 
		if sampGetCurrentDialogId() == 3040 then 
			local skup_money = 0
			for i = 1, #profiles[selected_profile].tab, 1 do 
				skup_money = skup_money + profiles[selected_profile].tab[i].quantity * profiles[selected_profile].tab[i].price
			end
			local player_money = getPlayerMoney(PLAYER_HANDLE)
			if player_money < skup_money then 
				sampAddChatMessage(script_name..'Не удалось выставить товары на скупку', -1)
				sampAddChatMessage(script_name..'Требуется денег: '..skup_money, -1)
				sampAddChatMessage(script_name..'На руках: '..player_money, -1)
				return
			end
			
			
			for i = 1, #profiles[selected_profile].tab, 1 do
				
				if (profiles[selected_profile].tab[i].quantity ~= 0 and profiles[selected_profile].tab[i].price ~= 0) then
					to_page(profiles[selected_profile].tab[i].page, 2)
					sampSendDialogResponse(3050, 1, profiles[selected_profile].tab[i].number_in_list - 1, -1)
					wait(1000)
					local str
					if sampGetDialogText():find('количество') then 
						str = string.format('%d, %d', profiles[selected_profile].tab[i].quantity, profiles[selected_profile].tab[i].price)
					else
						str = string.format('%d', profiles[selected_profile].tab[i].price)
					end
			
					
					if sampGetDialogText():find(profiles[selected_profile].tab[i].name:gsub('^%s*(.-)%s*$', '%1'), 1, true) then 
						sampSetCurrentDialogEditboxText(str)
						setVirtualKeyDown(13, true)
						setVirtualKeyDown(13, false)
						wait (1000)
					else
						setVirtualKeyDown(27, true)
						setVirtualKeyDown(27, false)
						wait(500)
						setVirtualKeyDown(27, true)
						setVirtualKeyDown(27, false)
						wait(500)
					end
					
				end
			end
			setVirtualKeyDown(27, true)
			setVirtualKeyDown(27, false)
		end
	end
end


function Sell_Thread_function ()
	if #sell_table == nil then return end
	if #sell_table == 0 then return end
	if sampIsDialogActive() then 
		if sampGetCurrentDialogId() == 3040 then 
			local current_page = 1
			local curent_line = 1
			local run = true
			while run do
				wait(0)
				to_page(current_page, 1)
				
				wait(1000)
				local str = sampGetDialogText()
				
				for line in str:gmatch('[^\n]+') do
					if (line:find('Название') == nil and line:find('Следующая') == nil and line:find('Предыдущая') == nil) then
						local name = ' '
						if line:find('}') ~= nil then 
							name = string.sub(line, line:find('}') + 1, line:find('\t'))
						end
						for i = 1, #sell_table, 1 do 
							if sell_table[i].name == name then
								if sell_table[i].price ~= nil then 
									if sell_table[i].price ~= 0 then 
										local quantity = 0
										if line:find('шт.') then 
											quantity = string.sub(line, line:find('}', line:find('\t') + 1) + 1, line:find('шт.') - 1)
										end
										sampSendDialogResponse(3050, 1, curent_line - 1, -1)
										wait(1000)
										
										if tonumber(quantity) ~= nil then 
											if tonumber(quantity) < 2 then
												name = string.format('%d', tonumber(sell_table[i].price))
											else
												name = string.format('%d, %d', tonumber(quantity), tonumber(sell_table[i].price))
											end
										end
										
										
										if sampGetDialogText():find(sell_table[i].name:gsub('^%s*(.-)%s*$', '%1'), 1, true) then 
											sampSetCurrentDialogEditboxText(name)
											setVirtualKeyDown(13, true)
											setVirtualKeyDown(13, false)
											wait (1000)
										else
											setVirtualKeyDown(27, true)
											setVirtualKeyDown(27, false)
											wait(500)
											setVirtualKeyDown(27, true)
											setVirtualKeyDown(27, false)
											wait(500)
										end
										to_page(current_page, 1)
										wait (1000)
										break
									end
								end
							end
						end
						curent_line = curent_line + 1
					end
					
				end
				curent_line = 1
				
				
				if sampIsDialogActive() then 
					if sampGetCurrentDialogId() == 3050 then 
						setVirtualKeyDown(27, true)
						setVirtualKeyDown(27, false)
						wait(100)
					end
				end
				
				if (str:find('Следующая') == nil) then 
					wait(100)
					setVirtualKeyDown(27, true)
					setVirtualKeyDown(27, false)
					run = false
				end
				--print ('Текущая страница: '..current_page)
				current_page = current_page + 1
				
				--wait (500)
				
			end
		end
	end
end


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--==================================================================ГУИ для СКУПКИ==============================================================================
function buy_cmd_imgui()
	 
	skup_window_state.v = not skup_window_state.v
	imgui.Process = skup_window_state.v or sell_window_state.v
end

function sell_cmd_imgui()
	sell_window_state.v = not sell_window_state.v
	imgui.Process = skup_window_state.v or sell_window_state.v
end


function string.upper ( str ) return str:gsub ( '([a-zа-я])', function ( c ) return string.char ( string.byte ( c ) - 32 ) end ) end

function imgui.TextQuestion(label, description)
	imgui.TextDisabled(label)
	
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
			imgui.PushTextWrapPos(600)
				imgui.TextUnformatted(description)
			imgui.PopTextWrapPos()
		imgui.EndTooltip()
		end
end


function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..' '..right
end

function separator(text)
	if text:find('$') then
	    for S in string.gmatch(text, '%$%d+') do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, '%d+%$') do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end


local selected = 0
local sell_selected = 0

local buff_q = imgui.ImBuffer(20)

local buff_p = imgui.ImBuffer(20)

local sell_buff_p = imgui.ImBuffer(20)


local search_buff = imgui.ImBuffer(50)

local sell_search_buff = imgui.ImBuffer(50)


local new_name_buff = imgui.ImBuffer(50)

local sw, sh = getScreenResolution()
local rb_1 = imgui.ImBool(false)
local rb_2 = imgui.ImBool(false)
local selected_item = imgui.ImInt(0)
local s_w_indx = 0

function imgui.OnDrawFrame()
	imgui.PushFont(fontsize)
	imgui.SetNextWindowSize(imgui.ImVec2(700, 250), imgui.Cond.FirstUseEver);
	imgui.SetNextWindowPos(imgui.ImVec2(sw / 2 , sh / 2),imgui.Cond.FirstUseEver, imgui.ImVec2(0.5,0.5))
	--print(default_profile)
	if (skup_window_state.v) then 
		if (default_profile[1] == nil) then 
			
			if (imgui.Begin(u8'Инструкция', skup_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)) then
				imgui.Text(u8'Для того, чтобы создать профиль, необходимо выполнить следующие шаги:')
				imgui.Text(u8'[1]: Найдите любую лавку (на центральном рынке/переносную)')
				imgui.Text(u8'[2]: Выберите [Покупать товар]')
				imgui.Text(u8'[3]: Установите имя и цвет вашей лавки')
				imgui.Text(u8'[4]: Выберите [Добавить товар на покупку]')
				imgui.Text(u8'[5]: Когда откроется список товаров, откройте чат (F6 или T)')
				imgui.Text(u8'[6]: Введите в чат /rescan и нажмите Enter')
				imgui.Text(u8'[7]: Скрипт должен пробежаться по всему списку и создать профиль')
				imgui.End()
			end
		else
			if (imgui.Begin(u8'[BSH] | Хелпер скупки', skup_window_state, imgui.WindowFlags.NoCollapse)) then
				
				if need_to_update == true then
					update_profiles()
					need_to_update = false
				end
				--===================================ДИАЛОГОВОЕ ОКНО======================================
				if second_window_state.v then	
					if (s_w_indx == 1) then
						imgui.SetNextWindowSize(imgui.ImVec2(324, 90), imgui.ImGuiCond_FirstUseEver);
						imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2 - 200),imgui.Cond.FirstUseEver, imgui.ImVec2(0.5,0.5))	
						if (imgui.Begin(u8'Введите имя профиля', second_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)) then
							imgui.InputText(u8'Имя профиля', new_name_buff)
							imgui.Separator()
							if imgui.Button(u8'Сохранить') or isKeyJustPressed(13) then
								local found_govno = false
								for i = 1, #bad_symbols, 1 do
									if new_name_buff.v:find(bad_symbols[i]) then
										found_govno = true
										sampAddChatMessage(script_name..'Недопустимые символы в названии профиля', -1)
										break
									end
								end
								if (u8:decode(new_name_buff.v) == ' ') then
									found_govno = true
								end
								for i = 1, #profiles, 1 do 
									if new_name_buff.v == profiles[i].name then 
										sampAddChatMessage(script_name..'Профиль с таким именем уже существует', -1)
										found_govno = true
										break
									end
								end
								if not found_govno then
									
									local tmp_tab = deepcopy(default_profile)
									for i = 1, #tmp_tab, 1 do

										tmp_tab[i].quantity = 0
										tmp_tab[i].price = 0
									end
									--print (u8:decode(new_name_buff.v))
									save_in_file(tmp_tab, u8:decode(new_name_buff.v))
									if (profiles[1].tab ~= nil and profiles[1].name ~= ' ') then 
										profiles[#profiles + 1] = {}
									end
									profiles[#profiles].tab = tmp_tab
									profiles[#profiles].name = new_name_buff.v
									
									selected_profile = #profiles
									selected_item.v = selected_profile - 1
									table.sort(profiles, function(a, b) return (a.name < b.name) end)
									--print (#profiles..'  SELECTED = '..selected_profile..'\n')
									second_window_state.v = false
									new_name_buff.v = ' '
									s_w_indx = 0
								end
								
							end
							imgui.SameLine()
							if imgui.Button(u8'Отмена') then
								second_window_state.v = false
								new_name_buff.v = ' '
								s_w_indx = 0
							end
					end
					--imgui.End()
					elseif (s_w_indx == 2) then
						imgui.SetNextWindowSize(imgui.ImVec2(320, 83), imgui.ImGuiCond_FirstUseEver);
						imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2 - 200),imgui.Cond.FirstUseEver, imgui.ImVec2(0.5,0.5))	
						if (imgui.Begin(u8'Вы точно хотите удалить профиль?', second_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)) then
							
							
							if imgui.Button(u8'Да', imgui.ImVec2(-0.1, 0)) or isKeyJustPressed(13) then
								
								os.remove(DEF_PATH..u8:decode(profiles[selected_profile].name)..'.profile')
								
								if (#profiles == 1) then 
									profiles[1] = {}
									profiles[1].tab = nil
									profiles[1].name = ' '
								else
									table.remove(profiles, selected_profile)
								end
								selected_profile = 1
								selected_item.v = 0
								second_window_state.v = false
								s_w_indx = 0
								
							end
							
							
							if imgui.Button(u8'Нет', imgui.ImVec2(-0.1, 0)) then
								second_window_state.v = false
								s_w_indx = 0
							end
							
							
						end
					end
					imgui.End()
				end
				--========================================================================================
				if (second_window_state.v == false) then s_w_indx = 0 end
				--========================================TOOL_BAR============================================
				imgui.BeginChild('search', imgui.ImVec2(694, 30), true);
					
					
					imgui.PushItemWidth(295)
					imgui.InputText(u8'Поиск', search_buff)
					for c in search_buff.v:gmatch('.') do
						for t = 1, #bad_serach_symbols, 1 do 
							if c == bad_serach_symbols[t] then 
								search_buff.v = ' '
								break
							end
						end
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					
					if imgui.RadioButton(' ',rb_1.v) then rb_1.v = not rb_1.v end
					imgui.SameLine()
					imgui.TextQuestion('(?)',u8'Все товары/скупаемые товары')
					imgui.SameLine()
					
					if imgui.Button(u8'Очистка') then
						if profiles[selected_profile].tab ~= nil then 
							for i = 1, #profiles[selected_profile].tab, 1 do 
								profiles[selected_profile].tab[i].quantity = 0
								profiles[selected_profile].tab[i].price = 0
							end
							
						end
					end
					imgui.SameLine()
					imgui.TextQuestion('(?)',u8'Очистить список всех скупаемых товаров текущего профиля')
					
					
					--print(profiles[selected_profile].name){ 'Jopa', 'Popa', 'and', 'Prokol'}
					imgui.SameLine()
					local p_names = {}
					for i = 1, #profiles, 1 do
						p_names[i] = profiles[i].name
					end
					 
					imgui.PushItemWidth(128)
					if imgui.Combo('', selected_item, p_names, #p_names) then
						for i = 1, #p_names, 1 do 
							if selected_item.v + 1 == i then
								selected_profile = i
								buff_q.v = u8(tostring(profiles[selected_profile].quantity))
								buff_p.v = u8(tostring(profiles[selected_profile].price))
							end
						end
					end
					imgui.PopItemWidth()
					
					imgui.SameLine()
					
					if imgui.Button(u8'[+]') and s_w_indx == 0 then
						second_window_state.v = true
						s_w_indx = 1
					end
					
					imgui.SameLine()
					if imgui.Button(u8'[-]') and s_w_indx == 0 then
						-- if profiles[selected_profile].name == 'default' then
							-- sampAddChatMessage(script_name..'Нельзя удалить профиль по умолчанию', -1)
						-- else
							if profiles[selected_profile] ~= nil and profiles[selected_profile].tab ~= nil then 
								second_window_state.v = true
								s_w_indx = 2
							end
						--end
					end
					
					
				imgui.EndChild();
				
				
				--=======================================================================================
				--========================================left============================================
				imgui.BeginChild('left pane', imgui.ImVec2(300, 0), true);
				if profiles[selected_profile] ~= nil and profiles[selected_profile].tab ~= nil then 
					for i = 0, #profiles[selected_profile].tab - 1, 1 do
						local label = u8('['..(i + 1)..']: '..profiles[selected_profile].tab[i + 1].name)
						if u8:decode(label):upper():find(u8:decode(search_buff.v):upper()) then
							if not rb_1.v then
								if (imgui.Selectable(label, selected == i)) then selected = i end
							elseif profiles[selected_profile].tab[i + 1].quantity > 0 then
								if (imgui.Selectable(label, selected == i)) then selected = i end
							end
						end
					end
				end
				imgui.EndChild();
				
				imgui.SameLine();
				
				--=======================================================================================
				--==========================================right========================================
				imgui.BeginGroup()
					imgui.BeginChild('item view', imgui.ImVec2(0, -imgui.GetItemsLineHeightWithSpacing()))
						if profiles[selected_profile] ~= nil and profiles[selected_profile].tab ~= nil then 
							imgui.Text(u8(profiles[selected_profile].tab[selected + 1].name))
							imgui.Separator()

							buff_q.v = tostring(profiles[selected_profile].tab[selected + 1].quantity)
							imgui.InputText(u8'Количество', buff_q)
							if (buff_q.v:find('%D') == nil and buff_q.v ~= ' ') then
								if tonumber(buff_q.v) ~= nil then
									if (tonumber(buff_q.v) >= 0) then
										profiles[selected_profile].tab[selected + 1].quantity = tonumber(buff_q.v)
									end
								end
							end
							
							
							buff_p.v = tostring(profiles[selected_profile].tab[selected + 1].price)
							imgui.InputText(u8'Цена', buff_p)
							if (buff_p.v:find('%D') == nil and buff_p.v ~= ' ') then
								if tonumber(buff_p.v) ~= nil then 
									if (tonumber(buff_p.v) >= 10 or tonumber(buff_p.v) == 0) then
										profiles[selected_profile].tab[selected + 1].price = tonumber(buff_p.v)
									end
								end
							end
						else
							imgui.Text(u8'Отсутствует профиль')
						end
						
						imgui.Separator()
						imgui.Text(u8('Настройка скрипта - CTRL + 8 или /'..buy_comand))
						
						
						if (imgui.Button(u8'Обновить профиль') and profiles[selected_profile].tab ~= nil) then check_profile(selected_profile) end
						imgui.SameLine()
						imgui.TextQuestion('(?)',u8'Если в профиле встречаются повторения, или каких-либо предметов не хватает - обновите профиль по умолчанию через /rescan и нажмите эту кнопку\n\nЕсли это не помогло - пишите мне в лс, либо скачайте файл default, приложенный в статье https://www.blast.hk/threads/89713/, и киньте его в папку скрипта: '..D_FOLDER_NAME..u8', затем нажмите на кнопку, выбрав нужный профиль\n\nP.S. файл в статье обновляться будет редко, нужных вам предметов там может не оказаться')
						imgui.SameLine()
						imgui.Text(u8'  |  ')
						imgui.SameLine()
						imgui.Text(u8('Если было обновление'))
						imgui.SameLine()
						imgui.TextQuestion('(?)',u8'Если во время обновления были добавлены новые предметы, необходимо пересоздать профиль по умолчанию (/rescan на списке предметов),\nпосле чего все ваши профили автоматически пополнятся новыми предметами')
						
						imgui.Text(u8('Команда скупки - /skup'))
						imgui.SameLine()
						imgui.TextQuestion('(?)',u8'Поставьте/займите лавку, укажите имя и цвет, затем пропишите команду в чат')
						
						
						
						
						
					imgui.EndChild();
					imgui.BeginChild('buttons');
						if (imgui.Button('Save') and profiles[selected_profile].tab ~= nil) then save_in_file(profiles[selected_profile].tab, u8:decode(profiles[selected_profile].name)) end
					
					imgui.SameLine()
					
					local all_price = 0
					if #profiles ~= 0 and profiles[selected_profile].tab ~= nil then
						for j = 1, #profiles[selected_profile].tab, 1 do 
							if profiles[selected_profile].tab[j].quantity ~= 0 and profiles[selected_profile].tab[j].price ~= 0 then 
								all_price = all_price + profiles[selected_profile].tab[j].quantity * profiles[selected_profile].tab[j].price
							end
						end
					end
					imgui.Text(u8('Общая сумма скупки: '..separator(tostring(all_price..'$'))))
					imgui.EndChild()
					
					
					
				imgui.EndGroup()
				--=======================================================================================
				imgui.End()
			end
			
		end
	end -- конец для окон скупки
	
	
	imgui.SetNextWindowSize(imgui.ImVec2(700, 240), imgui.Cond.FirstUseEver);
	imgui.SetNextWindowPos(imgui.ImVec2(sw / 2 , sh / 2),imgui.Cond.FirstUseEver, imgui.ImVec2(0.5,0.5))
	
	
	if (sell_window_state.v) then 
		if (#sell_table == 0) then 
			if (imgui.Begin(u8'Инструкция ', sell_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)) then
				imgui.Text(u8'Для того, чтобы создать список продажи, необходимо выполнить следующие шаги:')
				imgui.Text(u8'[1]: Найдите любую лавку (на центральном рынке/переносную)')
				imgui.Text(u8'[2]: Выберите [Продавать товар]')
				imgui.Text(u8'[3]: Установите имя и цвет вашей лавки')
				imgui.Text(u8'[4]: Выберите [Выставить товар на продажу]')
				imgui.Text(u8'[5]: Когда откроется список товаров, откройте чат (F6 или T)')
				imgui.Text(u8'[6]: Введите в чат /rescan и нажмите Enter')
				imgui.Text(u8'[7]: Скрипт должен пробежаться по всему списку и создать список')
				imgui.End()
			end
		else
			if (imgui.Begin(u8'[BSH] | Хелпер продажи', sell_window_state, imgui.WindowFlags.NoCollapse)) then

				--===================================TOOL_BAR============================================
				imgui.BeginChild('tool_bar', imgui.ImVec2(694, 30), true);
					imgui.PushItemWidth(295)
					imgui.InputText(u8'Поиск', sell_search_buff)
					for c in sell_search_buff.v:gmatch('.') do
						for t = 1, #bad_serach_symbols, 1 do 
							if c == bad_serach_symbols[t] then 
								sell_search_buff.v = ' '
								break
							end
						end
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					
					if imgui.RadioButton(' ',rb_2.v) then rb_2.v = not rb_2.v end
					imgui.SameLine()
					imgui.TextQuestion('(?)',u8'Все товары/продаваемые товары')
					imgui.SameLine()
					
					if imgui.Button(u8'Очистка') then
						if #sell_table ~= 0 then 
							for i = 1, #sell_table, 1 do 
								sell_table[i].price = 0
							end
						end
					end
					imgui.SameLine()
					imgui.TextQuestion('(?)',u8'Очистить список продаваемых товаров')
				imgui.EndChild();
				--=======================================================================================
				--====================================LEFT==============================================
				imgui.BeginChild('left sell pane', imgui.ImVec2(300, 0), true);
				if #sell_table ~= 0 then 
					for i = 0, #sell_table - 1, 1 do
						local label = u8('['..(i + 1)..']: '.. sell_table[i + 1].name)
						if u8:decode(label):upper():find(u8:decode(sell_search_buff.v):upper()) then
							if not rb_2.v then
								if (imgui.Selectable(label, sell_selected == i)) then sell_selected = i end
							elseif sell_table[i + 1].price ~= nil then
								if sell_table[i + 1].price > 0 then
									if (imgui.Selectable(label, sell_selected == i)) then sell_selected = i end
								end
							end
						end
					end
				end
				imgui.EndChild();
				--=======================================================================================
				imgui.SameLine();
				--==========================================right========================================
				imgui.BeginGroup()
					imgui.BeginChild('sell_items', imgui.ImVec2(0, -imgui.GetItemsLineHeightWithSpacing()))
						if #sell_table ~= 0 then 
							imgui.Text(u8(sell_table[sell_selected + 1].name))
							imgui.Separator()
							
							
							sell_buff_p.v = tostring(sell_table[sell_selected + 1].price)
							imgui.InputText(u8'Цена', sell_buff_p)
							if (sell_buff_p.v:find('%D') == nil and sell_buff_p.v ~= ' ') then
								if tonumber(sell_buff_p.v) ~= nil then
									if (tonumber(sell_buff_p.v) >= 10 or tonumber(sell_buff_p.v) == 0) then
										sell_table[sell_selected + 1].price = tonumber(sell_buff_p.v)
									end
								end
							end
						else
							imgui.Text(u8'Отсутствует список товаров')
						end
						
						imgui.Separator()
						imgui.Text(u8('Настройка скрипта - CTRL + 7 или /'..sell_comand))
						
						imgui.Text(u8('Если нужно пополнить список'))
						imgui.SameLine()
						imgui.TextQuestion('(?)',u8'Если вам нужно добавить новые предметы в список - пропишите /rescan на списке предметов для продажи')
						
						imgui.Text(u8('Команда продажи - /sell'))
						imgui.SameLine()
						imgui.TextQuestion('(?)',u8'Поставьте/займите лавку, укажите имя и цвет, затем пропишите команду в чат')
						
						imgui.TextQuestion(u8'[АХТУНГ]',u8'Скрипт никак не сможет распознать - заточен аксессуар, или нет (благодарите за это Аризону).\nЕсли хотите выставить аксессуар с заточкой - либо добавляйте в таблицу цену сразу на заточенный аксессуар, либо выставляйте их отдельно, уже после того, как скрипт отработает\n')
						
						
						
					imgui.EndChild();
					imgui.BeginChild('buttons save');
						if (imgui.Button('Save') and #sell_table ~= 0) then save_sell_table_in_file() end
					imgui.EndChild()
				imgui.EndGroup()
				
				imgui.End()
			end
			
		end
		
	end -- конец окон покупки
	
	
	
	imgui.PopFont()
end

--=============================================================================================================================================================

Skup_Thread = lua_thread.create_suspended(Skup_Thread_function)
Sell_Thread = lua_thread.create_suspended(Sell_Thread_function)
Create = lua_thread.create_suspended(create_default_profile)

function main()
    while not isSampAvailable() do wait(0) end
	
	sampAddChatMessage(script_name..'Скрипт запущен...', -1)
	sampAddChatMessage(script_name..'Версия скрипта ['..script_version..']', -1)
	sampAddChatMessage(script_name..'Создатели: Vincento_Vega и George_Vega', -1)
	sampAddChatMessage(script_name..'Открыть настройки продажи - CTRL + 7 или /'..sell_comand, -1)
	sampAddChatMessage(script_name..'Открыть настройки покупки  - CTRL + 8 или /'..buy_comand, -1)
	
	
	load_from_file()
	sampRegisterChatCommand('skup',Skup)
	sampRegisterChatCommand('sell',Sell)
	sampRegisterChatCommand('rescan',RescanItems)
	sampRegisterChatCommand(buy_comand, buy_cmd_imgui)
	sampRegisterChatCommand(sell_comand, sell_cmd_imgui)
	
	while true do
		wait(0)
		if not skup_window_state.v and not sell_window_state.v then
			imgui.Process = false
		end
		
		if isKeyDown(17) then
			if isKeyJustPressed(56) then
				buy_cmd_imgui(1)
			end
			if isKeyJustPressed(55) then 
				sell_cmd_imgui(2)
			end
		end
		
	end
	wait(-1)
end


function Skup ()
	Skup_Thread:run()
end

function RescanItems ()
	Create:run()
end

function Sell ()
	Sell_Thread:run()
end

function check_profile(profile_id)
	local i = tonumber(profile_id)
	for j = 1, #default_profile, 1 do
		if profiles[i].tab[j] == nil then 
			table.insert(profiles[i].tab, j, deepcopy(default_profile[j]))
		elseif profiles[i].tab[j].name ~= default_profile[j].name then 
			profiles[i].tab[j].name = default_profile[j].name
			profiles[i].tab[j].quantity = 0
			profiles[i].tab[j].price = 0
		end
	end
	save_in_file(profiles[i].tab, u8:decode(profiles[i].name))
end


function update_profiles()
	for i = 1, #profiles, 1 do
		if profiles[i].tab ~= nil and #profiles[i].tab ~= #default_profile then
			check_profile(i)
		end
	end
end