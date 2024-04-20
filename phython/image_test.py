from matplotlib import pyplot as plt
import numpy as np
import cv2
from PIL import Image
from numpy import asarray
import binascii


#im_2= plt.imread('constrained_image.jpg')
#print(im_2.shape)
#print(im_2)


def constrain_channels(pixel):
    # Constrain each channel value to the range [0, 15]
    return tuple(min(15, max(0, int(channel))) for channel in pixel)

def constrain_image(image):
    width, height = image.size
    constrained_image = Image.new('RGB', (width, height))

    for y in range(height):
        for x in range(width):
            # Get the pixel value at (x, y)
            pixel = image.getpixel((x, y))
            # Constrain the RGB channels
            constrained_pixel = constrain_channels(pixel)
            # Set the constrained pixel value in the new image
            constrained_image.putpixel((x, y), constrained_pixel)

    return constrained_image

# Load the image
image_path = 'image_480.jpg'  # Replace 'your_image_path.jpg' with your image file path
image = Image.open(image_path)

# Constrain the image channels
constrained_image = constrain_image(image)

# Save the constrained image
constrained_image.save('constrained_image.jpg')  # Save the constrained image as 'constrained_image.jpg'


pix=plt.imread('constrained_image.jpg')

#file=open('output_rgb.txt','w')
#file.write(str(pix))
#file.close()

print(binascii.b2a_hex(pix[1]))

