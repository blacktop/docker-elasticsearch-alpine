## To run in production  

On Ubuntu:

```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144
echo 'GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' | sudo tee -a /etc/default/grub
sudo update-grub
sudo reboot
```

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
