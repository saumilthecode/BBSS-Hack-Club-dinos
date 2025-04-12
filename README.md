# draw a dino

~ Currently deployed at https://dinodisplay.bbsshack.club/ and https://dino.bbsshack.club/ scheduled to be taken down to save costs by the end of december ~


hosted on a digital ocean droplet
(they're kinda abit weird to deploy on since they rejected our HCB card at first and took 5 emails to verify me)

run on  Debian 12 x64

specs:
2 vCPUs
2GB / 60GB Disk
($18/mo)

(this has been working relably on the $4 a month server with 512mb of ram so scale accordingly)
afforementioned $4
512 MB / 1 CPU
10 GB SSD Disk
500 GB transfer

 ##### yes we ball

(i belive that you can run the following scriptto automate it on a digital ocean machine (pi's have networking issues in my exp) (tested, your milage may vary)

## edit, this seems to be broken for any other domains then bbsshack.club so a bit of tinkering is in the way. Expect 1h of tinkering
run 
```bash
curl https://raw.githubusercontent.com/saumilthecode/dino-s-/refs/heads/main/dino_setup.sh | bash
```

So from what i understand, to get this running, 

Quick note about all "nano" refrences here, to save your nano file, press 
1.control + o then 
2.enter then control + 
3. x to exit

First install everything you need

assuming linux,

```bash
sudo apt update && sudo apt upgrade
```

then 
```bash
sudo apt install nginx
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
sudo apt install python3.12-venv
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
and now paste in the code from this [index.html](https://github.com/saumilthecode/dino-s-/blob/main/var/www/dino/index.html)

now do ditto for dinodisplay

```bash
sudo mkdir -p /var/www/dinodisplay
sudo nano /var/www/dinodisplay/index.html
```
and paste from this [index.html](https://github.com/saumilthecode/dino-s-/blob/main/var/www/dinodisplay/index.html)


now we reload ngnix to recognise these new sites as well as create systemlinks so it knows to serve them

```bash
sudo ln -s /etc/nginx/sites-available/dino /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/dinodisplay /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

and now that shouldve executed with no errors at all. If it errored then recheck the files and path and try consulting anyone for help

now, we issue the SSL certs for the website so ngnix can seve it witout the pesky insecure connection

```bash
sudo certbot --nginx -d dino.bbsshack.club -d dinodisplay.bbsshack.club
```
## Before doing this, head into porkbun(or whatever you use)and set a "A" record with the server IP in the "answer" 
(i really have no clue how this pans out if you want to use any other domain then dino & dinodisplay so GL tinkering around)

Now that you have your website set up you need to get the Flask server setup to serve the images + recieve the images as a sort of API

go on and `cd` into your main path

and now type in 
```bash
mkdir -p /root/dino_app
cd /root/dino_app
```

This will make a dino_app folder in your main path 

Now, we add in the .py that handles it all 

Since you're already in the dino_app folder,

run `nano app.py`

and paste in everything from [here](https://github.com/saumilthecode/dino-s-/blob/main/dino_app/app.py)

Now, you need to make the admin templates so that you can actually remove pictures you really dont want up.

For that, run `nano /root/dino_app/templates/admin.html` and paste in everything from [here](https://github.com/saumilthecode/dino-s-/blob/main/dino_app/templates/admin.html)
then one more for index.html (i have no clue what the diff is but if it works it works)

`nano /root/dino_app/templates/index.html` and paste in [this](https://github.com/saumilthecode/dino-s-/blob/main/dino_app/templates/index.html)

and now you should be clear start running your app!

so run,
```bash
cd root/dino_app
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

and tada! it should all just work now

So in summary, you should have two domains, dino.xxx and dinodisplay.xxx for users to interact with as well as a special admin server at [ip]:5000/admin

Hope this helps any other club :D



















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
- Flask for handling image uploads and serving the gallery

## Features Breakdown
- **Gallery**: The images are fetched from a backend and displayed in an ever-moving, randomized animation. New images can be added periodically.
- **Drawing Canvas**: Users can submit drawings through a canvas element, which are then saved and added to the gallery.
- **Animations**: The images are animated to move smoothly and randomly across the screen, creating an organic effect as they overlap.
- **QR Code**: A QR code linking to the gallery is displayed at the bottom-left corner of the page for easy access on mobile devices.

## Setup Instructions

### 1. Set A records in your domain registar that point to your server IP
this part is important or else the sits would not show up + setup script will break halfway through

### 2. run the sh setup script

```bash
curl https://raw.githubusercontent.com/saumilthecode/dino-s-/refs/heads/main/dino_setup.sh | bash
```

### 3. Profit?!?!?!
it should work now just that you need to tweek the /var/www/dinodisplay to not be affiliated to BBSS Hack Club + swap out qr code!

# license 
Free to use but do lmk at saumil@bbsshack.club so i can flex on others :D
