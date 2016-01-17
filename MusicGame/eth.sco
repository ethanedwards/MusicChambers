

if(alive == 1){
srand() /* srand with no seed will use system clock for seed */
//have you set id?
//volume = makeconnection("inlet", slot, 0.0)
ampenv = maketable("line", 1000, 0,0, 1,1, 2,0)
amp = 5000
wave = maketable("wave", 1000, 1, 0.4, 0.2, 0.1)

pitches = { 7.00, 7.02, 7.05, 7.07, 7.1, 8., 8.03, 8.04, 8.05, 8.07 }
lengthpitches = len(pitches)

start = 0


index = trand(0, lengthpitches)
pch = pitches[index] + irand(0.001, 0.0035)
dur = irand(3.0, 7.0)
i = 0;
for(i = 0; i < voices; i = i + 1){

//    if(bamp == 2.0){
//        pch = pch + trand(0, 3)*.04
//        start = start +.2
//        dur = .5
//        WAVETABLE(start, dur, amp*ampenv, pch, random(), wave)

//    } else{

volume = makeconnection("inlet", slot, 0.0)
        WAVETABLE(start, dur, amp*ampenv*volume*.5, pch, random(), wave)
        pch = pch + .04;
//    }
    //obviously not all .04 interval

}

//WAVETABLE(start+irand(0.0, 1.0), dur, amp*ampenv, pch+.04, random(), wave)
//WAVETABLE(start+irand(0.0, 1.0), dur, amp*ampenv, pch+.07, random(), wave)

MAXMESSAGE(3.0, 0.0, slot)
}












/*
for (i = 0; i < 4; i = i+1) {
if( random() < 0.3) {
for (j = 0; j < 4; j = j+1) {
index = trand(0, lengthpitches)
pch = pitches[index] + irand(0.001, 0.0035)
dur = irand(3.0, 7.0)
WAVETABLE(start+irand(0.0, 1.0), dur, amp*ampenv, pch, random(), wave)
}
}
}
*/