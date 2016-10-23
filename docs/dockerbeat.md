## To monitor the clusters metrics using [dockerbeat](https://github.com/Ingensi/dockerbeat)

```bash
$ curl https://raw.githubusercontent.com/Ingensi/dockerbeat/develop/etc/dockerbeat.template.json \
  | curl -H "Content-Type: application/json" -XPUT -d @- 'http://localhost:9200/_template/dockerbeat'
$ docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link elastic:elasticsearch ingensi/dockerbeat
```
