#!make

ME = $(USER)
TS := $(shell date '+%Y_%m_%d_%H_%M')
PWD := $(shell pwd)
USR := $(shell id -u)
GRP := $(shell id -g)

all: build up

build:
	@cp index.html fast
	@cp index.html slow
	@docker build --no-cache -t dina/fast fast
	@docker build --no-cache -t dina/slow slow

up:
	@docker-compose up -d

down:
	@docker-compose down

test-qos:
	@echo "Emulating user-agent-string saying Mozilla:"
	@wget --progress=bar --user-agent="Mozilla" qos.docker -O /dev/null

	@echo "Emulating user-agent-string saying MSIE:"
	@wget --progress=bar --user-agent="MSIE" qos.docker -O /dev/null

debug:
	@firefox http://qos.docker
