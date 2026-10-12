# hello-gitops-app

Static site in an nginx image. Pushing to `main` builds the image, pushes it to GHCR, and writes the new tag into [hello-gitops-infra](https://github.com/ok2ju/hello-gitops-infra). ArgoCD deploys from there.

```
push to main
  -> build image ghcr.io/ok2ju/hello-gitops-app:<sha>
  -> commit tag to hello-gitops-infra/helm/hello/values-dev.yaml   (ArgoCD syncs dev)
  -> wait for approval on the "prod" environment
  -> commit tag to values-prod.yaml                                (ArgoCD syncs prod)
```

## One-time GitHub setup

1. Create both repos as **public** (`hello-gitops-app`, `hello-gitops-infra`) and push them.
2. Create a fine-grained personal access token with access to `hello-gitops-infra` only and the permission **Contents: Read and write**. Save it in this repo as the Actions secret `GITOPS_TOKEN`.
3. Under Settings > Environments, create `dev` and `prod`. On `prod`, add yourself as a required reviewer.
4. After the first workflow run, open the `hello-gitops-app` package on your GitHub profile. If its visibility is private, set it to **public** so the cluster can pull without credentials.

## Run locally

```sh
docker build -t hello --build-arg VERSION=local .
docker run --rm -p 8080:80 hello   # http://localhost:8080
```
