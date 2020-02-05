#!/usr/bin/env bash
set -ex

build_container() {
  docker build -t bww/wpwebsite --no-cache .
}

containerize() {
  echo "Building Container Image"
  build_container
  docker tag bww/wpwebsite:latest 865324692845.dkr.ecr.eu-central-1.amazonaws.com/bww/websitewp:latest
  echo "Pushing... "
  docker push 865324692845.dkr.ecr.eu-central-1.amazonaws.com/bww/websitewp:latest
}

case $1 in
"push")
  echo "Building and Pushing to AWS ..."
  containerize
  ;;
esac