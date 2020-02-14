#!/usr/bin/env bash
set -ex

build_container() {
  docker build -t org/wpwebsite --no-cache .
}

containerize() {
  echo "Building Container Image"
  build_container
  docker tag org/wpwebsite:latest docker.reg.com/org/websitewp:latest
  echo "Pushing... "
  docker push docker.reg.com/org/websitewp:latest
}

case $1 in
"push")
  echo "Building and Pushing to AWS ..."
  containerize
  ;;
esac
