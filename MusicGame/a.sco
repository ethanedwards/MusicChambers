pitches = { 7.00, 7.02, 7.05, 7.07, 7.10, 8.00, 8.07 }
psize = len(pitches)
//for (st = 0; st < .5; st = st+0.1) {
st = 0
    index = trand(0, psize)
    pch = pitches[index]
    STRUM2(st, 1.0, 5000, pch, 1, 1.0, random())
//}
