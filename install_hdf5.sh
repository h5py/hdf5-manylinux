set -euo pipefail

if which yum; then
    echo "Installing zlib with yum"
    yum -y install zlib-devel
else
    echo "Installing zlib with apk"
    apk add zlib-dev
fi
echo "zlib installation complete"

pushd /tmp

if which yum; then
    # This seems to be needed to find libsz.so.2
    # using the presence of yum as a proxy to distinguish between
    # manylinux and musllinux, knowing that musllinux builds don't need this
    # step, and actually *crash* if it is run.
    ldconfig
fi

echo "Downloading & unpacking HDF5 ${HDF5_VERSION}"
# Releases after 2.1.0 are tagged with the plain version only (e.g. "2.2.0");
# older releases use the "hdf5_X.Y.Z" tag convention.
urls=(
    "https://github.com/HDFGroup/hdf5/archive/refs/tags/${HDF5_VERSION}.tar.gz"
    "https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_${HDF5_VERSION}.tar.gz"
)

# NB: HDF5_DIR is already taken (the install prefix, set by the Dockerfiles)
HDF5_SRC_DIR="hdf5-${HDF5_VERSION}"
HDF5_TARBALL="${HDF5_SRC_DIR}.tar.gz"

set +e
for url in "${urls[@]}"; do
    echo "downloading from $url"
    curl --location "$url" --output "${HDF5_TARBALL}" --fail --silent --show-error
    if [[ "$?" == 0 ]]; then
        echo "download succeeded"
        break
    else
        echo "download failed"
    fi
done
set -e

mkdir -p "${HDF5_SRC_DIR}"
tar -xzf "${HDF5_TARBALL}" --strip-components=1 --directory "${HDF5_SRC_DIR}"
pushd "${HDF5_SRC_DIR}"

echo "Configuring, building & installing HDF5 ${HDF5_VERSION} to ${HDF5_DIR}"
mkdir build
cmake -S . -B build \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX="$HDF5_DIR" \
    -D CMAKE_INSTALL_LIBDIR=lib \
    -D BUILD_TESTING=OFF \
    -D BUILD_STATIC_LIBS=OFF \
    -D HDF5_BUILD_EXAMPLES=OFF \
    -D HDF5_BUILD_TOOLS=OFF \
    -D HDF5_BUILD_UTILS=OFF \
    -D HDF5_ALLOW_EXTERNAL_SUPPORT:STRING=NO \
    -D HDF5_ENABLE_ZLIB_SUPPORT=ON \
    -D HDF5_ENABLE_SZIP_SUPPORT=ON

make -C build -j "$(nproc)"
make -C build install
popd

# Clean up to limit the size of the Docker image
echo "Cleaning up unnecessary files"
rm -r "${HDF5_SRC_DIR}"
rm "${HDF5_TARBALL}"

if which yum; then
    yum erase -y zlib-devel
else
    apk del zlib-dev
fi
