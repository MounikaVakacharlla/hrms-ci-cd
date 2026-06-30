#!/bin/bash


URL=http://localhost:8000


if curl -f $URL

then

echo "Application Healthy"

exit 0


else

echo "Application Failed"

exit 1


fi
