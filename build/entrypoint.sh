#!/bin/bash

NETWORK="prater"
VALIDATOR_PORT=3500

DATA_DIR="/home/user/nimbus-eth2/build/data"
VALIDATORS_DIR="${DATA_DIR}/validators"
TOKEN_FILE="${DATA_DIR}/auth-token"

# Create validators dir
mkdir -p ${VALIDATORS_DIR}

case $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_PRATER in
"goerli-geth.dnp.dappnode.eth")
    HTTP_ENGINE="http://goerli-geth.dappnode:8551"
    ;;
"goerli-nethermind.dnp.dappnode.eth")
    HTTP_ENGINE="http://goerli-nethermind.dappnode:8551"
    ;;
"goerli-besu.dnp.dappnode.eth")
    HTTP_ENGINE="http://goerli-besu.dappnode:8551"
    ;;
"goerli-erigon.dnp.dappnode.eth")
    HTTP_ENGINE="http://goerli-erigon.dappnode:8551"
    ;;
*)
    echo "Unknown value for _DAPPNODE_GLOBAL_EXECUTION_CLIENT_PRATER: $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_PRATER"
    HTTP_ENGINE=$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_PRATER
    ;;
esac

if [ -n "$_DAPPNODE_GLOBAL_MEVBOOST_PRATER" ] && [ "$_DAPPNODE_GLOBAL_MEVBOOST_PRATER" == "true" ]; then
    echo "MEVBOOST is enabled"
    MEVBOOST_URL="http://mev-boost.mev-boost-goerli.dappnode:18550"
    if curl --retry 5 --retry-delay 5 --retry-all-errors "${MEVBOOST_URL}"; then
        EXTRA_OPTS="${EXTRA_OPTS} --payload-builder=true --payload-builder-url=${MEVBOOST_URL}"
    else
        echo "MEVBOOST is enabled but ${MEVBOOST_URL} is not reachable"
        curl -X POST -G 'http://my.dappnode/notification-send' --data-urlencode 'type=danger' --data-urlencode title="${MEVBOOST_URL} is not available" --data-urlencode 'body=Make sure the mevboost is available and running'
    fi
fi

# Run checkpoint sync script if provided
[[ -n $CHECKPOINT_SYNC_URL ]] &&
    /home/user/nimbus-eth2/build/nimbus_beacon_node trustedNodeSync \
        --network=${NETWORK} \
        --trusted-node-url=${CHECKPOINT_SYNC_URL} \
        --backfill=false \
        --data-dir=//home/user/nimbus-eth2/build/data
[[ -n $WEB3_BACKUP_URL ]] && EXTRA_OPTS="--web3-url=${WEB3_BACKUP_URL} ${EXTRA_OPTS}"
ls /home/user/nimbus-eth2/build/
exec -c /home/user/nimbus_beacon_node \
    --network=${NETWORK} \
    --data-dir=${DATA_DIR} \
    --tcp-port=$P2P_TCP_PORT \
    --udp-port=$P2P_UDP_PORT \
    --validators-dir=${VALIDATORS_DIR} \
    --log-level=${LOG_TYPE}\
    --rest \
    --rest-port=4500 \
    --rest-address=0.0.0.0 \
    --metrics \
    --metrics-address=0.0.0.0 \
    --metrics-port=8008 \
    --keymanager \
    --keymanager-port=${VALIDATOR_PORT} \
    --keymanager-address=0.0.0.0 \
    --keymanager-token-file=${TOKEN_FILE} \
    --graffiti="${GRAFFITI:0:32}" \
    --jwt-secret=/jwtsecret \
    --web3-url=$HTTP_ENGINE \
    --suggested-fee-recipient="${FEE_RECIPIENT_ADDRESS}" \
    $EXTRA_OPTS
