#!/bin/bash
docker stop chat-app-run
if [ $# -eq 0 ]; then
    docker rmi -f chat-app
else
    docker rmi -f chat-app:$1
fi
docker rm -f chat-app-run

gcloud compute ssh rach0556776216@rachelfabian-first-instance --project grunitech-mid-project --zone me-west1-a --command "docker stop chat-app-run;docker rm chat-app-run;docker rmi me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/chat-app;" 
#    # Deleting all images
#     docker rmi -f $(docker images -aq)
#     # Deleting all containers
#     docker rm -f $(docker rm -aq)