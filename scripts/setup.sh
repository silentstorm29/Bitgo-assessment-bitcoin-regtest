#!/usr/bin/env bash
set -euo pipefail

RPC1="-rpcuser=admin -rpcpassword=admin123 -regtest -rpcport=18443"
RPC2="-rpcuser=admin -rpcpassword=admin123 -regtest -rpcport=28443"

# Wait for node1 RPC to be ready
until docker exec bitgo-node1 bitcoin-cli $RPC1 getblockchaininfo &>/dev/null; do
  echo "Waiting for node1 RPC..."
  sleep 1
done

# Wait for node2 RPC to be ready
until docker exec bitgo-node2 bitcoin-cli $RPC2 getblockchaininfo &>/dev/null; do
  echo "Waiting for node2 RPC..."
  sleep 1
done

# Create wallets on both nodes if not existing
if ! docker exec bitgo-node1 bitcoin-cli $RPC1 listwallets | grep -q '"wallet"'; then
  docker exec bitgo-node1 bitcoin-cli $RPC1 createwallet wallet
fi

if ! docker exec bitgo-node2 bitcoin-cli $RPC2 listwallets | grep -q '"wallet"'; then
  docker exec bitgo-node2 bitcoin-cli $RPC2 createwallet wallet
fi

# 1. Connect node2 to node1
echo "[1/5] Connecting node2 to node1"
docker exec bitgo-node2 bitcoin-cli $RPC2 addnode "bitgo-node1" onetry

# 2. Mine initial blocks to unlock coinbase outputs
echo "[2/5] Mining 101 blocks on node1"
docker exec bitgo-node1 bitcoin-cli $RPC1 -generate 101
sleep 2

# 3. Generate a new address on node2
echo "[3/5] Generating address on node2"
ADDR=$(docker exec bitgo-node2 bitcoin-cli $RPC2 getnewaddress)
echo "Address: $ADDR"

# 4. Send funds from node1 to node2
echo "[4/5] Sending 10 BTC from node1 to node2"
TXID=$(docker exec bitgo-node1 bitcoin-cli $RPC1 sendtoaddress "$ADDR" 10)
echo "Transaction ID: $TXID"

# 5. Mine one block to confirm the transaction
echo "[5/5] Mining 1 block to confirm"
docker exec bitgo-node1 bitcoin-cli $RPC1 -generate 1

# Final: show balances
echo "All done! Balances:"
echo "Node1 balance:"
docker exec bitgo-node1 bitcoin-cli $RPC1 getbalance
echo "Node2 balance:"
docker exec bitgo-node2 bitcoin-cli $RPC2 getbalance