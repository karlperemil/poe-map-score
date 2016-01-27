MouseMoveThreshold := 40
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen


^+m::
Send ^c
Sleep 250
ClipBoardData = %clipboard%
StringReplace RawItemData, ClipBoardData, `r, , A
RegExMatch(RawItemData, "(Quantity:)\s\+([0-9]*)", SubPat)
quant := SubPat2


RegexMatch(RawItemData, "(Pack\sSize.*:)\s\+([0-9]*)", Packsize)
pack := Packsize2

RegexMatch(RawItemData, "(\d\d).\smore\sMagic", Magic)
mag := Magic1
If(!mag){
	mag = 1
}

RegexMatch(RawItemData, "(\d\d).\smore\sRare", Rare)
rar := Rare1

quant := quant/100 + 1
pack := pack*2/100 + 1
mag := mag*.7/100 + 1
rar := rar*.2/100 + 1
base := 1.75

maps := (base * quant * pack * mag ) + (base * quant * (rar - 1))

FunctionShowToolTipPriceInfo(maps)
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