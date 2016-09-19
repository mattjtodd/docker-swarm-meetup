# docker-swarm-meetup

How to play :)

In order to get around the restrictions with the native apps we're going to need to install the Docker engine into a suitable Hypervisor.  These instructions are for Vagrant OSX Specific using Virtualbox.

* Install Vagrant

```
$ brew update && \
  brew cask update && \
  brew cask install vagrant
```

* Install Virtualbox if it's not allready installed.  (Tested with 5.1.6 should work with others)

```
$ brew install  virtualbox
```

* Startup the VM. The last line of the output is the IP of the VM's bridge network adapter for reference.

```
$ vagrant plugin install vagrant-alpine && vagrant up
```

* Set the IP of the guest and host

```
$ export set GUEST_IP=`vagrant ssh -c "ifconfig eth1" | awk '/t addr:/{gsub(/.*:/,"",$2);print$2}'` && \
  export set CONSUL_IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
```

* Now start the consul service

```
$ docker run --name consul -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap -ui-dir /ui
```

* Start Docker Daemon

```
vagrant ssh -c 'sudo dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-advertise eth1:2375 --cluster-store consul://$CONSUL_IP:8500'
```

```
$ docker run --name manager -d -p 4000:4000 swarm manage -H :4000 --advertise $GUEST_IP:4000 consul://$CONSUL_IP:8500
```

* Start the swarm worker node

```
$ docker -H $GUEST_IP run --name swarm -d swarm join --advertise=$GUEST_IP:2375 consul://$CONSUL_IP:8500
```

* Check that it's all connected correctly.  You should see a single worker node with the Guest Bridge IP registered.

```
$ docker -H :4000 info
```

* Start an ES node

```
docker -H $CONSUL_IP:4000 run --rm --name es-node1 elasticsearch:2.4.0
```
