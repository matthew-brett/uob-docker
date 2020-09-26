# UoB Docker file for JupyterHub

## Build the image locally

```
docker build -t matthewbrett/uobhub:v002 .
```

## Google Container Registry

See <https://www.cloudsavvyit.com/4866/how-to-push-and-pull-docker-images-from-google-container-registry/>.

Enable GCR for project via
<https://console.cloud.google.com/apis/library/containerregistry.googleapis.com>.

Configure docker with gcloud:

```
gcloud auth configure-docker
```

Tag and push to GCR:

```
docker tag matthewbrett/uobhub:v002 gcr.io/uob-jupyterhub/uobhub:v002
docker push gcr.io/uob-jupyterhub/uobhub:v002
```

## Dockerhub

The image can be pushed up to dockerhub directly::

```
docker login --username=matthewbrett
docker push matthewbrett/uobhub:001
```

If you get a "User interaction is not allowed." error at the ``login`` stage,
you may get further by running this command at the affected terminal::

```
security unlock-keychain
```

See
<https://github.com/docker/docker-credential-helpers/issues/82#issuecomment-367258282>
