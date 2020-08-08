import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import math

def deep_ofdm_model(input_shape=(256,), output_size=16, reg=0.0):
    
    model_input = keras.Input(shape=input_shape, name = 'Received signal')
    ofdm_net = layers.Dense(500, kernel_regularizer=tf.keras.regularizers.l2(reg))(model_input)
    ofdm_net = layers.Activation('relu')(ofdm_net)
    ofdm_net = layers.Dense(250, kernel_regularizer=tf.keras.regularizers.l2(reg))(ofdm_net)
    ofdm_net = layers.Activation('relu')(ofdm_net)
    ofdm_net = layers.Dense(120, kernel_regularizer=tf.keras.regularizers.l2(reg))(ofdm_net)
    ofdm_net = layers.Activation('relu')(ofdm_net)
    ofdm_net = layers.Dense(output_size, kernel_regularizer=tf.keras.regularizers.l2(reg))(ofdm_net)
    model_output = layers.Activation('sigmoid')(ofdm_net)

    model = keras.Model(inputs=model_input, outputs=model_output)

    return model

    

