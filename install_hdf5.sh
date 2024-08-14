set -euo pipefail

echo "Installing zlib with yum"
yum -y install zlib-devel

pushd /tmp

# This seems to be needed to find libsz.so.2
ldconfig

echo "Downloading & unpacking HDF5 ${HDF5_VERSION}"
HDF5_TAG="hdf5_${HDF5_VERSION}"
curl -fsSLO "https://github.com/HDFGroup/hdf5/archive/refs/tags/${HDF5_TAG}.tar.gz"
tar -xzvf $HDF5_TAG.tar.gz
pushd hdf5-$HDF5_TAG
chmod u+x autogen.sh

echo "Configuring, building & installing HDF5 ${HDF5_VERSION} to ${HDF5_DIR}"
./configure --prefix $HDF5_DIR --enable-build-mode=production --with-szlib
make -j $(nproc)
make install
popd

# Clean up to limit the size of the Docker image
echo "Cleaning up unnecessary files"
rm -r hdf5-$HDF5_TAG
rm $HDF5_TAG.tar.gz

yum -y erase zlib-devel
