#!/usr/bin/env bash
export IMAGE_FAMILY='tf-latest-cpu'
export ZONE='us-central1-c'
export INSTANCE_NAME='preemptible-standard-8'
export INSTANCE_TYPE='n1-standard-8	'

# https://stackoverflow.com/a/12694189/4804137
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --image-family=$IMAGE_FAMILY \
        --image-project=deeplearning-platform-release \
        --machine-type=$INSTANCE_TYPE \
        --boot-disk-size=50GB \
        --min-cpu-platform=Intel\ Skylake \
        --preemptible \
        --metadata-from-file startup-script=$DIR/startup-gpu.sh
