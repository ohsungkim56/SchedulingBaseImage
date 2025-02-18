#!/bin/bash

if [ "x"$SYSTEM_TELEGRAM_BOT_TOKEN == "xSKIP" ] 
then
    echo SYSTEM_TELEGRAM_BOT_TOKEN is SKIP.;
    echo $HOSTNAME is $1
    exit 0;
fi


if [ "x"$SYSTEM_TELEGRAM_BOT_TOKEN == "x" ] 
then
    echo SYSTEM_TELEGRAM_BOT_TOKEN is not set.;
    exit 1;
fi


if [ "x"$SYSTEM_TELEGRAM_BOT_CHAT_ID == "x" ] 
then
    echo SYSTEM_TELEGRAM_BOT_CHAT_ID is not set.;
    exit 1;
fi

MESSAGE="$HOSTNAME is $1"

URL="https://api.telegram.org/bot${SYSTEM_TELEGRAM_BOT_TOKEN}/sendMessage"

curl -s -X POST $URL -d chat_id=$SYSTEM_TELEGRAM_BOT_CHAT_ID -d text="$MESSAGE"