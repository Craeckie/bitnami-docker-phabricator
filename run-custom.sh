#!/bin/bash

echo "Configuring SSH"
export PATH="$PATH:/usr/bin:/opt/bitnami/php/bin"
usermod --password "*" git
usermod --unlock git
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator

/opt/bitnami/phabricator/bin/config set --stdin cluster.mailers </bitnami/phabricator/conf/cluster.json
