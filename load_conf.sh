#!/bin/bash
#
# Script for loading in variables for an account
#

config=$1

if [ -z $config ] ; then
    echo "No config specified"
    exit 1
fi

file=config/$config
if [ ! -f $file ] ; then
    if [ -f config/$config.sh ] ; then
        file=config/$config.sh
    else
        echo "$file{.sh}: No such config" 
        exit 1
    fi
fi

source $file
