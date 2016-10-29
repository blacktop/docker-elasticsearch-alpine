## To increase the HEAP_SIZE to 2GB

```bash
$ docker run -d --name elastic -p 9200:9200 -e ES_JAVA_OPTS="-Xms2g -Xmx2g" blacktop/elasticsearch
```
