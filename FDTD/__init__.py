from .maths.field import *
from .interface.frame import *
# from matplotlib import 

size = int(input('Enter the size of the grid: '))
em = EM('x', size, 0.01)
message = f'{em.ey.name} and {em.hz.name} fields in the {em.ey.direc} direction are created.'
print(printFrame(message))

def startfdtd() -> None:
    import matplotlib.pyplot as plt
    import numpy as np

    plt.ion()
    plt.figure()

    for t in range(1000):
        em.update()
        if t < 100:
            em.ey.vec[1:3] += 5 * np.cos(2*np.pi*t/10) * np.exp(-(t - 20)**2 / 100)
        plt.clf()
        plt.plot(em.ey.vec, 'r')
        plt.ylim([-10, 10])
        # plt.plot(em.ey.vec, 'b')
        plt.pause(0.001)
