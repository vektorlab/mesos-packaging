FROM quay.io/vektorcloud/build

COPY build.sh /

ENTRYPOINT ["/build.sh"]
