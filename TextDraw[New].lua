script_name("TextDraw[New]")
script_authors("Shishkin") -- https://www.blast.hk/members/428491/

local imgui = require('imgui')
local inicfg = require "inicfg"
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

set = inicfg.load(nil, "TextDraw[New]") 
if set == nil then
	ini = { active = { alignactive = true, statusactive = true, coloractive = true, color1active = true, color2active = true, sizeXactive = true, sizeYactive = true, letSizeXactive = true, letSizeYactive = true, modelactive = true, rotXactive = true,rotYactive = true, rotZactive = true, zoomactive = true,outlineactive = true, outlinecoloractive = true, propactive = true, shadowactive = true, xactive = true, yactive = true, textactive = true, texttranslationtextdrawactive = true, copy = true  } }
	inicfg.save(ini, "TextDraw[New]")
	set = inicfg.load(nil, "TextDraw[New]")
end

ImVec4 = imgui.ImVec4
ImVec2 = imgui.ImVec2
style = imgui.GetStyle()
colors = style.Colors
clr = imgui.Col

krest = imgui.ImBool(false); active = imgui.ImBool(false)
alignactive = imgui.ImBool(set.active.alignactive); statusactive = imgui.ImBool(set.active.statusactive); coloractive = imgui.ImBool(set.active.coloractive); color1active = imgui.ImBool(set.active.color1active); color2active = imgui.ImBool(set.active.color2active); sizeXactive = imgui.ImBool(set.active.sizeXactive); sizeYactive = imgui.ImBool(set.active.sizeYactive); letSizeXactive = imgui.ImBool(set.active.letSizeXactive); letSizeYactive = imgui.ImBool(set.active.letSizeYactive); modelactive = imgui.ImBool(set.active.modelactive); rotXactive = imgui.ImBool(set.active.rotXactive); rotYactive = imgui.ImBool(set.active.rotYactive); rotZactive = imgui.ImBool(set.active.rotZactive); zoomactive = imgui.ImBool(set.active.zoomactive); outlineactive = imgui.ImBool(set.active.outlineactive); outlinecoloractive = imgui.ImBool(set.active.outlinecoloractive); propactive = imgui.ImBool(set.active.propactive); shadowactive = imgui.ImBool(set.active.shadowactive); xactive = imgui.ImBool(set.active.xactive); yactive = imgui.ImBool(set.active.yactive); textactive = imgui.ImBool(set.active.textactive); texttranslationtextdrawactive = imgui.ImBool(set.active.texttranslationtextdrawactive); copy = imgui.ImBool(set.active.copy)

function main()
	sampRegisterChatCommand("TextDraw",  function()
		colors[clr.WindowBg]  = ImVec4(0.09, 0.09, 0.09, 0.00)
		krest.v = not krest.v
		imgui.Process = krest.v
	end)
	sampRegisterChatCommand("TextDrawset",  function()
		colors[clr.WindowBg] = ImVec4(0.09, 0.09, 0.09, 1.00)
		active.v = not active.v
		imgui.Process = active.v
	end)
	sampRegisterChatCommand("deletetextdraw",  function(arg)
		if #arg == 0 then
			sampAddChatMessage("/DeleteTextDraw [id]", -1)
			else
			if sampTextdrawIsExists(arg) then
				sampTextdrawDelete(arg)
				sampAddChatMessage("TextDraw [" .. arg .. "] удален", -1)
				else
				sampAddChatMessage("TextDraw не существует", -1)
			end
		end
	end)
	while true do
		wait(0)
		if active.v and krest.v then
			sampAddChatMessage("Нельзя использовать показ текстдрава и настройку текстдрава одновременно", -1)
			active.v = false
			krest.v = false
			elseif not active.v and not krest.v then
			imgui.Process = false
			set.active.alignactive = alignactive.v
			set.active.statusactive = statusactive.v
			set.active.coloractive = coloractive.v; set.active.color1active = color1active.v; set.active.color2active = color2active.v; set.active.sizeXactive = sizeXactive.v; set.active.sizeYactive = sizeYactive.v; set.active.letSizeXactive = letSizeXactive.v; set.active.letSizeYactive = letSizeYactive.v; set.active.modelactive = modelactive.v; set.active.rotXactive = rotXactive.v; set.active.rotYactive = rotYactive.v; set.active.rotZactive = rotZactive.v; 		set.active.zoomactive = zoomactive.v; set.active.outlineactive = outlineactive.v; set.active.outlinecoloractive = outlinecoloractive.v; set.active.propactive = propactive.v; set.active.shadowactive = shadowactive.v; set.active.xactive = xactive.v; set.active.yactive = yactive.v; set.active.textactive = textactive.v; set.active.texttranslationtextdrawactive = texttranslationtextdrawactive.v; set.active.copy = copy.v
			inicfg.save(set, "TextDraw[New]")
		end
	end
	wait(-1)
end

-- imgui
function imgui.OnDrawFrame()
	
	if krest.v then
		sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(0, 0), imgui.Cond.Always, imgui.ImVec2(0, 0))
		imgui.SetNextWindowSize(imgui.ImVec2(sw, sh))
		imgui.Begin(u8"Зона поиска", krest, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)
		for id = 0, 2304 do
			if sampTextdrawIsExists(id) then
				xy, yx = sampTextdrawGetPos(id)
				alig = sampTextdrawGetAlign(id)
				statu, colo, sizX, sizY = sampTextdrawGetBoxEnabledColorAndSize(id)
				letSizX, letSizY = sampTextdrawGetLetterSizeAndColor(id)
				mode, roX, roY, roZ, zom, colo1, colo2 = sampTextdrawGetModelRotationZoomVehColor(id)
				outlin, outlinecolo = sampTextdrawGetOutlineColor(id)
				pro = sampTextdrawGetProportional(id)
				shado, shadowcolo = sampTextdrawGetShadowColor(id)
				tex = sampTextdrawGetString(id)
				if texttranslationtextdrawactive.v then
					tex = u8(translationtextdraw(tex))
				end
				
				if set.active.alignactive then
					align = "\n Align: " .. alig
					else
					align = ""
				end
				
				if set.active.statusactive then
					status = "\n Status: " .. statu
					else
					status = ""
				end
				
				if set.active.coloractive then
					color = "\n Color: " .. colo
					else
					color = ""
				end
				
				if set.active.color1active then
					color1 = "\n Color1: " .. colo1
					else
					color1 = ""
				end
				
				if set.active.color2active then
					color2 = "\n Color2: " .. colo2 
					else
					color2 = ""
				end
				
				if set.active.sizeXactive then
					sizeX = "\n SizeX: " .. sizX 
					else
					sizeX = ""
				end
				
				if set.active.sizeYactive then
					sizeY = "\n SizeY: " .. sizY 
					else
					sizeY = ""
				end
				
				if set.active.letSizeXactive then
					letSizeX = "\n LetSizeX: " .. letSizX
					else
					letSizeX = ""
				end
				
				if set.active.letSizeYactive then
					letSizeY = "\n LetSizeY: " .. letSizY
					else
					letSizeY = ""
				end
				
				if set.active.modelactive then
					model = "\n Model: " .. mode 
					else
					model = ""
				end
				
				if set.active.rotXactive then
					rotX = "\n RotX: " .. roX 
					else
					rotX = ""
				end
				
				if set.active.rotYactive then
					rotY = "\n RotY: " .. roY 
					else
					rotY = ""
				end
				
				if set.active.rotZactive then  
					rotZ = "\n RotZ: " .. roZ 
					else
					rotZ = ""
				end
				
				if set.active.zoomactive then
					zoom = "\n Zoom: " .. zom 
					else
					zoom = ""
				end
				
				if set.active.outlineactive then
					outline = "\n Outline: " .. outlin 
					else
					outline = ""
				end
				
				if set.active.outlinecoloractive then
					outlinecolor = "\n Outlinecolor: " .. outlinecolo 
					else
					outlinecolor = ""
				end
				
				if set.active.propactive then
					prop = "\n Prop: " .. pro
					else
					prop = ""
				end
				
				if set.active.shadowactive then
					shadow = "\n Shadow: " .. shado 
					else
					shadow = ""
				end
				
				if set.active.shadowcoloractive then
					shadowcolor = "\n Shadowcolor: " .. shadowcolo 
					else
					shadowcolor = ""
				end
				
				if set.active.xactive then
					x = "\n X: " .. xy 
					else
					x = ""
				end
				
				if set.active.yactive then
					y = "\n Y: " .. yx 
					else
					y = ""
				end
				
				if set.active.textactive then
					text = "\n Text: " .. tex
					else
					text = ""
				end
				
				x1, y1 = convertGameScreenCoordsToWindowScreenCoords(xy, yx)
				imgui.SetCursorPos(imgui.ImVec2(x1, y1))
				if imgui.Link(id, u8" TextDraw ID: " .. id .. align .. status .. color .. color1 .. color2 .. sizeX .. sizeY .. letSizeX .. letSizeY .. model .. rotX .. rotY .. rotZ .. zoom .. outline .. outlinecolor .. prop .. shadow .. shadowcolor .. x .. y .. text) then
					if copy.v then
						text = u8:decode(text)
						textcopy = align .. status .. color .. color1 .. color2 .. sizeX .. sizeY .. letSizeX .. letSizeY .. model .. rotX .. rotY .. rotZ .. zoom .. outline .. outlinecolor .. prop .. shadow .. shadowcolor .. x .. y .. text
						textcopy = string.gsub(textcopy, "\n", "")
						setClipboardText(textcopy)
					end
				end
			end
		end
		imgui.End()
	end
	
	if active.v then
		sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(320, 550))
		imgui.Begin(u8"Скрипт TextDraw[New]", active, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.Checkbox(u8"Показ параметра и копирование [Aligin]", alignactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Status]", statusactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Color]", coloractive)
		imgui.Checkbox(u8"Показ параметра и копирование [Color1]", color1active)		
		imgui.Checkbox(u8"Показ параметра и копирование [Color2]", color2active)
		imgui.Checkbox(u8"Показ параметра и копирование [SizeX]", sizeXactive)
		imgui.Checkbox(u8"Показ параметра и копирование [SizeY]", sizeYactive)
		imgui.Checkbox(u8"Показ параметра и копирование [LetSizeX]", letSizeXactive)
		imgui.Checkbox(u8"Показ параметра и копирование [LetSizeY]", letSizeYactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Model]", modelactive) 
		imgui.Checkbox(u8"Показ параметра и копирование [RotX]", rotXactive)		
		imgui.Checkbox(u8"Показ параметра и копирование [RotY]", rotYactive)
		imgui.Checkbox(u8"Показ параметра и копирование [RotZ]", rotZactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Zoom]", zoomactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Outline]", outlineactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Outlinecolor]", outlinecoloractive)
		imgui.Checkbox(u8"Показ параметра и копирование [Prop]", propactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Shadow]", shadowactive)
		imgui.Checkbox(u8"Показ параметра и копирование [X]", xactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Y]", yactive)
		imgui.Checkbox(u8"Показ параметра и копирование [Text]", textactive)
		imgui.Checkbox(u8"Параметр [Text Translation]", texttranslationtextdrawactive) 
		imgui.Checkbox(u8"Функция [Копирования]", copy)
		imgui.SetCursorPos(imgui.ImVec2(6, 528))
		if imgui.Link(u8"Вк создателя скрипта: https://vk.com/shishkin666", u8"Ссылка, жмякни") then
			--os.execute(('explorer.exe "%s"'):format("https://vk.com/shishkin666"))
		end
		
		imgui.End()
	end
	
end

function translationtextdraw(text) -- https://pawn-wiki.ru/index.php?/topic/24249-ispolzuem-russkie-simvoli-v-teksdravah/
	text = string.gsub(text, "a", "а")
	text = string.gsub(text, "A", "А")
	text = string.gsub(text, "—", "б")
	text = string.gsub(text, "Ђ", "Б")
	text = string.gsub(text, "ў", "в")
	text = string.gsub(text, "‹", "В")
	text = string.gsub(text, "™", "г")
	text = string.gsub(text, "‚", "Г")
	text = string.gsub(text, "љ", "д")
	text = string.gsub(text, "ѓ", "Д")
	text = string.gsub(text, "e", "е")
	text = string.gsub(text, "E", "Е")
	text = string.gsub(text, "e", "ё")
	text = string.gsub(text, "E", "Ё")
	text = string.gsub(text, "›", "ж")
	text = string.gsub(text, "„", "Ж")
	text = string.gsub(text, "џ", "з")
	text = string.gsub(text, "€", "З")
	text = string.gsub(text, "њ", "и")
	text = string.gsub(text, "…", "И")
	text = string.gsub(text, "ќ", "й")
	text = string.gsub(text, "…", "И")
	text = string.gsub(text, "k", "к")
	text = string.gsub(text, "K", "К")
	text = string.gsub(text, "ћ", "л")
	text = string.gsub(text, "‡", "Л")
	text = string.gsub(text, "Ї", "м")
	text = string.gsub(text, "M", "М")
	text = string.gsub(text, "®", "н")
	text = string.gsub(text, "H", "Н")
	text = string.gsub(text, "o", "о")
	text = string.gsub(text, "O", "О")
	text = string.gsub(text, "Ј", "п")
	text = string.gsub(text, "Њ", "П")
	text = string.gsub(text, "p", "р")
	text = string.gsub(text, "P", "Р")
	text = string.gsub(text, "c", "с")
	text = string.gsub(text, "C", "С")
	text = string.gsub(text, "¦", "т")
	text = string.gsub(text, "Џ", "Т")
	text = string.gsub(text, "y", "у")
	text = string.gsub(text, "Y", "У")
	text = string.gsub(text, "?", "ф")
	text = string.gsub(text, "Ѓ", "Ф")
	text = string.gsub(text, "x", "х")
	text = string.gsub(text, "X", "Х")
	text = string.gsub(text, "*", "ц")
	text = string.gsub(text, "‰", "Ц")
	text = string.gsub(text, "¤", "ч")
	text = string.gsub(text, "Ќ", "Ч")
	text = string.gsub(text, "Ґ", "ш")
	text = string.gsub(text, "Ћ", "Ш")
	text = string.gsub(text, "Ў", "щ")
	text = string.gsub(text, "Љ", "Щ")
	text = string.gsub(text, "©", "ь")
	text = string.gsub(text, "’", "Ь")
	text = string.gsub(text, "ђ", "ъ'")
	text = string.gsub(text, "§", "Ъ")
	text = string.gsub(text, "Ё", "ы")
	text = string.gsub(text, "‘", "Ы")
	text = string.gsub(text, "Є", "э")
	text = string.gsub(text, "“", "Э")
	text = string.gsub(text, "«", "ю")
	text = string.gsub(text, "”", "Ю")
	text = string.gsub(text, "¬", "я")
	text = string.gsub(text, "•", "Я")
	return text
end

function imgui.Link(label, description)
 	label = tostring(label)
	local size = imgui.CalcTextSize(label)
	local p = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local result = imgui.InvisibleButton(label, size)
	imgui.SetCursorPos(p2)
	if imgui.IsItemHovered() then
		if description then
			imgui.BeginTooltip()		
			imgui.PushTextWrapPos(600)
			imgui.TextUnformatted(description)
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.Text], label)
		imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Text]))
		else
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.Text], label)
	end
	return result
end

function guiCustomStyle()
	imgui.SwitchContext()
	style.WindowPadding                = ImVec2(4.0, 4.0)
	style.WindowRounding               = 7
	style.WindowTitleAlign             = ImVec2(0.5, 0.5)
	style.FramePadding             	   = ImVec2(4.0, 2.0)
	style.ItemSpacing                  = ImVec2(8.0, 4.0)
	style.ItemInnerSpacing             = ImVec2(4.0, 4.0)
	style.ChildWindowRounding          = 7
	style.FrameRounding                = 7
	style.ScrollbarRounding            = 7
	style.GrabRounding                 = 7
	style.IndentSpacing                = 21.0
	style.ScrollbarSize                = 13.0
	style.GrabMinSize                  = 10.0
	style.ButtonTextAlign              = ImVec2(0.5, 0.5)
	colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]         = ImVec4(0, 0, 0, 1.0)
	colors[clr.WindowBg]             = ImVec4(0.09, 0.09, 0.09, 1.00)
	colors[clr.ChildWindowBg]        = ImVec4(9.90, 9.99, 9.99, 1.00)
	colors[clr.PopupBg]              = ImVec4(0.09, 0.09, 0.09, 1.00)
	colors[clr.Border]               = ImVec4(0.71, 0.71, 0.71, 0.40)
	colors[clr.BorderShadow]         = ImVec4(9.90, 9.99, 9.99, 0.00)
	colors[clr.FrameBg]              = ImVec4(0.34, 0.30, 0.34, 0.30)
	colors[clr.FrameBgHovered]       = ImVec4(0.22, 0.21, 0.21, 0.40)
	colors[clr.FrameBgActive]        = ImVec4(0.20, 0.20, 0.20, 0.44)
	colors[clr.TitleBg]              = ImVec4(0.52, 0.27, 0.77, 0.82)
	colors[clr.TitleBgActive]        = ImVec4(0.55, 0.28, 0.75, 0.87)
	colors[clr.TitleBgCollapsed]     = ImVec4(9.99, 9.99, 9.90, 0.20)
	colors[clr.MenuBarBg]            = ImVec4(0.27, 0.27, 0.29, 0.80)
	colors[clr.ScrollbarBg]          = ImVec4(0.08, 0.08, 0.08, 0.60)
	colors[clr.ScrollbarGrab]        = ImVec4(0.54, 0.20, 0.66, 0.30)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.21, 0.21, 0.21, 0.40)
	colors[clr.ScrollbarGrabActive]  = ImVec4(0.80, 0.50, 0.50, 0.40)
	colors[clr.ComboBg]              = ImVec4(0.20, 0.20, 0.20, 0.99)
	colors[clr.CheckMark]            = ImVec4(0.89, 0.89, 0.89, 0.50)
	colors[clr.SliderGrab]           = ImVec4(1.00, 1.00, 1.00, 0.30)
	colors[clr.SliderGrabActive]     = ImVec4(0.80, 0.50, 0.50, 1.00)
	colors[clr.Button]               = ImVec4(0.48, 0.25, 0.60, 0.60)
	colors[clr.ButtonHovered]        = ImVec4(0.67, 0.40, 0.40, 1.00)
	colors[clr.ButtonActive]         = ImVec4(0.80, 0.50, 0.50, 1.00)
	colors[clr.Header]               = ImVec4(0.56, 0.27, 0.73, 0.44)
	colors[clr.HeaderHovered]        = ImVec4(0.78, 0.44, 0.89, 0.80)
	colors[clr.HeaderActive]         = ImVec4(0.81, 0.52, 0.87, 0.80)
	colors[clr.Separator]            = ImVec4(0.42, 0.42, 0.42, 1.00)
	colors[clr.SeparatorHovered]     = ImVec4(0.57, 0.24, 0.73, 1.00)
	colors[clr.SeparatorActive]      = ImVec4(0.69, 0.69, 0.89, 1.00)
	colors[clr.ResizeGrip]           = ImVec4(1.00, 1.00, 1.00, 0.30)
	colors[clr.ResizeGripHovered]    = ImVec4(1.00, 1.00, 1.00, 0.60)
	colors[clr.ResizeGripActive]     = ImVec4(1.00, 1.00, 1.00, 0.89)
	colors[clr.CloseButton]          = ImVec4(0.33, 0.14, 0.46, 0.50)
	colors[clr.CloseButtonHovered]   = ImVec4(0.69, 0.69, 0.89, 0.60)
	colors[clr.CloseButtonActive]    = ImVec4(0.69, 0.69, 0.69, 1.00)
	colors[clr.PlotLines]            = ImVec4(1.00, 0.99, 0.99, 1.00)
	colors[clr.PlotLinesHovered]     = ImVec4(0.49, 0.00, 0.89, 1.00)
	colors[clr.PlotHistogram]        = ImVec4(9.99, 9.99, 9.90, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(9.99, 9.99, 9.90, 1.00)
	colors[clr.TextSelectedBg]       = ImVec4(0.54, 0.00, 1.00, 0.34)
	colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.34)
end
guiCustomStyle()