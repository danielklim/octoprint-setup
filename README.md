# Setting up Octopi

## Versions
- raspbian: 2020-02-13-raspbian-buster.img
- octoprint: 0.17.0

## Instructions

1. Burn the base raspbian image onto SD card.
2. Set environment vars by renaming `example.env` to `.env` and setting the values
3. Run `./setup.sh` to substitute in env vars.
4. Copy `./boot/*` to root of boot partition of SD card
5. Start the pi and `passwd` to set password.

### Install base packages

```bash
sudo su
apt update && \
apt install vim git python3-pip xserver-xorg-input-evdev python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential -qy && \
apt --fix-broken install && \
apt upgrade -qy && \
usermod -a -G tty pi && \
usermod -a -G dialout pi
```

### Enable LCD screen

```bash
PATH_XIC=/home/pi/xinput-calibrator && \
git clone https://github.com/OSSystems/xinput-calibrator $PATH_XIC

PATH_LCDSHOW=/home/pi/LCD-show && \
git clone https://github.com/goodtft/LCD-show.git $PATH_LCDSHOW && \
chmod -R 755 $PATH_LCDSHOW && \
cd $PATH_LCDSHOW && \
sudo ./LCD35-show 180
```

### Install OctoPrint

After running the below code, copy the contents of `./.octoprint` to `~/.octoprint` on the pi. 

```bash
PATH_OCTOPRINT=/home/pi/OctoPrint
mkdir $PATH_OCTOPRINT && cd $PATH_OCTOPRINT && \
virtualenv venv && \
source venv/bin/activate && \
pip install pip --upgrade && \
pip install octoprint && \
pip install https://github.com/BillyBlaze/OctoPrint-TouchUI/archive/master.zip
```

### Enable OctoPrint service
```bash
sudo su
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init -O /etc/init.d/octoprint && \
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default -O /etc/default/octoprint && \
echo "DAEMON=/home/pi/OctoPrint/venv/bin/octoprint" >> /etc/default/octoprint && \
chmod +x /etc/init.d/octoprint && \
systemctl enable octoprint
```

### Enable autostart
```bash
mkdir -p ~/.config/lxsession/LXDE-pi/ && \
cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/autostart && \
echo "@chromium-browser --kiosk http://localhost:5000/" >> ~/.config/lxsession/LXDE-pi/autostart
```

## References

### LCD
https://github.com/goodtft/LCD-show/issues/159
http://www.lcdwiki.com/3.5inch_RPi_Display

### touchscreen
https://community.octoprint.org/t/octoprint-raspberry-pi-touch-screen-install-touch-ui-chriss-basement/8833

### octoprint
https://community.octoprint.org/t/setting-up-octoprint-on-a-raspberry-pi-running-raspbian/2337
https://community.octoprint.org/t/octoprint-raspberry-pi-4-3-5-touchscreen-configuration-raspbian-buster-goodtft-waveshare-xpt2046/13254
http://docs.octoprint.org/en/master/configuration/config_yaml.html#access-control
