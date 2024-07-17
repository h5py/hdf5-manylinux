cmake_minimum_required(VERSION 3.24.0)

project(cantera-dependency-superbuild)

include(ExternalProject)

set(DOWNLOAD_DIR "/cache")

set(BOOST_VERSION 1.85.0)
ExternalProject_Add(
    boost
    URL https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.xz
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(LIBAEC_VERSION 1.0.6)
set(LIBAEC_PATCHFILE)
ExternalProject_Add(
    libaec
    URL https://gitlab.dkrz.de/k202009/libaec/uploads/45b10e42123edd26ab7b3ad92bcf7be2/libaec-${LIBAEC_VERSION}.tar.gz
    PATCH_COMMAND patch -p0 < ${LIBAEC_PATCHFILE}
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DBUILD_TESTING:BOOL=OFF
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(LIBHDF5_VERSION 1.14.2)
set(LIBHDF5_SHORT_VERSION 1.14)
ExternalProject_Add(
    libhdf5
    URL https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-${LIBHDF5_SHORT_VERSION}/hdf5-${LIBHDF5_VERSION}/src/hdf5-${LIBHDF5_VERSION}.tar.gz
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DCMAKE_INSTALL_PREFIX:STRING=/usr/local
        -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON
        -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
        -DHDF5_BUILD_EXAMPLES:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
    DEPENDS libaec
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(EIGEN_VERSION 3.4.0)
ExternalProject_Add(
    eigen
    URL https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.bz2
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DEIGEN_BUILD_DOC:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(YAML_CPP_VERSION 0.8.0)
ExternalProject_Add(
    yamlcpp
    URL https://github.com/jbeder/yaml-cpp/archive/refs/tags/${YAML_CPP_VERSION}.tar.gz
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DYAML_CPP_DISABLE_UNINSTALL:BOOL=OFF
        -DYAML_CPP_FORMAT_SOURCE:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DBUILD_SHARED_LIBS:BOOL=ON
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(SUNDIALS_VERSION 7.0.0)
ExternalProject_Add(
    sundials
    URL https://github.com/LLNL/sundials/releases/download/v${SUNDIALS_VERSION}/sundials-${SUNDIALS_VERSION}.tar.gz
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DBUILD_SHARED_LIBS:BOOL=OFF
        -DEXAMPLES_INSTALL:BOOL=OFF
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(FMT_VERSION 10.2.1)
ExternalProject_Add(
    fmt
    URL https://github.com/fmtlib/fmt/releases/download/${FMT_VERSION}/fmt-${FMT_VERSION}.zip
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DFMT_DOC:BOOL=OFF
        -DFMT_TEST:BOOL=OFF
        -DBUILD_SHARED_LIBS:BOOL=ON
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(HIGHFIVE_VERSION 2.9.0)
ExternalProject_Add(
    highfive
    URL https://github.com/BlueBrain/HighFive/archive/refs/tags/v${HIGHFIVE_VERSION}.tar.gz
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=release
        -DHIGHFIVE_UNIT_TESTS:BOOL=OFF
        -DHIGHFIVE_USE_BOOST:BOOL=ON
        -DHIGHFIVE_USE_EIGEN:BOOL=ON
        -DHIGHFIVE_EXAMPLES:BOOL=OFF
        -DHIGHFIVE_BUILD_DOCS:BOOL=OFF
        -DBoost_NO_BOOST_CMAKE:BOOL=OFF
    DEPENDS boost eigen libhdf5
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)
