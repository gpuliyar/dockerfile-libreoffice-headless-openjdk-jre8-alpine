FROM openjdk:8-jre-alpine

ENV LIBREOFFICE_HOME /opt/libreoffice

COPY entrypoint.sh /

RUN set -xe; \
    \
    addgroup -S -g 1000 libreoffice; \
    adduser -S -D -s /sbin/nologin -G libreoffice -u 1000 -h ${LIBREOFFICE_HOME} libreoffice; \
    \
    apk add --no-cache --purge -uU libreoffice libreoffice-base libreoffice-lang-uk \
        ttf-freefont ttf-opensans ttf-ubuntu-font-family ttf-inconsolata ttf-liberation ttf-dejavu \
        bash; \
    \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    \
    apk add --no-cache -U ttf-font-awesome ttf-mononoki ttf-hack; \
    \
    rm -rf /var/cache/apk/*; \
    rm -rf /tmp/*; \
    \
    chown libreoffice:libreoffice /entrypoint.sh; \
    chmod +x /entrypoint.sh;

VOLUME [ "/usr/local/share/fonts" ]

WORKDIR $LIBREOFFICE_HOME

EXPOSE 8100

USER libreoffice

ENTRYPOINT ["/entrypoint.sh"]
