import numpy as np
import math
from numpy.lib.function_base import append
import mat73

from tensorflow.python.keras.backend import concatenate, shape, zeros
from model import mimo_model, train, predict
#from scipy.misc import imresize
from scipy.io import loadmat
import matplotlib.pyplot as plt

train_data = mat73.loadmat('datset_big.mat')
y = np.squeeze(np.array(train_data['dataset']))
#y = (x[0][0])
#print(y[1][1].shape)
train_image = []
train_label = []


for i in range(12):
    temp3 = np.empty([len(y[i][0][:,0,0]),0,len(y[i][0][0,0,:])])
    temp4 = np.empty([len(y[i][1][:,0,0]),0,len(y[i][1][0,0,:])])
    for j in range(4):
        temp = np.stack((np.real(y[i][0][:,j,:]), np.imag(y[i][0][:,j,:])),axis = 2)
        temp = np.moveaxis(temp, 2, 1)
        temp2 = np.stack((np.real(y[i][1][:,j,:]), np.imag(y[i][1][:,j,:])),axis = 2)
        temp2 = np.moveaxis(temp2, 2, 1)
        temp3 = np.concatenate((temp3,temp),axis=1)
        temp4 = np.concatenate((temp4,temp2),axis=1)
    train_image.append(temp3)
    train_label.append(temp4)


#idx_random = np.random.rand(len(train_image[7][1][1])) < (1/9)  # uses 32000 from 36000 as training and the rest as validation
train_data_1, train_label_1 = train_image[7][:,:,0:70000] , train_label[7][:,:,0:70000]
val_data_1, val_label_1 = train_image[7][:,:,70001:72500] , train_label[7][:,:,70001:72500]
Nant = len(train_data_1[:,0,0])
Ncarr = len(train_data_1[0,:,0])
train_data_1 = np.moveaxis(train_data_1,2,0)[..., np.newaxis]
train_label_1 = np.moveaxis(train_label_1,2,0)[..., np.newaxis]
val_data_1 = np.moveaxis(val_data_1,2,0)[..., np.newaxis]
val_label_1 = np.moveaxis(val_label_1,2,0)[..., np.newaxis]

print(train_data_1.shape)

train(train_data_1 ,train_label_1, val_data_1 , val_label_1,Nant,Ncarr)


train_pred = predict(train_data_1,Nant,Ncarr)
val_pred = predict(val_data_1,Nant,Ncarr)

