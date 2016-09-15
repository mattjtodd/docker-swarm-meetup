# docker-swarm-meetup

How to play :)

In order to get around the restrictions with the native apps we're going to need to install the Docker engine into a suitable Hypervisor.  These instructions are for Virtualbox.

Binaries for the workshop can be found in the following webserver:

http://192.168.14.52:8080

There's a local copy of some of the later instructions available here:

http://localhost:8080/Build%20a%20Swarm%20cluster%20for%20production.htm

* Get and install Virtualbox from the webserver for your Host
* Download the Apline Linux ISO from the webserver
* Create a new VM and call it `Alpine Linux Docker` or similar (Blue new explosion!), Type Linux, Version, one of the generic ones
* Memory Size ~2G
* Create a Virtual Disk Now
* VDI
* Dynamically Allocated
* Defaults for size (8G)
* In the right hand pannel, find the storage subsection and click on [Optical Drive],  choose the Alpine ISO.
* Click on the settings wheel, the Network and change 'Attached To` to `Bridged Adapter`
* Start the VM up
* Login as `root` no password
* in the bash prompt enter `setup-alpine`
* All of the answers are the default except:
* system host name: `your-name!!` This is important!
* mirror number `13`
* disks to use `sda`
* how would you like to use it?  `lvmsys`
* erase the disk `y`
* This should take a while to format your VDI disk
* One this is complete we're ready to install docker!!
* `vi /etc/apk/repositories`
* Uncomment the lines `*/edge/main` and `*/edge/communtiy`, save and exit
* run `apk update`
* run `apk add docker`
* Create a user for ssh access `adduser <youruser> && adduser <youruser> docker`
* run `halt` await completion
* unmount the ISO CD by going back to the storgae section and clicking on the iso and removing it
* switch onto the TP-LINK_2A*** password `tart276-byway` 
* Reset the machine and wait for it to come back up
* login as root and use `ifconfig` to get the ip of the machine
* Run `sysctl -w kernel.pax.softmode=1`
* Start with `dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375`
