/*load("MSAXOFONY")
pches = { 6.05, 6.11, 7.09, 6.10}
lpches = len(pches)
breathenv = maketable("line", 1000, 0,1, 2,0)

cheese = pches[trand(0, lpches)]
MSAXOFONY(0, 0.3, 20000.0, cpspch(pches[2]), 0.2, 0.7, 0.5, 0.3, 0.6, 0.5, breathenv)
cheese = pches[trand(0, lpches)]
MSAXOFONY(0, 0.4, 10000.0, cpspch(cheese), 0.2, 0.7, 0.5, 0.3, 0.6, 0.5, breathenv)
*/
pitches = {6.07, 6.10, 8.00, 8.07 }
psize = len(pitches)
//for (st = 0; st < .5; st = st+0.1) {
st = 0
index = trand(0, psize)
pch = pitches[index]
STRUM2(st, 1.0, 5000, pch, 1, 1.0, random())
//}
