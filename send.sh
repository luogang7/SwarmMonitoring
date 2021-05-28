#!/bin/bash

[ -z ${DEBUG_API+x} ] && DEBUG_API=http://localhost:1635
[ -z ${MIN_AMOUNT+x} ] && MIN_AMOUNT=10000

function getPeers() {
  curl -s "$DEBUG_API/chequebook/cheque" | jq -r '.lastcheques | .[].peer'
}

function getLastCashedPayout() {
  local peer=$1
  local cashout=$(curl -s "$DEBUG_API/chequebook/cashout/$peer" | jq '.cumulativePayout')
  if [ $cashout == null ]
  then
    echo 0
  else
    echo $cashout
  fi
}

function getAllUncashed() {
  uncashednum=0
  for peer in $(getPeers)
  do
    local uncashedAmount=$(getUncashedAmount $peer)
    if (( "$uncashedAmount" > 0 ))
    then
      echo $peer $uncashedAmount
      let uncashednum=uncashednum+1
    fi
  done
}

function getUncashedAmount() {
  local peer=$1
  local cumulativePayout=$(getCumulativePayout $peer)
  if [ $cumulativePayout == 0 ]
  then
    echo 0
    return
  fi

  cashedPayout=$(getLastCashedPayout $peer)
  let uncashedAmount=$cumulativePayout-$cashedPayout
  echo $uncashedAmount
}

function getCumulativePayout() {
  local peer=$1
  local cumulativePayout=$(curl -s "$DEBUG_API/chequebook/cheque/$peer" | jq '.lastreceived.payout')
  if [ $cumulativePayout == null ]
  then
    echo 0
  else
    echo $cumulativePayout
  fi
}

function makejson(){
  ip=$(curl -s api.infoip.io/ip)
  address=$(curl -s localhost:1635/addresses | jq .ethereum)
  chequeaddress=$(curl -s http://localhost:1635/chequebook/address | jq .chequebookAddress)
  category="server"
  getAllUncashed
  name=$HOSTNAME
  peers=$(curl -s http://localhost:1635/peers | jq '.peers | length')
  diskavail=$(df -P . | awk 'NR==2{print $2}')
  diskfree=$(df -P . | awk 'NR==2{print $4}')
  cheque=$(curl -s http://localhost:1635/chequebook/cheque | jq '.lastcheques | length')
  json='{"ip":"'"$ip"'","address":'${address}',"chequeaddress":'${chequeaddress}',"category":"'${category}'","uncashednum":'${uncashednum}',"name":"'"$name"'","peers":'$peers',"diskavail":'$diskavail',"diskfree":'$diskfree',"cheque":'$cheque'}'
}

if [ $# -eq 0 ]
  then
    echo "I need URL of your Rest API!"
    exit 1
fi
makejson
echo $json
curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data ""$json"" ""$1""
