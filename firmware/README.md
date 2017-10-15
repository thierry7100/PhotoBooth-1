## Install

Install shutdown service
 sudo cp listen-for-shutdown.service /etc/systemd/system/
 sudo systemctl daemon-reload
 sudo systemctl enable listen-for-shutdown.service
 sudo systemctl start listen-for-shutdown.service

Install Photobooth service
 sudo cp photobooth.service /etc/systemd/system/
 sudo systemctl daemon-reload
 sudo systemctl enable photobooth.service
 sudo systemctl start photobooth.service

 add to /boot/config.txt
  # enable uart for "power" led
  enable_uart=1

Install needed python modules
 pip install --upgrade google-api-python-client
get api ID clients OAuth 2.0 client_id.json and put in here
see https://console.developers.google.com/apis/credentials
