#!/bin/sh

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

################################################
# = MASTER NODE =                              #
################################################
if [ "$1" = 'master' -a "$(id -u)" = '0' ]; then
	# Change node into a data node
	CONFIG=/usr/share/elasticsearch/config/elasticsearch.yml
	sed -ri "s!^(\#\s*)?(node\.master:).*!\2 'true'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.ingest:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.data:).*!\2 'false'!" $CONFIG

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

		set -- su-exec elasticsearch "$@"
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
fi

################################################
# = INGEST NODE =                              #
################################################
if [ "$1" = 'ingest' -a "$(id -u)" = '0' ]; then
	# Change node into a data node
	CONFIG=/usr/share/elasticsearch/config/elasticsearch.yml
	sed -ri "s!^(\#\s*)?(node\.master:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.ingest:).*!\2 'true'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.data:).*!\2 'false'!" $CONFIG
	# Set master.node's name
	if ! grep -q "discovery.zen.ping.unicast.hosts" $CONFIG; then
		echo "discovery.zen.ping.unicast.hosts: [\"elastic-master\"]" >> $CONFIG
	fi

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

		set -- su-exec elasticsearch "$@"
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
fi

################################################
# = DATA NODE =                                #
################################################
if [ "$1" = 'data' -a "$(id -u)" = '0' ]; then
	# Change node into a data node
	CONFIG=/usr/share/elasticsearch/config/elasticsearch.yml
	sed -ri "s!^(\#\s*)?(node\.master:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.ingest:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.data:).*!\2 'true'!" $CONFIG
	# Set master.node's name
	if ! grep -q "discovery.zen.ping.unicast.hosts" $CONFIG; then
		echo "discovery.zen.ping.unicast.hosts: [\"elastic-master\"]" >> $CONFIG
	fi

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

		set -- su-exec elasticsearch "$@"
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

	set -- su-exec elasticsearch "$@"
fi

exec "$@"
