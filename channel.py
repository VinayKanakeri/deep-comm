import numpy as np

def rayleigh_channel(msg,ebno):
    ebno_lin = np.power(10,((ebno)/10)) 
    sigma = np.sqrt(1/(2*ebno_lin))
    h = (np.random.normal(0.0, 1.0, msg.shape) + 1j*np.random.normal(0.0, 1.0, msg.shape))/np.sqrt(2)
    n = (np.random.normal(0.0, sigma, msg.shape) + 1j*np.random.normal(0.0, sigma, msg.shape))/np.sqrt(2)

    return (np.multiply(msg,h) + n)
    