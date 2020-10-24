import tensorflow as tf
import keras
from keras.layers import Input, Dense, LSTM, Conv1D, Bidirectional, Permute
from keras.models import Model

input_layer = Input(shape=(14, 128))
conv1 = Conv1D(filters=128,
               kernel_size=1,
               strides=1,
               activation='tanh',
               padding='same')(input_layer)
permute1 = Permute((2, 1), input_shape=(14, 128))(conv1)
lstm1 = Bidirectional(LSTM(14, return_sequences=True))(permute1)
act = tf.keras.activations.tanh(lstm1)
output_layer = Dense(14, activation='tanh')(act)
model = Model(inputs=input_layer, outputs=output_layer)

model.summary()