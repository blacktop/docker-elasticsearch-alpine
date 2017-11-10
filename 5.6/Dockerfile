FROM alpine:3.6

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre su-exec

ENV VERSION 5.6.4
ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL "${DOWNLOAD_URL}/elasticsearch-${VERSION}.tar.gz"
ENV ES_TARBALL_ASC "${DOWNLOAD_URL}/elasticsearch-${VERSION}.tar.gz.asc"
ENV EXPECTED_SHA_URL "${DOWNLOAD_URL}/elasticsearch-${VERSION}.tar.gz.sha512"
ENV ES_TARBALL_SHA "37730f39cf1711b6a20861370ef7aff4b48e7f90ad82cb1c8c92643179194c4dcdf0180691d8065304bf61e7f5a2fb1ed5c84c384e0b2ff7ad0dc58ac7352f47"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && wget --progress=bar:force -O elasticsearch.tar.gz "$ES_TARBAL"; \
	if [ "$ES_TARBALL_SHA" ]; then \
		echo "$ES_TARBALL_SHA *elasticsearch.tar.gz" | sha512sum -c -; \
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
  && mv elasticsearch-$VERSION /usr/share/elasticsearch \
  && adduser -D -h /usr/share/elasticsearch elasticsearch \
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
