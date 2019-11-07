script_name('GameHelperBind')
script_author('Sergey_Mescaline')
script_version("08.11.2019")

require 'lib.moonloader'
local inicfg = require'inicfg'
local memory = require 'memory'
local imgui = require 'imgui'
local imadd = require 'imgui_addons'
local key = require 'vkeys'
local rkeys = require 'rkeys'
local encoding = require 'encoding'
local s = require 'lib.samp.events'
local BitStreamIO = require 'lib.samp.events.bitstream_io'

imgui.ToggleButton = require('imgui_addons').ToggleButton

encoding.default = 'CP1251'
u8 = encoding.UTF8

--local stateIni = inicfg.save(mainIni, directIni)
local playerTargeting = -1 -- ïåðåìåííàÿ äëÿ id èãðîêà íà ïðèöåëå


local toggle = false
local directIni = "moonloader\\GameHelperBind\\settings.ini"
local mainIni = inicfg.load(nil, directIni)
local imBool1 = imgui.ImBool(false)
local imBool2 = imgui.ImBool(false)
local imBool3 = imgui.ImBool(false)
local wind = imgui.ImBool(false)
local settings_window = imgui.ImBool(false)

local items = {
	u8"Êðàñíàÿ òåìà",
	u8"Êîðè÷íåâàÿ òåìà",
	u8"Çåë¸íî-ãîëóáàÿ òåìà",
	u8"Ãîëóáàÿ òåìà"
}
local def = {
	settings = {
		theme = 1,
	},
}
local ini = inicfg.load(def, directIni)
local eatId = mainIni.tdid.eat
local tema = imgui.ImInt(ini.settings.theme)
local armour = false

function imgui.OnDrawFrame()
	if ini.settings.theme == 0 then
	red_style()
	end
	if ini.settings.theme == 1 then
	brown_style()
	end
	if ini.settings.theme == 2 then
	blue_green_style()
	end
  if wind.v then
  
	local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) --ïîëîæåíèå
    imgui.SetNextWindowSize(imgui.ImVec2(596, 500), imgui.Cond.FirstUseEver)--ðàçìåð
    
	imgui.Begin('GameHelperBind', wind)
		imgui.PushItemWidth(150)
		imgui.SetCursorPos(imgui.ImVec2(435, 25))
			if imgui.Combo('', tema, items, -1)then
				ini.settings.theme = tema.v
				inicfg.save(def, directIni)
			end imgui.PopItemWidth()
	
	--Èãðîê íà ïðèöåëå (äëÿ âçàèìîäåéñòâèÿ)
	imgui.BeginChild('##hide', imgui.ImVec2(580, 30), true)
		if (playerTargeting >= 0) then
			local name = sampGetPlayerNickname(tostring(playerTargeting))
			imgui.Text(u8'Öåëü: '..name..'('..tostring(playerTargeting)..')')
			imgui.SameLine( ) ShowHelpMarker(u8'Ïðèöåëüòåñü (ÏÊÌ) â èãðîêà, ÷òîáû çàõâàòèòü åãî ID!')
			imgui.SameLine()
			if imgui.Button(u8'Check LVL') then
				sampSendChat("/id "..tostring(playerTargeting))
			end
		end
		if (playerTargeting < 0) then
			imgui.Text(u8'Öåëü: íåò')
			imgui.SameLine( ) ShowHelpMarker(u8'Ïðèöåëüòåñü (ÏÊÌ) â èãðîêà, ÷òîáû çàõâàòèòü åãî ID!')
		end
	imgui.EndChild()
	-----------------------------------------------------------
	--Êíîïêè
	
	--1 áëîê
	-----------------------------------------------------------
	imgui.BeginChild('##1', imgui.ImVec2(190, 180), true)
	local btn_size = imgui.ImVec2(-0.1, 0)
	imgui.Text(u8'Îáùåíèå')
	imgui.Separator()
		if imgui.Button(u8'Ïðèâåò!', btn_size) then
		  sampSendChat("Ïðèâåò!")
		end
		if imgui.Button(u8'[fam] Ïðèâåò!', btn_size) then
		  sampSendChat("/fam Ïðèâåò!")
		end
		if imgui.Button(u8'[fam] Âåëêîì!', btn_size) then
		  sampSendChat("/fam Äîáðî ïîæàëîâàòü â íàøó äðóæíóþ ñåìüþ!")
		end
		if imgui.Button(u8'[fam] Ñ ÄÐ!', btn_size) then
		  sampSendChat("/fam Ïîçäðàâëÿþ ñ Äí¸ì ðîæäåíèÿ! Ñ÷àñòüÿ, çäîðîâüÿ, äîëãèõ ëåò æèçíè!")
		end
	imgui.EndChild()
	------------------------------------------------------------
	
	imgui.SameLine() -- Äëÿ òîãî, ÷òîá áëîêè øëè â îäíó ñòðîêó
	
	--2 áëîê
	------------------------------------------------------------
	imgui.BeginChild('##2', imgui.ImVec2(190, 180), true)
	imgui.Text(u8'Îñêíóòü ìóäàêà')
	imgui.Separator()
		if imgui.Button(u8'Ñìîòðè êóäà åäåøü, ïèäîðàñ!', btn_size) then
		  sampSendChat("/s Ñìîòðè êóäà åäåøü, ïèäîðàñ!")
		end
		if imgui.Button(u8'Õóéëî åáàíîå!', btn_size) then
		  sampSendChat("/s Õóéëî åáàíîå!")
		end
		if imgui.Button(u8'Çàâàëè åáàëî!', btn_size) then
		  sampSendChat("/s Çàâàëè åáàëî, îáîññàíûé!")
		end
	imgui.EndChild()
	------------------------------------------------------------
	
	imgui.SameLine() -- Äëÿ òîãî, ÷òîá áëîêè øëè â îäíó ñòðîêó
	
	--3 áëîê
	------------------------------------------------------------
	imgui.BeginChild('##3', imgui.ImVec2(190, 180), true)
	imgui.Text(u8'Äåíåæíûå îïåðàöèè')
	imgui.Separator()
		if imgui.Button(u8'Òðåéä', btn_size) then
		  sampSendChat("/trade "..tostring(playerTargeting))
		end
		if imgui.Button(u8'Ïåðåäàòü 10ê', btn_size) then
		  sampSendChat("/pay "..tostring(playerTargeting).." 10000")
		end
		if imgui.Button(u8'Ïåðåäàòü 20ê', btn_size) then
		  sampSendChat("/pay "..tostring(playerTargeting).." 20000")
		end
		if imgui.Button(u8'Ïåðåäàòü 30ê', btn_size) then
		  sampSendChat("/pay "..tostring(playerTargeting).." 30000")
		end
		if imgui.Button(u8'Ïåðåäàòü 40ê', btn_size) then
		  sampSendChat("/pay "..tostring(playerTargeting).." 40000")
		end
		if imgui.Button(u8'Ïåðåäàòü 50ê', btn_size) then
		  sampSendChat("/pay "..tostring(playerTargeting).." 50000")
		end
	imgui.EndChild()
	------------------------------------------------------------
	
	--imgui.SameLine() -- Íå íóæíà, ò.ê. â ýòîì ìåñòå áëîê 4 èä¸ò ñ íîâîé ñòðîêè
	
	--4 áëîê
	------------------------------------------------------------
	imgui.BeginChild('##4', imgui.ImVec2(190, 180), true)
	imgui.Text(u8'×èòû')
	imgui.Separator()
		
		if imgui.Button(u8'Åäà', btn_size) then
		  sampSendClickTextdraw(mainIni.tdid.eat)
		end
		if imgui.Button(u8'Õèëë', btn_size) then
		  sampSendClickTextdraw(mainIni.tdid.hp)
		end
	imgui.EndChild()
	------------------------------------------------------------
	
	imgui.SameLine()
	
	--5 áëîê
	------------------------------------------------------------
	imgui.BeginChild('##5', imgui.ImVec2(190, 180), true)
	imgui.Text(u8'Ðàçíîå')
	imgui.Separator()
		if imgui.Button(u8'Ïî÷èíêà', btn_size) then
		sampSendChat("/repcar")
		end
		if imgui.Button(u8'Çàïðàâêà', btn_size) then
		sampSendChat("/fillcar")
		end
		if imgui.Button(u8'Áðîíÿ', btn_size) then
		lua_thread.create(function()
		mainIni = inicfg.load(nil, directIni)
			sampSendChat("/me "..mainIni.roleplay.armour)
				wait(1000)
			sampSendChat("/armour")
		end)
		end
		if imgui.Button(u8'Ìàñêà', btn_size) then
		lua_thread.create(function()
		mainIni = inicfg.load(nil, directIni)
			sampSendChat("/me "..mainIni.roleplay.mask)
				wait(1000)
			sampSendChat("/mask")
		end)
		end
		if imgui.Button(u8'Òåñò', btn_size) then
		sampIsChatInputActive(true)
		sampSetChatInputText('/gps')
		end
		if imgui.Button(u8'Óïîòðåáèòü 3ã íàðêî', btn_size) then
		lua_thread.create(function()
		mainIni = inicfg.load(nil, directIni)
			sampSendChat("/me äîñòàë òàáëåòêó àíàëüãèíà è çàêèíóë â ðîò")
				wait(1000)
			sampSendChat("/usedrugs 3")
		end)
		end
	imgui.EndChild()
	-----------------------------------------------------------
	
	imgui.SameLine()
	
	--6 áëîê
	------------------------------------------------------------
	imgui.BeginChild('##6', imgui.ImVec2(190, 180), true)
	imgui.Text(u8'Ïîëåçíîñòè')
	imgui.Separator()
		imgui.Text(u8'ÀâòîÅäà')
		imgui.SameLine( ) ShowHelpMarker(u8'ÎÑÒÎÐÎÆÍÎ! Äàííàÿ ôóíêöèÿ çàïðåùåíà íà ñåðâåðå è êàðàåòñÿ áàíîì!')
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(155, 30))
		if imgui.ToggleButton("aeat", imBool1) then
			a = not a
		end
		imgui.Text(u8'ÀíòèÀôê')
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(155, 57))
		if imgui.ToggleButton("aafk", imBool2) then
			aAfk()
		end
		imgui.Text('Hide')
		imgui.SameLine( ) ShowHelpMarker(u8'Ñêðûâàåò èãðîêîâ â çîíå ïðîðèñîâêè. Äëÿ òîãî, ÷òîáû îíè ñíîâà ïîÿâèëèñü, íóæíî çàéòè â ëþáîé èíòåðüåð. ÔÓÍÊÖÈß ÇÀÏÐÅÙÅÍÀ ÍÀ ÑÅÐÂÅÐÅ!')
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(155, 84))
		if imgui.ToggleButton("hide", imBool3) then
			hide()
		end
	imgui.EndChild()
	-----------------------------------------------------------
	--imgui.ShowStyleEditor()
  end
 imgui.End()
end

function main()
autoupdate("https://raw.githubusercontent.com/SergeyMescaline/GameHelperBind/master/update.json", '['..string.upper(thisScript().name)..']: ', "http://vk.com/irbis_st")
repeat wait(0) until isSampAvailable()
lua_thread.create(eat)
   sampRegisterChatCommand('/goeat', function() 
      g = not g
      sampAddChatMessage(g and "{0x21dfb9}ÀâòîÅäà âêëþ÷åíà!" or "{0xe8482c}ÀâòîÅäà âûêëþ÷åíà!", -1)
   end)
   sampRegisterChatCommand('/eat', function() sampSendClickTextdraw(646) end)
   sampRegisterChatCommand('/hp', function() sampSendClickTextdraw(644) end)
   sampRegisterChatCommand('getinfo', cmd_getinfo)
   sampRegisterChatCommand('setinfo', cmd_setinfo)
   
   sampAddChatMessage(string.format("{f93f00} [Mescaline binder] çàãðóæåí!", -1), -1)
   sampAddChatMessage(string.format("{f93f00} [Àêòèâàöèÿ]: {e8e632}Q+E êàê ÷èò êîä.", -1), -1)
   sampAddChatMessage(string.format("{f93f00} [Àâòîð]: {e8e632}Sergey_Mescaline | vk.com/irbis_st", -1), -1)
  
  while true do wait(0)
    --if isKeyJustPressed(0x72) then
        --wind.v = not wind.v
    --end
	--Àêòèâàöèÿ
    if isKeyDown(key.VK_Q) and isKeyJustPressed(key.VK_E) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then
        wind.v = not wind.v
    end
	------------
	-- Ïîëó÷åíèå àéäè èãðîêà â ïðèöåëå
	local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid and doesCharExist(ped) then
		local result, id = sampGetPlayerIdByCharHandle(ped)
		if result then
			playerTargeting = id
		end
	end
	------------------------------------
 imgui.Process = wind.v
  end
end

function aAfk()
    actAFK = not actAFK
    if actAFK then
        writeMemory(7634870, 1, 1, 1)
        writeMemory(7635034, 1, 1, 1)
        memory.fill(7623723, 144, 8)
        memory.fill(5499528, 144, 6)
        addOneOffSound(0.0, 0.0, 0.0, 1136)
        sampAddChatMessage("   {1E90FF}Anti AFK{808080}  |  {90EE90}Àêòèâèðîâàí!", 0xFFFFFF)
    else
        writeMemory(7634870, 1, 0, 0)
        writeMemory(7635034, 1, 0, 0)
        memory.hex2bin('5051FF1500838500', 7623723, 8)
        memory.hex2bin('0F847B010000', 5499528, 6)
        addOneOffSound(0.0, 0.0, 0.0, 1136)
        sampAddChatMessage("   {1E90FF}Anti AFK{808080}  |  {FA8072}Äåàêòèâèðîâàí!", 0xFFFFFF)
    end
end



function eat()
   while true do wait(1800000)
     if a then
	  sampSendClickTextdraw(mainIni.tdid.eat)
    end
  end
end

function ShowHelpMarker(text)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(imgui.GetFontSize() * 35.0)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function s.onPlayerStreamIn()
	if toggle then 
	return false
	end
end

function hide()
toggle = not toggle
  if toggle then
  sampAddChatMessage('[hide] {FFFFFF}Activated.', 0xFF3F33)
  local chars = getAllChars()
	for i = 1, #chars do
	local res, id = sampGetPlayerIdByCharHandle(chars[i])
	  if res and chars[i] ~= 1 then
	  hidePlayer(id)
	  end
	end
  else
  sampAddChatMessage('[hide] {FFFFFF}Deactivated.', 0xFF3F33)
  end
end

function hidePlayer(id)
local w = BitStreamIO.bs_write
local bs = raknetNewBitStream()
w.int16(bs, id)
raknetEmulRpcReceiveBitStream(163, bs)
end



--ÑÒÈËÈ
function red_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function brown_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.23, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.43, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.43, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.23, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.43, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.39, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.43, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.43, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.43, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.28, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.43, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.43, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.43, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.25, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.25, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.43, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.43, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.43, 0.26, 0.95)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.50, 0.35, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.43, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function blue_green_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.16, 0.48, 0.42, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.98, 0.85, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.98, 0.85, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.48, 0.42, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.88, 0.77, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.Button]                 = ImVec4(0.26, 0.98, 0.85, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.98, 0.82, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.98, 0.85, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.98, 0.85, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.10, 0.75, 0.63, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.10, 0.75, 0.63, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.26, 0.98, 0.85, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.98, 0.85, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.98, 0.85, 0.95)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.98, 0.85, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function light_blue_style()
imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

colors[clr.Text]   = ImVec4(0.00, 0.00, 0.00, 0.51)
colors[clr.TextDisabled]   = ImVec4(0.24, 0.24, 0.24, 1.00)
colors[clr.WindowBg]              = ImVec4(1.00, 1.00, 1.00, 1.00)
colors[clr.ChildWindowBg]         = ImVec4(0.96, 0.96, 0.96, 1.00)
colors[clr.PopupBg]               = ImVec4(0.92, 0.92, 0.92, 1.00)
colors[clr.Border]                = ImVec4(0.86, 0.86, 0.86, 1.00)
colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg]               = ImVec4(0.88, 0.88, 0.88, 1.00)
colors[clr.FrameBgHovered]        = ImVec4(0.82, 0.82, 0.82, 1.00)
colors[clr.FrameBgActive]         = ImVec4(0.76, 0.76, 0.76, 1.00)
colors[clr.TitleBg]               = ImVec4(0.00, 0.45, 1.00, 0.82)
colors[clr.TitleBgCollapsed]      = ImVec4(0.00, 0.45, 1.00, 0.82)
colors[clr.TitleBgActive]         = ImVec4(0.00, 0.45, 1.00, 0.82)
colors[clr.MenuBarBg]             = ImVec4(0.00, 0.37, 0.78, 1.00)
colors[clr.ScrollbarBg]           = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.ScrollbarGrab]         = ImVec4(0.00, 0.35, 1.00, 0.78)
colors[clr.ScrollbarGrabHovered]  = ImVec4(0.00, 0.33, 1.00, 0.84)
colors[clr.ScrollbarGrabActive]   = ImVec4(0.00, 0.31, 1.00, 0.88)
colors[clr.ComboBg]               = ImVec4(0.92, 0.92, 0.92, 1.00)
colors[clr.CheckMark]             = ImVec4(0.00, 0.49, 1.00, 0.59)
colors[clr.SliderGrab]            = ImVec4(0.00, 0.49, 1.00, 0.59)
colors[clr.SliderGrabActive]      = ImVec4(0.00, 0.39, 1.00, 0.71)
colors[clr.Button]                = ImVec4(0.00, 0.49, 1.00, 0.59)
colors[clr.ButtonHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
colors[clr.ButtonActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
colors[clr.Header]                = ImVec4(0.00, 0.49, 1.00, 0.78)
colors[clr.HeaderHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
colors[clr.HeaderActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
colors[clr.ResizeGrip]            = ImVec4(0.00, 0.39, 1.00, 0.59)
colors[clr.ResizeGripHovered]     = ImVec4(0.00, 0.27, 1.00, 0.59)
colors[clr.ResizeGripActive]      = ImVec4(0.00, 0.25, 1.00, 0.63)
colors[clr.CloseButton]           = ImVec4(0.00, 0.35, 0.96, 0.71)
colors[clr.CloseButtonHovered]    = ImVec4(0.00, 0.31, 0.88, 0.69)
colors[clr.CloseButtonActive]     = ImVec4(0.00, 0.25, 0.88, 0.67)
colors[clr.PlotLines]             = ImVec4(0.00, 0.39, 1.00, 0.75)
colors[clr.PlotLinesHovered]      = ImVec4(0.00, 0.39, 1.00, 0.75)
colors[clr.PlotHistogram]         = ImVec4(0.00, 0.39, 1.00, 0.75)
colors[clr.PlotHistogramHovered]  = ImVec4(0.00, 0.35, 0.92, 0.78)
colors[clr.TextSelectedBg]        = ImVec4(0.00, 0.47, 1.00, 0.59)
colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35)
end

--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   ______   __   ___  ____  _     _  __
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| | __ ) \ / /  / _ \|  _ \| |   | |/ /
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   |  _ \\ V /  | | | | |_) | |   | ' /
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  | |_) || |   | |_| |  _ <| |___| . \
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____| |____/ |_|    \__\_\_| \_\_____|_|\_\                                                                                                                                                                                                                  
--
-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Çàãðóæåíî %d èç %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')
                      sampAddChatMessage((prefix..'Îáíîâëåíèå çàâåðøåíî!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Îáíîâëåíèå íå òðåáóåòñÿ.')
            end
          end
        else
          print('v'..thisScript().version..': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end


