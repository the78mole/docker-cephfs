# Docker CephFS mount container

This repos contains a Dockerfile and a compose file to create a docker container based on jammy and the latest ceph packages of ceph-fuse to mount a remote cephfs.

To achieve this, you need to create a keyring on your ceph mgr, place it in the root folder of this repo, copy the ceph.conf beside it, adjust the name of the CephFS client to your one and then bring up the container.

Crating the keyring can be achieved on your ceph manager node:

    $ cephadm shell
    $ ceph fs ls
    ...list of your fs-es...
    $ ceph fs authorize <FS_NAME> client.<SOME_NAME> / rw
    [client.<SOME_NAME>]
        key = acbdef....xyz==
    $ ceph auth get client.<SOME_NAME> >> /etc/ceph/ceph.client.<SOME_NAME>.keyring

The copy the keyring to your client, where you will run the CephFS client docker container, adjust the Dockerfile, the docker-compose.yml file and the entrypoint.sh to your needs and bring up the cointainer using one of the two following methods:

    $ docker run --privileged --device /dev/fuse -v /mnt:/mnt:shared -it jammy-test /bin/bash
    $ ceph-fuse -n client.<YOUR_NAME> /mnt/cephfs

    # or
    $ docker compose up -d

If you now inspect the /mnt/cephfs mount point, you can list the content of your CephFS there.
