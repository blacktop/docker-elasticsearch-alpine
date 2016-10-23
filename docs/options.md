## To increase the ES_HEAP_SIZE to 2GB

```bash
$ docker run -d --name elastic -p 9200:9200 -e ES_HEAP_SIZE="2g" blacktop/elasticsearch
```
