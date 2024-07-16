set -euo pipefail

pushd /tmp

BOOST_DOWNLOAD_FILE="/cache/boost-cmake.tar.xz"
curl -fsSL -o $BOOST_DOWNLOAD_FILE https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.xz
tar -xf $BOOST_DOWNLOAD_FILE -C /tmp
mkdir -p boost-${BOOST_VERSION}/build
pushd boost-${BOOST_VERSION}/build

cmake -G "Ninja" \
    -DCMAKE_BUILD_TYPE=release \
    -DBOOST_INCLUDE_LIBRARIES="algorithm;dll;stacktrace;core;math;numeric/ublas;serialization;multi_array" \
    ..
ninja install

popd

rm -rf boost-${BOOST_VERSION}
