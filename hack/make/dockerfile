#!/bin/bash

VERSION=$(cat "$BUILD/Dockerfile" | grep '^ENV VERSION' | cut -d" " -f3)
DOWNLOAD_URL="https://artifacts.elastic.co/downloads/elasticsearch"
EXPECTED_SHA_URL=$(cat "$BUILD/Dockerfile" | grep '^ENV EXPECTED_SHA_URL' | cut -d" " -f3)

echo "===> Getting $BUILD tarball sha1 for version: $VERSION"
SHA_URL=$(eval echo $EXPECTED_SHA_URL)
TARBALL_SHA=$(curl -s "$SHA_URL" | cut -d" " -f1)

echo " * TARBALL_SHA=$TARBALL_SHA"
sed -i.bu 's/TARBALL_SHA "[0-9a-f.]\{128\}"/TARBALL_SHA "'$TARBALL_SHA'"/' $BUILD/Dockerfile
echo
