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

### To Run on OSX

-	Install [Homebrew](http://brew.sh)

```bash
$ brew install caskroom/cask/brew-cask
$ brew cask install virtualbox
$ brew install docker
$ brew install docker-machine
$ docker-machine create --driver virtualbox
$ eval $(docker-machine env)
```

### Documentation

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-elasticsearch-alpine/issues/new) and I'll get right on it.

### Credits

### License

MIT Copyright (c) 2016 **blacktop**
