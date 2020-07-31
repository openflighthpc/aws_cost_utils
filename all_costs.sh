#!/bin/bash

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

for config in $(ls $DIR/config/) ; do 
    $DIR/costs.sh $config
done
