#!/bin/bash

set -e

# Files created by Elasticsearch should always be group writable too
umask 0002

es_opts=''

while IFS='=' read -r envvar_key envvar_value
do
    # Elasticsearch env vars need to have at least two dot separated lowercase words, e.g. `cluster.name`
    if [[ "$envvar_key" =~ ^[a-z]+\.[a-z]+ ]]
    then
        if [[ ! -z $envvar_value ]]; then
          es_opt="-E${envvar_key}=${envvar_value}"
          es_opts+=" ${es_opt}"
        fi
    fi
done < <(env)

export ES_JAVA_OPTS="-Des.cgroups.hierarchy.override=/ $ES_JAVA_OPTS"

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
	sed -ri "s!^(\#\s*)?(node\.ingest:).*!\2 'false'!" $CONFIG
	sed -ri "s!^(\#\s*)?(node\.data:).*!\2 'false'!" $CONFIG

	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

	set -- su-exec elasticsearch "$@" ${es_opts}
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

	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

	set -- su-exec elasticsearch "$@" ${es_opts}
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

	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs

	set -- su-exec elasticsearch "$@" ${es_opts}

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
