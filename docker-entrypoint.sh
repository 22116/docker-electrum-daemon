#!/usr/bin/env sh
set -ex

# Graceful shutdown
trap 'pkill -TERM -P1; electrum daemon stop; exit 0' SIGTERM

# Set config
electrum setconfig rpcuser ${ELECTRUM_USER}
electrum setconfig rpcpassword ${ELECTRUM_PASSWORD}
electrum setconfig rpcport 7777
electrum setconfig rpchost 0.0.0.0

electrum setconfig --testnet rpcuser ${ELECTRUM_USER}
electrum setconfig --testnet rpcpassword ${ELECTRUM_PASSWORD}
electrum setconfig --testnet rpcport 7777
electrum setconfig --testnet rpchost 0.0.0.0

# XXX: Check load wallet or create

# Run application
if [ ${TESTNET} == true ];then
    electrum daemon start --testnet
    electrum daemon load_wallet --testnet
    electrum daemon status --testnet
else
    electrum daemon start
    electrum daemon load_wallet
    electrum daemon status
fi

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done
