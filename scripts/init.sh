#!/bin/bash
version='latest'
if [ $# -ne 0 ]; then
  # Arguments were passed, so use them
    version=$1
fi

#  docker volume create chat-app-data
# docker build -t  chat-app:${version} . 
# docker run -v chat-app-data:/chatApp/data -p 8080:8080 --name chat-app-run chat-app:${version}
# gcloud compute ssh rach0556776216@rachelfabian-first-instance --project grunitech-mid-project --zone me-west1-a --command "docker volume create chat-app-data; docker pull me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/chat-app:v9.9.9; docker run -v chat-app-data:/chatApp/data -p 8080:80 --name chat-app-run me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/chat-app:${version};"
gcloud compute ssh rach0556776216@rachelfabian-first-instance --project grunitech-mid-project --zone me-west1-a --command "docker volume create chat-app-data; docker pull me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/chat-app:v9.9.9; docker run -v chat-app-data:/chatApp/data -p 8080:80 --name chat-app-run me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/chat-app:${version};"