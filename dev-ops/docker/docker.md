# Docker


## Commands
```
detach from container -> ^P^Q

docker start [container]

docker run -d ubuntu // -d stands for daemon mode
docker run -ti // t = terminal, i = stdin -> terminal

docker attach [container] // attach to container, same as -ti flag with run

docker ps // list running processes
docker ps -a // see all containers
docker ps -l // last started container

docker logs [container] --tail 5 // view logs
docker logs [container] --tail 1 --follow // check logs in real time

docker kill
docker stop

docker images // list local images
docker search [keyword] // list images on repo

docker pull [image]:[version] // pull image from repo, default is latest

docker diff // see changes between base image and our custom layers

// tagging an image
docker tag [image] [tag]
docker commit [container] [tag]

// building an image
docker build -t [name] .
docker build --no-cache // force rebuild
docker history [image] // show history of layers of image
```

Docker images

- files + metadata
- made of layers stacked on top of each other
- layer can add/change/remove files/metadata
- read-only filesystem
- image <-> class (conceptual)
- layer <-> inheritance (conceptual)
- special image called "scratch"
- can be stored locally or in online registry
Dockerfile

- build recipe for Docker image
- series of instructions how to build an image
- docker build command is used to build the image
- RUN commands must be non-interactive
- .dockerignore file to ignore certain files to speed up the build
- JSON syntax
	- specifies an exact command to execute
	- harder to write and read
	- passes all arguments without extra processing
	- doesn't create an extra process and doesn't need /bin/sh in the container
- String syntax
	- specifies a command to be wrapped within /bin/sh -c "[comand]"
	- easier to write
	- can interpolate env. variables and other shell expressions
	- create an extra process " /bin/sh -c ..." to parse the string
	- requires /bin/sh to exist in the container

Commands

- FROM
	- specifies a base image to start with
	- first command in Dockerfile
- RUN 
	- runs a specified command (can be more than one)
	- creates a new layer
- CMD
	- defines a default command to run when none is given 
	- every CMD overrides previous one (one per Dockerfile)
	- if command is specified when executing "run" it overrides default CMD command
- ENTRYPOINT
	- defines a base command and its parameters for the container
	- command line arguments are appended to those parameters
	- can be overriden by specifying --entrypoint parameter to "run"
- COPY
	- copy files/folders from build context to container

```
## Examples

docker import from [image] // create the first layer for the new image 
docker commit // saves current state of container to new image
docker build

FROM ubuntu // base image to start with
RUN apt-get update // first layer
RUN apt-get install figlet // second layer

---

RUN apt-get install figlet // plain string syntax
RUN ["apt-get", "install", "figlet"] // JSON syntax

--- 

CMD figlet -f script hello // default command to run when none is given
ENTRYPOINT ["figlet", "-f", "script"] // JSON syntax to avoid running bash as well
```

---
Docker containers

- encapsulated set of processes running in a read-write copy of image
- container <-> instance (concepctual)
- can be started in read-mody (read-write only volumes)

Docker repositores

- Docker Hub official images
- Docker Hub user defined images
- Self hosted repositories


