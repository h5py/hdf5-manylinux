# libaec implements szip compression, so the optional szip filter can be built
# in HDF5.
set -euo pipefail

pushd /tmp

aec_version="1.1.7"

echo "Downloading libaec"
curl -fsSLO https://github.com/Deutsches-Klimarechenzentrum/libaec/releases/download/v${aec_version}/libaec-${aec_version}.tar.gz
tar zxf libaec-$aec_version.tar.gz

echo "Building & installing libaec"
pushd libaec-$aec_version
mkdir build
cmake -S . -B build \
    -D CMAKE_BUILD_TYPE=Release \
    -D BUILD_STATIC_LIBS=OFF \
    -D BUILD_TESTING=OFF
make -C build -j "$(nproc)"
make -C build install

# Clean up the files from the build
popd
rm -r libaec-$aec_version libaec-$aec_version.tar.gz
