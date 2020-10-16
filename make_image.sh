#!/bin/bash
pth=$1
if [ -z "$pth" ]; then
    echo Specify path to build
    exit 1
fi
if [[ -n $(git status --short) ]]; then
    git status
    echo Clean git status and commit before building image.
    exit 2
fi

gcloud auth configure-docker
tag=$(git rev-parse --short HEAD)
name=$(basename $PWD)
user=gcr.io/uob-jupyterhub
img_name="${name}:${tag}"
full_name="${user}/${img_name}"
docker build -t ${full_name} ${pth}
docker push ${full_name}
