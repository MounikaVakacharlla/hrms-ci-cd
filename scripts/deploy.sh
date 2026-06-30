#!/bin/bash


VERSION=$1


echo "Deploying version $VERSION"


export VERSION=$VERSION


docker compose down


docker compose up -d


echo "Deployment completed"
