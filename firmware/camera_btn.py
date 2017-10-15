#!/usr/bin/python

from __future__ import print_function
import httplib2
import os

from picamera import PiCamera
from time import *
from gpiozero import Button, LED, PWMLED
from PIL import Image

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage
from apiclient.http import MediaFileUpload
from apiclient.discovery import build

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/drive_photobooth.json
SCOPES = 'https://www.googleapis.com/auth/drive.file'
CLIENT_SECRET_FILE = 'client_id.json'
APPLICATION_NAME = 'PhotoBooth'


button = Button(17)
led = PWMLED(18)
led2 = PWMLED(12)
camera = PiCamera()

camera.resolution = (2592, 1944)
camera.annotate_text_size = 160
camera.hflip = True

def get_credentials():
	"""Gets valid user credentials from storage.

	If nothing has been stored, or if the stored credentials are invalid,
	the OAuth2 flow is completed to obtain the new credentials.

	Returns:
		Credentials, the obtained credential.
	"""
	home_dir = os.path.expanduser('~')
	credential_dir = os.path.join(home_dir, '.credentials')
	if not os.path.exists(credential_dir):
		os.makedirs(credential_dir)
	credential_path = os.path.join(credential_dir,
											'drive_photobooth.json')

	store = Storage(credential_path)
	credentials = store.get()
	if not credentials or credentials.invalid:
		flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
		flow.user_agent = APPLICATION_NAME
		if flags:
			credentials = tools.run_flow(flow, store, flags)
		else: # Needed only for compatibility with Python 2.6
			credentials = tools.run(flow, store)
		print('Storing credentials to ' + credential_path)
	return credentials

def uploadToDrive (fname):
	credentials = get_credentials()
	http = credentials.authorize(httplib2.Http())
	service = discovery.build('drive', 'v3', http=http)

	results = service.files().list(
		pageSize=10,fields="nextPageToken, files(id, name)").execute()
	items = results.get('files', [])
	if not items:
		print('No files found.')
	else:
		print('Files:')
		folder_id = None;
		for item in items:
			print('{0} ({1})'.format(item['name'], item['id']))
			if item['name'] == "PhotoBooth":
				folder_id = item['id']
		if not folder_id:
			# create dir
			file_metadata = {
				'name': 'PhotoBooth',
				'mimeType': 'application/vnd.google-apps.folder'
			}
			file = service.files().create(body=file_metadata,
															fields='id').execute()
			print ('Folder ID: %s' % file.get('id'))
			folder_id = file.get('id')
		# upload file
		file_metadata = {
			'name': os.path.basename(fname),
			'parents': [folder_id]
		}
		media = MediaFileUpload(fname,
										mimetype='image/jpeg',
										resumable=True)
		file = service.files().create(body=file_metadata,
														media_body=media,
														fields='id').execute()
		print ("File ID: %s" % (file.get('id')))

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

camera.start_preview()
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

		#led.blink (on_time=0.125, off_time=0.125, n=16, background=True)
		#led2.blink (on_time=0.125, off_time=0.125, n=16, background=True)
		led2.pulse (fade_in_time=0.125, fade_out_time=0.125, n=16, background=True)
		led.pulse (fade_in_time=0.125, fade_out_time=0.125, n=16, background=True)

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
		led2.value = 1
		camera.capture( outfile )
		#print outfile

		led.value = 0
		led2.value = 0
		o = camera.add_overlay(merci.tobytes(), format='rgba', layer=3)
		sleep(2)
		outover = getImg (outfile)
		camera.remove_overlay(o)
		o = camera.add_overlay(outover.tobytes(), format='rgba', layer=3)
		#camera.annotate_text = 'Voici votre Photo ...\nMerci'
		sleep(4)
		camera.remove_overlay(o)
		uploadToDrive ( outfile );
	except KeyboardInterrupt:
		camera.stop_preview()
		break



camera.stop_preview()

