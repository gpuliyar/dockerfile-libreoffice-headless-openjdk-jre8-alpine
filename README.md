# dockerfile-libreoffice-openjdk-jre8-alpine
The project packages OpenJDK JRE 8, LibreOffice on Alpine as a Container

## Let's learn more about the code

### Dockerfile
```
FROM openjdk:8-jre-alpine
```
Start from OpenJDK JRE 8 Alpine

```
ENV LIBREOFFICE_HOME /opt/libreoffice
```
Set the environment variable for the Libreoffice Home

```
COPY entrypoint.sh /
```
Copy the entrypoint.sh file into the container. We will learn more about the code in the shell script at the end of the readme.

```
RUN set -xe; \
    \
    addgroup -S -g 1000 libreoffice; \
    adduser -S -D -s /sbin/nologin -G libreoffice -u 1000 -h ${LIBREOFFICE_HOME} libreoffice; \
# Add a new user and group. The same will be used as the default user for the container \
    \
    apk add --no-cache --purge -uU libreoffice libreoffice-base libreoffice-lang-uk \
        ttf-freefont ttf-opensans ttf-ubuntu-font-family ttf-inconsolata ttf-liberation ttf-dejavu \
        bash; \
# Install the libreoffice, libreoffice base, and relevant fonts. \
# Install bash as the alpine version doesn't support arrays that we will use in the entrypoint.sh script \
    \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
# Add additional repositories so we can install more fonts \
    \
    apk add --no-cache -U ttf-font-awesome ttf-mononoki ttf-hack; \
# Install more fonts \
    \
    rm -rf /var/cache/apk/*; \
    rm -rf /tmp/*; \
# Remove the APK cache and tmp files created as part of the install process \
    \
    chown libreoffice:libreoffice /entrypoint.sh; \
    chmod +x /entrypoint.sh;
# Provide relevant user and access permissions to the shell file
```

```
VOLUME [ "/usr/local/share/fonts" ]
```
Set the volume so you can add more custom fonts from the mount volume.

```
WORKDIR $LIBREOFFICE_HOME
```
Set the working directory

```
EXPOSE 8100
```
Expose the port

```
USER libreoffice
```
Set the default user as `libreoffice`

```
ENTRYPOINT ["/entrypoint.sh"]
```
Set the entrypoint as the shell script

> Now let's see what `entrypoint.sh` file has

### entrypoint.sh

```
#!/bin/bash

set -ex

# Set the default values it not already configured
: ${HOST_IN:=0}
: ${PORT_IN:=8100}
: ${LANG:='C.UTF-8'}

# define the input arguments as an array for libreoffice command
SOFFICE_ARGS=(
    "--accept=socket,host=${HOST_IN},port=${PORT_IN},tcpNoDelay=1;urp"
    "--headless"
    "--invisible"
    "--nodefault"
    "--nofirststartwizard"
    "--nolockcheck"
    "--nologo"
    "--norestore"
)

# call the soffice headless mode
soffice "${SOFFICE_ARGS[@]}"
```
