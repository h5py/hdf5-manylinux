set -euo pipefail

pushd /tmp

BOOST_DOWNLOAD_FILE="/cache/boost-cmake.tar.xz"
curl -fsSL -o $BOOST_DOWNLOAD_FILE https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.xz
tar -xf $BOOST_DOWNLOAD_FILE -C /tmp
pushd boost-${BOOST_VERSION}

./bootstrap.sh --prefix=${BOOST_DIR}
# We have to explicitly include cmakedir here so that cmake files are installed
./b2 variant=release toolset=gcc --with-headers --cmakedir=${BOOST_DIR}/lib/cmake install

popd

rm -rf boost-${BOOST_VERSION}
