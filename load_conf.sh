#!/bin/bash
#
# Script for loading in variables for an account
#

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
config=$1

if [ -z $config ] ; then
    echo "No config specified"
    exit 1
fi

file=$DIR/config/$config
if [ ! -f $file ] ; then
    if [ -f $DIR/config/$config.sh ] ; then
        file=$DIR/config/$config.sh
    else
        echo "$file{.sh}: No such config" 
        exit 1
    fi
fi

source $file
