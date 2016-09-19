# docker-swarm-meetup

How to play :)

In order to get around the restrictions with the native apps we're going to need to install the Docker engine into a suitable Hypervisor.  These instructions are for Vagrant OSX Specific using Virtualbox.

* Install vagrant

```
$ brew update && \
  brew cask update && \
  brew cask install vagrant
```

* Install Virtualbox if it's not allready installed tested with 5.1.6

```
$ brew install  virtualbox
```

* Set the IP of the guest and host

```
$ export set WORKER_IP=`vagrant ssh -c "ifconfig eth1" | awk '/t addr:/{gsub(/.*:/,"",$2);print$2}'` && \
  export set MANAGER_IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
```

* Startup the VM. The last line of the output is the IP of the VM's bridge network adapter for reference.

```
$ vagrant plugin install vagrant-alpine && vagrant up
```

* Now start the consul service

```
$ docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
```

* Start the manager

```
$ docker run -d -p 4000:4000 swarm manage -H :4000 --advertise $MANAGER_IP:4000 consul://$MANAGER_IP:8500
```

* Start the swarm worker node

```
$ docker -H $$WORKER_IP run -d swarm join --advertise=$WORKER_IP:2375 consul://$MANAGER_IP:8500
```

* Check that it's all connected correctly.  You should see a single worker node with the Guest Bridge IP registered.

```
$ docker -H :4000 info
```
