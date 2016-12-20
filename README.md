# qos-docker

This project sets up a small system with two web servers, one fast and one slow.

Depending on the browser's user agent string, http traffic is routed to one or the other.

# Relevance

The idea is to set up do a scenario where one application has two classes of users, say for example both machine and human users and one class crowds out the other, say that the machine users crowd out the human users, affecting their ability to download and upload data. We're looking for a mechanism to "cap" the machine users traffic - to rate limit their upload and download, while letting the humans use the remainder of the bandwith without limits.

# Usage

To compare exactly the same asset (an index.html-page) being served from each of the two containers:

	make  # to build and launch services
	
	make test-qos  # to compare download speeds using wget

# Changing the upload and download rate limits

The fast web server has no up or down limit on network traffic.

The slow web server has a set limit on up and down network traffic, utilizing a tool called "wondershaper".

The default strategy is extremely simplistic but could be made more complicated. Rate limits can be changed at build-time, run-time at start or run-time at any time... 


## Build-time

The "slow" container could be parameterized with regards to up and down limits like so:

	# for build-time arguments, use https://docs.docker.com/engine/reference/builder/#arg
	# for example, in Dockerfile, use ARG and ENV for the UP_LIMIT, 
	# then use $UP_LIMIT in CMD specification

	ARG UP_LIMIT
	ENV UP_LIMIT ${UP_LIMIT:-10}

	# then in the Makefile for the "build" action, set the arguments like so:

	$ docker build --build-arg UP=10 --build-arg DOWN=10  

## Run-time at startup

When started, the "slow" container can be given its rate limits:

	# When defining the command for the container 
	# ("command:" in docker-compose.yml for example)

	command: wondershaper eth0 10 10 && real-startup-command-whatever-it-may-be.sh

## Anytime during run-time

It seems even be possible to send a command to a running container to change the limits while the container is running:

	docker exec -it slow sh -c "wondershaper eth0 clear" # reset qos limits
	docker exec -it slow sh -c "wondershaper eth0 100 100" # set new qow limits

This means a separate container could be used to launch such commands depending on existing load levels of the system.


