#!/bin/bash

ADDITIONAL_ARGS="${@:2}"

if [ "$1" = "build" ]; then
	echo "Starting to build your project..."
	# unfortunately we have to specify the actual environment var here, because passing it in via CMD does not work with environment variables: https://docs.docker.com/engine/reference/builder/#environment-replacement
	if [ -z "$(ls -A $APP_BUILDDIR)" ]; then
		echo "Mount point /var/build is empty, did you invoke the container with \"docker run --rm -v /path/to/qmake/project:/var/build qt-build:tag build\"?"
		exit 0
	else
		cd $APP_BUILDDIR
		mkdir -p build
		cd build
		qmake $ADDITIONAL_ARGS ..
		make
	fi
else
	cd ~
	echo "If you wanted to use the container to build a qmake project, you have to invoke the container with command \"build\" and mount the project to /var/build"
	echo "Invoking container with command(s) ${@}..."
	"${@}"
fi