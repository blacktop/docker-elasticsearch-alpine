#!/bin/bash

set -e

es_opts=''

while IFS='=' read -r envvar_key envvar_value
do
    # Elasticsearch env vars need to have at least two dot separated lowercase words, e.g. `cluster.name`
    if [[ "$envvar_key" =~ ^[a-z]+\.[a-z]+ ]]
    then
        if [[ ! -z $envvar_value ]]; then
          es_opt="-D${envvar_key}=${envvar_value}"
          es_opts+=" ${es_opt}"
        fi
    fi
done < <(env)

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@" ${es_opts}
fi

################################################
# = MASTER NODE =                              #
################################################
if [ "$1" = 'master' -a "$(id -u)" = '0' ]; then
	# Change node into a data node
	CONFIG=/usr/share/elasticsearch/config/elasticsearch.yml
	sed -ri "s!^(\#\s*)?(node\.master:).*!\2 'true'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.client:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.data:).*!\2 'false'!" $CONFIG

	# Drop root privileges if we are running elasticsearch
	# allow the container to be started with `--user`
	if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
		# Change the ownership of user-mutable directories to elasticsearch
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
		chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

		set -- su-exec elasticsearch "$@" ${es_opts}
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
fi

################################################
# = CLIENT NODE =                              #
################################################
if [ "$1" = 'client' -a "$(id -u)" = '0' ]; then
	# Change node into a data node
	CONFIG=/usr/share/elasticsearch/config/elasticsearch.yml
	sed -ri "s!^(\#\s*)?(node\.master:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.client:).*!\2 'true'!" $CONFIG
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

		set -- su-exec elasticsearch "$@" ${es_opts}
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
	sed -ri "s!^(\#\s*)?(node\.client:).*!\2 'false'!" $CONFIG
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

		set -- su-exec elasticsearch "$@" ${es_opts}
	fi

	set -- su-exec elasticsearch /sbin/tini -- elasticsearch
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

	set -- su-exec elasticsearch "$@" ${es_opts}
fi

exec "$@"
