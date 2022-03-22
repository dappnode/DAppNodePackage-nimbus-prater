ARG UPSTREAM_VERSION

FROM statusim/nimbus-eth2:multiarch-v${UPSTREAM_VERSION}

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]