#!/bin/sh -xe

# This script starts docker and systemd (if el7)

# Version of CentOS/RHEL
el_version=$1
cache=$2

 # Run tests in Container
if [ "$el_version" = "6" ]; then

sudo docker run --privileged --rm=true -v `pwd`:/StashCache:rw centos:centos${OS_VERSION} /bin/bash -c "bash -xe /StashCache/bin/stashcp2/tests/test_inside_docker.sh ${OS_VERSION} ${XRD_CACHE}"

elif [ "$el_version" = "7" ]; then

docker run --privileged --cap-add SYS_ADMIN -d -ti -e "container=docker"  -v /sys/fs/cgroup:/sys/fs/cgroup -v `pwd`:/StashCache:rw  centos:centos${OS_VERSION}   /usr/sbin/init
DOCKER_CONTAINER_ID=$(docker ps | grep centos | awk '{print $1}')
docker logs $DOCKER_CONTAINER_ID
docker exec -ti $DOCKER_CONTAINER_ID /bin/bash -xec "bash -xe /StashCache/bin/stashcp2/tests/test_inside_docker.sh ${OS_VERSION} ${XRD_CACHE};
echo -ne \"------\nEND stashcp TESTS\n\";"
docker ps -a
docker stop $DOCKER_CONTAINER_ID
docker rm -v $DOCKER_CONTAINER_ID

fi
