# libaec implements szip compression, so the optional szip filter can be built
# in HDF5.
set -euo pipefail

pushd /tmp

aec_version="1.0.6"

echo "Downloading libaec"
LIBAEC_DOWNLOAD_FILE="/cache/libaec-${aec_version}.tar.gz"
# The URL includes a hash, so it needs to change if the version does
curl -fsSL -o $LIBAEC_DOWNLOAD_FILE https://gitlab.dkrz.de/k202009/libaec/uploads/45b10e42123edd26ab7b3ad92bcf7be2/libaec-${aec_version}.tar.gz
tar -zxf $LIBAEC_DOWNLOAD_FILE -C /tmp

echo "Building & installing libaec"
mkdir -p libaec-${aec_version}/build
pushd libaec-$aec_version
patch -p0 < /tmp/libaec_cmakelists.patch
pushd build
cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib -DBUILD_TESTING=OFF ..
ninja install

popd

# Clean up the files from the build
popd
rm -r libaec-$aec_version
