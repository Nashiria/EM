import numpy as np

class Field():
    def __init__(self, name: str, amplitude: float, direction: str, size: int, dx: float) -> None:
        self.name = name # Name of the field
        self.size = size # size in the direction of propagation
        self.direc = direction
        self.amp = amplitude # amplitude of the 'uniform' field
        self.vec = self.amp * np.ones(self.size) # field vector
        self.dx = dx # spatial step

    def __call__(self, x: float) -> float:
        return self.vec[int(x)]

    def zeroboundary(self):
        self.vec[0] = 0
        self.vec[-1] = 0

    def derivative(self, prop='front') -> np.ndarray:
        # Front propagation
        if prop == 'front':
            for i in range(0, self.size-1):
                self.vec[i] = (self.vec[i+1] - self.vec[i]) / self.dx
            self.vec[self.size-1] = self.vec[self.size-2]
        # Back propagation
        elif prop == 'back':
            for i in range(self.size-1, 0, -1):
                self.vec[i] = (self.vec[i] - self.vec[i-1]) / self.dx
            self.vec[0] = self.vec[1]

    def __repr__(self) -> str:
        return f'{self.name} field in the {self.direc} direction'

    def __str__(self) -> str:
        return f'{self.name} field in the {self.direc} direction'

class EM():
    eps0 = 8.854187817620e-12
    mu0 = 4*np.pi*1e-7
    c = 1/np.sqrt(eps0*mu0)

    def __init__(self, direc: str, size: int, dx: float) -> None:
        self.dx = dx
        self.dt = self.dx / self.c  
        self.direc = direc
        self.size = size
        self.ey = Field('Ey', 0, direc, self.size, self.dt)
        self.hz = Field('Hz', 0, direc, self.size, self.dt)

    def update(self) -> None:
        temp1 = np.zeros(self.size)
        temp2 = np.zeros(self.size)
        
        self.ey.zeroboundary()
        
        for i in range(0, self.size-1):
            temp2[i] = self.hz.vec[i] + (self.dt/(self.dx*self.mu0))*(self.ey.vec[i+1] - self.ey.vec[i])
        
        self.hz.vec = temp2 

        self.hz.zeroboundary()

        for i in range(0, self.size):
            temp1[i] = self.ey.vec[i] + (self.dt/(self.dx*self.eps0))*(self.hz.vec[i] - self.hz.vec[i-1])

        self.ey.vec = temp1

        self.ey.zeroboundary()
        self.hz.zeroboundary()

    def __repr__(self) -> str:
        return f'EM field in the {self.direc} direction'

    def __str__(self) -> str:
        return f'EM field in the {self.direc} direction'
    
    def __call__(self, x: int) -> tuple:
        return self.ey(x), self.hz(x)
