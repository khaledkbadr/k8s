# container images is a binary package that encapsulates all of the files necessary to run a program iniside of an OS container

# Docker images use an overlay filesystem. They are made up of a series of filesystem layers. Each layer adds, removes, modifies files from the preceding layer in the filesystem

# Below is an example of packaging a node application. 
# Also we ignore "node_modules" files by adding a `.dockerignore`

# this image can be run by `docker build -t <image name> .`

FROM node:10
# Specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app 
# Copy package files and install dependencies
# this is done as a separate step for size optimization. for more details check below notes
COPY package*.json ./
RUN npm install

# copy all of the app files into the image
COPY . .
# The default command to run when starting the container
CMD ["npm", "start"]

################################################################################
# Optimizing Image Sizes
################################################################################
# Removing Files doesn't remove them physically from images but just makes it inaccessible. Therefore when removing a file from a parent layer doesn't make the image any smaller.

# Also if a base layer changes too much it will make all children layers rebuilt
# layer A: OS
#    -> layer B: has server.js
#    -> layer C: installs node package
# in the above example whenever we change server.js it triggers `layer C` compilation with it.
# And hence, you should order layers from least likely to change to most likely to change in order to optimize the image size for pushing and pulling. That's why in the above example we copied the `package*.json` and install the deps first then copy the rest of the program. To avoid compiling the whole thing with every change in the source code

# Multistage Image Builds
# To avoid large container image the actual program compilation should not be a part of the construction of the application container image

# STAGE 1: Build
FROM golang:1.11-alpine AS build

# Install Node and NPM
RUN apk update && apk upgrade && apk add --no-cache git nodejs bash npm

# Get dependencies for Go part of build
RUN go get -u github.com/jteeuwen/go-bindata/...
RUN go get github.com/tools/godep

WORKDIR /go/src/github.com/kubernetes-up-and-running/kuard

# Copy all sources in
COPY . .

# This is a set of variables that the build script expects
ENV VERBOSE=0
ENV PKG=github.com/kubernetes-up-and-running/kuard
ENV ARCH=amd64
ENV VERSION=test

# Do the build. Script is part of incoming sources.
RUN build/build.sh

# STAGE 2: Deployment
FROM alpine

USER nobody:nobody
COPY --from=build /go/bin/kuard /kuard

CMD [ "/kuard" ]

# When Running containers we have the ability to limit resources consume by them.
# docker run -d --name kuard \
# --publish 8080:8080 \
# --memory 200m \
# --memory-swap 1G \
# --cpu-shares 1024 \
#  gcr.io/kuar-demo/kuard-amd64:blue

