**Kobo Tools for building a custom KoboRoot.tgz**
***

**1. Introduction**

I decided to upload it because I can't find an easy way to install **dropbear** and **fmon**  without installing other software that I don't need.


**2. Build instructions**

You'll need gcc-arm-linux-gnueabihf to cross compile for kobos

To build KoboRoot.tgz:

	./kobo.sh build

 To purge generated files:

	./kobo.sh clean

**3. Installation**

Follow the standard procedure for all upgrades:

  1. plug the device
  2. copy KoboRoot.tgz on .kobo/ folder via USB storage
  3. unplug the device
