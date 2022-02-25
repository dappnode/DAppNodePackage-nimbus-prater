ARG UPSTREAM_VERSION

###########
# BUILDER #
###########
# Get jq binaries (curl is already in the consensys image)
FROM debian:bullseye-slim as builder
RUN apt update && apt install cron jq curl --yes

FROM statusim/nimbus-eth2:multiarch-v1.7.0

# Copy curl binary
COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY --from=builder /usr/lib/x86_64-linux-gnu/libcurl* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libng* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/librtmp* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libssh2* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libpsl* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libldap* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/liblber* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libbrotlidec* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libsasl2* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libbrotlicommon* /usr/lib/x86_64-linux-gnu/
# Copy jq binary
COPY --from=builder /usr/bin/jq /usr/bin/jq
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjq* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libonig* /usr/lib/x86_64-linux-gnu/
# Copy crontab and cron binary
COPY --from=builder /usr/sbin/cron /usr/sbin/cron
COPY --from=builder /usr/bin/crontab /usr/bin/crontab
COPY --from=builder /var/spool/cron /var/spool/cron

# Setup cronjob
COPY get-keys-cron /etc/cron.d/
COPY get-keys.sh /usr/local/bin/get-keys.sh

# Apply cron job
RUN crontab /etc/cron.d/get-keys-cron

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]