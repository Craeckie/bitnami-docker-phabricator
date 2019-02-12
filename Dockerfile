FROM bitnami/phabricator

RUN echo 'git ALL=(USERNAME) SETENV: NOPASSWD: /opt/bitnami/git/bin/git-upload-pack, /opt/bitnami/git/bin/git-receive-pack' >>/etc/sudoers \
    && sed -i 's/git:!:/git:NP:/' /etc/shadow \
    && cp /opt/bitnami/phabricator/resources/sshd/phabricator-ssh-hook.sh /usr/share/ \
    && sed -i -e '/^VCSUSER=/c\VCSUSER="git"' -e '/^ROOT=/c\ROOT="/opt/bitnami/phabricator"' /usr/share/phabricator-ssh-hook.sh \
    && chown root /usr/share/phabricator-ssh-hook.sh \
    && chmod 755 /usr/share/phabricator-ssh-hook.sh \
    && cp /opt/bitnami/phabricator/resources/sshd/sshd_config.phabricator.example /etc/ssh/sshd_config.phabricator \
    && sed -i -e '/^AuthorizedKeysCommand /c\AuthorizedKeysCommand /usr/share/phabricator-ssh-hook.sh' -e '/^AuthorizedKeysCommandUser /c\AuthorizedKeysCommandUser git' -e '/^AllowUsers /c\AllowUsers git' -e '/^Port /c\Port 2222' /etc/ssh/sshd_config.phabricator \


