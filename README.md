# Doctor's Prescription System with Handwriting Recognition

This project explores the the viability of handwriting recognition to recognize the names of medicines from a doctor's prescription. This is done using a Convolutional Neural Network (CNN). The app is connected to a Flask backend which hosts the model and predicts the names of medicines from a given image.


## How it works
The API has been developed using Flask and uses a combination of OpenCV and Tensorflow to pre-process the image and perfom the prediction. Using OpenCV, individual letters are cropped out from an image of the prescription. Then, a Convolutional Neural Network (CNN) is used to recognize individual letters. These predictions are then merged and then a similarity detection algorithm is used to find the closest medicine match. 