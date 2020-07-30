#!/bin/bash
#
# Identifies the currently running resources for an account.
#
# Note that this automatically excludes gateway, admin & head nodes
# to focus on gathering information about the compute nodes. The 
# reasoning for this is that the customer can only really change what
# compute nodes they are using whereas the gateway, admin and head 
# nodes are constant resources.
#

# Load account configuration
. load_conf.sh $1

# Variables
REGION="eu-west-2"
DATE="$(date +'%Y-%m-%d')"
LOG="log/usage_$CLUSTER.log"
EXCLUDE_NAMES="gateway|gw|GW|cadmin|chead|monitor"

# Functions
function join_by_comma { printf -- "%s, " "$1" |sed -E 's/(.*),/\1/' ; }

# Gather info
INSTANCES="$(aws ec2 describe-instances --region $REGION --output text --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]|[0].Value, InstanceId, InstanceType, State.Name]')"

# Remove excluded names
INSTANCES_FILTERED="$(echo "$INSTANCES" |grep -vE "$EXCLUDE_NAMES")"

# Split by instance type & power state
INSTANCE_TYPES="$(echo "$INSTANCES_FILTERED" |awk '{print $3}' |sort |uniq)"

details=()
for type in $INSTANCE_TYPES ; do
    typeinstances="$(echo "$INSTANCES_FILTERED" |grep "$type")"

    numtype="$(echo "$typeinstances" |wc -l)"
    numup="$(echo "$typeinstances" |grep --count 'running')"
    numdown="$(echo "$typeinstances" |grep --count 'stopped')"

    if [[ $numdown != 0 ]] ; then
        details+=("$numtype x $type ($numdown powered off)")
    else
        details+=("$numtype x $type")
    fi
done

echo "[$DATE] $(join_by_comma "${details[@]}")" >> $LOG
