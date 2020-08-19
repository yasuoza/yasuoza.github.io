#!/bin/sh

sed -i -e "s|CODESERVER_PASSWORD|$CODESERVER_PASSWORD|g" /home/coder/.config/code-server/config.yaml

/usr/bin/dumb-init -- fixuid -q "$@"
