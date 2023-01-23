#!/bin/bash

# DEFINING ALL NECESSARY VARIABLES
# FOR UNITY AUTHENTICATION
SERIAL_NUMBER=''
USERNAME=''
PASSWORD=''

# PROJECT PATH VARIABLE
PROJECT_PATH='/home/CoursePaperTestProject/'
BUILD_LOG_PATH="$PROJECT_PATH/BuildLogs"

integration_function () {
    # GITHUB ACTIONS BEFORE BUILD: GET NEWEST CHANGES IN MAIN AND DELETE OLD BUILD
    cd $PROJECT_PATH
    git checkout "builds/$1Artifacts"
    git pull
    git rm -rf "Build$1/"
    git commit -m "Deleting old build artifacts"
    git push

    # CONSTRUCTING LOG PATH, LOG NAME AND BUILD PATH
    CURRENT_DATE="$(date +"%Y-%m-%d")"
    LOG_FILE_PATH="$BUILD_LOG_PATH/$CURRENT_DATE-$(date +%H%M%S).log"
    BUILD_PATH="$PROJECT_PATH/Build$1/"

    # GOING BACK TO MAIN TO CONTINUE WITH THE BUILDING PROCESS AFTER GETTING LATEST UPDATES
    git checkout main -f
    git pull

    # START THE BUILD PROCESS AND TIME THE BUILD LENGTH
    START="$(date -u +%s)"
    unity-editor -batchmode -nographics -serial "$SERIAL_NUMBER" -username "$USERNAME" -password "$PASSWORD" -quit \
    -projectPath $PROJECT_PATH $2 "$BUILD_PATH/$3" -logFile $LOG_FILE_PATH
    END="$(date -u +%s)"
    RUNTIME="$(($END-$START))"

    # GET CURRENT TIME FOR ADDITIONAL INFO IN COMMIT MESSAGE AND README
    CURRENT_DATE_TIME="$(date +"%Y-%m-%d %T")"

    # CHECKOUT TO BUILD BRANCH, CHECK BUILD, LOG BUILD STATE, ADD SUCCESSFULL BUILD FOLDER
    git checkout "builds/$1Artifacts" -f
    if grep -q "Result: Success." $LOG_FILE_PATH; then

        echo -e "\n* $1 Build SUCCESS - $CURRENT_DATE_TIME UTC - Runtime: $RUNTIME seconds" >> README.md
        COMMIT_MESSAGE="Successful $1 Build Artifacts - $CURRENT_DATE_TIME UTC"
        git add $BUILD_PATH
    else
        echo -e "\n* $1 Build FAIL - $CURRENT_DATE_TIME UTC - Runtime: $RUNTIME seconds" >> README.md
        COMMIT_MESSAGE="Failed $1 Build Log - $CURRENT_DATE_TIME UTC"
    fi

    # ADD, COMMIT AND PUSH BUILD ARTIFACTS
    git add README.md $LOG_FILE_PATH
    git commit -m "$COMMIT_MESSAGE"
    git push
}

# GET OPTIONS, CALL INTEGRATION FUNCTION AND PASS APPROPRIATE ARGUMENTS CASE BY CASE
while getopts 'lmwai' OPTION; do
    case "$OPTION" in
        l)  integration_function "Linux" "-buildLinux64Player" "Test.x86" ;;
        m)  integration_function "macOS" "-buildOSXUniversalPlayer" "Test.app" ;;
        w)  integration_function "Windows" "-buildWindows64Player" "Test.exe" ;;
    esac
done