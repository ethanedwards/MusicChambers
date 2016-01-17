if(alive == 1){
srand() /* srand with no seed will use system clock for seed */

ampenv = maketable("line", 1000, 0,0, 1,1, 2,0)
amp = 5000
wave = maketable("wave", 1000, 1, 0.4, 0.2, 0.1)

pitches = { 7.00, 7.02, 7.05, 7.07, 7.1, 8., 8.03, 8.04, 8.05, 8.07 }
lengthpitches = len(pitches)

start = 0
for (i = 0; i < 4; i = i+1) {
if( random() < 0.3) {
for (j = 0; j < 4; j = j+1) {
index = trand(0, lengthpitches)
pch = pitches[index] + irand(0.001, 0.0035)
dur = irand(10.5, 25.0)
volume = makeconnection("inlet", slot, 0.0)
WAVETABLE(start+irand(0.0, 1.0), dur, amp*ampenv*volume*.5, pch, random(), wave)
}
}
}

//MAXBANG(irand(7.0, 14.0))
MAXMESSAGE(irand(7.0, 14.0), 1.0, slot)
}