; Thanks to exiletools.com for the item lookup script

MouseMoveThreshold := 40
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen


^+m::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{
	Send ^c
	Sleep 250
	ClipBoardData = %clipboard%
	StringReplace RawItemData, ClipBoardData, `r, , A
	RegExMatch(RawItemData, "(Quantity:)\s\+([0-9]*)", SubPat)
	quant := SubPat2/100
	If(!quant){
		quant = 0
	}

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

	mapDropChance = 0.0101148
	magicModIncrease = 0.1430/30
	rareModIncrease = 0.04532/30
	
	itemsDroppedMagic = 64.346
	itemsDroppedRare = 20.395
	itemsDroppedNormal = 39.41
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
	totalMapdrops := (magicItems + bossItems + normalItems + rareItems) * mapDropChance
	totalMapDrops := totalMapdrops + .2
	breakEvenValue := mapDropPlusTwo + mapDropPlusOne + mapDropSameLevel
	advanceValue := mapDropPlusTwo + mapDropPlusOne

	textToShow := "Map Return Chances`rTotal Map Drops: " . Round(totalMapdrops,2) . " `r" . "+2: " . Round(mapDropPlusTwo,2) . " `r" . "+1: " . Round(mapDropPlusOne,2) . "`r+0: " . Round(mapDropSameLevel,2) . "`rBreak Even: " . Round(breakEvenValue,2) . "`radvanceValue: " . Round(advanceValue,2)
	
	FunctionShowToolTipPriceInfo(textToShow)

	;FunctionShowToolTipPriceInfo()
}
return

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