#!/bin/sh -l

echo "Hello $1 $2 $3 $4"

echo "::set-output name=needs-update::true"
