# qt-build

[![Build Status](https://travis-ci.com/darkmattercoder/qt-build.svg?branch=deploy)](https://travis-ci.com/darkmattercoder/qt-build)
[![Image information](https://images.microbadger.com/badges/image/darkmattercoder/qt-build.svg)](https://microbadger.com/images/darkmattercoder/qt-build "Get your own image badge on microbadger.com")
[![Image version information](https://images.microbadger.com/badges/version/darkmattercoder/qt-build.svg)](https://microbadger.com/images/darkmattercoder/qt-build)
![Dockerhub pulls](https://img.shields.io/docker/pulls/darkmattercoder/qt-build.svg)
![Dockerhub stars](https://img.shields.io/docker/stars/darkmattercoder/qt-build.svg)

A (nearly) full qt build environment using docker. Using multi-stage build to decouple build from actual image.
Can build a `qmake` project with one single command.

Find the images on [Dockerhub](https://hub.docker.com/r/darkmattercoder/qt-build).
Find the sources on [Github](https://github.com/darkmattercoder/qt-build)

## Usage (short)

Download `qt-build` from dockerhub:

	docker pull darkmattercoder/qt-build:latest

Provide your qmake project that you want to build in a separate directory and build it with `qt-build`:

	docker run --rm -u $UID -v /path/to/your/project/directory:/var/build darkmattercoder/qt-build:latest build

You will find your built project in a new sub directory named `build` in your project directory. You can safely omit the `-u $UID` part in most environments, where your user has the standard `UID=1000`.

## Usage (detailed)

The `latest`-tag will give you the latest released `qt` version for your build environment. For different versions available, refer to the [available tags](#available-tags)-section.

Generally you will find full version tags like `5.11.3` as well as minor version tags that refer to the last patch release for the given minor release like `5.11` or `5.12`. There will be some tags listed that are named like `builder-x.y.z`, where `x,y,z` represent qt version numbers. Those images are used for ci builds of the images and contain the whole qt source overhead. They are used as caches in the ci environment. You normally do not want to use them for any production stuff, because they are fairly large.

The `build` command for docker run will build any qmake project that is mounted to `/var/build`. However, you can get an interactive session as well for manual adjustments or examinations:

	docker run --rm -it -u $UID -v /path/to/your/project/directory:/var/build darkmattercoder/qt-build:latest bash

If you pass additional arguments to `build` they will be taken into account as arguments to `qmake` which allows you to modify your build if needed.

## Building it yourself

	git clone https://github.com/darkmattercoder/qt-build.git
	cd qt-build
	docker build --build-arg QT_VERSION_MAJOR=X --build-arg QT_VERSION_MINOR=Y --build-arg QT_VERSION_PATCH=Z --build-arg CORE_COUNT=N --target=qt -t qt-build:X.Y.Z

Replace `X,Y,Z` according to your desired qt version. You have to provide a build configuration as a very simple `configure`-script in the `buildconfig` directory to make the build succeed. The script has to be named after your desired `QT` version, e.g. `configure-5.11.3.sh`. Example content:

	#!/bin/sh
	../configure -prefix $QT_PREFIX -opensource -confirm-license -nomake examples -nomake tests

### Build arguments

The build arguments can entirely be omitted, resulting in a build with some default values from the `Dockerfile`. However, I do not promise that those default values for the `Qt`-Version that are hardcoded in the `Dockerfile` will get updated on a regular basis, because I inject the desired versions all in my ci build matrix. Available build arguments are:

* `QT_VERSION_MAJOR`
* `QT_VERSION_MINOR`
* `QT_VERSION_PATCH`
* `QT_DOWNLOAD_BRANCH` -- gives you the possibility to address different versions for download. Should e.g. read `official_releases` or `archive`.
* `QT_TARBALL_NAMING_SCHEME` -- gives you the possibility to alter the naming scheme. `Qt` changed that between `5.9`and `5.10` ftom `qt-everywhere-opensource-src` to `qt-everywhere-src`. The `qt-` and `-src` parts are hardcoded, `QT_TARBALL_NAMING_SCHEME` is inserted between
* `CI_BUILD` -- will suppress regular `make` output. If set to `2` it will stay silent, if set to `1` (or anything else) only warnings will show up. When the compiling fails, `make` is run again  regularly to give you the whole output, skipping everything that has been built before, to give you the possibility to see the actual behaviour. When left undefined, all output is visible and the second run of make is *not* performed
* `CORE_COUNT` -- determines the number of parallel make jobs. Adjust it to fit your machine

### Convenience local build script

In case you want to do a quick, customised build like I do it in the automated build process. Have a look at the self-explanatory script `build-dockerfile-local.sh`.

## Available tags

All currently supported versions of `Qt` should be available as tags. I added also versions that have been supported at the time adding them first, but are now archived. I'd like to add other archived versions, too, but I did not yet put any effort into thet. This is no hard work though, so might be a nice ![first contribution](https://img.shields.io/badge/-first_contribution-006b75.svg)

| Tags                                                                                                                            | Size                                          |
| ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| [![imgVerInfo][ver_img_latest]][lnk_latest] [![imgVerInfo][ver_img_5.13]][lnk_5.13] [![imgVerInfo][ver_img_5.13.0]][lnk_5.13.0] | [![imgSizeInfo][size_img_5.13.0]][lnk_5.13.0] |
| [![imgVerInfo][ver_img_5.12]][lnk_5.12] [![imgVerInfo][ver_img_5.12.4]][lnk_5.12.4]                                             | [![imgSizeInfo][size_img_5.12.4]][lnk_5.12.4] |
| [![imgVerInfo][ver_img_5.12.3]][lnk_5.12.3]                                                                                     | [![imgSizeInfo][size_img_5.12.3]][lnk_5.12.3] |
| [![imgVerInfo][ver_img_5.12.2]][lnk_5.12.2]                                                                                     | [![imgSizeInfo][size_img_5.12.2]][lnk_5.12.2] |
| [![imgVerInfo][ver_img_5.12.1]][lnk_5.12.1]                                                                                     | [![imgSizeInfo][size_img_5.12.1]][lnk_5.12.1] |
| [![imgVerInfo][ver_img_5.12.0]][lnk_5.12.0]                                                                                     | [![imgSizeInfo][size_img_5.12.0]][lnk_5.12.0] |
| [![imgVerInfo][ver_img_5.11]][lnk_5.11] [![imgVerInfo][ver_img_5.11.3]][lnk_5.11.3]                                             | [![imgSizeInfo][size_img_5.11.3]][lnk_5.11.3] |
| [![imgVerInfo][ver_img_5.11.2]][lnk_5.11.2]                                                                                     | [![imgSizeInfo][size_img_5.11.2]][lnk_5.11.2] |
| [![imgVerInfo][ver_img_5.11.1]][lnk_5.11.1]                                                                                     | [![imgSizeInfo][size_img_5.11.1]][lnk_5.11.1] |
| [![imgVerInfo][ver_img_5.11.0]][lnk_5.11.0]                                                                                     | [![imgSizeInfo][size_img_5.11.0]][lnk_5.11.0] |
| [![imgVerInfo][ver_img_5.10]][lnk_5.10] [![imgVerInfo][ver_img_5.10.1]][lnk_5.10.1]                                             | [![imgSizeInfo][size_img_5.10.1]][lnk_5.10.1] |
| [![imgVerInfo][ver_img_5.10.0]][lnk_5.10.0]                                                                                     | [![imgSizeInfo][size_img_5.10.0]][lnk_5.10.0] |
| [![imgVerInfo][ver_img_5.9]][lnk_5.9] [![imgVerInfo][ver_img_5.9.8]][lnk_5.9.8]                                                 | [![imgSizeInfo][size_img_5.9.8]][lnk_5.9.8]   |
| [![imgVerInfo][ver_img_5.9.7]][lnk_5.9.7]                                                                                       | [![imgSizeInfo][size_img_5.9.7]][lnk_5.9.7]   |
| [![imgVerInfo][ver_img_5.9.6]][lnk_5.9.6]                                                                                       | [![imgSizeInfo][size_img_5.9.6]][lnk_5.9.6]   |
| [![imgVerInfo][ver_img_5.9.5]][lnk_5.9.5]                                                                                       | [![imgSizeInfo][size_img_5.9.5]][lnk_5.9.5]   |
| [![imgVerInfo][ver_img_5.9.4]][lnk_5.9.4]                                                                                       | [![imgSizeInfo][size_img_5.9.4]][lnk_5.9.4]   |
| [![imgVerInfo][ver_img_5.9.3]][lnk_5.9.3]                                                                                       | [![imgSizeInfo][size_img_5.9.3]][lnk_5.9.3]   |
| [![imgVerInfo][ver_img_5.9.2]][lnk_5.9.2]                                                                                       | [![imgSizeInfo][size_img_5.9.2]][lnk_5.9.2]   |
| [![imgVerInfo][ver_img_5.9.1]][lnk_5.9.1]                                                                                       | [![imgSizeInfo][size_img_5.9.1]][lnk_5.9.1]   |
| [![imgVerInfo][ver_img_5.9.0]][lnk_5.9.0]                                                                                       | [![imgSizeInfo][size_img_5.9.0]][lnk_5.9.0]   |
| [![imgVerInfo][ver_img_5.6]][lnk_5.6] [![imgVerInfo][ver_img_5.6.3]][lnk_5.6.3]                                                 | [![imgSizeInfo][size_img_5.6.3]][lnk_5.6.3]   |
| [![imgVerInfo][ver_img_5.6.2]][lnk_5.6.2]                                                                                       | [![imgSizeInfo][size_img_5.6.2]][lnk_5.6.2]   |
| [![imgVerInfo][ver_img_5.6.1-1]][lnk_5.6.1-1] [![imgVerInfo][ver_img_5.6.1]][lnk_5.6.1]                                         | [![imgSizeInfo][size_img_5.6.1]][lnk_5.6.1]   |
| [![imgVerInfo][ver_img_5.6.0]][lnk_5.6.0]                                                                                       | [![imgSizeInfo][size_img_5.6.0]][lnk_5.6.0]   |

[ver_img_latest]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:latest.svg
[size_img_latest]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:latest.svg
[lnk_latest]: https://microbadger.com/images/darkmattercoder/qt-build:latest

[ver_img_5.13]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.13.svg
[size_img_5.13]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.13.svg
[lnk_5.13]: https://microbadger.com/images/darkmattercoder/qt-build:5.13

[ver_img_5.13.0]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.13.0.svg
[size_img_5.13.0]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.13.0.svg
[lnk_5.13.0]: https://microbadger.com/images/darkmattercoder/qt-build:5.13.0

[ver_img_5.12]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.12.svg
[size_img_5.12]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.12.svg
[lnk_5.12]: https://microbadger.com/images/darkmattercoder/qt-build:5.12

[ver_img_5.12.4]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.12.4.svg
[size_img_5.12.4]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.12.4.svg
[lnk_5.12.4]: https://microbadger.com/images/darkmattercoder/qt-build:5.12.4

[ver_img_5.12.3]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.12.3.svg
[size_img_5.12.3]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.12.3.svg
[lnk_5.12.3]: https://microbadger.com/images/darkmattercoder/qt-build:5.12.3

[ver_img_5.12.2]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.12.2.svg
[size_img_5.12.2]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.12.2.svg
[lnk_5.12.2]: https://microbadger.com/images/darkmattercoder/qt-build:5.12.2

[ver_img_5.12.1]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.12.1.svg
[size_img_5.12.1]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.12.1.svg
[lnk_5.12.1]: https://microbadger.com/images/darkmattercoder/qt-build:5.12.1

[ver_img_5.12.0]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.12.0.svg
[size_img_5.12.0]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.12.0.svg
[lnk_5.12.0]: https://microbadger.com/images/darkmattercoder/qt-build:5.12.0

[ver_img_5.11]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.11.svg
[size_img_5.11]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.11.svg
[lnk_5.11]: https://microbadger.com/images/darkmattercoder/qt-build:5.11

[ver_img_5.11.3]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.11.3.svg
[size_img_5.11.3]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.11.3.svg
[lnk_5.11.3]: https://microbadger.com/images/darkmattercoder/qt-build:5.11.3

[ver_img_5.11.2]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.11.2.svg
[size_img_5.11.2]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.11.2.svg
[lnk_5.11.2]: https://microbadger.com/images/darkmattercoder/qt-build:5.11.2

[ver_img_5.11.1]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.11.1.svg
[size_img_5.11.1]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.11.1.svg
[lnk_5.11.1]: https://microbadger.com/images/darkmattercoder/qt-build:5.11.1

[ver_img_5.11.0]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.11.0.svg
[size_img_5.11.0]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.11.0.svg
[lnk_5.11.0]: https://microbadger.com/images/darkmattercoder/qt-build:5.11.0

[ver_img_5.10]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.10.svg
[size_img_5.10]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.10.svg
[lnk_5.10]: https://microbadger.com/images/darkmattercoder/qt-build:5.10

[ver_img_5.10.1]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.10.1.svg
[size_img_5.10.1]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.10.1.svg
[lnk_5.10.1]: https://microbadger.com/images/darkmattercoder/qt-build:5.10.1

[ver_img_5.10.0]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.10.0.svg
[size_img_5.10.0]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.10.0.svg
[lnk_5.10.0]: https://microbadger.com/images/darkmattercoder/qt-build:5.10.0

[ver_img_5.9]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.svg
[size_img_5.9]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.svg
[lnk_5.9]: https://microbadger.com/images/darkmattercoder/qt-build:5.9

[ver_img_5.9.8]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.8.svg
[size_img_5.9.8]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.8.svg
[lnk_5.9.8]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.8

[ver_img_5.9.7]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.7.svg
[size_img_5.9.7]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.7.svg
[lnk_5.9.7]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.7

[ver_img_5.9.6]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.6.svg
[size_img_5.9.6]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.6.svg
[lnk_5.9.6]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.6

[ver_img_5.9.5]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.5.svg
[size_img_5.9.5]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.5.svg
[lnk_5.9.5]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.5

[ver_img_5.9.4]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.4.svg
[size_img_5.9.4]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.4.svg
[lnk_5.9.4]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.4

[ver_img_5.9.3]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.3.svg
[size_img_5.9.3]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.3.svg
[lnk_5.9.3]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.3

[ver_img_5.9.2]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.2.svg
[size_img_5.9.2]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.2.svg
[lnk_5.9.2]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.2

[ver_img_5.9.1]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.1.svg
[size_img_5.9.1]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.1.svg
[lnk_5.9.1]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.1

[ver_img_5.9.0]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.9.0.svg
[size_img_5.9.0]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.9.0.svg
[lnk_5.9.0]: https://microbadger.com/images/darkmattercoder/qt-build:5.9.0

[ver_img_5.6]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.6.svg
[size_img_5.6]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.6.svg
[lnk_5.6]: https://microbadger.com/images/darkmattercoder/qt-build:5.6

[ver_img_5.6.3]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.6.3.svg
[size_img_5.6.3]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.6.3.svg
[lnk_5.6.3]: https://microbadger.com/images/darkmattercoder/qt-build:5.6.3

[ver_img_5.6.2]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.6.2.svg
[size_img_5.6.2]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.6.2.svg
[lnk_5.6.2]: https://microbadger.com/images/darkmattercoder/qt-build:5.6.2

[ver_img_5.6.1-1]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.6.1-1.svg
[size_img_5.6.1-1]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.6.1-1.svg
[lnk_5.6.1-1]: https://microbadger.com/images/darkmattercoder/qt-build:5.6.1-1

[ver_img_5.6.1]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.6.1.svg
[size_img_5.6.1]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.6.1.svg
[lnk_5.6.1]: https://microbadger.com/images/darkmattercoder/qt-build:5.6.1

[ver_img_5.6.0]: https://images.microbadger.com/badges/version/darkmattercoder/qt-build:5.6.0.svg
[size_img_5.6.0]: https://images.microbadger.com/badges/image/darkmattercoder/qt-build:5.6.0.svg
[lnk_5.6.0]: https://microbadger.com/images/darkmattercoder/qt-build:5.6.0

## Contributions

I highly appreciate any contributions to this project. I will add contribution guidelines later on. As a short summary here is what you could do:

* Provide new or changed documentation
* File issues against the project
* Tinker nice badges to give a visual overview of the docker image structure or the build status for individual tags
* Open pull requests, for example
  + add new qt version build configurations
  + add more qt features
  + add tests

For opening pull requests, please keep the following in mind:

* Pull requests for the `master` branch will be rejected
* Pull requests must be made for the `deploy` branch only
* Pull requests that alter the build configuration or the dependencies in the base image to compile something that did not compile before have to provide a test that represents the changes. The test, when added without changes to build configs or docker file has to fail.
* Pull requests should be made with the fact in mind, that we want to provide a general multi purpose build environment that should not get bloated more than necessary.

## License

Any directly written content in this repo is licensed under the `GPL v3`. Software parts that are produced during the image build and resulting docker images are of course a composition of components that probably carry their own licenses.
