#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='YOUR_ollo1......ADDRESS'
VALIDATOR_ADDRESS='YOUR_ollovaloper1ADDRESS'
DELAY=3200 #in secs - how often restart the script 
ACC_NAME='YOU_WALLET_WITHOUT_QUOTES' #example: = ACC_NAME=wallet_qwwq_54
NODE=http://localhost:26657 #change it only if you use another rpc port of your node

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo -e "${PWD}\ny\n" | ollod tx distribution withdraw-all-rewards --from ${ACC_NAME} --fees 20uatolo --chain-id groot-011 --yes
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done

        BAL=$(ollod query bank balances ${DELEGATOR_ADDRESS} --node ${NODE});
        # BAL=$(($BAL -100000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} uatolo\n"
        echo -e "Claim rewards\n"
        echo -e "${PWD}\n${PWD}\n" | ollod tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --chain-id groot-011 --from ${ACC_NAME} --node ${NODE} --commission -y --fees 1000utollo
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done
        BAL=$(ollod query bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount');
        BAL=$(($BAL -100000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utollo\n"
        echo -e "Stake ALL 11111\n"
        echo -e "${PWD}\n${PWD}\n" | ollod tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}uatolo --chain-id testnet-0 --from ${ACC_NAME} --node ${NODE} -y --fees 1000utollo
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done
