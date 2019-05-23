FROM alpine:3.9

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre su-exec

ENV VERSION 6.7.2
ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL "${DOWNLOAD_URL}/elasticsearch-oss-${VERSION}.tar.gz"
ENV ES_TARBALL_ASC "${DOWNLOAD_URL}/elasticsearch-oss-${VERSION}.tar.gz.asc"
ENV EXPECTED_SHA_URL "${DOWNLOAD_URL}/elasticsearch-oss-${VERSION}.tar.gz.sha512"
ENV ES_TARBALL_SHA "2c81159ff2639d77d028114ef09c6cb9a4f0d1880268255812eb033cfddd9eb97afe8f468df8b1fb1f2910fb7b3d87a02eb6a248453fc2aa11e2c964f3f2cbcb"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-6.3.0.zip
RUN apk add --no-cache bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && set -ex \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && wget --progress=bar:force -O elasticsearch.tar.gz "$ES_TARBAL"; \
  if [ "$ES_TARBALL_SHA" ]; then \
  echo "$ES_TARBALL_SHA *elasticsearch.tar.gz" | sha512sum -c -; \
  fi; \
  if [ "$ES_TARBALL_ASC" ]; then \
  wget --progress=bar:force -O elasticsearch.tar.gz.asc "$ES_TARBALL_ASC"; \
  export GNUPGHOME="$(mktemp -d)"; \
  ( gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
  || gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" \
  || gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY" ); \
  gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
  rm -rf "$GNUPGHOME" elasticsearch.tar.gz.asc || true; \
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
  /usr/share/elasticsearch/tmp \
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
RUN chmod +x /elastic-entrypoint.sh
COPY docker-healthcheck /usr/local/bin/

WORKDIR /usr/share/elasticsearch

ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV ES_TMPDIR /usr/share/elasticsearch/tmp

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300
ENTRYPOINT ["/elastic-entrypoint.sh"]
CMD ["elasticsearch"]

# HEALTHCHECK CMD ["docker-healthcheck"]
