FROM gliderlabs/alpine:3.4

MAINTAINER blacktop, https://github.com/blacktop

ENV GOSU_VERSION 1.7
ENV GOSU_URL https://github.com/tianon/gosu/releases/download

# Install java and tini
RUN apk-install openjdk8-jre tini
# Install gosu
RUN apk-install -t build-deps wget ca-certificates gpgme \
  && set -x \
	&& echo "Grab *gosu* for easy step-down from root..." \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
  && apk del --purge build-deps

ENV ELASTIC 5.0.0-rc1

RUN apk-install bash
RUN apk-install -t build-deps wget ca-certificates \
  && cd /tmp \
  && wget -O elasticsearch-$ELASTIC.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTIC.tar.gz \
  && tar -xzf elasticsearch-$ELASTIC.tar.gz \
  && mv elasticsearch-$ELASTIC /usr/share/elasticsearch \
  && adduser -DH -s /sbin/nologin elasticsearch \
	&& echo "Creating Elasticsearch Paths..." \
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
  && apk del --purge build-deps

COPY config/elastic /usr/share/elasticsearch/config
COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /

WORKDIR /usr/share/elasticsearch

ENV PATH /usr/share/elasticsearch/bin:$PATH

# This is needed for it to run
# I think it is a bug with the alpha version
ENV ES_JAVA_OPTS "-Xms2g -Xmx2g"

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300

ENTRYPOINT ["/elastic-entrypoint.sh"]

CMD ["elasticsearch"]
