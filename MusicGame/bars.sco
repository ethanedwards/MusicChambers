//MMODALBAR(outsk, dur, AMP, FREQ, hardness, pos, preset[, PAN, AMPENV])
load("MMODALBAR")
pches = { 7.05, 7.07, 7.09, 7.10, 8.00, 8.03, 8.05, 8.07, 8.08, 8.09, 8.10, 9.00, 9.05, 9.07, 10.00 }
lpches = len(pches)
//for(i = 0; i<9; i = i+3){
pch = pches[trand(0, lpches)]
MMODALBAR(1*.1, 1.0, 10000, cpspch(pch), 0.4, 0.4) //originally one last i
MMODALBAR(2*.1, 1.0, 10000, cpspch(pch), 0.4, 1)
MMODALBAR(5*.1, 1.0, 10000, cpspch(pch), 0.4, 2)
//}
