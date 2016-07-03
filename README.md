docker-elasticsearch-alpine
===========================

[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based Elasticsearch Docker Image

### Dependencies

-	[gliderlabs/alpine](https://index.docker.io/_/gliderlabs/alpine/)

### Usage

```
docker run -d -p 9200:9200 blacktop/elasticsearch
```

> **NOTE:** If you want to jack up the heap use:`ES_JAVA_OPTS="-Xms2g -Xmx2g"`, which sets the HEAP_MAX and HEAP_MIN to 2GB.

```
docker run -d -p 9200:9200 -e ES_JAVA_OPTS="-Xms2g -Xmx2g" blacktop/elasticsearch
```

### Documentation

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-elasticsearch-alpine/issues/new)

### Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/elasticsearch

### License

MIT Copyright (c) 2016 **blacktop**
