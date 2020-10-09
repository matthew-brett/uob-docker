#!/bin/bash
tag=$(git rev-parse --short HEAD)
name=$(basename $PWD)
user=gcr.io/uob-jupyterhub
img_name="${name}:${tag}"
full_name="${user}/${img_name}"
docker build -t ${full_name} .
docker push ${full_name}
