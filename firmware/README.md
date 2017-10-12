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
