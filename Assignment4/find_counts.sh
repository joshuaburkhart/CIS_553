#!/bin/bash

cat weka_out.txt | grep '/' | awk -F '(' '{print $3}' | awk -F '/' '{print $1}' | sort -n
