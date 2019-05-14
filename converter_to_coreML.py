import coremltools
from keras import models


model = models.load_model('MNIST_model.h5')
output_labels = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
mnist_model = coremltools.converters.keras.convert('MNIST_model.h5',
                                                   input_names=['image'],
                                                   output_names=['output'], 
                                                   class_labels=output_labels,
                                                   image_input_names='image')
mnist_model.author = 'kedrboje'
mnist_model.short_description = 'Digit Recognition with MNIST'
mnist_model.input_description['image'] = 'Input image'
mnist_model.output_description['output'] = 'Output prediction'
mnist_model.save('MNIST_model.mlmodel')