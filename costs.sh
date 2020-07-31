#!/bin/bash

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

if [ -z "$SLACK_TOKEN" ] ; then
    echo "Export a slack token before running script"
    echo "    export SLACK_TOKEN=MySlackToken"
    exit 1
fi

. $DIR/load_conf.sh $config

# Get costs
TODAY=$(date +'%Y-%m-%d')
YESTERDAY=$(date -d yesterday  +'%Y-%m-%d')
YESTERYESTERDAY=$(date -d '2 days ago'  +'%Y-%m-%d')
    
DATA=$(aws ce get-cost-and-usage --time-period Start=$YESTERYESTERDAY,End=$YESTERDAY --granularity DAILY --metrics UnblendedCost --output text --region us-east-1 --filter '{"Not":{"Dimensions":{"Key":"RECORD_TYPE","Values":["Credit"]}}}')
export COSTLONG=$(echo "$DATA" |grep UNBLENDEDCOST -m 1 |awk '{print $2}')
COST=$(ruby -e "printf '%.2f', ENV['COSTLONG'].to_f.round(2)")

export CU_FLAT=$(ruby -e "puts (ENV['COSTLONG'].to_f * 10).ceil")
CU_RISK=$(ruby -e "puts (ENV['CU_FLAT'].to_f * 1.25).ceil")

USAGE=$(grep "^\[$YESTERYESTERDAY\]" log/usage_$CLUSTER.log)
    
msg="
:moneybag: Usage for $YESTERYESTERDAY :moneybag:\n
*USD:* $COST \n
*Compute Units (Flat):* $CU_FLAT \n
*Compute Units (Risk):* $CU_RISK\n
$(if [ ! -z "$USAGE" ] ; then
echo "*Usage:* $USAGE"
fi)"

cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$CHANNEL",
  "as_user": true
}
EOF
