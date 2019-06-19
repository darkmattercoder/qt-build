FROM ubuntu:bionic as base

LABEL maintainer="devel@jochenbauer.net"
LABEL stage=qt-build-base

# UID/GID injection on build if wanted
ARG USER_UID=
ARG USER_GID=

# In case you have to build behind a proxy
ARG PROXY=
ENV http_proxy=$PROXY
ENV https_proxy=$PROXY

# Name of the regular user. Does not look useful but can save a bit time when changing
ENV QT_USERNAME=qt

# Needed in both builder and qt stages, so has to be defined here
ENV QT_PREFIX=/usr/local

# Install all build dependencies
RUN apt-get update && apt-get -y dist-upgrade && apt-get -y --no-install-recommends install \
	ca-certificates \
	curl \
	python \
	gperf \
	bison \
	flex \
	build-essential \
	pkg-config \
	libgl1-mesa-dev \
	libicu-dev \
	# bc suggested for openssl tests
	bc \
	libssl-dev \
	# git is needed to build openssl in older versions
	git \
	# xcb dependencies
	libfontconfig1-dev \
	libfreetype6-dev \
	libx11-dev \
	libxext-dev \
	libxfixes-dev \
	libxi-dev \
	libxrender-dev \
	libxcb1-dev \
	libx11-xcb-dev \
	libxcb-glx0-dev \
	# bash needed for argument substitution in entrypoint
	bash \
	&& apt-get -qq clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& printf "#!/bin/sh\nls -lah" > /usr/local/bin/ll && chmod +x /usr/local/bin/ll

# Adding regular user
RUN if [ ${USER_GID} ]; then \
	addgroup -g ${USER_GID} ${QT_USERNAME}; \
	else \
	addgroup ${QT_USERNAME}; \
	fi \
	&& if [ ${USER_UID} ]; then \
	useradd -u ${USER_UID} -g ${QT_USERNAME} ${QT_USERNAME}; \
	else \
	useradd -g ${QT_USERNAME} ${QT_USERNAME}; \
	fi

# build stage
FROM base as builder

LABEL stage=qt-build-builder

# QT Version
ARG QT_VERSION_MAJOR=5
ARG QT_VERSION_MINOR=11
ARG QT_VERSION_PATCH=3

ENV QT_BUILD_ROOT=/tmp/qt_build

# They switched the tarball naming scheme from 5.9 to 5.10. This ARG shall provide a possibility to reflect that
ARG QT_TARBALL_NAMING_SCHEME=everywhere
# Providing flag for archived or stable versions
ARG QT_DOWNLOAD_BRANCH=official_releases

ENV QT_BUILD_DIR=${QT_BUILD_ROOT}/qt-${QT_TARBALL_NAMING_SCHEME}-src-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}/build

# Installing from here
WORKDIR ${QT_BUILD_ROOT}

# Download sources
RUN curl -sSL https://download.qt.io/${QT_DOWNLOAD_BRANCH}/qt/${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}/${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}/single/qt-${QT_TARBALL_NAMING_SCHEME}-src-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}.tar.xz | tar xJ

WORKDIR ${QT_BUILD_DIR}

# Possibility to make outputs less verbose when required for a ci build
ARG CI_BUILD=
ENV CI_BUILD=${CI_BUILD}

# Speeding up make depending of your system
ARG CORE_COUNT=1
ENV CORE_COUNT=${CORE_COUNT}

# Configure, make, install
ADD buildconfig/configure-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}.sh configure.sh
# before running the configuration, adding a directory to copy additional contents to the final image
RUN mkdir /opt/extra-dependencies && chmod +x ./configure.sh && ./configure.sh ${CORE_COUNT} ${CI_BUILD}

COPY buildconfig/build.sh build.sh
RUN ./build.sh ${CI_BUILD} ${CORE_COUNT}

# install it
RUN make install

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# resulting image with environment
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FROM base as qt

ENV ENTRYPOINT_DIR=/usr/local/bin
ENV APP_BUILDDIR=/var/build

COPY --from=builder ${QT_PREFIX} ${QT_PREFIX}
COPY --from=builder /opt/extra-dependencies/ /
# the next copy statement failed often. My only guess is, that the extra dependencies are not existent and somehow that
# triggers a failure here.... A workaround for similar issues is to put an empty run statement in between: https://github.com/moby/moby/issues/37965
RUN true
COPY entrypoint.sh ${ENTRYPOINT_DIR}

RUN chmod +x ${ENTRYPOINT_DIR}/entrypoint.sh

VOLUME ["${APP_BUILDDIR}"]

USER ${QT_USERNAME}

ENTRYPOINT ["entrypoint.sh"]