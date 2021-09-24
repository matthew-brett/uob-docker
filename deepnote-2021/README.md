# Docker file for Deepnote image

This assumes that `matthewbrett` is your [DockerHub](https://hub.docker.com)
user name, and you've made a project called `deepnote-2021` in your DockerHub
account.

We will call this image `001`.  Choose a name for each new image.

Build locally with:

```
ACCOUNT=matthewbrett
PROJECT=deepnote-2021
TAG="001"
IMG_NAME="${ACCOUNT}/${PROJECT}:${TAG}"

docker build -t $IMG_NAME .
```

Upload with:

```
docker login --username=$ACCOUNT
docker push $IMG_NAME
```
