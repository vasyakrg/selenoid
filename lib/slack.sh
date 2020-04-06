#!/bin/bash

[ -z $1 ] && [ -z $2 ] && [ -z $3 ] && {
    echo "usage ./slack <KEY> <subject> <message>. Subject = 'PROBLEM' or 'OK'"
}

KEY="$1"
URL="https://hooks.slack.com/services/${KEY}"

# TO="#tests"
SUB="$2"
ICON=":scream:"
MESS="$3"

if [[ $SUB == 'PROBLEM' ]]
then
	ICON=":scream:"
elif [[ $SUB == 'OK' ]]
then
	ICON=":ok_hand:"
else
	ICON=":point_up_2:"
fi

curl -X POST --data-urlencode "payload={\"channel\": \"#tests\", \"username\": \"selenoid\", \"text\": \"$MESS\", \"icon_emoji\": \":squid:\"}" $URL
