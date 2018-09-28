#!/usr/bin/env bash
export IMAGE_FAMILY='tf-latest-cu92'
export ZONE='us-central1-c'
export INSTANCE_NAME='hw3'
export INSTANCE_TYPE='n1-highmem-2'

# https://stackoverflow.com/a/12694189/4804137
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --image-family=$IMAGE_FAMILY \
        --image-project=deeplearning-platform-release \
        --maintenance-policy=TERMINATE \
        --accelerator='type=nvidia-tesla-k80,count=1' \
        --machine-type=$INSTANCE_TYPE \
        --boot-disk-size=200GB \
        --metadata='install-nvidia-driver=True' \
        --preemptible \
        --metadata-from-file startup-script=$DIR/startup-gpu.sh
