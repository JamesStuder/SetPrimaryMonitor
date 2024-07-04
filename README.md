# SetPrimaryMonitor
Script that can be used for X11 or Wayland to have only 1 monitor screen active at login.  The monitor that will be used is the laptop monitor, this way no matter if you are using a dock, display port, hdmi, etc.  It will always be the same monitor that the login screen appears on.

I use Tuxedo OS with Wayland drivers and have tested it on there with a 3 monitor setup (2 external + Laptop) via a Thundebolt 4 dock.

# How To:

1) First get laptop monitor screen name.  This might be "eDP-1".
   - Run `xrandr` in console.  It will be easier to find the laptop monitor if you don't have any other monitors plugged in.
2) Check SDDM Config to see if theer is a primary monitor setup.  Either set it to the laptop monitor or remove the section.  For my setup, I just removed it:
   - Run `sudo nano /etc/sddm.conf` check for `[Display]` section.  If it's not there you can close, it is and it's not your laptop screen, then remove it or update to your laptop screen name.
3) Now create the script file:
   - `sudo nano /usr/local/bin/set_primary_monitor.sh` - Copy the contents of the set_primary_monitor.sh file in the repo into this script changing the laptop monitor variable to the name of your laptop monitor.
4) Make the script executable:
   - `sudo chmod +x /usr/local/bin/set_primary_monitor.sh`
5) Set the script to run at startup:
   - `Open the SDDM Xsetup file to run the script at startup` add `/usr/local/bin/set_primary_monitor.sh`
6) Reboot - Only the laptop monitor should be on with the login screen present.  Once logged in, the other monitors should come on.
