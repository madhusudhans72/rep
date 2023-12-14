#!/bin/bash

# Build Docker image
docker build -t ansible-nginx .

# Run Docker container
docker run -it ansible-nginx

