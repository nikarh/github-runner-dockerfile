# Dockerized GitHub Runner

[![Docker](https://github.com/marius/github-runner-dockerfile/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/marius/github-runner-dockerfile/actions/workflows/docker-publish.yml)

This container runs Docker in Docker so it can use Docker based workflows.

Please provide the repository, for which this runner is meant, as `REPOSITORY` environment variable, and
a suitable GitHub personal access token (PAT) in `GITHUB_PAT` or as a secret
in file `/run/secrets/github_pat`.

## Docker run

```
docker run -d -e REPOSITORY=marius/postfix-sendgrid -e GITHUB_PAT=MYPAT ghcr.io/marius/github-actions-runner
```

## Docker compose example

```
version: "3"

secrets:
  github_pat:
    file: /tank/docker/secrets/github_pat

services:
  github-actions-runner:
    container_name: github-actions-runner
    image: ghcr.io/marius/github-actions-runner
    environment:
      REPOSITORY: marius/postfix-sendgrid
    secrets:
      - github_pat
```

## History

This container is based on [beikeni/github-runner-dockerfile](https://github.com/beikeni/github-runner-dockerfile).
Please check the README over there or the author's
[blog post](https://baccini-al.medium.com/creating-a-dockerfile-for-dynamically-creating-github-actions-self-hosted-runners-5994cc08b9fb).
