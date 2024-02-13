FROM ubuntu:jammy
WORKDIR /cephfuse
COPY . .
COPY entrypoint.sh /entrypoint.sh
COPY ceph.* /etc/ceph/
RUN apt-get update -qy && apt-get upgrade -qy && apt-get install curl -qy && \
    curl 'https://download.ceph.com/keys/release.asc' > /etc/apt/trusted.gpg.d/ceph.asc && \
    echo "deb https://download.ceph.com/debian-reef jammy main" > /etc/apt/sources.list.d/ceph.list && \
    apt-get update -qy && apt-get upgrade -qy && \ 
    apt-get install -qy ceph-fuse && mkdir -p /mnt/cephfs && chmod +x /entrypoint.sh

#CMD ["ceph-fuse", "-n", "client.dockappserver", "/mnt/cephfs"]
CMD [ "/bin/bash", "/entrypoint.sh" ]
