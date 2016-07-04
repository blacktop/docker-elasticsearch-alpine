docker-elasticsearch-alpine
===========================

[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based Elasticsearch Docker Image

### Dependencies

-	[gliderlabs/alpine](https://index.docker.io/_/gliderlabs/alpine/)

### Usage

```
docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
```

To increase the HEAP_MAX and HEAP_MIN to 2GB.

```
docker run -d --name elastic -p 9200:9200 -e ES_JAVA_OPTS="-Xms2g -Xmx2g" blacktop/elasticsearch
```

To monitor the clusters metrics using [dockerbeat](https://github.com/Ingensi/dockerbeat):

```bash
$ curl https://raw.githubusercontent.com/Ingensi/dockerbeat/develop/etc/dockerbeat.template.json \
  | curl -H "Content-Type: application/json" -XPUT -d @- 'http://localhost:9200/_template/dockerbeat'
$ docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link elastic:elasticsearch ingensi/dockerbeat
```

### Documentation

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-elasticsearch-alpine/issues/new)

### Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/elasticsearch

### License

MIT Copyright (c) 2016 **blacktop**
