#!/bin/bash

set -e

echo "Creating temporary directory..."

rm -rf tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

echo "Copying application files..."

cp sample_app.py tempdir/
cp templates/index.html tempdir/templates/
cp static/style.css tempdir/static/

echo "Creating Dockerfile..."

cat << 'DOCKER' > tempdir/Dockerfile
FROM python:3.12-slim

WORKDIR /home/myapp

RUN pip install --no-cache-dir flask

COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

EXPOSE 8080

CMD ["python3", "/home/myapp/sample_app.py"]
DOCKER

echo "Building Docker image..."

docker build -t sampleapp tempdir

echo "Removing old container if it exists..."

docker rm -f samplerunning 2>/dev/null || true

echo "Starting Docker container..."

docker run -d \
-p 8080:8080 \
--name samplerunning \
sampleapp

echo "Docker containers:"

docker ps -a

echo "Build and deployment completed!"
