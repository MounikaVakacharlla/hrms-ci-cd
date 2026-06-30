#!/bin/bash


echo "Rollback started"


docker stop hrms-app || true


docker rm hrms-app || true


docker compose up -d


echo "Rollback completed"
