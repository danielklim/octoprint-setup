#!/bin/bash

FILES="boot/wpa_supplicant.conf
.octoprint/config.yaml
.octoprint/users.yaml
"

for f in $FILES
do
	echo "Processing $f"
	env $(cat .env | xargs) envsubst < $f.template > $f
done
