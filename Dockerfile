# Note, TARGET_ARCH must be defined as a build-time arg, it is deliberately different
# from TARGETARCH which is defined by docker. The reason is because TARGETARCH=amd64
# but we need TARGET_ARCH=x86_64
ARG TARGET_ARCH
FROM quay.io/pypa/manylinux_2_28_${TARGET_ARCH}:2024-07-15-c746fd8

ARG BOOST_VERSION=1.85.0
ARG HDF5_VERSION=1.14.2
ARG NINJA_VERSION=1.12.1
# Has to be repeated here so it's imported from the "top level" above the FROM
ARG TARGET_ARCH

ENV HDF5_VERSION=${HDF5_VERSION} \
    HDF5_DIR=/usr/local \
    BOOST_DIR=/usr/local \
    BOOST_VERSION=${BOOST_VERSION}

RUN --mount=type=cache,target=/cache \
    if [[ "$TARGET_ARCH" == "aarch64" ]]; then NINJA_ARCH="-aarch64"; else NINJA_ARCH=""; fi \
    && echo "Getting Ninja for '${NINJA_ARCH}'" \
    && curl -fsSL -o /cache/ninja-linux.zip https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux${NINJA_ARCH}.zip \
    && unzip /cache/ninja-linux.zip -d /usr/local/bin \
    && ninja --version
COPY install_libaec.sh libaec_cmakelists.patch install_hdf5.sh install_boost.sh /tmp/
RUN --mount=type=cache,target=/cache \
    bash /tmp/install_libaec.sh
RUN --mount=type=cache,target=/cache \
    bash /tmp/install_hdf5.sh
RUN --mount=type=cache,target=/cache \
    bash /tmp/install_boost.sh
