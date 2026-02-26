#!/usr/bin/env bash

if fuser -s /dev/video0 2>/dev/null; then
    exit 0
else
    exit 1
fi
