load("MSAXOFONY")
pches = { 7.05, 7.07, 7.09, 7.10}
lpches = len(pches)
breathenv = maketable("line", 1000, 0,1, 2,0)

cheese = pches[trand(0, lpches)]
MSAXOFONY(0, 1.1, 20000.0, cpspch(cheese), 0.2, 0.7, 0.5, 0.3, 0.6, 0.5, breathenv)
cheese = pches[trand(0, lpches)]
MSAXOFONY(0, 1.1, 20000.0, cpspch(cheese), 0.2, 0.7, 0.5, 0.3, 0.6, 0.5, breathenv)