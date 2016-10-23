## To create an elasticsearch cluster

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

> **NOTE:** `docker-compose.yml` assumes you have more than 4GB of RAM available.  

Now you can:  
 - Navigate to: [http://localhost:5601](http://localhost:5601) for [Kibana](https://www.elastic.co/products/kibana)  
 - Navigate to: [http://localhost:9200/_plugin/kopf](http://localhost:9200/_plugin/kopf) for [kopf](https://github.com/lmenezes/elasticsearch-kopf)  

> **NOTE:** Example usage assumes you are using [Docker for Mac](https://docs.docker.com/docker-for-mac/)
