#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory of the current script
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
BASE_DIR=$(realpath "$SCRIPT_DIR/..")

# Define directories
SRC_DIR="$BASE_DIR/app/src"
APP_DIR="$BASE_DIR/app"
BUILD_DIR="$BASE_DIR/app/build"
PROJECT_DIR_NAME=$(basename "$BASE_DIR")
DIST="${APP_DIR}/tmp/${PROJECT_DIR_NAME}"

echo $BASE_DIR

prepare() {
    if [ -d "$DIST" ]; then
    rm -rf "$DIST"
    fi

    echo "Creating build directory..."

    mkdir -p "$DIST"

    cd "$DIST"
    cp -r "$BUILD_DIR" .

    echo "Copying project manifest..."

    cp $APP_DIR/package.json $APP_DIR/package-lock.json .

    echo "Installing dependencies..."

    npm install --production --ignore-scripts
}

bundle() {
    echo "Creating zip file..."

    if [ ! -d $DIST ]; then
        echo "Build directory does not exist. Run prepare first."
        exit 0
    fi

    local zip_file="$APP_DIR/$PROJECT_DIR_NAME.zip"
    cd $DIST
    echo "Zipping project into $zip_file..."

    zip -r $zip_file .

    echo "Zip file created successfully."

    cd $BASE_DIR 

    echo "Cleaning up temporary files..."

    rm -rf "${APP_DIR}/tmp"
}

run () {
    prepare
    bundle
}

if [ $# -gt 0 ] && declare -f "$1" > /dev/null; then
    # Call the function passed as the first argument
    "$@"
else
    echo "Usage: $0 {prepare|bundle|run}"
    exit 1
fi