#!/bin/sh
set -e

mkdir -p tmp

if [ ! -f tmp/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f tmp/id_ed25519 -P "" -q
fi
if [ ! -f tmp/id_rsa ]; then
    ssh-keygen -t rsa -f tmp/id_rsa -P "" -q
fi

exec ./jobs
