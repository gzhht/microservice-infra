#!/usr/bin/env bash

set -x
docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")
set +x