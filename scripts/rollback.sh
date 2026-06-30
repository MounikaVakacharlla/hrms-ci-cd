#!/bin/bash


echo "Rollback started"


docker stop hrms-app || true


docker rm hrms-app || true


export VERSION=$1


docker compose up -d


echo "Rollback completed"
