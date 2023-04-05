#!/bin/bash

set -e

CURRENT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -d "$CURRENT_DIR/build" ]
then
  npm run build
fi


if [ -z "$1" ]
then
  echo "Please input the bucket name"
  exit 1
fi

if [ -z "$2" ]
then
  echo "Please input the domain name"
  exit 1
fi

S3_BUCKET_NAME=$1
DNS_CDN=$2

# Sync build to S3

aws s3 sync build s3://S3_BUCKET_NAME
