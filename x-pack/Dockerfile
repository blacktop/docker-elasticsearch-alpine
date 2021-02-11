FROM openjdk:11-jre

LABEL maintainer "https://github.com/blacktop"

RUN set -ex; \
	# https://artifacts.elastic.co/GPG-KEY-elasticsearch
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
# key='46095ACC8548582C1A2699A9D27D666CD88E42B4'; \
# export GNUPGHOME="$(mktemp -d)"; \
# gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
# gpg --export "$key" > /etc/apt/trusted.gpg.d/elastic.gpg; \
# rm -rf "$GNUPGHOME"; \
# apt-key list

# https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-repositories.html
# https://www.elastic.co/guide/en/elasticsearch/reference/5.0/deb.html
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/* \
	&& echo 'deb https://artifacts.elastic.co/packages/7.x/apt stable main' > /etc/apt/sources.list.d/elasticsearch.list

ENV ELASTICSEARCH_VERSION 7.10.2
ENV ELASTICSEARCH_DEB_VERSION 7.10.2
ENV ELASTIC_CONTAINER=true

RUN set -x \
	\
	# don't allow the package to install its sysctl file (causes the install to fail)
	# Failed to write '262144' to '/proc/sys/vm/max_map_count': Read-only file system
	&& dpkg-divert --rename /usr/lib/sysctl.d/elasticsearch.conf \
	\
	&& apt-get update \
	&& apt-get install -y --no-install-recommends "elasticsearch=$ELASTICSEARCH_DEB_VERSION" \
	&& rm -rf /var/lib/apt/lists/*

ENV PATH /usr/share/elasticsearch/bin:$PATH

WORKDIR /usr/share/elasticsearch

RUN set -ex \
	&& for path in \
	./data \
	./logs \
	./config \
	./config/scripts \
	./config/ingest-geoip \
	; do \
	mkdir -p "$path"; \
	chown -R elasticsearch:elasticsearch "$path"; \
	done

COPY config/elastic/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY config/x-pack/log4j2.properties /usr/share/elasticsearch/config/x-pack/
COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /
COPY docker-healthcheck /usr/local/bin/

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300
ENTRYPOINT ["/elastic-entrypoint.sh"]
CMD ["elasticsearch"]

# HEALTHCHECK CMD ["docker-healthcheck"]
