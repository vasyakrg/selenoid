#!/bin/bash

source lib/key

[[ "$OSTYPE" == "darwin"* ]] && {
    # 'brew install gnu-sed' before!
    SED="gsed sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g'"
    echo "OS=Mac OS"

} || {
    SED="sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g'"
    echo "OS=linux"
}

SITE=$1

# SITE=https://dev-yegorov.mlmsoft.com

[ -z $SITE ] && {
    echo "usage: ./start <link of site>, example: ./start https://yandex.ru"
    exit 1
}

echo "SITE=$SITE" > runner/sides/.env
mo -s=runner/sides/.env -u runner/sides/mlm-main-app.side.template > runner/sides/mlm-main-app.side

cd runner
# docker-compose up -d --remove-orphans

cd ..
while [ ! -f runner/out/runner1/mlm-main-app.json ]
do
    echo "wait end of test..."
    sleep 10
done

RESULT=$(cat runner/out/runner1/mlm-main-app.json | jq '.numFailedTests')

[ ${RESULT} == '0' ] && {
    arg1="OK"
    arg2="All test of $SITE passed"
} || {
    # TITLE=$(cat runner/out/runner1/mlm-main-app.json | jq '.testResults[] | .assertionResults[] | .title')
    # TESTNAME=$(cat runner/out/runner1/mlm-main-app.json | jq '.testResults[] | .assertionResults[] | .fullName')
    PROBLEM=$(cat runner/out/runner1/mlm-main-app.json | jq -r '.testResults[] | .message')
    arg1="PROBLEM"
    # arg2="Any test of $SITE failed\n TESTSUITE=$TESTNAME\n TITLE=$TITLE\n $PROBLEM"
    arg2="Any test of $SITE failed\n $PROBLEM"
}

lib/slack.sh $KEY "$arg1" "$arg2"
# echo -e "$arg1: $arg2"

# rm runner/sides/mlm-main-app.side
# rm runner/out/runner1/mlm-main-app.json
# echo "" > runner/sides/.env
