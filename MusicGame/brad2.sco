if(alive == 1){
srand() /* srand with no seed will use system clock for seed */

ampenv = maketable("line", 1000, 0,0, 1,1, 2,0)
amp = 5000
wave = maketable("wave", 1000, "square5")

pitches = { 6.05, 6.07, 6.08, 6.10, 7.00, 7.02, 7.05, 7.07, 7.10 }
lengthpitches = len(pitches)

start = 0
for (i = 0; i < voices; i = i+1) {
index = trand(0, lengthpitches)
pch = pitches[index]
dur = irand(7.0, 15.0)
for (j = 0; j < 4; j = j+1) {
volume = makeconnection("inlet", slot, 0.0)
WAVETABLE(start+irand(0.0, 1.0), dur, amp*ampenv*volume*.5, pch + irand(0.001, 0.004), j/3, wave)
}
start = start + irand(0, 8)
}

//MAXBANG(irand(5.0, 10.0))
MAXMESSAGE(irand(5.0, 10.0), 2.0, slot)
}