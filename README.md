# SetPrimaryMonitor
Script that can be used for X11 or Wayland to have only 1 monitor screen active at login. I have it setup to use connected primary.  For me in testing this would default to the laptop monitor.

I use Tuxedo OS with Wayland drivers and have tested it on there with a 3 monitor setup (2 external + Laptop) via a Thundebolt 4 dock.  Desktop environment is KDE Plasma.  I have not tested on other desktop environments so other confirguration might be needed.

# How To:

## Setup Script:
1) Now create the script file:
   - `sudo nano /usr/local/bin/set_primary_monitor.sh` - Copy the contents of the set_primary_monitor.sh file in the repo into this file.
2) Make the script executable:
   - `sudo chmod +x /usr/local/bin/set_primary_monitor.sh`
## Setup X11:
1) Edit the SDDM configuration file:
   - `sudo nano /etc/sddm.conf`
2) Add or modify the following section:
   - ```
     [X11]
     DisplayCommand=/usr/local/bin/set_primary_monitor.sh
     ```
     
## Setup Wayland - This will utilize KWin:
1) Create an Autostart entry for the script:
   - `mkdir -p ~/.config/autostart-scripts`
2) Create the autostart script:
   - `nano ~/.config/autostart-scripts/set_primary_monitor.sh`
3) Add the following to the autostart script:
   - ```
     #!/bin/bash
      /usr/local/bin/set_primary_monitor.sh
     ```
4) Make the autostart script executable:
    - `chmod +x ~/.config/autostart-scripts/set_primary_monitor.sh`
  
## Logging:
If you have any issues logging is setup to output to this location:
 - `/var/log/set_primary_monitor.log`
