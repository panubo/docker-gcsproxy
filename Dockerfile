FROM docker.io/nginx:latest

# Install Panubo bash container
RUN set -x \
  && BASHCONTAINER_VERSION=0.3.0 \
  && if ! command -v wget > /dev/null; then \
      fetchDeps="${fetchDeps} wget"; \
     fi \
  && if ! command -v gpg > /dev/null; then \
      fetchDeps="${fetchDeps} gnupg dirmngr"; \
     fi \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl ${fetchDeps} \
  && cd /tmp \
  && wget -nv https://github.com/panubo/bash-container/releases/download/v${BASHCONTAINER_VERSION}/panubo-functions.tar.gz \
  && wget -nv https://github.com/panubo/bash-container/releases/download/v${BASHCONTAINER_VERSION}/panubo-functions.tar.gz.asc \
  && GPG_KEYS="E51A4070A3FFBD68C65DDB9D8BECEF8DFFCC60DD" \
  && ( gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEYS" \
      || gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEYS" \
      || gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEYS" ) \
  && gpg --batch --verify panubo-functions.tar.gz.asc panubo-functions.tar.gz  \
  && tar -C / -zxf panubo-functions.tar.gz \
  && rm -rf /tmp/* \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${fetchDeps} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  ;

# Install gomplate
RUN set -x \
  && GOMPLATE_VERSION=v2.6.0 \
  && GOMPLATE_CHECKSUM=dce66be08c81d266408123e8f59a17951225dc226883c6c9fe903fbecf15b7a4 \
  && curl -sS -o /tmp/gomplate_linux-amd64-slim -L https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim \
  && echo "${GOMPLATE_CHECKSUM}  gomplate_linux-amd64-slim" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM; ) \
  && mv /tmp/gomplate_linux-amd64-slim /usr/local/bin/gomplate \
  && chmod +x /usr/local/bin/gomplate \
  && rm -f /tmp/* \
  ;

# Install s6
RUN set -x \
  && S6_VERSION=2.7.1.1 \
  && EXECLINE_VERSION=2.5.0.0 \
  && SKAWARE_RELEASE=1.21.5 \
  && curl -sS -L https://github.com/just-containers/skaware/releases/download/v${SKAWARE_RELEASE}/s6-${S6_VERSION}-linux-amd64-bin.tar.gz | tar -C /usr -zxf - \
  && curl -sS -L https://github.com/just-containers/skaware/releases/download/v${SKAWARE_RELEASE}/execline-${EXECLINE_VERSION}-linux-amd64-bin.tar.gz | tar -C /usr -zxf - \
  ;
CMD ["/usr/bin/s6-svscan","/etc/s6"]

# Install gcsproxy
RUN set -x \
  && GCSPROXY_VERSION=0.2.0 \
  && curl -sS -L https://github.com/daichirata/gcsproxy/releases/download/v${GCSPROXY_VERSION}/gcsproxy_${GCSPROXY_VERSION}_amd64_linux -o /usr/local/bin/gcsproxy \
  && chmod +x /usr/local/bin/gcsproxy \
  ;

COPY s6/ /etc/s6/
COPY nginx/ /etc/nginx/

