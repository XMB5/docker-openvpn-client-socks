FROM alpine

COPY build_openvpn.sh /
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update-cache dante-server bash \
    && /build_openvpn.sh

COPY sockd.conf /etc/
COPY up.sh /

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
