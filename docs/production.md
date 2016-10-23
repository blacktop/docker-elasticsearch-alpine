## To run in production  

On Ubuntu you have to edit `/etc/default/grub` and add this line:

```
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
```

Then run `sudo update-grub` and `sudo reboot`.

```bash
$ docker run -d -p 9200:9200 \
                --name elastic \
                --cap-add=IPC_LOCK --ulimit nofile=65536:65536 --ulimit memlock=-1:-1 \
                --memory="4g" --memory-swap="4g" --memory-swappiness=0 \
                -e ES_HEAP_SIZE="2g" \
                blacktop/elasticsearch:kopf \
                -Des.bootstrap.mlockall=true \
                -Des.network.host=_eth0_ \
                -Des.discovery.zen.ping.multicast.enabled=false
```

> **NOTE:** This will limit the container memory to 4GB and the ES heap size to 2GB.  This also will prevent the container from being able to swap its memory.
