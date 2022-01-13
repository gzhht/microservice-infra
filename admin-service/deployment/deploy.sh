#!/usr/bin/env bash

VERSION=$SERVICE-$BUILD_NUMBER
IMAGE=$SERVICE:$TAG

sed "s#{{service}}#$SERVICE#g; s#{{image}}#$IMAGE#g; s#{{namespace}}#$NAMESPACE#g; s#{{version}}#$VERSION#g" ./deployment/dev.yaml 

sed "s#{{service}}#$SERVICE#g; s#{{image}}#$IMAGE#g; s#{{namespace}}#$NAMESPACE#g; s#{{version}}#$VERSION#g" ./deployment/dev.yaml | kubectl apply -f -

kubectl rollout restart deployment.apps/$SERVICE -n $NAMESPACE