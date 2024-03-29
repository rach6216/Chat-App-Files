#!/bin/bash

# Check if the script was passed any arguments
if [ $# -eq 0 ]; then
    # No arguments were passed, so prompt the user for them
    # Get the version and commit hash from the user
    echo "Enter the version number: "
    read version
    echo "Enter the commit hash: "
    read commit_hash
else
  # Arguments were passed, so use them
  version=$1
  commit_hash=$2
fi

if [ $(git rev-list --quiet $commit_hash)  ]; then
    echo "No such commit hash"
    exit 1
fi

version="v$version"
dock_name='Dockerfile'
if [ $# -eq 3 ]; then
    dock_name=$3
fi
appname="chat-app"
if docker image inspect "$appname:$version" &> /dev/null; then
    read -p "Image $appname:$version already exists. Do you want to rebuild it? (y/n): " rebuild
    if [[ "$rebuild" == "y" ]]; then
    # Delete the existing image
        docker rmi "$appname:$version"
        # Build the Docker image
        docker build -t ${appname}:${version} . -f ${dock_name}
    else
        echo "Using existing image $appname:$version."
    fi
else 
    docker build -t ${appname}:${version} . -f ${dock_name}
fi

read -p "Do you want to push the tag to GitHub? (y/n): " push_tag
if [[ "$push_tag" == "y" ]]; then
    # Tag the image with the commit hash
    git tag ${version} ${commit_hash}
    git push origin ${version}
    # Check if the image was pushed successfully
    if [ $? -ne 0 ]; then
        echo "Error pushing image to GitHub"
        exit 1
    else
        # Success!
        echo "Image pushed to GitHub successfully"
    fi
else
    echo "Tag not pushed to GitHub."
fi

read -p "Do you want to push the tag to GCR? (y/n): " push_gcr
if [[ "$push_gcr" == "y" ]]; then
    gcloud config set auth/impersonate_service_account artifact-admin-sa@grunitech-mid-project.iam.gserviceaccount.com
    gcloud auth configure-docker me-west1-docker.pkg.dev
    docker tag $appname:$version \
    me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/$appname:$version
    docker push me-west1-docker.pkg.dev/grunitech-mid-project/rachelfabian-chat-app-images/chat-app:${version} 
    cloud config unset auth/impersonate_service_account
else
    echo "Image not pushed to Artifact Registry."
fi


