#!/usr/bin/env bash
set -ex
case $1 in
"dev")
  echo "Building local image and mounting codebase..."
  docker build -t tippexs/wwp:devbuild .
  docker-compose up
  ;;
"stop")
  echo "Stoping Services"
  docker-compose down
  docker rm --force dev_wordpress_1
  ;;
esac
