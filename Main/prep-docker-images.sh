#!/bin/bash

# MAIN FUNCTION RESPONSIBLE FOR CREATING DOCKER IMAGES
docker_setup () {

    # DELETION OF THE ALREADY CREATED DOCKER IMAGE
    docker image rm "unity_$1"

    # INITIAL SETUP - COPY NECESSARY FILES TO APPROPRIATE DOCKERFILE FOLDER
    if [ ! -f "../Dockerfiles/Docker_$2/build.sh" ]; then
        cp build.sh "../Dockerfiles/Docker_$2"
        cp id_ed25519 "../Dockerfiles/Docker_$2"
    fi

    # BUILDING THE DOCKER IMAGE
    cd "../Dockerfiles/Docker_$2/"
    docker build -t "unity_$1" .

    # CLEANUP AFTER BUILD
    cd ../../Main/
    rm -rf "../Dockerfiles/Docker_$2/build.sh"
    rm -rf "../Dockerfiles/Docker_$2/id_ed25519"
}

# DEFINING THE OS ARRAY AND SENDING ITS VALUES BY ITERATING IT
OS_ARRAY=("Linux" "macOs" "Windows")
for OS in ${OS_ARRAY[@]}; do
    TEMP_VAR=$OS
    LOWER_CASE_OS=${TEMP_VAR,,}
    docker_setup "$LOWER_CASE_OS" "$OS"
done
