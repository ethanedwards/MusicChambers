pitches = { 7.00, 7.02, 7.05, 7.07, 7.10, 8.00, 8.07 }
psize = len(pitches)
//for (st = 0; st < .5; st = st+0.1) {

wave = maketable("wave3", 1000, 1, 1, 0, 2, 0.2, 90.0, 3.5, 0.4, 0)
//table = maketable("line", size, time1, value1, [ timeN-1, valueN-1, ] timeN, valueN)
//   wave = maketable("line", 1000, 0, -1, 1, 1, 2, -1, 3, 1)
amp = 5000
ampenv = maketable("line", 1000, 0,0, 0.1,1, 0.2,1, 0.3,0)

start = 0
n = trand(1, 3)
//i should ideally equal 5
for(i = 0; i < n; i = i + 1){
//      freq = irand(200, 700)
index = trand(0, psize)
pch = pitches[index]
freq = cpspch(pch)
WAVETABLE(start, 0.3, amp*ampenv, freq, random(), wave)
start = start + .2
}
