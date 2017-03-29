FROM gliderlabs/alpine:3.4

MAINTAINER blacktop, https://github.com/blacktop

RUN apk-install openjdk8-jre tini su-exec

ENV ES_VERSION 5.2.2

ENV ELASTICSEARCH_URL "https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL "${ELASTICSEARCH_URL}/elasticsearch-${ES_VERSION}.tar.gz"
ENV ES_TARBALL_ASC "${ELASTICSEARCH_URL}/elasticsearch-${ES_VERSION}.tar.gz.asc"
ENV ES_TARBALL_SHA1 "7351cd29ac9c20592d94bde950f513b5c5bb44d3"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk-install bash
RUN apk-install -t .build-deps wget ca-certificates gnupg openssl \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && wget -O elasticsearch.tar.gz "$ES_TARBAL"; \
	if [ "$ES_TARBALL_SHA1" ]; then \
		echo "$ES_TARBALL_SHA1 *elasticsearch.tar.gz" | sha1sum -c -; \
	fi; \
	if [ "$ES_TARBALL_ASC" ]; then \
		wget -O elasticsearch.tar.gz.asc "$ES_TARBALL_ASC"; \
		export GNUPGHOME="$(mktemp -d)"; \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
		gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
		rm -r "$GNUPGHOME" elasticsearch.tar.gz.asc; \
	fi; \
  tar -xf elasticsearch.tar.gz \
  && ls -lah \
  && mv elasticsearch-$ES_VERSION /usr/share/elasticsearch \
  && adduser -DH -s /sbin/nologin elasticsearch \
  && echo "===> Creating Elasticsearch Paths..." \
  && for path in \
  	/usr/share/elasticsearch/data \
  	/usr/share/elasticsearch/logs \
  	/usr/share/elasticsearch/config \
  	/usr/share/elasticsearch/config/scripts \
  	/usr/share/elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  done \
  && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

COPY config/elastic /usr/share/elasticsearch/config
COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /
COPY docker-healthcheck /usr/local/bin/

WORKDIR /usr/share/elasticsearch

ENV PATH /usr/share/elasticsearch/bin:$PATH

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300
ENTRYPOINT ["/elastic-entrypoint.sh"]
CMD ["elasticsearch"]

# HEALTHCHECK CMD ["docker-healthcheck"]
