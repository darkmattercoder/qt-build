FROM ubuntu:bionic as base

LABEL maintainer="devel@jochenbauer.net"
LABEL stage=qt-build-base

# UID/GID injection on build if wanted
ARG USER_UID=
ARG USER_GID=

# Name of the regular user. Does not look useful but can save a bit time when changing
ENV QT_USERNAME=qt

# QT Version
ARG QT_VERSION_MAJOR=5
ARG QT_VERSION_MINOR=11
ARG QT_VERSION_PATCH=3
ENV QT_VERSION_MAJOR=${QT_VERSION_MAJOR}
ENV QT_VERSION_MINOR=${QT_VERSION_MINOR}
ENV QT_VERSION_PATCH=${QT_VERSION_PATCH}
ENV QT_BUILD_ROOT=/tmp/qt_build
ENV QT_BUILD_DIR=${QT_BUILD_ROOT}/qt-everywhere-src-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}/build
ENV QT_PREFIX=/usr/local

# Install all build dependencies
RUN apt-get update && apt-get dist-upgrade && apt-get -y --no-install-recommends install \
	ca-certificates \
	curl \
	python \
	gperf \
	bison \
	flex \
	build-essential \
	pkg-config \
	libgl1-mesa-dev \
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

# Installing from here
WORKDIR ${QT_BUILD_ROOT}

# Download sources
RUN curl -sSL https://download.qt.io/official_releases/qt/${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}/${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}/single/qt-everywhere-src-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}.tar.xz | tar xJ

WORKDIR ${QT_BUILD_DIR}

# Configure, make, install
ADD buildconfig/configure-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}.sh configure.sh
RUN chmod +x ./configure.sh && ./configure.sh

# Possibility to make outputs less verbose when required for a ci build
ARG CI_BUILD=
ENV CI_BUILD=${CI_BUILD}

# Speeding up make depending of your system
ARG CORE_COUNT=1

RUN if [ $CI_BUILD ]; then \
	echo "Suppressing make output for CI environments to decrease log size"; \
	make -j${CORE_COUNT} > /dev/null || make; \
	else make -j${CORE_COUNT}; \
	fi

# install it
RUN make install

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# resulting image with environment
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FROM base as qt

ENV ENTRYPOINT_DIR=/usr/local/bin
ENV APP_BUILDDIR=/var/build

COPY --from=builder ${QT_PREFIX} ${QT_PREFIX}
COPY entrypoint.sh ${ENTRYPOINT_DIR}

RUN chmod +x ${ENTRYPOINT_DIR}/entrypoint.sh

VOLUME ["${APP_BUILDDIR}"]

USER ${QT_USERNAME}

ENTRYPOINT ["entrypoint.sh"]