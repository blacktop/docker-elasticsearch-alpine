## To increase the HEAP_SIZE to 2GB

```bash
$ docker run -d --name elastic -p 9200:9200 -e ES_JAVA_OPTS="-Xms2g -Xmx2g" blacktop/elasticsearch
```

## Runtime config changes

### Change Cluster Name (to `prod-cluster`)

```bash
$ docker run -d --name elastic -p 9200:9200 -e cluster.name=prod-cluster  blacktop/elasticsearch
```

### Change Transport Address to bind to `0.0.0.0` (to use JAVA ES API to interact with ES nodes)

```bash
$ docker run -d --name elastic -p 9300:9300 -e transport.host=0.0.0.0  blacktop/elasticsearch
```
