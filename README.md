**Kobo Tools for building a custom KoboRoot.tgz**
***

**1. Introduction**

I decided to upload it because I can't find an easy way to install *** dropbear *** or *** fmon *** without installing other software that I don't need.

Before build you can modify *config.txt* to suit your needs.

***

**2. Build instructions**

To build KoboRoot.tgz:

	./kobo.sh build

 To purge generated files:

	./kobo.sh clean

***

**3. Config.txt options**

	build_sshd="yes|no"
	
*builds dropbear as part of KoboRoot.tgz. It also modifies inittab to start the script /etc/init.d/rc.local and sets a new password for root*

	build_fmon="yes|no"
	
*builds fmon as part of KoboRoot.tgz. It modifies /etc/init.d/on-animator.sh and install a helper script in /mnt/onboard/.adds/fmon.sh*

	add_png_koreader="yes|no" 
	
***fmon only:***  *adds koreader icon to KoboRoot.tgz* 

	add_png_launcher="yes|no"
	
***fmon only:*** *adds launcher icon to KoboRoot.tgz* 

	ota_survive="yes|no"
	
***fmon only:***  *let fmon survive OTA upgrades from Kobo*
