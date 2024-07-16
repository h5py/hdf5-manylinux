# Note, TARGET_ARCH must be defined as a build-time arg, it is deliberately different
# from TARGETARCH which is defined by docker. The reason is because TARGETARCH=amd64
# but we need TARGET_ARCH=x86_64
ARG TARGET_ARCH
FROM quay.io/pypa/manylinux2014_${TARGET_ARCH}:2024-07-15-c746fd8

ARG BOOST_VERSION=1.85.0
ARG HDF5_VERSION=1.14.2

ENV HDF5_VERSION=${HDF5_VERSION} \
    HDF5_DIR=/usr/local \
    BOOST_DIR=/usr/local \
    BOOST_VERSION=${BOOST_VERSION}

COPY install_libaec.sh install_hdf5.sh install_boost.sh /tmp/
RUN bash /tmp/install_libaec.sh
RUN bash /tmp/install_hdf5.sh
RUN bash /tmp/install_boost.sh
