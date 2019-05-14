import keras 
from keras.datasets import mnist
import numpy as np
from keras.backend import backend as K
from matplotlib import pyplot as plt
import keras.layers as layers
import keras.models as models


# NEURAL NETWORK SETTINGS
batch_size = 128
num_classes = 10
epochs = 1

# INPUT DIMENSIONS
img_h, img_w = 28, 28

# LOAD DATASET
(x_train, y_train), (x_test, y_test) = mnist.load_data()

# np.arrays has following shapes: 
# (60000, 28, 28) - x_train.shape
# (60000,) - y_train.shape
# (10000, 28, 28) - x_test.shape
# (10000,) - y_test.shape

# IMAGE PREPROCESSING
x_train = x_train.reshape(x_train.shape[0], img_h, img_w, 1)
x_test = x_test.reshape(x_test.shape[0], img_h, img_w, 1)
input_shape = (img_h, img_w, 1)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255 

y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

model = models.Sequential()
model.add(layers.Conv2D(32, kernel_size=(3, 3),
                 activation='relu',
                 input_shape=input_shape))
model.add(layers.Conv2D(64, (3, 3), activation='relu'))
model.add(layers.MaxPooling2D(pool_size=(2, 2)))
model.add(layers.Dropout(0.25))
model.add(layers.Flatten())
model.add(layers.Dense(128, activation='relu'))
model.add(layers.Dropout(0.5))
model.add(layers.Dense(num_classes, activation='softmax'))

model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.Adadelta(),
              metrics=['accuracy'])

model.summary()
history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(x_test, y_test))

score = model.evaluate(x_test, y_test, verbose=0)


model.save('MNIST_model.h5')

model_json = model.to_json()
with open("MNIST_model.json", "w") as f:
    f.write(model_json)

model.save_weights("MNIST_model_weights.h5")
print("Saved model to disk")


acc = history.history['acc']
val_acc = history.history['val_acc']
loss = history.history['loss']
val_loss = history.history['val_loss']
epochs = range(1, len(acc) + 1)
plt.plot(epochs, acc, 'bo', label='Training acc')
plt.plot(epochs, val_acc, 'b', label='Validation acc')
plt.title('Training and validation accuracy')
plt.legend()
plt.figure()
plt.plot(epochs, loss, 'bo', label='Training loss')
plt.plot(epochs, val_loss, 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.legend()
plt.show()