# libaec implements szip compression, so the optional szip filter can be built
# in HDF5.
set -euo pipefail

pushd /tmp

aec_version="1.1.3"

echo "Downloading libaec"
# The URL includes a hash, so it needs to change if the version does
curl -fsSLO https://gitlab.dkrz.de/-/project/117/uploads/dc5fc087b645866c14fa22320d91fb27/libaec-${aec_version}.tar.gz
tar zxf libaec-$aec_version.tar.gz

echo "Building & installing libaec"
pushd libaec-$aec_version
./configure
make
make install

# Clean up the files from the build
popd
rm -r libaec-$aec_version libaec-$aec_version.tar.gz
