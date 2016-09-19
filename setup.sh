#!/bin/bash

vagrant plugin install vagrant-alpine && vagrant up && sleep 5 && \
  export set CONSUL_IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'` && \
  docker run --name consul -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap -ui-dir /ui && \
  vagrant ssh -c "sudo sed -i 's/DOCKER_OPTS=.*/DOCKER_OPTS=\"-H tcp:\/\/0.0.0.0:2375 -H unix:\/\/\/var\/run\/docker.sock --cluster-advertise eth1:2375 --cluster-store consul:\/\/$CONSUL_IP:8500\"/g' /etc/conf.d/docker" && \
  vagrant ssh -c "sudo service docker start && sleep 5" && \
  export set GUEST_IP=`vagrant ssh -c 'ifconfig eth1' | awk '/t addr:/{gsub(/.*:/,"",$2);print$2}'` && \
  docker -H $GUEST_IP run --name manager -d -p 4000:4000 swarm manage -H :4000 --advertise $GUEST_IP:4000 consul://$CONSUL_IP:8500 && \
  docker -H $GUEST_IP run --name swarm -d swarm join --advertise=$GUEST_IP:2375 consul://$CONSUL_IP:8500 && sleep 5 && \
  docker -H $GUEST_IP:4000 info && \
  echo "Run: docker -H $GUEST_IP:4000 info"
  