#!/bin/bash


VERSION=$1


echo "Rollback started"


docker stop hrms-app || true


docker rm hrms-app || true


VERSION=$VERSION docker compose up -d


echo "Rollback completed"
