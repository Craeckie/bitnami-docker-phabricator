#!/bin/bash

echo "Configuring SSH"
export PATH="$PATH:/usr/bin:/opt/bitnami/php/bin"
usermod --password "*" git
usermod --unlock git
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator
