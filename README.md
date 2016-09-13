# docker-swarm-meetup

* Install alpine linux into your Virtualbox Host
* Ensure that the network is set to `bridge` mode
* Create a user for ssh access `adduser cyril && adduser cyril docker`
* Run `sysctl -w kernel.pax.softmode=1`
* Start with dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375
