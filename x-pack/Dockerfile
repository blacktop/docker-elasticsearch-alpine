FROM alpine:3.5

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre tini su-exec

ENV ES_VERSION 5.5.1

ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz"
ENV ES_TARBALL_ASC "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz.asc"
ENV SHA1_URL "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz.sha1"
ENV ES_TARBALL_SHA1 "5a63834a8bb1ea62ac4eca4755e63bcee3ae4810"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

RUN apk add --no-cache bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && echo "===> Adding glibc..." \
  && wget --progress=bar:force -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
  && wget --progress=bar:force https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
  && apk add glibc-2.23-r3.apk \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && EXPECTED_SHA=$(wget -O - ${SHA1_URL}) \
  && wget --progress=bar:force -O elasticsearch.tar.gz "$ES_TARBAL"; \
	if [ "$ES_TARBALL_SHA1" ]; then \
		echo "$ES_TARBALL_SHA1 *elasticsearch.tar.gz" | sha1sum -c -; \
	fi; \
	if [ "$ES_TARBALL_ASC" ]; then \
		wget --progress=bar:force -O elasticsearch.tar.gz.asc "$ES_TARBALL_ASC"; \
		export GNUPGHOME="$(mktemp -d)"; \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
		gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
		rm -r "$GNUPGHOME" elasticsearch.tar.gz.asc; \
	fi; \
  tar -xf elasticsearch.tar.gz \
  && ls -lah \
  && mv elasticsearch-$ES_VERSION /usr/share/elasticsearch \
  && addgroup -g 1000 elasticsearch \
  && adduser -D -u 1000 -G elasticsearch -h /usr/share/elasticsearch elasticsearch \
  && echo "===> Creating Elasticsearch Paths..." \
  && for path in \
  	/usr/share/elasticsearch/data \
  	/usr/share/elasticsearch/logs \
  	/usr/share/elasticsearch/config \
  	/usr/share/elasticsearch/config/scripts \
  	/usr/share/elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  chown -R elasticsearch:elasticsearch "$path"; \
  done \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

WORKDIR /usr/share/elasticsearch

# Install X-Pack plugin
RUN elasticsearch-plugin install -b x-pack
# Install geoip/user-agent plugin
RUN elasticsearch-plugin install -b ingest-geoip
RUN elasticsearch-plugin install -b ingest-user-agent

COPY config/elastic /usr/share/elasticsearch/config
COPY config/x-pack/log4j2.properties /usr/share/elasticsearch/config/x-pack/
COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /
COPY docker-healthcheck /usr/local/bin/

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300
ENTRYPOINT ["/elastic-entrypoint.sh"]
CMD ["elasticsearch"]

# HEALTHCHECK CMD ["docker-healthcheck"]
