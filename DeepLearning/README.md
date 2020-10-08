# DeepLearning
This is directory contains all the MATLAB files for the deep learning model simulation.To run any of these files the user must have :

MATLAB v. 2018 or greter 

Toolboxes :
Communication System Toolbox
Deep Learning Toolbox
WINNER2 Toolbox 
 
## Files and what they do :

### WINNER2ChannelModelConfig.m

This matlab function file helps us in configuring the WINNER 2 model by specifying the number of tx,rx antennaes, positions of the MS and BS
stations as their velocities if they have any. Other than this we can also select the environment we are doing the simulatio in, more information
regarding these options are mentioned in the WINNER2 documnetaion. 


### WINNER2ImpulseResponse.m

This notebook gets the impulse response of the channel i.e. CIR for the given duration. This also provides the channel coeffcients of each 
of the taps and their evolution in time.

### OFDMCOnfig.m :

MATLAB function to setup the configuration structure of the OFDM system, i.e. number of symbols, CP length, Gaurd Interval, DC Null etc.

### OFDM_Tx.m :
Provides the final OFDM waveform in timedomain which is to be transmitted across the channel with the CP and all the guard interval included. 

### LSE.m :
Provides the Least Square Estimate for the received signal for the subcarriers and time instants at which the pilot is defined.

### ChanNetEst.mlx :

This is an interative notebook (MATLAB version of jupyter notebook) for the deep learning model for the ChanNetEst neural network implementation. Its 
implementation and traning/testing is done in this notebook.

### trainingDataLabels_freq.m

Provides the training data and labels of the channel in the frequency domain for the defined subframe, number of symbols, and for the mentioned
OFDM_Config settings.

### tanhLayer.m

MATLAB 2018 has no implementation  of the tanh layer we had to write this layer on our own.
