load("MULTIWAVE")
//number should probably be limited, clipping very frequent, strange crash with too many, should probably talk to brad
ampenv = maketable("line", 1000, 0,0, 1,1, 2,0)
wave = maketable("wave", 1000, 1)

srand()

MULTIWAVE(0, 4.3, ampenv*35000, wave,
irand(100, 700), 1, 0, random())
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random(),
//irand(100, 700), 1, 0, random())