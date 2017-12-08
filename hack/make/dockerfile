#!/bin/bash

VERSION=$(cat "$BUILD/Dockerfile" | grep '^ENV VERSION' | cut -d" " -f3)
# tarball info
DOWNLOAD_URL=https://artifacts.elastic.co/downloads/$NAME
SHA_URL=$DOWNLOAD_URL/$NAME-$VERSION.tar.gz.sha512

echo "===> Getting $BUILD tarball sha1 for version: $VERSION"
TARBALL_SHA=$(curl -s "$SHA_URL" | cut -d" " -f1)

echo " * TARBALL_SHA=$TARBALL_SHA"
sed -i.bu 's/TARBALL_SHA "[0-9a-f.]\{128\}"/TARBALL_SHA "'$TARBALL_SHA'"/' $BUILD/Dockerfile
echo
