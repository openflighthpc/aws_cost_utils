#!/bin/bash

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

for config in $(ls $DIR/config/) ; do 
    $DIR/get_usage.sh $config
done
