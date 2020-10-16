# deep-comm
This is repository is for the deep learning exploration of channel estimation in MIMO OFDM communication systems. The code for the implementation 
is written in both Python and MATLAB.
 
## Files and what they do :

### OTFS_Tut.ipynb

This is a jupyter notebook for the introduction to OTFS modulation written completely in python. The modulation steps have been laid out. Steps
for channel estimation and detection are yet to be implemented.

Note : To run this notebook commpy module is required. If you dont have it please run the following command to install it :

pip install scikit-commpy

### CooperativeOFDM.ipynb

This notebook is an introduction to the using of commpy module and also introduces the concept of Amplify and Forward for cooperative relay 
systems consiting of a single relay.

### DeepLearning :

MATLAB deeplearning implementation.

### channel_test.zip and channel_train.zip :

These contain the values for the testing and training data for our deep learning models for the channel. Each file contains an numpy array stored as an
object which needs to loaded onto the variable of use. The numpy array has a dimension of $Tx16$ where the rows inidcate the evolution of the 16
taps across time. 

Note : This is the time domain complex values of the channel obtained through the WINNER 2 channel model. 
