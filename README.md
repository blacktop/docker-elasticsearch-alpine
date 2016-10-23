![es-logo](https://raw.githubusercontent.com/blacktop/docker-elasticsearch-alpine/master/es-logo.png)

docker-elasticsearch-alpine
===========================

[![CircleCI](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine.png?style=shield)](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Image](https://img.shields.io/badge/docker image-141.5 MB-blue.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based Elasticsearch Docker Image

**Table of Contents**

- [docker-elasticsearch-alpine](#docker-elasticsearch-alpine)
    - [Why?](#why)
    - [Dependencies](#dependencies)
    - [Image Tags](#image-tags)
    - [Getting Started](#getting-started)
    - [Documentation](#documentation)
        - [To increase the HEAP_MAX and HEAP_MIN to 2GB.](#to-increase-the-heap_max-and-heap_min-to-2gb)
        - [To create an elasticsearch cluster](#to-create-an-elasticsearch-cluster)
        - [To monitor the clusters metrics using dockerbeat:](#to-monitor-the-clusters-metrics-using-dockerbeat)
    - [Known Issues](#known-issues)
      - [5.0 failing to start](#50-failing-to-start)
    - [Issues](#issues)
    - [Credits](#credits)
    - [CHANGELOG](#changelog)
    - [Contributing](#contributing)
    - [License](#license)

### Why?

Compare Image Sizes:  
 - official elasticsearch = 354.8 MB  
 - blacktop/elasticsearch = 141 MB

**Alpine version is 213 MB smaller !**

### Dependencies

-	[gliderlabs/alpine:3.4](https://index.docker.io/_/gliderlabs/alpine/)

### Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/elasticsearch   latest              141.7 MB
blacktop/elasticsearch   5.0                 151.1 MB
blacktop/elasticsearch   kopf                147.5 MB
blacktop/elasticsearch   2.4                 141.5 MB
blacktop/elasticsearch   2.3                 141.7 MB
blacktop/elasticsearch   1.7                 145.4 MB
```

> **NOTE:** tag **5.0** requires at least 2GB of RAM to run.
> **NOTE:** tag **kopf** includes the *kopf* plugin.

### Getting Started

```bash
$ docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
```

### Documentation

> **NOTE:** Example usage assumes you are using [Docker for Mac](https://docs.docker.com/docker-for-mac/)

##### To increase the HEAP_MAX and HEAP_MIN to 2GB.

```bash
$ docker run -d --name elastic -p 9200:9200 -e ES_JAVA_OPTS="-Xms2g -Xmx2g" blacktop/elasticsearch
```

##### To create an elasticsearch cluster

```bash
$ docker run -d --name elastic-master blacktop/elasticsearch master
$ docker run -d --name elastic-client -p 9200:9200 --link elastic-master blacktop/elasticsearch:kopf client
$ docker run -d --name elastic-data-1 --link elastic-master blacktop/elasticsearch data
$ docker run -d --name elastic-data-2 --link elastic-master blacktop/elasticsearch data
$ docker run -d --name elastic-data-3 --link elastic-master blacktop/elasticsearch data
$ docker run -d --name kibana -p 5601:5601 --link elastic-client:elasticsearch kibana
```

Or you can use [docker-compose](https://docs.docker.com/compose/):

```bash
$ curl -sL https://raw.githubusercontent.com/blacktop/docker-elasticsearch-alpine/master/docker-compose.yml \
  > docker-compose.yml
$ docker-compose up -d
$ docker-compose scale data=3
```

Now you can:  
 - Navigate to: [http://localhost:5601](http://localhost:5601) for [Kibana](https://www.elastic.co/products/kibana)  
 - Navigate to: [http://localhost:9200/_plugin/kopf](http://localhost:9200/_plugin/kopf) for [kopf](https://github.com/lmenezes/elasticsearch-kopf)

##### To monitor the clusters metrics using [dockerbeat](https://github.com/Ingensi/dockerbeat):

```bash
$ curl https://raw.githubusercontent.com/Ingensi/dockerbeat/develop/etc/dockerbeat.template.json \
  | curl -H "Content-Type: application/json" -XPUT -d @- 'http://localhost:9200/_template/dockerbeat'
$ docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link elastic:elasticsearch ingensi/dockerbeat
```

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-elasticsearch-alpine/issues/new)

### Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/elasticsearch

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/docker-elasticsearch-alpine/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/docker-elasticsearch-alpine/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/docker-elasticsearch-alpine/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2016 **blacktop**
