#!/bin/sh
set -e

if [ -n "$GF_INSTALL_PLUGINS" ]; then
	printf '%s' "$GF_INSTALL_PLUGINS" |
		tr ',' '\n' |
		while read -r plugin; do
		grafana-cli plugins install ${plugin}
	done
fi

## Check for the "Username of owner" and "Group name of owner" of "/grafana/data" and if grafana doesn't have ownership than transfer it
if [ "$(stat -c "%U:%G" /grafana/data)" != grafana:grafana ]; then
	chown grafana:grafana /grafana/data
fi

## Run grafana server with hme directory "/grafana"
exec su-exec grafana grafana-server --homepath=/grafana