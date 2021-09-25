# Docker file for Deepnote image

This assumes that `matthewbrett` is your [DockerHub](https://hub.docker.com)
user name, and you've made a project called `deepnote-2021` in your DockerHub
account.

The `TAG` code below names the image from the current date and time.

Build locally with:

```
ACCOUNT=matthewbrett
PROJECT=deepnote-2021
TAG=$(date +'%Y-%m-%d_%H-%M')
IMG_NAME="${ACCOUNT}/${PROJECT}:${TAG}"

docker build -t $IMG_NAME .
```

Upload with:

```
docker login --username=$ACCOUNT
docker push $IMG_NAME
```
