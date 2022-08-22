from scipy import signal
import numpy as np
import matplotlib.pyplot as plt

t = np.linspace(start=0, stop=148799, num=500000)
y_list = []
for i in t:
    y = abs((i % 27565)-2500)
    y_list.append(y)

# plt.plot(t, signal.sawtooth(2 * np.pi * 2000 * t, width=0.5))
# plt.show()
# plt.plot(t, y_list)
# plt.show()
RATE = 11025
minf = 500
maxf = 3000
fw = 2000
delta = fw/RATE
half_T = int((maxf-minf)/delta)
singal_len = 148799
a = np.arange(start=minf, stop=maxf, step=delta)
while len(a)<singal_len:
    a = np.concatenate([a, a[::-1]])

# b = np.concatenate([a, a[::-1]])

x = np.arange(start=0, stop=singal_len, step=1)

plt.plot(x, a[0:singal_len])
plt.show()

