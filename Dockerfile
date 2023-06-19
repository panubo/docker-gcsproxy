FROM docker.io/nginx:1.24

# Install bash-container functions
RUN set -x \
  && BASHCONTAINER_VERSION=0.7.2 \
  && BASHCONTAINER_SHA256=87c4b804f0323d8f0856cb4fbf2f7859174765eccc8b0ac2d99b767cecdcf5c6 \
  && if ! command -v wget > /dev/null; then \
      fetchDeps="${fetchDeps} wget"; \
     fi \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl ${fetchDeps} \
  && cd /tmp \
  && wget -nv https://github.com/panubo/bash-container/releases/download/v${BASHCONTAINER_VERSION}/panubo-functions.tar.gz \
  && echo "${BASHCONTAINER_SHA256}  panubo-functions.tar.gz" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum panubo-functions.tar.gz)"; exit 1; )) \
  && tar --no-same-owner -C / -zxf panubo-functions.tar.gz \
  && rm -rf /tmp/* \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${fetchDeps} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  ;

# Install gomplate
RUN set -x \
  && GOMPLATE_VERSION=v3.11.5 \
  && GOMPLATE_CHECKSUM_X86_64=16f6a01a0ff22cae1302980c42ce4f98ca20f8c55443ce5a8e62e37fc23487b3 \
  && GOMPLATE_CHECKSUM_AARCH64=fd980f9d233902e50f3f03f10ea65f36a2705385358a87aa18b19fb7cdf54c1d \
  && if [ "$(uname -m)" = "x86_64" ] ; then \
        GOMPLATE_CHECKSUM="${GOMPLATE_CHECKSUM_X86_64}"; \
        GOMPLATE_ARCH="amd64"; \
      elif [ "$(uname -m)" = "aarch64" ]; then \
        GOMPLATE_CHECKSUM="${GOMPLATE_CHECKSUM_AARCH64}"; \
        GOMPLATE_ARCH="arm64"; \
      fi \
  && curl -sSf -o /tmp/gomplate_linux-${GOMPLATE_ARCH} -L https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-${GOMPLATE_ARCH} \
  && echo "${GOMPLATE_CHECKSUM}  gomplate_linux-${GOMPLATE_ARCH}" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum gomplate_linux-${GOMPLATE_ARCH})"; exit 1; )) \
  && install -m 0755 /tmp/gomplate_linux-${GOMPLATE_ARCH} /usr/local/bin/gomplate \
  && rm -f /tmp/* \
  ;

# Install s6
RUN set -x \
  && S6_VERSION=2.11.0.0 \
  && EXECLINE_VERSION=2.8.1.0 \
  && SKAWARE_RELEASE=2.0.7 \
  && S6_CHECKSUM_X86_64=fcf79204c1957016fc88b0ad7d98f150071483583552103d5822cbf56824cc87 \
  && S6_CHECKSUM_AARCH64=64151e136f887c6c2c7df69e3100573c318ec7400296680cc698bc7b0ca36943 \
  && EXECLINE_CHECKSUM_X86_64=b216cfc4db928729d950df5a354aa34bc529e8250b55ab0de700193693dea682 \
  && EXECLINE_CHECKSUM_AARCH64=8cb1d5c2d44cb94990d63023db48f7d3cd71ead10cbb19c05b99dbd528af5748 \
  && if [ "$(uname -m)" = "x86_64" ] ; then \
        S6_CHECKSUM="${S6_CHECKSUM_X86_64}"; \
        EXECLINE_CHECKSUM="${EXECLINE_CHECKSUM_X86_64}"; \
        SKAWARE_ARCH="amd64"; \
      elif [ "$(uname -m)" = "aarch64" ]; then \
        S6_CHECKSUM="${S6_CHECKSUM_AARCH64}"; \
        EXECLINE_CHECKSUM="${EXECLINE_CHECKSUM_AARCH64}"; \
        SKAWARE_ARCH="aarch64"; \
      fi \
  && curl -sSf -L -o /tmp/s6-${S6_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz https://github.com/just-containers/skaware/releases/download/v${SKAWARE_RELEASE}/s6-${S6_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz \
  && curl -sSf -L -o /tmp/execline-${EXECLINE_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz https://github.com/just-containers/skaware/releases/download/v${SKAWARE_RELEASE}/execline-${EXECLINE_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz \
  && echo "${S6_CHECKSUM}  s6-${S6_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz" > /tmp/SHA256SUM \
  && echo "${EXECLINE_CHECKSUM}  execline-${EXECLINE_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz" >> /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected S6: $(sha256sum s6-${S6_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz) Execline: $(sha256sum execline-${EXECLINE_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz)"; exit 1; )) \
  && tar -C /usr -zxf /tmp/s6-${S6_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz \
  && tar -C /usr -zxf /tmp/execline-${EXECLINE_VERSION}-linux-${SKAWARE_ARCH}-bin.tar.gz \
  && rm -rf /tmp/* \
  ;

CMD ["/usr/bin/s6-svscan","/etc/s6"]

# Install gcsproxy
RUN set -x \
  && GCSPROXY_VERSION=0.4.0 \
  && GCSPROXY_CHECKSUM_X86_64=3df0fa7ab12849d4711990b64128e58100582f2f50a53af871ecca796f2b09a8 \
  && GCSPROXY_CHECKSUM_AARCH64=6cb271b78b7feed4e83135a97321ec7f204f90e62bb31fedc0472f2137d8f068 \
  && if [ "$(uname -m)" = "x86_64" ] ; then \
        GCSPROXY_CHECKSUM="${GCSPROXY_CHECKSUM_X86_64}"; \
        GCSPROXY_ARCH="amd64"; \
      elif [ "$(uname -m)" = "aarch64" ]; then \
        GCSPROXY_CHECKSUM="${GCSPROXY_CHECKSUM_AARCH64}"; \
        GCSPROXY_ARCH="arm64"; \
      fi \
  && curl -sSf -o /tmp/gcsproxy-${GCSPROXY_VERSION}-linux-${GCSPROXY_ARCH}.tar.gz -L https://github.com/daichirata/gcsproxy/releases/download/v${GCSPROXY_VERSION}/gcsproxy-${GCSPROXY_VERSION}-linux-${GCSPROXY_ARCH}.tar.gz \
  && echo "${GCSPROXY_CHECKSUM}  gcsproxy-${GCSPROXY_VERSION}-linux-${GCSPROXY_ARCH}.tar.gz" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum gcsproxy-${GCSPROXY_VERSION}-linux-${GCSPROXY_ARCH}.tar.gz)"; exit 1; )) \
  && tar -C /tmp -zxf /tmp/gcsproxy-${GCSPROXY_VERSION}-linux-${GCSPROXY_ARCH}.tar.gz \
  && install -m 0755 /tmp/gcsproxy-${GCSPROXY_VERSION}-linux-${GCSPROXY_ARCH}/gcsproxy /usr/local/bin/gcsproxy \
  && rm -rf /tmp/* \
  ;

COPY s6/ /etc/s6/
COPY nginx/ /etc/nginx/

