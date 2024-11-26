# draw a dino

Currently deployed at https://dinodisplay.bbsshack.club/ and https://dino.bbsshack.club/ scheduled to be taken down to save costs by the end of November


hosted on a digital ocean droplet
(they're kinda abit weird to deploy on since they rejected our HCB card at first and took 5 emails to verify me)

run on  Debian 12 x64

specs:
2 vCPUs
2GB / 60GB Disk
($18/mo)
 ##### yes we ball


So from what i understand, to get this running, 

First install everything you need

assuming linux,

```bash
sudo apt update && sudo apt upgrade
```

then 
```bash
sudo apt install ngnix
``` 
(for ngnix install)

then 
```bash
sudo apt install python3
sudo apt install certbot python3-certbot-nginx

```

then (depending on what the heck you're using, digitalocean made me do this)
you need to make a virtual env (feel free to skip)

```bash
python3 -m venv venv
source venv/bin/activate
```
then install everything we need,

```bash
pip install gunicorn #to serve the flask app
pip install flask #flask!
```

Now, you're ready to start moving the actual code in

so, start with making adding the ngnix files for both dinodisplay & dino

type in 
```bash
sudo mkdir -p /var/www/dino
sudo nano /var/www/dino/index.html
```
and now paste in the code from 





















 ## from this part on its chatgpt explaning my code and how to make it run since i would leave a lot of stuff out if i did this


# Dino Gallery

The Dino Gallery is a fun, dynamic gallery website where users can upload and view floating dinosaur drawings. The site displays images in a randomized flow, making it a lively, interactive experience on large displays.

## Features
- **Floating Dino Drawings**: The images float randomly across the screen, providing a lively, dynamic display.
- **Submit Your Drawings**: Users can submit their own dinosaur drawings through a canvas, which are then displayed in the gallery.
- **Static Overlay**: A logo appears at the bottom-right corner, and the website features a QR code linking to the gallery.
- **Responsive Design**: While optimized for large screens, the design adjusts for smaller devices as well.

## Tech Stack
- HTML
- CSS (for styling and animations)
- JavaScript (for handling drawing, image animations, and interactivity)
- Node.js (or similar backend) for handling image uploads and serving the gallery

## Features Breakdown
- **Gallery**: The images are fetched from a backend and displayed in an ever-moving, randomized animation. New images can be added periodically.
- **Drawing Canvas**: Users can submit drawings through a canvas element, which are then saved and added to the gallery.
- **Animations**: The images are animated to move smoothly and randomly across the screen, creating an organic effect as they overlap.
- **QR Code**: A QR code linking to the gallery is displayed at the bottom-left corner of the page for easy access on mobile devices.

## Setup Instructions

### 1. Clone the Repository
Clone the repository to your local machine or server:
```bash
git clone https://github.com/yourusername/dino-gallery.git
cd dino-gallery

