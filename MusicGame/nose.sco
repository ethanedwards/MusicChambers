load("NOISE")

ampenv = maketable("window", 1000, "hanning")
NOISE(0.0, 2.5, 2000*ampenv)