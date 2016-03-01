# keewebdocker
Let's bring KeeWeb in a Docker container

## Usage:
  1. Build the container (it will take the latest version of UpdateDesktop.zip) from this repo:  
     `docker build -t ponsfrilus/keewebdocker github.com/ponsfrilus/keewebdocker`
  1. Launch the container:  
     `docker run -d -p 443:443 --name keewebdocker -t ponsfrilus/keewebdocker`
  1. Open your browser:  
     `firefox https://localhost`

## Info:
  - [Official website](https://keeweb.info)
  - [Github repo](https://github.com/antelle/keeweb)
  - [Docker nginx](https://hub.docker.com/_/nginx/)

## Dev:
  - `docker build -t ponsfrilus/keewebdocker .` or `docker build -t ponsfrilus/keewebdocker github.com/ponsfrilus/keewebdocker`
  - `docker rm -f keewebdocker && docker run -d -p 443:443 --name keewebdocker -t ponsfrilus/keewebdocker`
  - `DEBUG: docker run -p 443:443 -it --rm ponsfrilus/keewebdocker bash`
