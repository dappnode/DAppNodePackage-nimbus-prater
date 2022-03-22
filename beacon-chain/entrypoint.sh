#!/bin/bash

exec -c /home/user/nimbus-eth2/build/nimbus_beacon_node \
    --non-interactive \
    --network=prater \
    --data-dir=/home/user/nimbus-eth2/build/data \
    --tcp-port=9000 \
    --udp-port=9000 \
    --web3-url=$HTTP_WEB3PROVIDER \
    --rest \
    --rest-port=$BEACON_API_PORT \
    --rest-address=0.0.0.0 \
    --rest-allow-origin "*" \
    --metrics \
    --metrics-address=0.0.0.0 \
    --metrics-port=8008 \
    $EXTRA_OPTS
