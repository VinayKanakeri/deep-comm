import tensorflow as tf
from tensorflow import keras
from keras.models import Sequential,  Model
from keras.layers import Convolution2D,Input,BatchNormalization,Conv2D,Activation,Lambda,Subtract,Conv2DTranspose, PReLU
from keras.regularizers import l2
from keras.layers import  Reshape,Dense,Flatten
# from keras.layers.advanced_activations import LeakyReLU
from keras.callbacks import ModelCheckpoint
from keras.optimizers import SGD, Adam
from scipy.io import loadmat
import keras.backend as K
# from keras.layers.advanced_activations import LeakyReLU
from keras.callbacks import ModelCheckpoint
from keras.optimizers import SGD, Adam
import numpy as np
import math

def mimo_model(input_shape=(5,128,1)):
    #input_shape = (5,128,1)
    # Input
    initializer = tf.keras.initializers.GlorotNormal()
    input = Input(shape=input_shape, name = 'Input')

    c1 = Conv2D(64, (2,2), activation = 'relu', kernel_initializer=initializer, padding='same')(input)
    c2 = Conv2D( 32 , (1,1), activation = 'relu', kernel_initializer=initializer, padding='same')(c1)
    c3 = Conv2D(1, (5,5), kernel_initializer=initializer, padding='same')(c2)

    #DnCNN

    # 1st layer, Conv+relu
    x = Conv2D(filters=64, kernel_size=(3,3), strides=(1,1), padding='same')(c3)
    x = Activation('relu')(x)
    # 18 layers, Conv+BN+relu
    for i in range(18):
        x = Conv2D(filters=64, kernel_size=(3,3), strides=(1,1), padding='same')(x)
        x = BatchNormalization(axis=-1, epsilon=1e-3)(x)
        x = Activation('relu')(x)   
    # last layer, Conv
    x = Conv2D(filters=1, kernel_size=(3,3), strides=(1,1), padding='same')(x)
    x = Subtract()([c3, x])   # input - noise
    model = Model(inputs=input, outputs=x)
    adam = Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-8) 
    model.compile(optimizer=adam, loss='mean_squared_error', metrics=['mean_squared_error'])    
    #model.summary()
    return model

def train(train_data,train_label,val_data,val_label,Nant,Ncarr):
    model = mimo_model((Nant,Ncarr,1))

    checkpoint = ModelCheckpoint("mimo_check.h5", monitor='val_loss', verbose=1, save_best_only=True,
                                 save_weights_only=False, mode='min')
    callbacks_list = [checkpoint]   
    model.fit(train_data, train_label, batch_size=128, validation_data=(val_data, val_label),
                  callbacks=callbacks_list, shuffle=True, epochs= 100 , verbose=0)
    model.save_weights("mimo_"+str(Nant)+".h5")

def predict(input_data, Nant, Ncarr):
    model = mimo_model((Nant,Ncarr,1))
    model.load_weights("mimo_" + str(Nant)+".h5")
    predicted  = model.predict(input_data)
    return predicted
