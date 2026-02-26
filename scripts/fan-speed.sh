#!/usr/bin/env bash

RAW_STATUS=$(nbfc status | grep "Target Fan Speed" | head -n 1 | awk '{print $NF}')
echo "$RAW_STATUS" | cut -d. -f1
