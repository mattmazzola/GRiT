#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

STORAGE_ACCOUNT_NAME=$1
STORAGE_ACCOUNT_KEY=$2
STORAGE_CONTAINER_NAME=$3
STORAGE_MOUNT_LOCATION=$4

if [ -z "$STORAGE_ACCOUNT_NAME" ]; then
  echo "Error: You attempted to run storage mount script, but STORAGE_ACCOUNT_NAME was not set. Please check the inputs passed to the script."
  exit 1
fi

if [ -z "$STORAGE_ACCOUNT_KEY" ]; then
  echo "Error: You attempted to run storage mount script, but STORAGE_ACCOUNT_KEY was not set. Please check the inputs passed to the script."
  exit 1
fi

if [ -z "$STORAGE_CONTAINER_NAME" ]; then
  echo "Error: You attempted to run storage mount script, but STORAGE_CONTAINER_NAME was not set. Please check the inputs passed to the script."
  exit 1
fi

if [ -z "$STORAGE_MOUNT_LOCATION" ]; then
  echo "Error: You attempted to run storage mount script, but STORAGE_MOUNT_LOCATION was not set. Please check the inputs passed to the script."
  exit 1
fi

EXAMPLE_BLOBFUSE_CONFIG_FILE=$(realpath $SCRIPT_DIR/../.blobfuse/container_blobfuse_v2.example.yaml)

echo "Make copy of blobfuse config example file for $STORAGE_CONTAINER_NAME"
BLOBFUSE_CONFIG_FILE=$(realpath $SCRIPT_DIR/../.blobfuse/container_blobfuse_v2_aml.yaml)
cp $EXAMPLE_BLOBFUSE_CONFIG_FILE $BLOBFUSE_CONFIG_FILE

echo "Replace placeholders variables with values in $BLOBFUSE_CONFIG_FILE..."
sed -i "s@STORAGE_ACCOUNT_NAME@$STORAGE_ACCOUNT_NAME@g" $BLOBFUSE_CONFIG_FILE
sed -i "s@STORAGE_ACCOUNT_KEY@$STORAGE_ACCOUNT_KEY@g" $BLOBFUSE_CONFIG_FILE
sed -i "s@STORAGE_CONTAINER_NAME@$STORAGE_CONTAINER_NAME@g" $BLOBFUSE_CONFIG_FILE

echo "Creating dir $STORAGE_MOUNT_LOCATION..."
sudo mkdir -p $STORAGE_MOUNT_LOCATION

echo "Mounting $STORAGE_CONTAINER_NAME to $STORAGE_MOUNT_LOCATION account..."
sudo blobfuse2 mount $STORAGE_MOUNT_LOCATION --config-file=$BLOBFUSE_CONFIG_FILE --read-only || :

ls -l $STORAGE_MOUNT_LOCATION
