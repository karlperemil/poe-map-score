^+m::
Send {ctrl}c
mapText = %clipboard%
quantity = RegexMatch(mapText, (Quantity:)\s\+([0-9]*) [, quant = ""])
quant = quant%1%

packsize = RegexMatch(mapText, ((Pack\sSize.*:)\s\+([0-9]*) [, pack = ""])
pack = pack%2%

magic = RegexMatch(mapText, (\d\d)%\smore\smagic [, mag = ""])
mag = mag%1%

rare = RegexMatch(mapText, (\d\d)%\smore\srare, [, rar = ""])
rar = rar%1%

quant = quant/100 + 1
pack = pack*2/100 + 1
mag = mag*.7/100 + 1
rar = rar*.2/100 + 1

z = 1
base = 1.75

maps = (base * quant * pack * mag * z) + (base * quant * (rar - 1))


mapReturns = 1
MsgBox Map Score: %maps%
return