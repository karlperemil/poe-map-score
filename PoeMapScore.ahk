; Thanks to exiletools.com for the item lookup script
; AMBUSH zana mod asummes you roll EVERY box with "Guarded by one pack of Magic monsters"
; On average this will cost you 115 alteration orbs per map

; HOTKEYS:
; Ctrl + G = no zana or fragments
; Ctrl + H = no zana, 1 fragment
; Ctrl + J = no zana, 2 fragments
; Ctrl + k = no zana, 3 fragments
; Ctrl + Shift + G = Onslaught/Anarchy/Torment/Warbands/Beyond, 0 fragments
; Ctrl + Shift + H = Onslaught/Anarchy/Torment/Warbands/Beyond, 1 fragments
; Ctrl + Shift + J = Onslaught/Anarchy/Torment/Warbands/Beyond, 2 fragments
; Ctrl + Shift + K = Onslaught/Anarchy/Torment/Warbands/Beyond, 3 fragments
; Ctrl + Alt + G = Ambush, 0 fragments
; Ctrl + Alt + H = Ambush, 1 fragments
; Ctrl + Alt + J = Ambush, 2 fragments
; Ctrl + Alt + K = Ambush, 3 fragments

MouseMoveThreshold := 40
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

#IfWinActive Path of Exile ahk_class Direct3DWindowClass


^g::FunctionCalcMapDrops(0,false,false)
^h::FunctionCalcMapDrops(1,false,false)
^j::FunctionCalcMapDrops(2,false,false)
^k::FunctionCalcMapDrops(3,false,false)

^+g::FunctionCalcMapDrops(0,true,false)
^+h::FunctionCalcMapDrops(1,true,false)
^+j::FunctionCalcMapDrops(2,true,false)
^+k::FunctionCalcMapDrops(3,true,false)

^!g::FunctionCalcMapDrops(0,false,true)
^!h::FunctionCalcMapDrops(1,false,true)
^!j::FunctionCalcMapDrops(2,false,true)
^!k::FunctionCalcMapDrops(3,false,true)



FunctionCalcMapDrops(fragments, domi, ambush){

	quant := 0
	zana := 1
	zanaMod := "None"
	If(domi){
		zana := 1
		zanaMod := "Onslaught/Anarchy/Torment/Warbands/Beyond"
		quant := 0.2
	}

	If(ambush){
		zana := 1.276923
		zanaMod := "Ambush"
	}

	Send ^c
	Sleep 250
	ClipBoardData = %clipboard%
	StringReplace RawItemData, ClipBoardData, `r, , A

	RegExMatch(RawItemData, "(Quantity:)\s\+([0-9]*)", SubPat)
	quant := quant + (SubPat2/100)
	If(!quant){
		quant = 0
	}
	quant := quant + (fragments * 0.05)

	RegexMatch(RawItemData, "(Pack\sSize.*:)\s\+([0-9]*)", Packsize)
	pack := Packsize2/100

	If(!pack){
		pack = 0
	}
	Else {
		pack := ((1+pack)**2)-1
	}
	
	RegexMatch(RawItemData, "(\d\d).\smore\sMagic", Magic)
	mag := Magic1/100
	If(!mag){
		mag = 0
	}

	RegexMatch(RawItemData, "(\d\d).\smore\sRare", Rare)
	rar := Rare1/100
	If(!rar){
		rar = 0
	}

	RegexMatch(RawItemData, "two\sUnique\sBosses", Boss)
	boss := Boss1
	If(!boss){
		boss = 1
	}
	Else {
		boss = 2
	}

	RegexMatch(RawItemData, "Map\sTier:\s([0-9]*)", Tier)
	tier := Tier1
	If(!tier){
		tier = 1
	}

	;todo add zana mods
	;todo add vaal fragments

	mapDropChance = 0.013424
	magicModIncrease = 0.1430/30
	rareModIncrease = 0.04532/30

	
	itemsDroppedMagic := 64.346 * zana
	If(ambush){
		itemsDroppedMagic := 64.346 * 1.5
	}
	itemsDroppedRare = 20.395
	itemsDroppedNormal := 39.41 * zana
	If(ambush){
		itemsDroppedNormal := 39.41 * 1.19
	}
	itemsDroppedBoss = 10.83

	magicItems := itemsDroppedMagic * (1 + pack) * (1 + mag) * (1 + quant)
	rareItems := itemsDroppedRare * (1 + rar) * (1 + quant)
	normalItems := itemsDroppedNormal * (1 +pack) * (1 + quant)
	bossItems := itemsDroppedBoss * boss * (1 + quant)

	mapDropPlusTwo := .2 * 1/(tier+2)
	mapDropPlusOne := (magicItems + rareItems + bossItems) * mapDropChance * (1/(tier + 1))
	mapDropPlusOne := mapDropPlusOne + (.2 - mapDropPlusTwo)
	mapDropSameLevel := (magicItems + rareItems + bossItems + normalItems) * mapDropChance * (1/tier)
	mapDropSameLevel := mapDropSameLevel + (.2 - mapDropPlusTwo*2)
	mapDropSameLevelOrBelow := (magicItems + rareItems + normalItems + bossItems) * mapDropChance
	mapDropSameLevelOrBelow := mapDropSameLevelOrBelow + (.2  - mapDropPlusTwo*2)
	totalMapDrops := (magicItems + bossItems + normalItems + rareItems) * mapDropChance
	totalMapDrops := totalMapDrops + .2
	breakEvenValue := mapDropPlusTwo + mapDropPlusOne + mapDropSameLevel
	advanceValue := mapDropPlusTwo + mapDropPlusOne

	textToShow := "Map Return Chances" . "`rMap Score: " . Round(breakEvenValue,2) . "`rTotal Map Drops: " . Round(totalMapDrops,2) . " `r" . "+2: " . Round(mapDropPlusTwo,2) . " `r" . "+1: " . Round(mapDropPlusOne,2) . "`r+0: " . Round(mapDropSameLevel,2)  . "`rAdvance Value: " . Round(advanceValue,2) . "`rZanaMod: " . zanaMod . "`rVaal Fragments: " . fragments
	
	FunctionShowToolTipPriceInfo(textToShow)

	;FunctionShowToolTipPriceInfo()

}


FunctionShowToolTipPriceInfo(responsecontent)
{
    ; Get position of mouse cursor
    Sleep, 2
	Global X
    Global Y
    MouseGetPos, X, Y	
	gui, font, s15, Verdana 
    ToolTip, %responsecontent%, X - 135, Y + 30
    SetTimer, SubWatchCursorPrice, 100     

}



SubWatchCursorPrice:
  MouseGetPos, CurrX, CurrY
  MouseMoved := (CurrX - X)**2 + (CurrY - Y)**2 > MouseMoveThreshold**2
  If (MouseMoved)
  {
    SetTimer, SubWatchCursorPrice, Off
    ToolTip
  }
return