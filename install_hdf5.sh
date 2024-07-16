set -euo pipefail

echo "Installing zlib with yum"
yum -y install zlib-devel

pushd /tmp

# This seems to be needed to find libsz.so.2
ldconfig

echo "Downloading & unpacking HDF5 ${HDF5_VERSION}"
HDF5_DOWNLOAD_FILE="/cache/hdf5-${HDF5_VERSION}.tar.gz"
#                                   Remove trailing .*, to get e.g. '1.12' ↓
curl -fsSL -o $HDF5_DOWNLOAD_FILE "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.gz"
tar -xzf $HDF5_DOWNLOAD_FILE -C /tmp
mkdir -p hdf5-${HDF5_VERSION}/build
pushd hdf5-$HDF5_VERSION/build

echo "Configuring, building & installing HDF5 ${HDF5_VERSION} to ${HDF5_DIR}"
cmake -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=${HDF5_DIR} \
    -DHDF5_BUILD_CPP_LIB=ON \
    -DHDF5_ENABLE_Z_LIB_SUPPORT=ON \
    -DHDF5_ENABLE_SZIP_SUPPORT=ON \
    -DHDF5_BUILD_EXAMPLES=OFF \
    -DBUILD_TESTING=OFF \
    ..
ninja install
popd

# Clean up to limit the size of the Docker image
echo "Cleaning up unnecessary files"
rm -r hdf5-$HDF5_VERSION

yum -y erase zlib-devel
