import numpy as np
from ofdm_utils import *
from ofdm import *
from channel import *

def data_generator(train=0,val=0,test=0):
    if(train==1):
        message_length = 4096
    if(val==1):
        message_length = 256
    if(test==1):
        message_length = 256
    EbNodb = np.arange(0,12)
    BER = np.zeros((1,np.size(EbNodb)))
    n_iter = 100
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
            input_symbols = np.reshape(QPSK_symbols, (-1,64)).T
            time_domain_input = np.reshape(ofdm_tx(input_symbols,nfft,nsc,CP),(-1,int(nfft+CP))).T
            
            # flat rayleigh fading
            received_time_domain = rayleigh_channel(time_domain_input,ebno)

            # remove the CP
            received_td = np.zeros(input_symbols.shape)
            received_td = received_time_domain[CP:,:]
            received_td = received_td.T
            x = np.reshape(np.real(received_td.flatten()), (-1,1))
            y = np.reshape(np.imag(received_td.flatten()),(-1,1))
            b = np.concatenate((x,y),axis=1).flatten()

            # Collect the training data
            training_bits.append(msg_bits)
            training_received_symbols.append(b)
    if(train==1):
        print("Train data length is %d bits" %np.size(training_bits))
    if(val==1):
        print("validation data length is %d bits" %np.size(training_bits))
    if(test==1):
        print("Test data length is %d bits" %np.size(training_bits))   

    return(training_received_symbols,training_bits)

