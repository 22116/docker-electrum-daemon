#!/usr/bin/env sh
set -ex

# Graceful shutdown
trap 'pkill -TERM -P1; electrum daemon stop; exit 0' SIGTERM

if [ ${TESTNET} == 1 ];then
    TEST = '--testnet'
else
    TEST = ''
fi

# Set config
electrum setconfig ${TEST} rpcuser ${ELECTRUM_USER}
electrum setconfig ${TEST} rpcpassword ${ELECTRUM_PASSWORD}
electrum setconfig ${TEST} rpcport 7777
electrum setconfig ${TEST} rpchost 0.0.0.0

# XXX: Check load wallet or create

# Run application
electrum -v daemon start ${TEST}
electrum -v daemon load_wallet ${TEST}
electrum daemon status ${TEST}

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done
