import numpy as np
from ofdm_utils import *
from ofdm import *
from channel import *

message_length = 256
EbNodb = np.arange(0,12)
BER = np.zeros((1,np.size(EbNodb)))
n_iter = 1
training_bits = []
training_received_symbols = []
for ebno in EbNodb:
    for itr in range(0,n_iter):
        msg_bits = message_generator(message_length)
        modem = QAMModem(4) # QPSK
        QPSK_symbols = modem.modulate(msg_bits)

        # OFDM
        CP = 4
        nfft = 64
        nsc = 64
        input_symbols = np.reshape(QPSK_symbols, (64,-1))
        time_domain_input = np.reshape(ofdm_tx(input_symbols,nfft,nsc,CP),(int(nfft+CP),-1))

        # flat rayleigh fading
        received_time_domain = rayleigh_channel(time_domain_input,ebno)

        # remove the CP
        received_td = np.zeros(input_symbols.shape)
        received_td = received_time_domain[CP:,:]

        # Collect the training data
        training_bits.append(msg_bits)
        training_received_symbols.append(received_td)



print(np.size(training_bits))
print(np.size(training_received_symbols))
