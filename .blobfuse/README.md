
## Mounting Datasets

⚠️ These scripts must be run from host machine (not in the dev container)

Use [BlobFuse](https://learn.microsoft.com/en-us/azure/storage/blobs/blobfuse2-configuration#cli-parameters) to setup `/mnt/vlpdatasets/data`

### Install BlobFuse2

```bash
cd /tmp
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install fuse3 blobfuse2 -y
rm packages-microsoft-prod.deb
cd -
```

### Mount containers to host machine

```bash
# Set shell vars
EFFICIENT_AI_SUBSCRIPTION_ID=332431bf-68bf-46f9-ab8b-c7bfe2197219
DEEP_LEARNING_GROUP_SUBSCRIPTION_ID=2cd190bb-b42a-477c-b1bb-2f20932d8dc5

# Acquire credentials to Azure Subscription
az login --use-device-code

# Set up variables for storage mount
export STORAGE_ACCOUNT_NAME=vlpdatasets
export STORAGE_ACCOUNT_KEY=$(az storage account keys list --subscription $DEEP_LEARNING_GROUP_SUBSCRIPTION_ID --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)
echo "Storage Account Key: ${STORAGE_ACCOUNT_KEY:0:5}...${STORAGE_ACCOUNT_KEY: -5}"
export STORAGE_CONTAINER_NAME=data
# Note: We are mounting to the `/mnt` location in the Data Science Virtual Machines
# These are Azure Ephemeral drives that have higher I/O but are reset during maintenance
# This means mounts may need to be setup again.
export STORAGE_MOUNT_LOCATION=/mnt/$STORAGE_ACCOUNT_NAME/$STORAGE_CONTAINER_NAME

bash ./.blobfuse/storageMount.sh \
    $STORAGE_ACCOUNT_NAME \
    $STORAGE_ACCOUNT_KEY \
    $STORAGE_CONTAINER_NAME \
    $STORAGE_MOUNT_LOCATION

# Set up variables for storage mount
export STORAGE_ACCOUNT_NAME=swadspmcworksp8316681497
export STORAGE_ACCOUNT_KEY=$(az storage account keys list --subscription $EFFICIENT_AI_SUBSCRIPTION_ID --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)
echo "Storage Account Key: ${STORAGE_ACCOUNT_KEY:0:5}...${STORAGE_ACCOUNT_KEY: -5}"
export STORAGE_CONTAINER_NAME=azureml-blobstore-c0c4b1fc-24bf-4b6b-ab9b-fa61e97866c5
export STORAGE_MOUNT_LOCATION=/mnt/swadsaml/blobstore

bash ./.blobfuse/storageMount.sh \
    $STORAGE_ACCOUNT_NAME \
    $STORAGE_ACCOUNT_KEY \
    $STORAGE_CONTAINER_NAME \
    $STORAGE_MOUNT_LOCATION
```