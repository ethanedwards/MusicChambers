load("MMODALBAR")
pches = { 6.05, 6.07, 6.09, 6.10, 7.00, 7.03, 7.05, 7.07, 7.08, 7.09, 7.10, 8.00, 8.05}
lpches = len(pches)
//for(i = 0; i<9; i = i+3){
pch = pches[trand(0, lpches)]
MMODALBAR(.1, 1.0, 10000, cpspch(pch), 0.4, 0.4)
MMODALBAR(.3, 1.0, 10000, cpspch(pch), 0.4, 1)
MMODALBAR(.7, 1.0, 10000, cpspch(pch), 0.4, 2)
//}