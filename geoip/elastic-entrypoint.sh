#!/bin/sh

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
	; do
		chown -R elasticsearch:elasticsearch "$path"
	done

	set -- su-exec elasticsearch "$@"
	#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'master' -a "$(id -u)" = '0' ]; then
	# Change node into a master node
	echo "node.master: true" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "node.ingest: false" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "node.data: false" >> /usr/share/elasticsearch/config/elasticsearch.yml

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		for path in \
			/usr/share/elasticsearch/data \
			/usr/share/elasticsearch/logs \
		; do
			chown -R elasticsearch:elasticsearch "$path"
		done

		set -- su-exec elasticsearch "$@"
		#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
	#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'ingest' -a "$(id -u)" = '0' ]; then
	# Change node into a ingest node
	echo "node.master: false" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "node.ingest: true" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "node.data: false" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "discovery.zen.ping.unicast.hosts: [\"elastic-master\"]" >> /usr/share/elasticsearch/config/elasticsearch.yml

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		for path in \
			/usr/share/elasticsearch/data \
			/usr/share/elasticsearch/logs \
		; do
			chown -R elasticsearch:elasticsearch "$path"
		done

		set -- su-exec elasticsearch "$@"
		#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
	#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'data' -a "$(id -u)" = '0' ]; then
	# Change node into a data node
	echo "node.master: false" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "node.ingest: false" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "node.data: true" >> /usr/share/elasticsearch/config/elasticsearch.yml
	echo "discovery.zen.ping.unicast.hosts: [\"elastic-master\"]" >> /usr/share/elasticsearch/config/elasticsearch.yml

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		for path in \
			/usr/share/elasticsearch/data \
			/usr/share/elasticsearch/logs \
		; do
			chown -R elasticsearch:elasticsearch "$path"
		done

		set -- su-exec elasticsearch "$@"
		#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
	#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
fi

exec "$@"
