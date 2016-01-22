#!/usr/bin/env bash

if [[ -n $MC_OPS ]] ; then
	echo "$MC_OPS" > ops.json
fi

exec ./ServerStart.sh
