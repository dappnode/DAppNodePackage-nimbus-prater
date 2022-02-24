ARG UPSTREAM_VERSION

FROM statusim/nimbus-eth2:multiarch-$UPSTREAM_VERSION

RUN apt update && apt install -y cron jq

# Setup cronjob
COPY get-keys-cron /etc/cron.d/
COPY get-keys.sh /usr/local/bin/get-keys.sh

# Apply cron job
RUN crontab /etc/cron.d/get-keys-cron

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]