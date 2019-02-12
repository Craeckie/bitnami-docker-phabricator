FROM bitnami/phabricator


RUN install_packages openssh-server python-pygments \
    && useradd -b /home -d /home/git -m git \
    && echo 'git ALL=(git) SETENV: NOPASSWD: /opt/bitnami/git/bin/git-upload-pack, /opt/bitnami/git/bin/git-receive-pack' >>/etc/sudoers \
    && sed -i 's/git:!:/git:NP:/' /etc/shadow \
    && cp /opt/bitnami/phabricator/resources/sshd/phabricator-ssh-hook.sh /usr/share/ \
    && sed -i -e '/^VCSUSER=/c\VCSUSER="git"' \
              -e '/^ROOT=/c\ROOT="/opt/bitnami/phabricator"\nexport PATH=/usr/bin:/opt/bitnami/php/bin' \
              /usr/share/phabricator-ssh-hook.sh \
    && chown root /usr/share/phabricator-ssh-hook.sh \
    && chmod 755 /usr/share/phabricator-ssh-hook.sh \
    && cp /opt/bitnami/phabricator/resources/sshd/sshd_config.phabricator.example /etc/ssh/sshd_config.phabricator \
    && sed -i -e '/^AuthorizedKeysCommand /c\AuthorizedKeysCommand /usr/share/phabricator-ssh-hook.sh' \
              -e '/^AuthorizedKeysCommandUser /c\AuthorizedKeysCommandUser git' \
              -e '/^AllowUsers /c\AllowUsers git' \
              -e '/^Port /c\Port 2222' /etc/ssh/sshd_config.phabricator \
    && echo 'PermitUserEnvironment yes' >> /etc/ssh/sshd_config.phabricator \
    && sed -i 's;SSHD_OPTS=.*;SSHD_OPTS="-f /etc/ssh/sshd_config.phabricator";' /etc/default/ssh \
    && sed -i 's;\(\$root = \)dirname;\1;' /opt/bitnami/phabricator/bin/ssh-auth \
    && mkdir -p /home/git/.ssh \
    && echo 'PATH=/usr/bin:/opt/bitnami/php/bin' >> ~git/.ssh/environment \
    && ln -s /opt/bitnami/php/bin/php /usr/bin/php \
    && mkdir -p /run/sshd \
    && sed -i '/exec/i source /run-custom.sh' /app-entrypoint.sh

COPY run-custom.sh /run-custom.sh

# CMD [ "/run-custom.sh" ]


