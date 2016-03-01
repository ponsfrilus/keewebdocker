#  __  _   ___   ___ __    __   ___ ____  ___    ___     __ __  _   ___ ____
# |  |/ ] /  _] /  _]  |__|  | /  _]    \|   \  /   \   /  ]  |/ ] /  _]    \
# |  ' / /  [_ /  [_|  |  |  |/  [_|  o  )    \|     | /  /|  ' / /  [_|  D  )
# |    \|    _]    _]  |  |  |    _]     |  D  |  O  |/  / |    \|    _]    /
# |     \   [_|   [_|  `  '  |   [_|  O  |     |     /   \_|     \   [_|    \
# |  .  |     |     |\      /|     |     |     |     \     |  .  |     |  .  \
# |__|\_|_____|_____| \_/\_/ |_____|_____|_____|\___/ \____|__|\_|_____|__|\_|
#                                  ...let's bring KeeWeb in a Docker container
#
# Usage:
#   1. Build the container:
#      `docker build -t ponsfrilus/keewebdocker .`
#   1. Launch the container:
#      `docker run -d -p 443:443 --name keewebdocker -t ponsfrilus/keewebdocker`
#   1. Open your browser:
#      `firefox https://localhost`
#
# Info:
#   - [Official website](https://keeweb.info)
#   - [Github repo](https://github.com/antelle/keeweb)
#	  - [Docker nginx](https://hub.docker.com/_/nginx/)
#
# Dev:
#   - `docker build -t ponsfrilus/keewebdocker .`
#   - `docker rm keewebdocker && docker run -d -p 443:443 --name keewebdocker -t ponsfrilus/keewebdocker`
#   - `DEBUG: docker run -p 443:443 -it --rm ponsfrilus/keewebdocker bash`

FROM nginx
MAINTAINER @ponsfrilus

# Make the container ready to install new packages
RUN apt-get update
RUN apt-get -y install wget zip

# Create dev dir
RUN mkdir -p /srv/KeeWeb

# Get KeeWeb app, unzip it and link it to the defaul nginix dir
RUN wget -O /srv/KeeWeb.zip https://github.com/antelle/keeweb/releases/download/v1.0.4/KeeWeb.linux.x64.zip
RUN unzip /srv/KeeWeb.zip -d /srv/KeeWeb
RUN rm -rf /usr/share/nginx/html/
RUN ln -s /srv/KeeWeb/resources/app/ /usr/share/nginx/
RUN mv /usr/share/nginx/app /usr/share/nginx/html

# Generate the SSL certs
## https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04
## http://superuser.com/questions/226192/openssl-without-prompt
RUN mkdir -p /etc/nginx/ssl
RUN openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=CH/ST=Foo/L=Bar/O=Docker/CN=localhost" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

# Make the nginx config file for SSL
RUN echo " \n\
server { \n\
listen 443 ssl; \n\
root /usr/share/nginx/html; \n\
index index.html index.htm; \n\
server_name localhost; \n\
ssl_certificate /etc/nginx/ssl/nginx.crt; \n\
ssl_certificate_key /etc/nginx/ssl/nginx.key; \n\
location / { \n\
  try_files \$uri \$uri/ =404; \n\
} \n\
}" > /etc/nginx/conf.d/keeweb.conf

# Comfort
WORKDIR /srv/KeeWeb/resources/app

# Expose the SSL port
EXPOSE 443
