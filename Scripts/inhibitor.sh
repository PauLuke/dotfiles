#!/bin/sh

pactl list | grep RUNNING && exit 1 || exit 0
