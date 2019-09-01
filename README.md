
A PhotoBooth for special events like wedding.

![pic](hardware/pic/photo1.jpg?raw=true)

## Usage
Live video is displayed on the screen. The big red buton is slowly flashing. When pressed, the screen display a countdown and the picture is taken. Then the captured photo is displayed on the screen.
At the end, it is saved in the home directory and uploaded to a google drive if network is available.

A small button can be used to :
* restart software (short press)
* power off RPi (long press)
* power on the pi (short press when off)

A led strip can be controled by the PhotoBooth to add light during countdown and picture shooting.

## Firmware
Based on a standard Raspbian distribution with some python software.

See readme in [subdir](firmware/) for details.

## Hardware

Bill Of material :
* 1 RaspberryPi 3
* 1 Raspberry Pi Camera v2
* 1 52pi 7 inches [screen](https://wiki.52pi.com/index.php/7-Inch-1024x600_Display_Kit_(without_Touch_Screen)_SKU:Z-0051)
* 1 [Big red button](https://www.aliexpress.com/item/5-Colors-LED-Light-Lamp-60MM-Big-Round-Arcade-Video-Game-Player-Push-Button-Switch/32794775928.html?spm=a2g0s.9042311.0.0.KW8o9V) for picture shooting
* 1 arcade button for software control

See readme in [subdir](hardware/) for details.

## tips for post-treatment
Picture are mirorred, to revert to normal :
```
mogrify -flop *.jpg
```
If running windows, download ImageMagick for Windows then command is :
```
magick.exe mogrify -flop *.jpg
```

In case of bad date and so a bad name. (with no RTC on the pi)
Let's say a picture is taken 22/03/2018 at 16:30, but dated 04/03/2018 at 17:48
```
jhead -da2018:03:22/16:30-2018:03:04/17:48 *.jpg
jhead -ft *.jpg
jhead -nf%Y%m%d-%H%M%S *.jpg
```
