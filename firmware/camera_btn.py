#!/usr/bin/python

from picamera import PiCamera
from time import *
from gpiozero import Button, LED, PWMLED
from PIL import Image


button = Button(17)
led = PWMLED(18)
camera = PiCamera()

camera.resolution = (2592, 1944)
camera.annotate_text_size = 160
camera.hflip = True

camera.start_preview()

def getImg (fname):
	# Load the arbitrarily sized image
	img = Image.open(fname)
	# Create an image padded to the required size with
	# mode 'RGB'
	#print img.size
	pad = Image.new('RGBA', (
		((img.size[0] + 31) // 32) * 32,
		((img.size[1] + 15) // 16) * 16,
		))
	# Paste the original image into the padded one
	pad.paste(img, (0, 0))
	return pad

acc = getImg ("Accueil.png")
merci = getImg ("Merci.png")
waits = []
for i in range(3):
	waits.append(getImg ("%d.png" % (i+1)))

while True:
	try:
		# Add the overlay with the padded image as the source,
		# but the original image's dimensions
		o = camera.add_overlay(acc.tobytes(), format='rgba')
		# By default, the overlay is in layer 0, beneath the
		# preview (which defaults to layer 2). Here we make
		# the new overlay semi-transparent, then move it above
		# the preview
		#o.alpha = 128
		o.layer = 3

		led.pulse(2,2)
		button.wait_for_press()

		camera.remove_overlay(o)

		led.blink (on_time=0.125, off_time=0.125, n=16, background=True)

		for i in range(2, -1, -1):
			#led.value = 0
			o = camera.add_overlay(waits[i].tobytes(), format='rgba', layer=3)
			sleep(1)
			nblink = 3-i
			#print (nblink, ", ", 1.0/(2**nblink))
			#led.blink (on_time=1.0/(2**nblink), off_time=1.0/(2**nblink), n=nblink, background=False)
			camera.remove_overlay(o)
		outfile = '/home/pi/Pictures/%s.jpg' % ( strftime("%Y%m%d-%H%M%S", localtime() ) )
		led.value = 1
		camera.capture( outfile )
		#print outfile

		led.value = 0
		o = camera.add_overlay(merci.tobytes(), format='rgba', layer=3)
		sleep(2)
		outover = getImg (outfile)
		camera.remove_overlay(o)
		o = camera.add_overlay(outover.tobytes(), format='rgba', layer=3)
		#camera.annotate_text = 'Voici votre Photo ...\nMerci'
		sleep(5)
		#camera.annotate_text = ''
		camera.remove_overlay(o)
		#camera.annotate_text = ""
	except KeyboardInterrupt:
		camera.stop_preview()
		break



camera.stop_preview()

