# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]


function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    local wheelhouse=$(abspath ${WHEEL_SDIR:-wheelhouse})
    if [ -z "$IS_OSX" ]; then
        yum install -y cmake
    else
        brew install cmake
    fi
    if [ -n "$BUILD_DEPENDS" ]; then
        pip install $(pip_opts) $BUILD_DEPENDS
    fi
    mkdir -p digital_rf/python/build
    cd digital_rf/python/build
    cmake .. && make digital_rf_sdist && cp dist/* ${wheelhouse}/
}

function build_wheel {
    local repo_dir=${1:-$REPO_DIR}
    if [ -z "$IS_OSX" ]; then
        build_linux_wheel $@
    else
        build_osx_wheel $@
    fi
}

function build_libs {
    build_hdf5
}

function build_linux_wheel {
    source multibuild/library_builders.sh
    build_libs
    # Add workaround for auditwheel bug:
    # https://github.com/pypa/auditwheel/issues/29
    local bad_lib="/usr/local/lib/libhdf5.so"
    if [ -z "$(readelf --dynamic $bad_lib | grep RUNPATH)" ]; then
        patchelf --set-rpath $(dirname $bad_lib) $bad_lib
    fi
    build_pip_wheel $@
}

function build_osx_wheel {
    local repo_dir=${1:-$REPO_DIR}
    local wheelhouse=$(abspath ${WHEEL_SDIR:-wheelhouse})
    # Build dual arch wheel
    export CC=clang
    export CXX=clang++
    install_pkg_config
    # 32-bit wheel
    export CFLAGS="-arch i386"
    export FFLAGS="-arch i386"
    export LDFLAGS="-arch i386"
    # Build libraries
    source multibuild/library_builders.sh
    build_libs
    # Build wheel
    local py_ld_flags="-Wall -undefined dynamic_lookup -bundle"
    local wheelhouse32=${wheelhouse}32
    mkdir -p $wheelhouse32
    export LDFLAGS="$LDFLAGS $py_ld_flags"
    export LDSHARED="clang $LDFLAGS $py_ld_flags"
    build_pip_wheel "$repo_dir"
    mv ${wheelhouse}/*whl $wheelhouse32
    # 64-bit wheel
    export CFLAGS="-arch x86_64"
    export FFLAGS="-arch x86_64"
    export LDFLAGS="-arch x86_64"
    unset LDSHARED
    # Force rebuild of all libs
    rm *-stamp
    build_libs
    # Build wheel
    export LDFLAGS="$LDFLAGS $py_ld_flags"
    export LDSHARED="clang $LDFLAGS $py_ld_flags"
    build_pip_wheel "$repo_dir"
    # Fuse into dual arch wheel(s)
    for whl in ${wheelhouse}/*.whl; do
        delocate-fuse "$whl" "${wheelhouse32}/$(basename $whl)"
    done
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    python -c 'import digital_rf'
    python -c 'import digital_rf._py_rf_write_hdf5'
}

