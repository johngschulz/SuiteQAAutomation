from PIL import Image
from PIL import ImageChops
from io import BytesIO

class ImageLibrary:

    def images_should_be_equal(self,fnameRefImage,imageBytes,maxBad=20):
         print '*DEBUG* fname = %s, other image has %i bytes' % (fnameRefImage, len(imageBytes))
         refImage = self._loadImageFromDisk(fnameRefImage)
         otherImage = self._loadImageFromBytes(imageBytes)

         if ( (refImage.width != otherImage.width) or (refImage.height != otherImage.height) ):
             raise AssertionError('reference image and test image have different height/width!')

         badPixels = self._nPixelsDifferent(refImage, otherImage)
         print '*DEBUG* number of different pixels = %i' % badPixels
         if badPixels > maxBad :
            otherImage.save("_badimage.png","PNG")
            raise AssertionError('reference image and test image are different! %i pixels are different.' % badPixels)

    def read_file_bytes(self, fname) :
        return open(fname,"rb").read()


    def _loadImageFromDisk(self,fname) :
        return (Image.open(fname)).convert("RGB")

    def _loadImageFromBytes(self,imageBytes) :
        return (Image.open( BytesIO(imageBytes))).convert("RGB")

    def _nPixelsDifferent(self,image1,image2,threshhold=3) :
         diffImage = ImageChops.difference(image1, image2)
         badPixels = 0
         for w in range(0,diffImage.width):
            for h in range(0,diffImage.height):
                pixel = diffImage.getpixel( (w,h))
                difference = pixel[0] + pixel[1] + pixel[2] # absolute pixel difference
                if difference > threshhold:
                    badPixels += 1
         return badPixels
