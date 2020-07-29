# AWS Cost & Usage Utilities

## Overview

An assortment of scripts for tracking usage & costs of an AWS account

## Config

An account can be configured by adding a new file to `config/`, see `config/.example.sh` for more information on required variables

## Scripts

- `costs.sh`: Loops through all known configurations and identifies the cost for 2 days ago (as this seems to be how long it takes for the daily cost to stabilise)
- `get_usage.sh`: Breakdown the compute node usage for the account region for the current day, this is then logged to `log/costs_$CONFIG_NAME.log`
- `load_conf.sh`: Checks & loads in the configuration file & variables 

