#!/bin/bash

set -e

umask 0002

declare -a es_opts

while IFS='=' read -r envvar_key envvar_value
do
    # Elasticsearch env vars need to have at least two dot separated lowercase words, e.g. `cluster.name`
    if [[ "$envvar_key" =~ ^[a-z0-9_]+\.[a-z0-9_]+ ]]; then
        if [[ ! -z $envvar_value ]]; then
          es_opt="-E${envvar_key}=${envvar_value}"
          es_opts+=("${es_opt}")
        fi
    fi
done < <(env)

export ES_JAVA_OPTS="-Des.cgroups.hierarchy.override=/ $ES_JAVA_OPTS"


if [[ -d bin/x-pack ]]; then
    # Check for the ELASTIC_PASSWORD environment variable to set the
    # bootstrap password for Security.
    #
    # This is only required for the first node in a cluster with Security
    # enabled, but we have no way of knowing which node we are yet. We'll just
    # honor the variable if it's present.
    if [[ -n "$ELASTIC_PASSWORD" ]]; then
        [[ -f /usr/share/elasticsearch/config/elasticsearch.keystore ]] || (echo "y" | elasticsearch-keystore create)
        if ! (elasticsearch-keystore list | grep -q '^bootstrap.password$'); then
            (echo "$ELASTIC_PASSWORD" | elasticsearch-keystore add -x 'bootstrap.password')
        fi
    fi
fi

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/{data,logs,config}

	set -- chroot --userspec=elasticsearch / "$@" "${es_opts[@]}"
fi

exec "$@"
