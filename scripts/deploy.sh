#!/bin/bash


VERSION=$1


echo "Deploying HRMS version $VERSION"


docker compose down


VERSION=$VERSION docker compose up -d


echo "Deployment completed"
