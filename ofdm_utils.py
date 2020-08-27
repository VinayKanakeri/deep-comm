import numpy as np 
from numpy.fft import fft, ifft
from numpy.linalg import qr, norm
import matplotlib.pyplot as plt
from itertools import product

# QPSK
# SISO flat channel
# 64 subcarriers, N = 64
# 128 bits per block

def bitarray2dec(in_bitarray):

    number = 0

    for i in range(len(in_bitarray)):
        number = number + in_bitarray[i] * pow(2, len(in_bitarray) - 1 - i)

    return number

def dec2bitarray(in_number, bit_width):
    
    if isinstance(in_number, (np.integer, int)):
        return decimal2bitarray(in_number, bit_width).copy()
    result = np.zeros(bit_width * len(in_number), np.int8)
    for pox, number in enumerate(in_number):
        result[pox * bit_width:(pox + 1) * bit_width] = decimal2bitarray(number, bit_width).copy()
    return result

def decimal2bitarray(number, bit_width):

    result = np.zeros(bit_width, np.int8)
    i = 1
    pox = 0
    while i <= number:
        if i & number:
            result[bit_width - pox - 1] = 1
        i <<= 1
        pox += 1
    return result

def signal_power(signal):

    @np.vectorize
    def square_abs(s):
        return abs(s) ** 2

    P = np.mean(square_abs(signal))
    return P

def message_generator(message_length,blocks=1):
    msg = np.random.randint(2, size=(int(message_length),blocks))
    return msg


# Modulator and demodulator

class Modem:

    """ Creates a custom Modem object.
        Parameters
        ----------
        constellation : array-like with a length which is a power of 2
                        Constellation of the custom modem
        Attributes
        ----------
        constellation : 1D-ndarray of complex
                        Modem constellation. If changed, the length of the new constellation must be a power of 2.
        Es            : float
                        Average energy per symbols.
        m             : integer
                        Constellation length.
        num_bits_symb : integer
                        Number of bits per symbol.
        Raises
        ------
        ValueError
                        If the constellation is changed to an array-like with length that is not a power of 2.
        """

    def __init__(self, constellation):
        """ Creates a custom Modem object. """

        self.constellation = constellation

    def modulate(self, input_bits):
        """ Modulate (map) an array of bits to constellation symbols.
        Parameters
        ----------
        input_bits : 1D ndarray of ints
            Inputs bits to be modulated (mapped).
        Returns
        -------
        baseband_symbols : 1D ndarray of complex floats
            Modulated complex symbols.
        """
        mapfunc = np.vectorize(lambda i:
                            self._constellation[bitarray2dec(input_bits[i:i + self.num_bits_symbol])])

        baseband_symbols = mapfunc(np.arange(0, len(input_bits), self.num_bits_symbol))

        return baseband_symbols

    def demodulate(self, input_symbols, demod_type, noise_var=0):
        """ Demodulate (map) a set of constellation symbols to corresponding bits.
        Parameters
        ----------
        input_symbols : 1D ndarray of complex floats
            Input symbols to be demodulated.
        demod_type : string
            'hard' for hard decision output (bits)
            'soft' for soft decision output (LLRs)
        noise_var : float
            AWGN variance. Needs to be specified only if demod_type is 'soft'
        Returns
        -------
        demod_bits : 1D ndarray of ints
            Corresponding demodulated bits.
        """
        if demod_type == 'hard':
            index_list = abs(input_symbols - self._constellation[:, None]).argmin(0)
            demod_bits = dec2bitarray(index_list, self.num_bits_symbol)

        elif demod_type == 'soft':
            demod_bits = np.zeros(len(input_symbols) * self.num_bits_symbol)
            for i in np.arange(len(input_symbols)):
                current_symbol = input_symbols[i]
                for bit_index in np.arange(self.num_bits_symbol):
                    llr_num = 0
                    llr_den = 0
                    for bit_value, symbol in enumerate(self._constellation):
                        if (bit_value >> bit_index) & 1:
                            llr_num += np.exp((-abs(current_symbol - symbol) ** 2) / noise_var)
                        else:
                            llr_den += np.exp((-abs(current_symbol - symbol) ** 2) / noise_var)
                    demod_bits[i * self.num_bits_symbol + self.num_bits_symbol - 1 - bit_index] = np.log(llr_num / llr_den)
        else:
            raise ValueError('demod_type must be "hard" or "soft"')

        return demod_bits

    def plot_constellation(self):
        """ Plot the constellation """
        plt.scatter(self.constellation.real, self.constellation.imag)

        for symb in self.constellation:
            plt.text(symb.real + .2, symb.imag, self.demodulate(symb, 'hard'))

        plt.title('Constellation')
        plt.grid()
        plt.show()

    @property
    def constellation(self):
        """ Constellation of the modem. """
        return self._constellation

    @constellation.setter
    def constellation(self, value):
        # Check value input
        num_bits_symbol = np.log2(len(value))
        if num_bits_symbol != int(num_bits_symbol):
            raise ValueError('Constellation length must be a power of 2.')

        # Set constellation as an array
        self._constellation = np.array(value)

        # Update other attributes
        self.Es = signal_power(self.constellation)
        self.m = self._constellation.size
        self.num_bits_symbol = int(num_bits_symbol)

# QAM modulator, use m=4 for QPSK

class QAMModem(Modem):
    """ Creates a Quadrature Amplitude Modulation (QAM) Modem object.
        Parameters
        ----------
        m : int
            Size of the PSK constellation.
        Attributes
        ----------
        constellation : 1D-ndarray of complex
                        Modem constellation. If changed, the length of the new constellation must be a power of 2.
        Es            : float
                        Average energy per symbols.
        m             : integer
                        Constellation length.
        num_bits_symb : integer
                        Number of bits per symbol.
        Raises
        ------
        ValueError
                        If the constellation is changed to an array-like with length that is not a power of 2.
    """

    def __init__(self, m):
        """ Creates a Quadrature Amplitude Modulation (QAM) Modem object.
        Parameters
        ----------
        m : int
            Size of the QAM constellation.
        """

        def _constellation_symbol(i):
            return (2 * i[0] - 1) + (2 * i[1] - 1) * (1j)

        mapping_array = np.arange(1, np.sqrt(m) + 1) - (np.sqrt(m) / 2)
        self.constellation = list(map(_constellation_symbol,
                                      list(product(mapping_array, repeat=2))))
