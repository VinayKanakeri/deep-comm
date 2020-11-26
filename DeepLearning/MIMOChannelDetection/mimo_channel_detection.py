import numpy as np
import math
from model import mimo_model, train
#from scipy.misc import imresize
from scipy.io import loadmat
import matplotlib.pyplot as plt

train_data = loadmat('file.mat')
