import numpy as np
from numpy.fft import fft, ifft
from numpy.linalg import qr, norm
import matplotlib.pyplot as plt
from itertools import product

def ofdm_tx(x, nfft, nsc, cp_length):
    """ OFDM Transmit signal generation """

    nfft = float(nfft)
    nsc = float(nsc)
    cp_length = float(cp_length)
    ofdm_tx_signal = np.array([])

    for i in range(0, x.shape[1]):
        symbols = x[:, i]
        ofdm_sym_freq = np.zeros(int(nfft), dtype=complex)
        ofdm_sym_freq[1:int((nsc) / 2) + 1] = symbols[int((nsc) / 2):]
        ofdm_sym_freq[-int((nsc)/ 2):] = symbols[0:int((nsc) / 2)]
        ofdm_sym_time = ifft(ofdm_sym_freq)
        cp = ofdm_sym_time[-int(cp_length):]
        ofdm_tx_signal = np.concatenate((ofdm_tx_signal, cp, ofdm_sym_time))

    return ofdm_tx_signal


def ofdm_rx(y, nfft, nsc, cp_length):
    """ OFDM Receive Signal Processing """

    num_ofdm_symbols = int(len(y) / (nfft + cp_length))
    x_hat = np.zeros([nsc, num_ofdm_symbols], dtype=complex)

    for i in range(0, num_ofdm_symbols):
        ofdm_symbol = y[i * nfft + (i + 1) * cp_length:(i + 1) * (nfft + cp_length)]
        symbols_freq = fft(ofdm_symbol)
        x_hat[:, i] = np.concatenate((symbols_freq[-nsc / 2:], symbols_freq[1:(nsc / 2) + 1]))

    return x_hat
